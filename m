From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 1/3] cxlflash: Base error recovery support
Date: Mon, 17 Aug 2015 09:38:06 -0500
Message-ID: <55D1F1CE.1030900@linux.vnet.ibm.com>
References: <1439520454-56759-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:41497 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbHQOiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2015 10:38:18 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 17 Aug 2015 10:38:17 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 2048338C806A
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2015 10:38:14 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7HEcEq845678788
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2015 14:38:14 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7HEcBW7000890
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2015 10:38:13 -0400
In-Reply-To: <1439520454-56759-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org
Cc: hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 08/13/2015 09:47 PM, Matthew R. Ochs wrote:
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -76,6 +76,12 @@ enum cxlflash_init_state {
>  	INIT_STATE_SCSI
>  };
> 
> +enum cxlflash_state {
> +	STATE_NORMAL,	/* Normal running state, everything good */
> +	STATE_LIMBO,	/* Limbo running state, trying to reset/recover */

Might be more clear to call this STATE_RESETTING or STATE_RECOVERY

> +	STATE_FAILTERM	/* Failed/terminating state, error out users/threads */
> +};
> +
>  /*
>   * Each context has its own set of resource handles that is visible
>   * only from that context.

> @@ -105,7 +109,8 @@ struct cxlflash_cfg {
> 
>  	wait_queue_head_t tmf_waitq;
>  	bool tmf_active;
> -	u8 err_recovery_active:1;
> +	wait_queue_head_t limbo_waitq;

How about reset_waitq instead?

> +	enum cxlflash_state state;
>  };
> 
>  struct afu_cmd {

> @@ -455,9 +471,21 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> 
> -	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> -	if (unlikely(rcr))
> +	switch (cfg->state) {
> +	case STATE_NORMAL:
> +		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> +		if (unlikely(rcr))
> +			rc = FAILED;
> +		break;
> +	case STATE_LIMBO:
> +		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
> +		if (cfg->state == STATE_NORMAL)
> +			break;

In this case you've been asked to do a LUN reset but didn't actually reset the LUN. I'd suggest
restructuring this switch statement to send the LUN reset TMF in the case where you had
to wait for an AFU reset to complete.

> +		/* fall through */
> +	default:
>  		rc = FAILED;
> +		break;
> +	}
> 
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -487,11 +515,29 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> 
> -	rcr = cxlflash_afu_reset(cfg);
> -	if (rcr == 0)
> -		rc = SUCCESS;
> -	else
> +	switch (cfg->state) {
> +	case STATE_NORMAL:
> +		cfg->state = STATE_LIMBO;
> +		scsi_block_requests(cfg->host);
> +
> +		rcr = cxlflash_afu_reset(cfg);
> +		if (rcr) {
> +			rc = FAILED;
> +			cfg->state = STATE_FAILTERM;
> +		} else
> +			cfg->state = STATE_NORMAL;
> +		wake_up_all(&cfg->limbo_waitq);
> +		scsi_unblock_requests(cfg->host);

The scsi_block_requests / scsi_unblock_requests is not necessary in this path, since SCSI EH
will already be preventing any new commands being issued via queuecommand.

> +		break;
> +	case STATE_LIMBO:
> +		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
> +		if (cfg->state == STATE_NORMAL)
> +			break;
> +		/* fall through */
> +	default:
>  		rc = FAILED;
> +		break;
> +	}
> 
>  	pr_debug("%s: returning rc=%d\n", __func__, rc);
>  	return rc;
> @@ -642,7 +688,7 @@ static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
>  	struct pci_dev *pdev = cfg->dev;
> 
>  	if (pci_channel_offline(pdev))
> -		wait_event_timeout(cfg->eeh_waitq,
> +		wait_event_timeout(cfg->limbo_waitq,
>  				   !pci_channel_offline(pdev),
>  				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
>  }
> @@ -825,6 +871,8 @@ static void cxlflash_remove(struct pci_dev *pdev)
>  						    !cfg->tmf_active);
>  	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
> 
> +	cfg->state = STATE_FAILTERM;

I don't see any locking around the setting or reading of this flag. What are the
implications if the processor reorders the store to change this state either here
or elsewhere. Same goes for the load associated with checking the state.

> +
>  	switch (cfg->init_state) {
>  	case INIT_STATE_SCSI:
>  		scsi_remove_host(cfg->host);
> @@ -1879,6 +1927,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
>  	struct afu *afu = cfg->afu;
>  	struct device *dev = &cfg->dev->dev;
> 
> +	cxl_perst_reloads_same_image(cfg->cxl_afu, true);
> +
>  	rc = init_mc(cfg);
>  	if (rc) {
>  		dev_err(dev, "%s: call to init_mc failed, rc=%d!\n",

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


