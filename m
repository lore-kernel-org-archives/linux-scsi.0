From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 16/26] qla2xxx: Cleanup unused flags and #defines.
Date: Tue, 24 Mar 2009 09:08:10 -0700
Message-ID: <1237910900-30817-17-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762336AbZCXQIj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:39 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Shyam Sundar <shyam.sundar@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

General cleanup of extraneous/legacy crud.

Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   98 +++++---------------------------------
 drivers/scsi/qla2xxx/qla_init.c |   20 +--------
 drivers/scsi/qla2xxx/qla_isr.c  |   12 +----
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 --
 drivers/scsi/qla2xxx/qla_os.c   |    8 ---
 5 files changed, 15 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 421c634..757e31d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -201,20 +201,7 @@ typedef struct srb {
 /*
  * SRB flag definitions
  */
-#define SRB_TIMEOUT		BIT_0	/* Command timed out */
-#define SRB_DMA_VALID		BIT_1	/* Command sent to ISP */
-#define SRB_WATCHDOG		BIT_2	/* Command on watchdog list */
-#define SRB_ABORT_PENDING	BIT_3	/* Command abort sent to device */
-
-#define SRB_ABORTED		BIT_4	/* Command aborted command already */
-#define SRB_RETRY		BIT_5	/* Command needs retrying */
-#define SRB_GOT_SENSE		BIT_6	/* Command has sense data */
-#define SRB_FAILOVER		BIT_7	/* Command in failover state */
-
-#define SRB_BUSY		BIT_8	/* Command is in busy retry state */
-#define SRB_FO_CANCEL		BIT_9	/* Command don't need to do failover */
-#define SRB_IOCTL		BIT_10	/* IOCTL command. */
-#define SRB_TAPE		BIT_11	/* FCP2 (Tape) command. */
+#define SRB_DMA_VALID		BIT_0	/* Command sent to ISP */
 
 /*
  * ISP I/O Register Set structure definitions.
@@ -1570,39 +1557,13 @@ typedef struct fc_port {
 #define FCS_DEVICE_DEAD		2
 #define FCS_DEVICE_LOST		3
 #define FCS_ONLINE		4
-#define FCS_NOT_SUPPORTED	5
-#define FCS_FAILOVER		6
-#define FCS_FAILOVER_FAILED	7
 
 /*
  * FC port flags.
  */
 #define FCF_FABRIC_DEVICE	BIT_0
 #define FCF_LOGIN_NEEDED	BIT_1
-#define FCF_FO_MASKED		BIT_2
-#define FCF_FAILOVER_NEEDED	BIT_3
-#define FCF_RESET_NEEDED	BIT_4
-#define FCF_PERSISTENT_BOUND	BIT_5
-#define FCF_TAPE_PRESENT	BIT_6
-#define FCF_FARP_DONE		BIT_7
-#define FCF_FARP_FAILED		BIT_8
-#define FCF_FARP_REPLY_NEEDED	BIT_9
-#define FCF_AUTH_REQ		BIT_10
-#define FCF_SEND_AUTH_REQ	BIT_11
-#define FCF_RECEIVE_AUTH_REQ	BIT_12
-#define FCF_AUTH_SUCCESS	BIT_13
-#define FCF_RLC_SUPPORT		BIT_14
-#define FCF_CONFIG		BIT_15	/* Needed? */
-#define FCF_RESCAN_NEEDED	BIT_16
-#define FCF_XP_DEVICE		BIT_17
-#define FCF_MSA_DEVICE		BIT_18
-#define FCF_EVA_DEVICE		BIT_19
-#define FCF_MSA_PORT_ACTIVE	BIT_20
-#define FCF_FAILBACK_DISABLE	BIT_21
-#define FCF_FAILOVER_DISABLE	BIT_22
-#define FCF_DSXXX_DEVICE	BIT_23
-#define FCF_AA_EVA_DEVICE	BIT_24
-#define FCF_AA_MSA_DEVICE	BIT_25
+#define FCF_TAPE_PRESENT	BIT_2
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
@@ -2257,7 +2218,6 @@ struct qla_hw_data {
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
 		uint32_t	gpsc_supported		:1;
-		uint32_t	vsan_enabled		:1;
 		uint32_t	npiv_supported		:1;
 		uint32_t	fce_enabled		:1;
 		uint32_t	fac_supported		:1;
@@ -2302,7 +2262,6 @@ struct qla_hw_data {
 	uint16_t	max_loop_id;
 
 	uint16_t	fb_rev;
-	uint16_t	max_public_loop_ids;
 	uint16_t	min_external_loopid;    /* First external loop Id */
 
 #define PORT_SPEED_UNKNOWN 0xFFFF
@@ -2458,15 +2417,6 @@ struct qla_hw_data {
 	struct completion mbx_cmd_comp; /* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 
-	uint32_t	mbx_flags;
-#define  MBX_IN_PROGRESS	BIT_0
-#define  MBX_BUSY		BIT_1   /* Got the Access */
-#define  MBX_SLEEPING_ON_SEM	BIT_2
-#define  MBX_POLLING_FOR_COMP	BIT_3
-#define  MBX_COMPLETED		BIT_4
-#define  MBX_TIMEDOUT		BIT_5
-#define  MBX_ACCESS_TIMEDOUT	BIT_6
-
 	/* Basic firmware related information. */
 	uint16_t	fw_major_version;
 	uint16_t	fw_minor_version;
@@ -2619,36 +2569,19 @@ typedef struct scsi_qla_host {
 #define LOOP_RESYNC_ACTIVE	5
 #define LOCAL_LOOP_UPDATE	6	/* Perform a local loop update. */
 #define RSCN_UPDATE		7	/* Perform an RSCN update. */
-#define MAILBOX_RETRY		8
-#define ISP_RESET_NEEDED	9	/* Initiate a ISP reset. */
-#define FAILOVER_EVENT_NEEDED	10
-#define FAILOVER_EVENT		11
-#define FAILOVER_NEEDED		12
-#define SCSI_RESTART_NEEDED	13	/* Processes SCSI retry queue. */
-#define PORT_RESTART_NEEDED	14	/* Processes Retry queue. */
-#define RESTART_QUEUES_NEEDED	15	/* Restarts the Lun queue. */
-#define ABORT_QUEUES_NEEDED	16
-#define RELOGIN_NEEDED		17
-#define LOGIN_RETRY_NEEDED	18	/* Initiate required fabric logins. */
-#define REGISTER_FC4_NEEDED	19	/* SNS FC4 registration required. */
-#define ISP_ABORT_RETRY		20	/* ISP aborted. */
-#define FCPORT_RESCAN_NEEDED	21	/* IO descriptor processing needed */
-#define IODESC_PROCESS_NEEDED	22	/* IO descriptor processing needed */
-#define IOCTL_ERROR_RECOVERY	23
-#define LOOP_RESET_NEEDED	24
-#define BEACON_BLINK_NEEDED	25
-#define REGISTER_FDMI_NEEDED	26
-#define FCPORT_UPDATE_NEEDED	27
-#define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
-#define UNLOADING		29
-#define NPIV_CONFIG_NEEDED	30
+#define RELOGIN_NEEDED		8
+#define REGISTER_FC4_NEEDED	9	/* SNS FC4 registration required. */
+#define ISP_ABORT_RETRY		10	/* ISP aborted. */
+#define BEACON_BLINK_NEEDED	11
+#define REGISTER_FDMI_NEEDED	12
+#define FCPORT_UPDATE_NEEDED	13
+#define VP_DPC_NEEDED		14	/* wake up for VP dpc handling */
+#define UNLOADING		15
+#define NPIV_CONFIG_NEEDED	16
 
 	uint32_t	device_flags;
-#define DFLG_LOCAL_DEVICES		BIT_0
-#define DFLG_RETRY_LOCAL_DEVICES	BIT_1
-#define DFLG_FABRIC_DEVICES		BIT_2
-#define SWITCH_FOUND			BIT_3
-#define DFLG_NO_CABLE			BIT_4
+#define SWITCH_FOUND		BIT_0
+#define DFLG_NO_CABLE		BIT_1
 
 	srb_t		*status_srb;	/* Status continuation entry. */
 
@@ -2761,10 +2694,5 @@ typedef struct scsi_qla_host {
 #include "qla_inline.h"
 
 #define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
-#define CMD_COMPL_STATUS(Cmnd)  ((Cmnd)->SCp.this_residual)
-#define CMD_RESID_LEN(Cmnd)	((Cmnd)->SCp.buffers_residual)
-#define CMD_SCSI_STATUS(Cmnd)	((Cmnd)->SCp.Status)
-#define CMD_ACTUAL_SNSLEN(Cmnd)	((Cmnd)->SCp.Message)
-#define CMD_ENTRY_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
 
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a274750..d525808 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -72,7 +72,6 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->dpc_flags = 0;
 	vha->flags.management_server_logged_in = 0;
 	vha->marker_needed = 0;
-	ha->mbx_flags = 0;
 	ha->isp_abort_cnt = 0;
 	ha->beacon_blink_led = 0;
 	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
@@ -515,7 +514,6 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 static inline void
 qla24xx_reset_risc(scsi_qla_host_t *vha)
 {
-	int hw_evt = 0;
 	unsigned long flags = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -545,8 +543,6 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 		d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
 		barrier();
 	}
-	if (cnt == 0)
-		hw_evt = 1;
 
 	/* Wait for soft-reset to complete. */
 	d2 = RD_REG_DWORD(&reg->ctrl_status);
@@ -2011,7 +2007,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	fcport->port_type = FCT_UNKNOWN;
 	fcport->loop_id = FC_NO_LOOP_ID;
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
-	fcport->flags = FCF_RLC_SUPPORT;
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
 
 	return fcport;
@@ -2193,7 +2188,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			    vha->host_no, fcport->loop_id));
 
 			atomic_set(&fcport->state, FCS_DEVICE_LOST);
-			fcport->flags &= ~FCF_FARP_DONE;
 		}
 	}
 
@@ -2250,8 +2244,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			    WWN_SIZE))
 				continue;
 
-			fcport->flags &= ~(FCF_FABRIC_DEVICE |
-			    FCF_PERSISTENT_BOUND);
+			fcport->flags &= ~FCF_FABRIC_DEVICE;
 			fcport->loop_id = new_fcport->loop_id;
 			fcport->port_type = new_fcport->port_type;
 			fcport->d_id.b24 = new_fcport->d_id.b24;
@@ -2264,7 +2257,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 
 		if (!found) {
 			/* New device, add to fcports list. */
-			new_fcport->flags &= ~FCF_PERSISTENT_BOUND;
 			if (vha->vp_idx) {
 				new_fcport->vha = vha;
 				new_fcport->vp_idx = vha->vp_idx;
@@ -2297,11 +2289,6 @@ cleanup_allocation:
 		    "rval=%x\n", vha->host_no, rval));
 	}
 
-	if (found_devs) {
-		vha->device_flags |= DFLG_LOCAL_DEVICES;
-		vha->device_flags &= ~DFLG_RETRY_LOCAL_DEVICES;
-	}
-
 	return (rval);
 }
 
@@ -2787,7 +2774,6 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 				fcport->loop_id = FC_NO_LOOP_ID;
 				fcport->flags |= (FCF_FABRIC_DEVICE |
 				    FCF_LOGIN_NEEDED);
-				fcport->flags &= ~FCF_PERSISTENT_BOUND;
 				break;
 			}
 
@@ -2830,9 +2816,6 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	kfree(swl);
 	kfree(new_fcport);
 
-	if (!list_empty(new_fcports))
-		vha->device_flags |= DFLG_FABRIC_DEVICES;
-
 	return (rval);
 }
 
@@ -3015,7 +2998,6 @@ qla2x00_device_resync(scsi_qla_host_t *vha)
 					    0, 0);
 				}
 			}
-			fcport->flags &= ~FCF_FARP_DONE;
 		}
 	}
 	return (rval);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8e91f4a..0f03812 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -852,9 +852,6 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		/* Free outstanding command slot. */
 		req->outstanding_cmds[index] = NULL;
 
-		CMD_COMPL_STATUS(sp->cmd) = 0L;
-		CMD_SCSI_STATUS(sp->cmd) = 0L;
-
 		/* Save ISP completion status */
 		sp->cmd->result = DID_OK << 16;
 
@@ -955,7 +952,6 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 	if (sense_len >= SCSI_SENSE_BUFFERSIZE)
 		sense_len = SCSI_SENSE_BUFFERSIZE;
 
-	CMD_ACTUAL_SNSLEN(cp) = sense_len;
 	sp->request_sense_length = sense_len;
 	sp->request_sense_ptr = cp->sense_buffer;
 	if (sp->request_sense_length > 32)
@@ -973,8 +969,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 	    cp->device->channel, cp->device->id, cp->device->lun, cp,
 	    cp->serial_number));
 	if (sense_len)
-		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
-		    CMD_ACTUAL_SNSLEN(cp)));
+		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer, sense_len));
 }
 
 /**
@@ -1043,9 +1038,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	}
 
   	lscsi_status = scsi_status & STATUS_MASK;
-	CMD_ENTRY_STATUS(cp) = sts->entry_status;
-	CMD_COMPL_STATUS(cp) = comp_status;
-	CMD_SCSI_STATUS(cp) = scsi_status;
 
 	fcport = sp->fcport;
 
@@ -1104,7 +1096,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
 			resid = resid_len;
 			scsi_set_resid(cp, resid);
-			CMD_RESID_LEN(cp) = resid;
 
 			if (!lscsi_status &&
 			    ((unsigned)(scsi_bufflen(cp) - resid) <
@@ -1160,7 +1151,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 		if (scsi_status & SS_RESIDUAL_UNDER) {
 			scsi_set_resid(cp, resid);
-			CMD_RESID_LEN(cp) = resid;
 		} else {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld:%d:%d) UNDERRUN status detected "
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index dc5e5d9..7af9bd7 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1197,10 +1197,6 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		fcport->d_id.b.al_pa = pd->port_id[2];
 		fcport->d_id.b.rsvd_1 = 0;
 
-		/* Check for device require authentication. */
-		pd->common_features & BIT_5 ? (fcport->flags |= FCF_AUTH_REQ) :
-		    (fcport->flags &= ~FCF_AUTH_REQ);
-
 		/* If not target must be initiator or unknown type. */
 		if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
 			fcport->port_type = FCT_INITIATOR;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c3d165..ba3309f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2856,19 +2856,11 @@ qla2x00_timer(scsi_qla_host_t *vha)
 				spin_unlock_irqrestore(&ha->hardware_lock,
 								cpu_flags);
 			}
-			set_bit(ABORT_QUEUES_NEEDED, &vha->dpc_flags);
 			start_dpc++;
 		}
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
-			DEBUG(printk("scsi(%ld): Loop down exceed 4 mins - "
-			    "restarting queues.\n",
-			    vha->host_no));
-
-			set_bit(RESTART_QUEUES_NEEDED, &vha->dpc_flags);
-			start_dpc++;
-
 			if (!(vha->device_flags & DFLG_NO_CABLE) &&
 			    !vha->vp_idx) {
 				DEBUG(printk("scsi(%ld): Loop down - "
-- 
1.6.2.rc0.55.g30aa4f

