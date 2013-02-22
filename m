From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] ipr: Fix oops while resetting an ipr adapter
Date: Fri, 22 Feb 2013 15:02:57 -0500
Message-ID: <20130222150257.Horde.RZX4cJir309RJ87xDzbCY2A@imap.linux.ibm.com>
References: <20130131054507.796972036@linux.vnet.ibm.com>
 <20130131055053.742877117@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47151 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab3BVUDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 15:03:21 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Fri, 22 Feb 2013 15:03:20 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id E17506E801A
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2013 15:03:14 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1MK3GeJ253964
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2013 15:03:16 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1MK3FPc007690
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2013 15:03:16 -0500
In-Reply-To: <20130131055053.742877117@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com


Quoting wenxiong@linux.vnet.ibm.com:

> From: Brian King <brking@linux.vnet.ibm.com>
>
> When resetting an ipr adapter, we use scsi_block_requests to
> block any new commands from scsi core, and then unblock after
> the reset. When hotplug removing an adapter, we shut it down
> and go through this same code, but we've seen issues with
> scsi_unblock_requests running after the adapter's memory has
> been freed. There is really no need to block/unblock when
> the adapter is being removed, so this patch skips the
> block/unblock and will immediately fail any commands that
> happen to make it to queuecommand while the adapter is
> being shutdown.
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.c |   33 +++++++++++++++++++++++----------
>  drivers/scsi/ipr.h |    1 +
>  2 files changed, 24 insertions(+), 10 deletions(-)
>
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2013-01-21 13:45:10.000000000 -0600
> +++ b/drivers/scsi/ipr.c	2013-01-22 14:21:00.394286989 -0600
> @@ -6112,7 +6112,7 @@ static int ipr_queuecommand(struct Scsi_
>  	 * We have told the host to stop giving us new requests, but
>  	 * ERP ops don't count. FIXME
>  	 */
> -	if (unlikely(!hrrq->allow_cmds && !hrrq->ioa_is_dead)) {
> +	if (unlikely(!hrrq->allow_cmds && !hrrq->ioa_is_dead &&  
> !hrrq->removing_ioa)) {
>  		spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
> @@ -6121,7 +6121,7 @@ static int ipr_queuecommand(struct Scsi_
>  	 * FIXME - Create scsi_set_host_offline interface
>  	 *  and the ioa_is_dead check can be removed
>  	 */
> -	if (unlikely(hrrq->ioa_is_dead || !res)) {
> +	if (unlikely(hrrq->ioa_is_dead || hrrq->removing_ioa || !res)) {
>  		spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
>  		goto err_nodev;
>  	}
> @@ -6741,14 +6741,17 @@ static int ipr_ioa_bringdown_done(struct
>  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
>
>  	ENTER;
> +	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
> +		ipr_trace;
> +		spin_unlock_irq(ioa_cfg->host->host_lock);
> +		scsi_unblock_requests(ioa_cfg->host);
> +		spin_lock_irq(ioa_cfg->host->host_lock);
> +	}
> +
>  	ioa_cfg->in_reset_reload = 0;
>  	ioa_cfg->reset_retries = 0;
>  	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  	wake_up_all(&ioa_cfg->reset_wait_q);
> -
> -	spin_unlock_irq(ioa_cfg->host->host_lock);
> -	scsi_unblock_requests(ioa_cfg->host);
> -	spin_lock_irq(ioa_cfg->host->host_lock);
>  	LEAVE;
>
>  	return IPR_RC_JOB_RETURN;
> @@ -8494,7 +8497,8 @@ static void _ipr_initiate_ioa_reset(stru
>  		spin_unlock(&ioa_cfg->hrrq[i]._lock);
>  	}
>  	wmb();
> -	scsi_block_requests(ioa_cfg->host);
> +	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa)
> +		scsi_block_requests(ioa_cfg->host);
>
>  	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
>  	ioa_cfg->reset_cmd = ipr_cmd;
> @@ -8549,9 +8553,11 @@ static void ipr_initiate_ioa_reset(struc
>  			ipr_fail_all_ops(ioa_cfg);
>  			wake_up_all(&ioa_cfg->reset_wait_q);
>
> -			spin_unlock_irq(ioa_cfg->host->host_lock);
> -			scsi_unblock_requests(ioa_cfg->host);
> -			spin_lock_irq(ioa_cfg->host->host_lock);
> +			if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
> +				spin_unlock_irq(ioa_cfg->host->host_lock);
> +				scsi_unblock_requests(ioa_cfg->host);
> +				spin_lock_irq(ioa_cfg->host->host_lock);
> +			}
>  			return;
>  		} else {
>  			ioa_cfg->in_ioa_bringdown = 1;
> @@ -9695,6 +9701,7 @@ static void __ipr_remove(struct pci_dev
>  {
>  	unsigned long host_lock_flags = 0;
>  	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
> +	int i;
>  	ENTER;
>
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
> @@ -9704,6 +9711,12 @@ static void __ipr_remove(struct pci_dev
>  		spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
>  	}
>
> +	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
> +		spin_lock(&ioa_cfg->hrrq[i]._lock);
> +		ioa_cfg->hrrq[i].removing_ioa = 1;
> +		spin_unlock(&ioa_cfg->hrrq[i]._lock);
> +	}
> +	wmb();
>  	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
>
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2013-01-21 13:45:10.000000000 -0600
> +++ b/drivers/scsi/ipr.h	2013-01-22 11:10:23.414280773 -0600
> @@ -493,6 +493,7 @@ struct ipr_hrr_queue {
>  	u8 allow_interrupts:1;
>  	u8 ioa_is_dead:1;
>  	u8 allow_cmds:1;
> +	u8 removing_ioa:1;
>
>  	struct blk_iopoll iopoll;
>  };
>
> --

Hi James,

Our test team has verified this patch in the lab.

To integrate this patch into scsi tree, I would like to check with you  
if you need me
  to resend it or there is anything you need from me for this patch?

Thanks for your help
Wendy


