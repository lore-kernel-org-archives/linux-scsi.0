From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc7
Date: Thu, 11 Feb 2010 17:24:13 +0200
Message-ID: <4B74211D.8050603@panasas.com>
References: <1265900692.4420.90.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:2342 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753293Ab0BKPYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 10:24:19 -0500
In-Reply-To: <1265900692.4420.90.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

On 02/11/2010 05:04 PM, James Bottomley wrote:
> This is just a set of reasonably minor bug fixes ... the most serious
> seems to be the BSG compat issue because BSG just doesn't work in a 32
> on 64 environment at the moment.
> 
> The fix is available from:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> Anirban Chakraborty (1):
>       qla2xxx: Obtain proper host structure during response-queue processing.
> 
> FUJITA Tomonori (1):
>       compat_ioct: fix bsg SG_IO
> 
> Kashyap, Desai (1):
>       mptfusion : mptscsih_abort return value should be SUCCESS instead of value 0.
> 
> Swen Schillig (1):
>       zfcp: Report FC BSG errors in correct field
> 
> Xiaotian Feng (1):
>       qla2xxx: make msix interrupt handler safe for irq
> 

James hi.
Please add this patch for 2.6.33-rc:
http://marc.info/?l=linux-scsi&m=126335810027706&w=2
Titled:
	[PATCH 1/1] iscsi_tcp regression: remove bogus warn on in write path

It is a bug introduced in this Kernel. It causes an annoying useless WARN_ON
on ever iscsi login, (and scares the users ;))

Thanks
Boaz

> The diffstat:
> 
>  drivers/message/fusion/mptscsih.c |    2 -
>  drivers/s390/scsi/zfcp_fc.c       |    9 +++----
>  drivers/scsi/qla2xxx/qla_gbl.h    |    1 
>  drivers/scsi/qla2xxx/qla_isr.c    |   44 ++++++++------------------------------
>  drivers/scsi/qla2xxx/qla_mid.c    |    8 ++++--
>  fs/compat_ioctl.c                 |    6 +++++
>  6 files changed, 26 insertions(+), 44 deletions(-)
> 
> and the full diff below.
> 
> James
> 
> ---
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 5775275..81279b3 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1796,7 +1796,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
>  		   "Command not in the active list! (sc=%p)\n", ioc->name,
>  		   SCpnt));
> -		retval = 0;
> +		retval = SUCCESS;
>  		goto out;
>  	}
>  
> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
> index 0f7b493..271399f 100644
> --- a/drivers/s390/scsi/zfcp_fc.c
> +++ b/drivers/s390/scsi/zfcp_fc.c
> @@ -671,12 +671,11 @@ static void zfcp_fc_ct_els_job_handler(void *data)
>  {
>  	struct fc_bsg_job *job = data;
>  	struct zfcp_fsf_ct_els *zfcp_ct_els = job->dd_data;
> -	int status = zfcp_ct_els->status;
> -	int reply_status;
> +	struct fc_bsg_reply *jr = job->reply;
>  
> -	reply_status = status ? FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
> -	job->reply->reply_data.ctels_reply.status = reply_status;
> -	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
> +	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
> +	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
> +	jr->result = zfcp_ct_els->status ? -EIO : 0;
>  	job->job_done(job);
>  }
>  
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index f61fb8d..8bc6f53 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -453,6 +453,5 @@ extern void qla24xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
>  extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
>  extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
>  extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
> -extern struct scsi_qla_host * qla25xx_get_host(struct rsp_que *);
>  
>  #endif /* _QLA_GBL_H */
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index ffd0efd..6fc63b9 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1917,6 +1917,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>  	struct rsp_que *rsp;
>  	struct device_reg_24xx __iomem *reg;
>  	struct scsi_qla_host *vha;
> +	unsigned long flags;
>  
>  	rsp = (struct rsp_que *) dev_id;
>  	if (!rsp) {
> @@ -1927,15 +1928,15 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>  	ha = rsp->hw;
>  	reg = &ha->iobase->isp24;
>  
> -	spin_lock_irq(&ha->hardware_lock);
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>  
> -	vha = qla25xx_get_host(rsp);
> +	vha = pci_get_drvdata(ha->pdev);
>  	qla24xx_process_response_queue(vha, rsp);
>  	if (!ha->flags.disable_msix_handshake) {
>  		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>  		RD_REG_DWORD_RELAXED(&reg->hccr);
>  	}
> -	spin_unlock_irq(&ha->hardware_lock);
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -1946,6 +1947,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
>  	struct qla_hw_data *ha;
>  	struct rsp_que *rsp;
>  	struct device_reg_24xx __iomem *reg;
> +	unsigned long flags;
>  
>  	rsp = (struct rsp_que *) dev_id;
>  	if (!rsp) {
> @@ -1958,10 +1960,10 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
>  	/* Clear the interrupt, if enabled, for this response queue */
>  	if (rsp->options & ~BIT_6) {
>  		reg = &ha->iobase->isp24;
> -		spin_lock_irq(&ha->hardware_lock);
> +		spin_lock_irqsave(&ha->hardware_lock, flags);
>  		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>  		RD_REG_DWORD_RELAXED(&reg->hccr);
> -		spin_unlock_irq(&ha->hardware_lock);
> +		spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  	}
>  	queue_work_on((int) (rsp->id - 1), ha->wq, &rsp->q_work);
>  
> @@ -1979,6 +1981,7 @@ qla24xx_msix_default(int irq, void *dev_id)
>  	uint32_t	stat;
>  	uint32_t	hccr;
>  	uint16_t	mb[4];
> +	unsigned long flags;
>  
>  	rsp = (struct rsp_que *) dev_id;
>  	if (!rsp) {
> @@ -1990,7 +1993,7 @@ qla24xx_msix_default(int irq, void *dev_id)
>  	reg = &ha->iobase->isp24;
>  	status = 0;
>  
> -	spin_lock_irq(&ha->hardware_lock);
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
>  	vha = pci_get_drvdata(ha->pdev);
>  	do {
>  		stat = RD_REG_DWORD(&reg->host_status);
> @@ -2039,7 +2042,7 @@ qla24xx_msix_default(int irq, void *dev_id)
>  		}
>  		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>  	} while (0);
> -	spin_unlock_irq(&ha->hardware_lock);
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>  	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
> @@ -2277,30 +2280,3 @@ int qla25xx_request_irq(struct rsp_que *rsp)
>  	msix->rsp = rsp;
>  	return ret;
>  }
> -
> -struct scsi_qla_host *
> -qla25xx_get_host(struct rsp_que *rsp)
> -{
> -	srb_t *sp;
> -	struct qla_hw_data *ha = rsp->hw;
> -	struct scsi_qla_host *vha = NULL;
> -	struct sts_entry_24xx *pkt;
> -	struct req_que *req;
> -	uint16_t que;
> -	uint32_t handle;
> -
> -	pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
> -	que = MSW(pkt->handle);
> -	handle = (uint32_t) LSW(pkt->handle);
> -	req = ha->req_q_map[que];
> -	if (handle < MAX_OUTSTANDING_COMMANDS) {
> -		sp = req->outstanding_cmds[handle];
> -		if (sp)
> -			return  sp->fcport->vha;
> -		else
> -			goto base_que;
> -	}
> -base_que:
> -	vha = pci_get_drvdata(ha->pdev);
> -	return vha;
> -}
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index b901aa2..ff17dee 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -636,13 +636,15 @@ failed:
>  
>  static void qla_do_work(struct work_struct *work)
>  {
> +	unsigned long flags;
>  	struct rsp_que *rsp = container_of(work, struct rsp_que, q_work);
>  	struct scsi_qla_host *vha;
> +	struct qla_hw_data *ha = rsp->hw;
>  
> -	spin_lock_irq(&rsp->hw->hardware_lock);
> -	vha = qla25xx_get_host(rsp);
> +	spin_lock_irqsave(&rsp->hw->hardware_lock, flags);
> +	vha = pci_get_drvdata(ha->pdev);
>  	qla24xx_process_response_queue(vha, rsp);
> -	spin_unlock_irq(&rsp->hw->hardware_lock);
> +	spin_unlock_irqrestore(&rsp->hw->hardware_lock, flags);
>  }
>  
>  /* create response queue */
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index c5c45de..7cbbc7a 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -301,6 +301,12 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd,
>  	u32 data;
>  	void __user *dxferp;
>  	int err;
> +	int interface_id;
> +
> +	if (get_user(interface_id, &sgio32->interface_id))
> +		return -EFAULT;
> +	if (interface_id != 'S')
> +		return sys_ioctl(fd, cmd, (unsigned long)sgio32);
>  
>  	if (get_user(iovec_count, &sgio32->iovec_count))
>  		return -EFAULT;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

