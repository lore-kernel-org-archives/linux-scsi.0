From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND 3/5] ipr: Kexec boot speed improvements
Date: Tue, 02 Dec 2014 16:24:44 -0500
Message-ID: <20141202162444.Horde.RIzeLHaNNIlWScNCRGKt-g2@ltc.linux.ibm.com>
References: <201412021847.sB2IlhK5030235@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:41007 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbaLBVZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 16:25:08 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 14:25:07 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 58EA919D803E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 14:13:45 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2LO85O13893790
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 14:24:08 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2LP47B006159
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 14:25:04 -0700
In-Reply-To: <201412021847.sB2IlhK5030235@d03av02.boulder.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, anton@samba.org, ebiederm@xmission.com, kexec@lists.infradead.org


Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> Currently when performing a kexec boot with an ipr adapter,
> the adapter gets shutdown completely, flushing all write
> cache, as well as performing a full hardware reset of the card
> during the shutdown phase of the old kernel. This forces
> the new kernel to then wait for the adapter firmware to
> reinitialize, which slows down kexec boot. There is no
> need to do all of this on the newer ipr adapters, since they
> support the ability to cancel outstanding error buffers.
>
> This patch adds a special case for kexec boot to simply
> cancel these outstanding error buffers, and as long as
> there is no other I/O outstanding to the adapter, which
> there shouldn't be, place the adapter into a state
> where it has no memory of any DMA addresses from the old
> kernel, then disable the device. This significantly
> speeds up kexec boot, particularly in configurations with
> multiple ipr adapters.
>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: kexec <kexec@lists.infradead.org>
> Tested-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.c |  158  
> ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ipr.h |    6 +-
>  2 files changed, 155 insertions(+), 9 deletions(-)
>
> diff -puN drivers/scsi/ipr.h~ipr_cancel_hcams2 drivers/scsi/ipr.h
> --- scsi-queue/drivers/scsi/ipr.h~ipr_cancel_hcams2	2014-12-02  
> 12:24:48.848443248 -0600
> +++ scsi-queue-bjking1/drivers/scsi/ipr.h	2014-12-02 12:46:09.574668020 -0600
> @@ -196,6 +196,8 @@
>  /*
>   * Adapter Commands
>   */
> +#define IPR_CANCEL_REQUEST				0xC0
> +#define	IPR_CANCEL_64BIT_IOARCB			0x01
>  #define IPR_QUERY_RSRC_STATE				0xC2
>  #define IPR_RESET_DEVICE				0xC3
>  #define	IPR_RESET_TYPE_SELECT				0x80
> @@ -222,6 +224,7 @@
>  #define IPR_ABBREV_SHUTDOWN_TIMEOUT		(10 * HZ)
>  #define IPR_DUAL_IOA_ABBR_SHUTDOWN_TO	(2 * 60 * HZ)
>  #define IPR_DEVICE_RESET_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
> +#define IPR_CANCEL_TIMEOUT			(ipr_fastfail ? 10 * HZ : 30 * HZ)
>  #define IPR_CANCEL_ALL_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
>  #define IPR_ABORT_TASK_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
>  #define IPR_INTERNAL_TIMEOUT			(ipr_fastfail ? 10 * HZ : 30 * HZ)
> @@ -1402,7 +1405,8 @@ enum ipr_shutdown_type {
>  	IPR_SHUTDOWN_NORMAL = 0x00,
>  	IPR_SHUTDOWN_PREPARE_FOR_NORMAL = 0x40,
>  	IPR_SHUTDOWN_ABBREV = 0x80,
> -	IPR_SHUTDOWN_NONE = 0x100
> +	IPR_SHUTDOWN_NONE = 0x100,
> +	IPR_SHUTDOWN_KEXEC = 0x101,
>  };
>
>  struct ipr_trace_entry {
> diff -puN drivers/scsi/ipr.c~ipr_cancel_hcams2 drivers/scsi/ipr.c
> --- scsi-queue/drivers/scsi/ipr.c~ipr_cancel_hcams2	2014-12-02  
> 12:24:48.851443224 -0600
> +++ scsi-queue-bjking1/drivers/scsi/ipr.c	2014-12-02 12:46:09.705666926 -0600
> @@ -76,6 +76,7 @@
>  #include <linux/hdreg.h>
>  #include <linux/reboot.h>
>  #include <linux/stringify.h>
> +#include <linux/kexec.h>
>  #include <asm/io.h>
>  #include <asm/irq.h>
>  #include <asm/processor.h>
> @@ -1459,7 +1460,8 @@ static void ipr_process_ccn(struct ipr_c
>  	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>
>  	if (ioasc) {
> -		if (ioasc != IPR_IOASC_IOA_WAS_RESET)
> +		if (ioasc != IPR_IOASC_IOA_WAS_RESET &&
> +		    ioasc != IPR_IOASC_ABORTED_CMD_TERM_BY_HOST)
>  			dev_err(&ioa_cfg->pdev->dev,
>  				"Host RCB failed with IOASC: 0x%08X\n", ioasc);
>
> @@ -2563,7 +2565,8 @@ static void ipr_process_error(struct ipr
>  		ipr_handle_log_data(ioa_cfg, hostrcb);
>  		if (fd_ioasc == IPR_IOASC_NR_IOA_RESET_REQUIRED)
>  			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
> -	} else if (ioasc != IPR_IOASC_IOA_WAS_RESET) {
> +	} else if (ioasc != IPR_IOASC_IOA_WAS_RESET &&
> +		   ioasc != IPR_IOASC_ABORTED_CMD_TERM_BY_HOST) {
>  		dev_err(&ioa_cfg->pdev->dev,
>  			"Host RCB failed with IOASC: 0x%08X\n", ioasc);
>  	}
> @@ -5310,9 +5313,6 @@ static irqreturn_t ipr_handle_other_inte
>  	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
>  		/* Mask the interrupt */
>  		writel(IPR_PCII_IOA_TRANS_TO_OPER, ioa_cfg->regs.set_interrupt_mask_reg);
> -
> -		/* Clear the interrupt */
> -		writel(IPR_PCII_IOA_TRANS_TO_OPER, ioa_cfg->regs.clr_interrupt_reg);
>  		int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
>
>  		list_del(&ioa_cfg->reset_cmd->queue);
> @@ -8411,6 +8411,122 @@ static int ipr_reset_alert(struct ipr_cm
>  }
>
>  /**
> + * ipr_reset_kexec_done - Complete IOA disconnect
> + * @ipr_cmd:	ipr command struct
> + *
> + * Description: Freeze the adapter to complete kexec processing
> + *
> + * Return value:
> + * 	IPR_RC_JOB_CONTINUE
> + **/
> +static int ipr_reset_kexec_done(struct ipr_cmnd *ipr_cmd)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +
> +	ENTER;
> +	ipr_cmd->job_step = ipr_ioa_bringdown_done;
> +	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
> +	LEAVE;
> +	return IPR_RC_JOB_CONTINUE;
> +}
> +
> +/**
> + * ipr_reset_cancel_hcam_done - Check for outstanding commands
> + * @ipr_cmd:	ipr command struct
> + *
> + * Description: Ensure nothing is outstanding to the IOA and
> + *			proceed with IOA disconnect. Otherwise reset the IOA.
> + *
> + * Return value:
> + * 	IPR_RC_JOB_RETURN / IPR_RC_JOB_CONTINUE
> + **/
> +static int ipr_reset_cancel_hcam_done(struct ipr_cmnd *ipr_cmd)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	struct ipr_cmnd *loop_cmd;
> +	struct ipr_hrr_queue *hrrq;
> +	int rc = IPR_RC_JOB_CONTINUE;
> +	int count = 0;
> +
> +	ENTER;
> +	ipr_cmd->job_step = ipr_reset_kexec_done;
> +
> +	for_each_hrrq(hrrq, ioa_cfg) {
> +		spin_lock(&hrrq->_lock);
> +		list_for_each_entry(loop_cmd, &hrrq->hrrq_pending_q, queue) {
> +			count++;
> +			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
> +			list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
> +			rc = IPR_RC_JOB_RETURN;
> +			break;
> +		}
> +		spin_unlock(&hrrq->_lock);
> +
> +		if (count)
> +			break;
> +	}
> +
> +	LEAVE;
> +	return rc;
> +}
> +
> +/**
> + * ipr_reset_cancel_hcam - Cancel outstanding HCAMs
> + * @ipr_cmd:	ipr command struct
> + *
> + * Description: Cancel any oustanding HCAMs to the IOA.
> + *
> + * Return value:
> + * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
> + **/
> +static int ipr_reset_cancel_hcam(struct ipr_cmnd *ipr_cmd)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	int rc = IPR_RC_JOB_CONTINUE;
> +	struct ipr_cmd_pkt *cmd_pkt;
> +	struct ipr_cmnd *hcam_cmd;
> +	struct ipr_hrr_queue *hrrq = &ioa_cfg->hrrq[IPR_INIT_HRRQ];
> +
> +	ENTER;
> +	ipr_cmd->job_step = ipr_reset_cancel_hcam_done;
> +
> +	if (!hrrq->ioa_is_dead) {
> +		if (!list_empty(&ioa_cfg->hostrcb_pending_q)) {
> +			list_for_each_entry(hcam_cmd, &hrrq->hrrq_pending_q, queue) {
> +				if (hcam_cmd->ioarcb.cmd_pkt.cdb[0] != IPR_HOST_CONTROLLED_ASYNC)
> +					continue;
> +
> +				ipr_cmd->ioarcb.res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
> +				ipr_cmd->ioarcb.cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
> +				cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
> +				cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
> +				cmd_pkt->cdb[0] = IPR_CANCEL_REQUEST;
> +				cmd_pkt->cdb[1] = IPR_CANCEL_64BIT_IOARCB;
> +				cmd_pkt->cdb[10] = ((u64) hcam_cmd->dma_addr >> 56) & 0xff;
> +				cmd_pkt->cdb[11] = ((u64) hcam_cmd->dma_addr >> 48) & 0xff;
> +				cmd_pkt->cdb[12] = ((u64) hcam_cmd->dma_addr >> 40) & 0xff;
> +				cmd_pkt->cdb[13] = ((u64) hcam_cmd->dma_addr >> 32) & 0xff;
> +				cmd_pkt->cdb[2] = ((u64) hcam_cmd->dma_addr >> 24) & 0xff;
> +				cmd_pkt->cdb[3] = ((u64) hcam_cmd->dma_addr >> 16) & 0xff;
> +				cmd_pkt->cdb[4] = ((u64) hcam_cmd->dma_addr >> 8) & 0xff;
> +				cmd_pkt->cdb[5] = ((u64) hcam_cmd->dma_addr) & 0xff;
> +
> +				ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
> +					   IPR_CANCEL_TIMEOUT);
> +
> +				rc = IPR_RC_JOB_RETURN;
> +				ipr_cmd->job_step = ipr_reset_cancel_hcam;
> +				break;
> +			}
> +		}
> +	} else
> +		ipr_cmd->job_step = ipr_reset_alert;
> +
> +	LEAVE;
> +	return rc;
> +}
> +
> +/**
>   * ipr_reset_ucode_download_done - Microcode download completion
>   * @ipr_cmd:	ipr command struct
>   *
> @@ -8492,7 +8608,9 @@ static int ipr_reset_shutdown_ioa(struct
>  	int rc = IPR_RC_JOB_CONTINUE;
>
>  	ENTER;
> -	if (shutdown_type != IPR_SHUTDOWN_NONE &&
> +	if (shutdown_type == IPR_SHUTDOWN_KEXEC)
> +		ipr_cmd->job_step = ipr_reset_cancel_hcam;
> +	else if (shutdown_type != IPR_SHUTDOWN_NONE &&
>  			!ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
>  		ipr_cmd->ioarcb.res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
>  		ipr_cmd->ioarcb.cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
> @@ -9967,6 +10085,7 @@ static void ipr_shutdown(struct pci_dev
>  {
>  	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
>  	unsigned long lock_flags = 0;
> +	enum ipr_shutdown_type shutdown_type = IPR_SHUTDOWN_NORMAL;
>  	int i;
>
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> @@ -9982,9 +10101,31 @@ static void ipr_shutdown(struct pci_dev
>  		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
>  	}
>
> -	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
> +	if (kexec_in_progress && ioa_cfg->sis64)
> +		shutdown_type = IPR_SHUTDOWN_KEXEC;
> +
> +	ipr_initiate_ioa_bringdown(ioa_cfg, shutdown_type);
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
> +	if (kexec_in_progress && ioa_cfg->sis64) {
> +		if (ioa_cfg->intr_flag == IPR_USE_MSI ||
> +		    ioa_cfg->intr_flag == IPR_USE_MSIX) {
> +			int i;
> +			for (i = 0; i < ioa_cfg->nvectors; i++)
> +				free_irq(ioa_cfg->vectors_info[i].vec,
> +					 &ioa_cfg->hrrq[i]);
> +		}
> +
> +		if (ioa_cfg->intr_flag == IPR_USE_MSI) {
> +			pci_disable_msi(ioa_cfg->pdev);
> +			ioa_cfg->intr_flag &= ~IPR_USE_MSI;
> +		} else if (ioa_cfg->intr_flag == IPR_USE_MSIX) {
> +			pci_disable_msix(ioa_cfg->pdev);
> +			ioa_cfg->intr_flag &= ~IPR_USE_MSIX;
> +		}
> +
> +		pci_disable_device(ioa_cfg->pdev);
> +	}
>  }
>
>  static struct pci_device_id ipr_pci_table[] = {
> @@ -10142,7 +10283,8 @@ static int ipr_halt(struct notifier_bloc
>
>  	list_for_each_entry(ioa_cfg, &ipr_ioa_head, queue) {
>  		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
> -		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds) {
> +		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds ||
> +		    (kexec_in_progress && ioa_cfg->sis64)) {
>  			spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
>  			continue;
>  		}
> _


