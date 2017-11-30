From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 20/22] qla2xxx: Fix system crash in qlt_plogi_ack_unref
Date: Thu, 30 Nov 2017 17:24:07 +0100
Message-ID: <6275ae72-ecf5-2f64-9c47-1082fa4b7c47@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-21-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57903 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750742AbdK3QYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:24:09 -0500
In-Reply-To: <20171130034047.15070-21-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Fix system crash due to NULL pointer access.
> 
> qlt_plogi_ack_t and fc_port structures were not properly
> bound before calling qlt_plogi_ack_unref().
> 
> RIP: 0010:qlt_plogi_ack_unref+0xa1/0x150 [qla2xxx]
> Call Trace:
> qla24xx_create_new_sess+0xb1/0x320 [qla2xxx]
> qla2x00_do_work+0x123/0x260 [qla2xxx]
> qla2x00_iocb_work_fn+0x30/0x40 [qla2xxx]
> process_one_work+0x1f3/0x530
> worker_thread+0x4e/0x480
> kthread+0x10c/0x140
> 
> Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 2ec77b9f78b8..789030c9dd26 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4750,11 +4750,11 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
>  		} else {
>  			list_add_tail(&fcport->list, &vha->vp_fcports);
>  
> -			if (pla) {
> -				qlt_plogi_ack_link(vha, pla, fcport,
> -				    QLT_PLOGI_LINK_SAME_WWN);
> -				pla->ref_count--;
> -			}
> +		}
> +		if (pla) {
> +			qlt_plogi_ack_link(vha, pla, fcport,
> +			    QLT_PLOGI_LINK_SAME_WWN);
> +			pla->ref_count--;
>  		}
>  	}
>  	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
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
