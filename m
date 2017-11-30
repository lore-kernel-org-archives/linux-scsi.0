From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 19/22] qla2xxx: Remove aborting ELS IOCB call issued as
 part of timeout.
Date: Thu, 30 Nov 2017 17:23:07 +0100
Message-ID: <850d38f2-2c28-0dfc-8283-c44d6d69d0b8@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-20-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57763 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbdK3QXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:23:09 -0500
In-Reply-To: <20171130034047.15070-20-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Giridhar Malavali <giridhar.malavali@cavium.com>
> 
> This fix the spinlock recursion issue seen while unloading the driver.
> 
> 14 [ffff9f2e21e03db8] native_queued_spin_lock_slowpath at ffffffffad0d8802
> 15 [ffff9f2e21e03dc0] do_raw_spin_lock at ffffffffad0d99e4
> 16 [ffff9f2e21e03dd8] _raw_spin_lock_irqsave at ffffffffad652471
> 17 [ffff9f2e21e03e00] qla2x00_els_dcmd_iocb_timeout at ffffffffc070cd63
> 18 [ffff9f2e21e03e40] qla2x00_sp_timeout at ffffffffc06f06d3 [qla2xxx]
> 19 [ffff9f2e21e03e68] call_timer_fn at ffffffffad0f97d8
> 20 [ffff9f2e21e03ed8] run_timer_softirq at ffffffffad0faf47
> 21 [ffff9f2e21e03f68] __softirqentry_text_start at ffffffffad655f32
> 
> Fixes: 6eb54715b54bb ("qla2xxx: Added interface to send explicit LOGO.")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 106f4ac4f733..8ea59586f4f1 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2392,7 +2392,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
>  	srb_t *sp = data;
>  	fc_port_t *fcport = sp->fcport;
>  	struct scsi_qla_host *vha = sp->vha;
> -	struct qla_hw_data *ha = vha->hw;
>  	struct srb_iocb *lio = &sp->u.iocb_cmd;
>  
>  	ql_dbg(ql_dbg_io, vha, 0x3069,
> @@ -2400,15 +2399,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
>  	    sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
>  	    fcport->d_id.b.al_pa);
>  
> -	/* Abort the exchange */
> -	if (ha->isp_ops->abort_command(sp)) {
> -		ql_dbg(ql_dbg_io, vha, 0x3070,
> -		    "mbx abort_command failed.\n");
> -	} else {
> -		ql_dbg(ql_dbg_io, vha, 0x3071,
> -		    "mbx abort_command success.\n");
> -	}
> -
>  	complete(&lio->u.els_logo.comp);
>  }
>  
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
