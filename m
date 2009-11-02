From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [patch 1/1] scsi_transport_fc: Introduce helper function for blocking scsi_eh
Date: Mon, 2 Nov 2009 12:11:43 -0800
Message-ID: <C3F7F8CA-BA12-482A-B541-38A006608F25@qlogic.com>
References: <20091030165928.517760000@de.ibm.com> <20091030170727.393465000@de.ibm.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:32364 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbZKBULi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 15:11:38 -0500
In-Reply-To: <20091030170727.393465000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, Abhijeet Joglekar <abjoglek@cisco.com>, Joe Eykholt <jeykholt@cisco.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Thanks Christof.

Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>

On Oct 30, 2009, at 9:59 AM, Christof Schmitt wrote:

> From: Christof Schmitt <christof.schmitt@de.ibm.com>
>
> Move the duplicated code from FC LLDs to SCSI FC transport class.
>
> Acked-by: James Smart <james.smart@emulex.com>
> Cc: Abhijeet Joglekar <abjoglek@cisco.com>
> Cc: Joe Eykholt <jeykholt@cisco.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> ---
> drivers/scsi/fnic/fnic_scsi.c    |   20 ++------------------
> drivers/scsi/lpfc/lpfc_scsi.c    |   30 ++++--------------------------
> drivers/scsi/qla2xxx/qla_os.c    |   25 ++++---------------------
> drivers/scsi/scsi_transport_fc.c |   26 ++++++++++++++++++++++++++
> include/scsi/scsi_transport_fc.h |    1 +
> 5 files changed, 37 insertions(+), 65 deletions(-)
>
> --- a/drivers/scsi/scsi_transport_fc.c	2009-10-30 17:47:23.000000000  
> +0100
> +++ b/drivers/scsi/scsi_transport_fc.c	2009-10-30 17:48:50.000000000  
> +0100
> @@ -27,6 +27,7 @@
>  */
> #include <linux/module.h>
> #include <linux/init.h>
> +#include <linux/delay.h>
> #include <scsi/scsi_device.h>
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_transport.h>
> @@ -3144,6 +3145,31 @@ fc_scsi_scan_rport(struct work_struct *w
> 	spin_unlock_irqrestore(shost->host_lock, flags);
> }
>
> +/**
> + * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
> + * @cmnd: SCSI command that scsi_eh is trying to recover
> + *
> + * This routine can be called from a FC LLD scsi_eh callback. It
> + * blocks the scsi_eh thread until the fc_rport leaves the
> + * FC_PORTSTATE_BLOCKED. This is necessary to avoid the scsi_eh
> + * failing recovery actions for blocked rports which would lead to
> + * offlined SCSI devices.
> + */
> +void fc_block_scsi_eh(struct scsi_cmnd *cmnd)
> +{
> +	struct Scsi_Host *shost = cmnd->device->host;
> +	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd- 
> >device));
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		msleep(1000);
> +		spin_lock_irqsave(shost->host_lock, flags);
> +	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +EXPORT_SYMBOL(fc_block_scsi_eh);
>
> /**
>  * fc_vport_setup - allocates and creates a FC virtual port.
> --- a/include/scsi/scsi_transport_fc.h	2009-10-30 17:47:25.000000000  
> +0100
> +++ b/include/scsi/scsi_transport_fc.h	2009-10-30 17:48:50.000000000  
> +0100
> @@ -807,5 +807,6 @@ void fc_host_post_vendor_event(struct Sc
> struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
> 		struct fc_vport_identifiers *);
> int fc_vport_terminate(struct fc_vport *vport);
> +void fc_block_scsi_eh(struct scsi_cmnd *cmnd);
>
> #endif /* SCSI_TRANSPORT_FC_H */
> --- a/drivers/scsi/fnic/fnic_scsi.c	2009-10-30 17:47:23.000000000  
> +0100
> +++ b/drivers/scsi/fnic/fnic_scsi.c	2009-10-30 17:48:50.000000000  
> +0100
> @@ -1225,22 +1225,6 @@ void fnic_terminate_rport_io(struct fc_r
>
> }
>
> -static void fnic_block_error_handler(struct scsi_cmnd *sc)
> -{
> -	struct Scsi_Host *shost = sc->device->host;
> -	struct fc_rport *rport = starget_to_rport(scsi_target(sc->device));
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
> -		spin_unlock_irqrestore(shost->host_lock, flags);
> -		msleep(1000);
> -		spin_lock_irqsave(shost->host_lock, flags);
> -	}
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> -
> -}
> -
> /*
>  * This function is exported to SCSI for sending abort cmnds.
>  * A SCSI IO is represented by a io_req in the driver.
> @@ -1260,7 +1244,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 	DECLARE_COMPLETION_ONSTACK(tm_done);
>
> 	/* Wait for rport to unblock */
> -	fnic_block_error_handler(sc);
> +	fc_block_scsi_eh(sc);
>
> 	/* Get local-port, check ready and link up */
> 	lp = shost_priv(sc->device->host);
> @@ -1542,7 +1526,7 @@ int fnic_device_reset(struct scsi_cmnd *
> 	DECLARE_COMPLETION_ONSTACK(tm_done);
>
> 	/* Wait for rport to unblock */
> -	fnic_block_error_handler(sc);
> +	fc_block_scsi_eh(sc);
>
> 	/* Get local-port, check ready and link up */
> 	lp = shost_priv(sc->device->host);
> --- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-30 17:47:23.000000000  
> +0100
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-30 17:48:50.000000000  
> +0100
> @@ -2917,28 +2917,6 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
> }
>
> /**
> - * lpfc_block_error_handler - Routine to block error  handler
> - * @cmnd: Pointer to scsi_cmnd data structure.
> - *
> - *  This routine blocks execution till fc_rport state is not  
> FC_PORSTAT_BLCOEKD.
> - **/
> -static void
> -lpfc_block_error_handler(struct scsi_cmnd *cmnd)
> -{
> -	struct Scsi_Host *shost = cmnd->device->host;
> -	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd- 
> >device));
> -
> -	spin_lock_irq(shost->host_lock);
> -	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
> -		spin_unlock_irq(shost->host_lock);
> -		msleep(1000);
> -		spin_lock_irq(shost->host_lock);
> -	}
> -	spin_unlock_irq(shost->host_lock);
> -	return;
> -}
> -
> -/**
>  * lpfc_abort_handler - scsi_host_template eh_abort_handler entry  
> point
>  * @cmnd: Pointer to scsi_cmnd data structure.
>  *
> @@ -2961,7 +2939,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
> 	int ret = SUCCESS;
> 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
>
> -	lpfc_block_error_handler(cmnd);
> +	fc_block_scsi_eh(cmnd);
> 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
> 	BUG_ON(!lpfc_cmd);
>
> @@ -3259,7 +3237,7 @@ lpfc_device_reset_handler(struct scsi_cm
> 	struct lpfc_scsi_event_header scsi_event;
> 	int status;
>
> -	lpfc_block_error_handler(cmnd);
> +	fc_block_scsi_eh(cmnd);
>
> 	status = lpfc_chk_tgt_mapped(vport, cmnd);
> 	if (status == FAILED) {
> @@ -3318,7 +3296,7 @@ lpfc_target_reset_handler(struct scsi_cm
> 	struct lpfc_scsi_event_header scsi_event;
> 	int status;
>
> -	lpfc_block_error_handler(cmnd);
> +	fc_block_scsi_eh(cmnd);
>
> 	status = lpfc_chk_tgt_mapped(vport, cmnd);
> 	if (status == FAILED) {
> @@ -3384,7 +3362,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd
> 	fc_host_post_vendor_event(shost, fc_get_event_number(),
> 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
>
> -	lpfc_block_error_handler(cmnd);
> +	fc_block_scsi_eh(cmnd);
>
> 	/*
> 	 * Since the driver manages a single bus device, reset all
> --- a/drivers/scsi/qla2xxx/qla_os.c	2009-10-30 17:47:23.000000000  
> +0100
> +++ b/drivers/scsi/qla2xxx/qla_os.c	2009-10-30 17:48:50.000000000  
> +0100
> @@ -728,23 +728,6 @@ qla2x00_abort_fcport_cmds(fc_port_t *fcp
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> }
>
> -static void
> -qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
> -{
> -	struct Scsi_Host *shost = cmnd->device->host;
> -	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd- 
> >device));
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
> -		spin_unlock_irqrestore(shost->host_lock, flags);
> -		msleep(1000);
> -		spin_lock_irqsave(shost->host_lock, flags);
> -	}
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> -	return;
> -}
> -
> / 
> **************************************************************************
> * qla2xxx_eh_abort
> *
> @@ -774,7 +757,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> 	struct req_que *req = vha->req;
> 	srb_t *spt;
>
> -	qla2x00_block_error_handler(cmd);
> +	fc_block_scsi_eh(cmd);
>
> 	if (!CMD_SP(cmd))
> 		return SUCCESS;
> @@ -905,7 +888,7 @@ __qla2xxx_eh_generic_reset(char *name, e
> 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
> 	int err;
>
> -	qla2x00_block_error_handler(cmd);
> +	fc_block_scsi_eh(cmd);
>
> 	if (!fcport)
> 		return FAILED;
> @@ -985,7 +968,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
> 	unsigned long serial;
> 	srb_t *sp = (srb_t *) CMD_SP(cmd);
>
> -	qla2x00_block_error_handler(cmd);
> +	fc_block_scsi_eh(cmd);
>
> 	id = cmd->device->id;
> 	lun = cmd->device->lun;
> @@ -1048,7 +1031,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
> 	srb_t *sp = (srb_t *) CMD_SP(cmd);
> 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
>
> -	qla2x00_block_error_handler(cmd);
> +	fc_block_scsi_eh(cmd);
>
> 	id = cmd->device->id;
> 	lun = cmd->device->lun;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

