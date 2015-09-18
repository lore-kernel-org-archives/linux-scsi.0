From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 08/30] cxlflash: Fix to avoid CXL services during EEH
Date: Fri, 18 Sep 2015 08:37:41 -0500
Message-ID: <55FC13A5.1080301@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442438877-49469-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:50597 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbIRNiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2015 09:38:46 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 18 Sep 2015 07:38:45 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 7E2A91FF0042
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 07:29:51 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8IDbQlD55640136
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 06:37:34 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8IDc7wd028410
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 07:38:09 -0600
In-Reply-To: <1442438877-49469-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/16/2015 04:27 PM, Matthew R. Ochs wrote:
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -2311,6 +2311,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
>  	cfg->lr_port = -1;
>  	mutex_init(&cfg->ctx_tbl_list_mutex);
>  	mutex_init(&cfg->ctx_recovery_mutex);
> +	init_rwsem(&cfg->ioctl_rwsem);
>  	INIT_LIST_HEAD(&cfg->ctx_err_recovery);
>  	INIT_LIST_HEAD(&cfg->lluns);
> 
> @@ -2365,6 +2366,19 @@ out_remove:
>  }
> 
>  /**
> + * drain_ioctls() - wait until all currently executing ioctls have completed
> + * @cfg:	Internal structure associated with the host.
> + *
> + * Obtain write access to read/write semaphore that wraps ioctl
> + * handling to 'drain' ioctls currently executing.
> + */
> +static void drain_ioctls(struct cxlflash_cfg *cfg)
> +{
> +	down_write(&cfg->ioctl_rwsem);
> +	up_write(&cfg->ioctl_rwsem);
> +}
> +
> +/**
>   * cxlflash_pci_error_detected() - called when a PCI error is detected
>   * @pdev:	PCI device struct.
>   * @state:	PCI channel state.
> @@ -2383,16 +2397,14 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
>  	switch (state) {
>  	case pci_channel_io_frozen:
>  		cfg->state = STATE_LIMBO;
> -
> -		/* Turn off legacy I/O */
>  		scsi_block_requests(cfg->host);
> +		drain_ioctls(cfg);

So, what kicks any outstanding ioctls back? Let's assume you are in the middle of disk_attach
and you've sent the READ_CAP16 to the device. It appears as if what would happen here is we'd
sit here in cxlflash_pci_error_detected. Eventually, the READ_CAP16 would timeout. This would
wake the SCSI error handler, and end up calling your eh_device_reset handler, which would see that
we are in STATE_LIMBO, where it would then do a wait_event, waiting for us to get out of STATE_LIMBO,
and we would end up in a deadlock.

Rather than implementing a rw semaphore, would it be better to simply make the ioctls check the
state we are in and either wait to get out of EEH state or fail themselves?

>  		rc = cxlflash_mark_contexts_error(cfg);
>  		if (unlikely(rc))
>  			dev_err(dev, "%s: Failed to mark user contexts!(%d)\n",
>  				__func__, rc);
>  		term_mc(cfg, UNDO_START);
>  		stop_afu(cfg);
> -
>  		return PCI_ERS_RESULT_NEED_RESET;
>  	case pci_channel_io_perm_failure:
>  		cfg->state = STATE_FAILTERM;
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index cf2a85d..8a18230 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -1214,6 +1214,48 @@ static const struct file_operations null_fops = {
>  };
> 
>  /**
> + * check_state() - checks and responds to the current adapter state
> + * @cfg:	Internal structure associated with the host.
> + * @ioctl:	Indicates if on an ioctl thread.
> + *
> + * This routine can block and should only be used on process context.
> + * When blocking on an ioctl thread, the ioctl read semaphore should be
> + * let up to allow for draining actively running ioctls. Also note that
> + * when waking up from waiting in reset, the state is unknown and must
> + * be checked again before proceeding.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int check_state(struct cxlflash_cfg *cfg, bool ioctl)

All your callers appear to set the second parameter to true, so why bother having it?

> +{
> +	struct device *dev = &cfg->dev->dev;
> +	int rc = 0;
> +
> +retry:
> +	switch (cfg->state) {
> +	case STATE_LIMBO:
> +		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
> +		if (ioctl)
> +			up_read(&cfg->ioctl_rwsem);
> +		rc = wait_event_interruptible(cfg->limbo_waitq,
> +					      cfg->state != STATE_LIMBO);
> +		if (ioctl)
> +			down_read(&cfg->ioctl_rwsem);
> +		if (unlikely(rc))
> +			break;
> +		goto retry;
> +	case STATE_FAILTERM:
> +		dev_dbg(dev, "%s: Failed/Terminating!\n", __func__);
> +		rc = -ENODEV;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +/**
>   * cxlflash_disk_attach() - attach a LUN to a context
>   * @sdev:	SCSI device associated with LUN.
>   * @attach:	Attach ioctl data structure.

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

