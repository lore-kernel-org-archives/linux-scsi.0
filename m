From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 14/22] qla2xxx: Fix abort command deadlock due to
 spinlock
Date: Thu, 30 Nov 2017 17:19:09 +0100
Message-ID: <aff3d196-29bc-5b10-9546-ef5a124dd8c4@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-15-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57477 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751745AbdK3QTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:19:12 -0500
In-Reply-To: <20171130034047.15070-15-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Original code acquires hardware_lock to add Abort IOCB
> onto driver's request queue for processing. However,
> abort_command() will also acquire hardware lock to look up
> sp pointer before issuing abort IOCB command resulting
> into a deadlock. This patch safely removes the possible
> deadlock scenario by removing extra spinlock.
> 
> Fixes: 6eb54715b54bb ("qla2xxx: Added interface to send explicit LOGO.")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index d810a447cb4a..106f4ac4f733 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2394,7 +2394,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
>  	struct scsi_qla_host *vha = sp->vha;
>  	struct qla_hw_data *ha = vha->hw;
>  	struct srb_iocb *lio = &sp->u.iocb_cmd;
> -	unsigned long flags = 0;
>  
>  	ql_dbg(ql_dbg_io, vha, 0x3069,
>  	    "%s Timeout, hdl=%x, portid=%02x%02x%02x\n",
> @@ -2402,7 +2401,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
>  	    fcport->d_id.b.al_pa);
>  
>  	/* Abort the exchange */
> -	spin_lock_irqsave(&ha->hardware_lock, flags);
>  	if (ha->isp_ops->abort_command(sp)) {
>  		ql_dbg(ql_dbg_io, vha, 0x3070,
>  		    "mbx abort_command failed.\n");
> @@ -2410,7 +2408,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
>  		ql_dbg(ql_dbg_io, vha, 0x3071,
>  		    "mbx abort_command success.\n");
>  	}
> -	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	complete(&lio->u.els_logo.comp);
>  }
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
