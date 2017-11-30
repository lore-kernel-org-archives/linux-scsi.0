From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/22] qla2xxx: Fix re-login for Nport Handle in use
Date: Thu, 30 Nov 2017 16:51:51 +0100
Message-ID: <b1e8b1b5-b6c0-9a2b-d496-34063d730712@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-6-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54237 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751811AbdK3Pvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 10:51:53 -0500
In-Reply-To: <20171130034047.15070-6-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> When NPort Handle is in use, driver needs to mark the handle
> as used and pick another. Instead, the code clears the handle
> and re-pick the same handle.
> 
> Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_gs.c   | 16 ++++++++++-----
>  drivers/scsi/qla2xxx/qla_init.c | 44 +++++++++++++++++++++++++++++++++++++----
>  drivers/scsi/qla2xxx/qla_isr.c  |  5 -----
>  3 files changed, 51 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index ddc69d36877e..8984f857bb34 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -2833,7 +2833,7 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
>  				}
>  			} else { /* fcport->d_id.b24 != ea->id.b24 */
>  				fcport->d_id.b24 = ea->id.b24;
> -				if (fcport->deleted == QLA_SESS_DELETED) {
> +				if (fcport->deleted != QLA_SESS_DELETED) {
>  					ql_dbg(ql_dbg_disc, vha, 0x2021,
>  					    "%s %d %8phC post del sess\n",
>  					    __func__, __LINE__, fcport->port_name);
> @@ -3206,10 +3206,16 @@ static void qla2x00_async_gpnid_sp_done(void *s, int res)
>  	struct event_arg ea;
>  	struct qla_work_evt *e;
>  
> -	ql_dbg(ql_dbg_disc, vha, 0x2066,
> -	    "Async done-%s res %x ID %3phC. %8phC\n",
> -	    sp->name, res, ct_req->req.port_id.port_id,
> -	    ct_rsp->rsp.gpn_id.port_name);
> +	if (res)
> +		ql_dbg(ql_dbg_disc, vha, 0x2066,
> +		    "Async done-%s fail res %x ID %3phC. %8phC\n",
> +		    sp->name, res, ct_req->req.port_id.port_id,
> +		    ct_rsp->rsp.gpn_id.port_name);
> +	else
> +		ql_dbg(ql_dbg_disc, vha, 0x2066,
> +		    "Async done-%s good ID %3phC. %8phC\n",
> +		    sp->name, ct_req->req.port_id.port_id,
> +		    ct_rsp->rsp.gpn_id.port_name);
>  
>  	if (res) {
>  		sp->free(sp);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 1bafa043f9f1..be4c67b465b8 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1452,6 +1452,8 @@ static void
>  qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
>  {
>  	port_id_t cid;	/* conflict Nport id */
> +	u16 lid;
> +	struct fc_port *conflict_fcport;
>  
>  	switch (ea->data[0]) {
>  	case MBS_COMMAND_COMPLETE:
> @@ -1467,8 +1469,12 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
>  			qla24xx_post_prli_work(vha, ea->fcport);
>  		} else {
>  			ql_dbg(ql_dbg_disc, vha, 0x20ea,
> -				"%s %d %8phC post gpdb\n",
> -				__func__, __LINE__, ea->fcport->port_name);
> +			    "%s %d %8phC LoopID 0x%x in use with %06x. post gnl\n",
> +			    __func__, __LINE__, ea->fcport->port_name,
> +			    ea->fcport->loop_id, ea->fcport->d_id.b24);
> +
> +			set_bit(ea->fcport->loop_id, vha->hw->loop_id_map);
> +			ea->fcport->loop_id = FC_NO_LOOP_ID;
>  			ea->fcport->chip_reset = vha->hw->base_qpair->chip_reset;
>  			ea->fcport->logout_on_delete = 1;
>  			ea->fcport->send_els_logo = 0;
> @@ -1513,8 +1519,38 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
>  		    ea->fcport->d_id.b.domain, ea->fcport->d_id.b.area,
>  		    ea->fcport->d_id.b.al_pa);
>  
> -		qla2x00_clear_loop_id(ea->fcport);
> -		qla24xx_post_gidpn_work(vha, ea->fcport);
> +		lid = ea->iop[1] & 0xffff;
> +		qlt_find_sess_invalidate_other(vha,
> +		    wwn_to_u64(ea->fcport->port_name),
> +		    ea->fcport->d_id, lid, &conflict_fcport);
> +
> +		if (conflict_fcport) {
> +			/*
> +			 * Another fcport share the same loop_id/nport id.
> +			 * Conflict fcport needs to finish cleanup before this
> +			 * fcport can proceed to login.
> +			 */
> +			conflict_fcport->conflict = ea->fcport;
> +			ea->fcport->login_pause = 1;
> +
> +			ql_dbg(ql_dbg_disc, vha, 0x20ed,
> +			    "%s %d %8phC NPortId %06x inuse with loopid 0x%x. post gidpn\n",
> +			    __func__, __LINE__, ea->fcport->port_name,
> +			    ea->fcport->d_id.b24, lid);
> +			qla2x00_clear_loop_id(ea->fcport);
> +			qla24xx_post_gidpn_work(vha, ea->fcport);
> +		} else {
> +			ql_dbg(ql_dbg_disc, vha, 0x20ed,
> +			    "%s %d %8phC NPortId %06x inuse with loopid 0x%x. sched delete\n",
> +			    __func__, __LINE__, ea->fcport->port_name,
> +			    ea->fcport->d_id.b24, lid);
> +
> +			qla2x00_clear_loop_id(ea->fcport);
> +			set_bit(lid, vha->hw->loop_id_map);
> +			ea->fcport->loop_id = lid;
> +			ea->fcport->keep_nport_handle = 0;
> +			qlt_schedule_sess_for_deletion(ea->fcport, false);
> +		}
>  		break;
>  	}
>  	return;
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 2fd79129bb2a..545c527263d0 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2369,7 +2369,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
>  	int res = 0;
>  	uint16_t state_flags = 0;
>  	uint16_t retry_delay = 0;
> -	uint8_t no_logout = 0;
>  
>  	sts = (sts_entry_t *) pkt;
>  	sts24 = (struct sts_entry_24xx *) pkt;
> @@ -2640,7 +2639,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
>  		break;
>  
>  	case CS_PORT_LOGGED_OUT:
> -		no_logout = 1;
>  	case CS_PORT_CONFIG_CHG:
>  	case CS_PORT_BUSY:
>  	case CS_INCOMPLETE:
> @@ -2671,9 +2669,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
>  				port_state_str[atomic_read(&fcport->state)],
>  				comp_status);
>  
> -			if (no_logout)
> -				fcport->logout_on_delete = 0;
> -
>  			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
>  			qlt_schedule_sess_for_deletion_lock(fcport);
>  		}
> 
Does this really belong to the above patch?
It looks to me as if it fixes a completely different issue...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
