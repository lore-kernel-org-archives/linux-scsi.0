From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 21/22] qla2xxx: Improve submission of non critical MB
 interface.
Date: Wed, 7 Dec 2016 13:16:39 +0100
Message-ID: <3881057b-1a40-1a03-bb45-5efd618e888d@suse.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-22-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:51755 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751884AbcLGMQm (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 7 Dec 2016 07:16:42 -0500
In-Reply-To: <1481056251-2310-22-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On 12/06/2016 09:30 PM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Move Get ID list, stats and Get Port Databasae mailbox commands
> out of MB interface which is serialized to IOCB interface
> to reduce contention.
> 
> Current driver wait for FW to be in the ready state
> before processing in coming commands. For loop mode,
> certain initiator takes longer for login to complete.
> While other initiators already sends commands.
> 
> Add processing of Report ID Acquision F2. For Direct
> connect and target mode, Rida F2 provides the ALPA/Nport ID
> of the local adapter.
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h    |  34 +++-
>  drivers/scsi/qla2xxx/qla_dfs.c    |  85 +++++++++-
>  drivers/scsi/qla2xxx/qla_fw.h     |  18 +++
>  drivers/scsi/qla2xxx/qla_gbl.h    |  12 +-
>  drivers/scsi/qla2xxx/qla_init.c   | 112 ++++++--------
>  drivers/scsi/qla2xxx/qla_isr.c    |  22 ++-
>  drivers/scsi/qla2xxx/qla_mbx.c    | 315 +++++++++++++++++++++++++++++++++++---
>  drivers/scsi/qla2xxx/qla_os.c     |  95 +++++++++---
>  drivers/scsi/qla2xxx/qla_target.c |  53 ++++---
>  drivers/scsi/qla2xxx/qla_target.h |   5 +
>  10 files changed, 607 insertions(+), 144 deletions(-)
> 
[ .. ]
> @@ -200,6 +201,8 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
>  void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
>  	uint16_t *);
>  int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
> +void qla2x00_schedule_work(struct scsi_qla_host *);
> +
>  
>  /*
>   * Global Functions in qla_mid.c source file.
Pointless newline.

[ .. ]
> @@ -796,11 +802,16 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
>  		    "LOOP UP detected (%s Gbps).\n",
>  		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
>  
> +
>  		vha->flags.management_server_logged_in = 0;
>  		qla2x00_post_aen_work(vha, FCH_EVT_LINKUP, ha->link_data_rate);
>  		break;
>  
Same here.

> @@ -5856,3 +5896,238 @@ struct cs84xx_mgmt_cmd {
>  
>  	return rval;
>  }
> +
> +void qla2x00_async_mb_sp_done(void *v, void *s, int res)
> +{
> +	struct srb *sp = s;
> +	sp->u.iocb_cmd.u.mbx.rc = res;
> +	complete(&sp->u.iocb_cmd.u.mbx.comp);
> +	/* don't free sp here. Let the caller do the free */
> +}
> +
> +/* This mailbox uses the iocb interface to send MB command.
> + * This allows non-critial (non chip setup) command to go out in parrallel.
> + */
> +int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
> +{
> +	int rval = QLA_FUNCTION_FAILED;
> +	srb_t *sp;
> +	struct srb_iocb *c;
> +	char *name;
> +
> +	if (!vha->hw->flags.fw_started)
> +		goto done;
> +
> +	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> +	if (!sp)
> +		goto done;
> +
> +
And here.

[ .. ]
> +	case QLA_FUNCTION_TIMEOUT:
> +		ql_dbg(ql_dbg_mbx, vha, 0xffff,
> +			"%s: %s Timeout. %x.\n",
> +			__func__, name, rval);
> +		break;
> +	case  QLA_SUCCESS:
> +		ql_dbg(ql_dbg_mbx, vha, 0xffff,
> +			"%s: %s done.\n",
> +			__func__, sp->name);
> +		sp->free(sp->vha, sp);
> +		break;
> +
> +	default:
> +		ql_dbg(ql_dbg_mbx, vha, 0xffff,
> +			"%s: %s Failed. %x.\n",
> +			__func__,sp->name, rval);
> +		sp->free(sp->vha, sp);
> +		break;
> +	}
> +
> +	return rval;
> +
> +done_free_sp:
> +	sp->free(sp->vha, sp);
> +done:
> +	return rval;
> +
> +}
> +
> +
And here.

[ .. ]
> +	memset(&mc, 0, sizeof(mc));
> +	mc.mb[0] = MBC_GET_PORT_DATABASE;
> +	mc.mb[1] = cpu_to_le16(fcport->loop_id);
> +	mc.mb[2] = MSW(pd_dma);
> +	mc.mb[3] = LSW(pd_dma);
> +	mc.mb[6] = MSW(MSD(pd_dma));
> +	mc.mb[7] = LSW(MSD(pd_dma));
> +	mc.mb[9] = cpu_to_le16(vha->vp_idx);
> +	mc.mb[10] = cpu_to_le16((uint16_t)opt);
> +
> +
And here.

> +	rval = qla24xx_send_mb_cmd(vha, &mc);
> +	if (rval != QLA_SUCCESS) {
> +		ql_dbg(ql_dbg_mbx, vha, 0xffff,
> +		    "%s: %8phC fail\n",
> +		    __func__, fcport->port_name);
> +		goto done_free_sp;
> +	}
> +
> +	rval = _qla24xx_parse_gpdb(vha,fcport, pd);
> +
> +	ql_dbg(ql_dbg_mbx, vha, 0xffff,
> +		"%s: %8phC done\n",
> +		   __func__, fcport->port_name);
> +
> +done_free_sp:
> +	if (pd)
> +		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
> +
> +done:
> +	return rval;
> +}
> +
> +
And here.


[ .. ]
> +void qla2x00_schedule_work(struct scsi_qla_host *vha)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vha->work_lock, flags);
> +	if (vha->flags.iocb_work_sheduled) {
> +		spin_unlock_irqrestore(&vha->work_lock, flags);
> +		return;
> +	} else {
> +		vha->flags.iocb_work_sheduled = 1;
> +	}
> +	spin_unlock_irqrestore(&vha->work_lock, flags);
> +
> +
And here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
