From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.19+ merge window
Date: Fri, 02 Nov 2018 14:41:03 -0700
Message-ID: <1541194863.2824.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of minor small (and safe changes) that didn't make the
initial pull request plus some bug fixes.  

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Bart Van Assche (7):
      scsi: qla2xxx: Remove two arguments from qlafx00_error_entry()
      scsi: qla2xxx: Make sure that qlafx00_ioctl_iosb_entry() initializes 'res'
      scsi: qla2xxx: Remove a set-but-not-used variable
      scsi: qla2xxx: Make qla2x00_sysfs_write_nvram() easier to analyze
      scsi: qla2xxx: Declare local functions 'static'
      scsi: qla2xxx: Improve several kernel-doc headers
      scsi: qla2xxx: Modify fall-through annotations

Nathan Chancellor (1):
      scsi: 3w-sas: 3w-9xxx: Use unsigned char for cdb

Roland Dreier (2):
      scsi: target: Don't request modules that aren't even built
      scsi: target: Set response length for REPORT TARGET PORT GROUPS

Sabyasachi Gupta (1):
      scsi: mvsas: Use dma_pool_zalloc

YueHaibing (1):
      scsi: mvsas: Remove set but not used variable 'id'

And the diffstat:

 drivers/scsi/3w-9xxx.c                 | 12 ++++++++----
 drivers/scsi/3w-sas.c                  |  8 +++++---
 drivers/scsi/mvsas/mv_sas.c            |  6 ++----
 drivers/scsi/qla2xxx/qla_attr.c        |  2 +-
 drivers/scsi/qla2xxx/qla_init.c        |  7 ++++---
 drivers/scsi/qla2xxx/qla_iocb.c        |  4 ++--
 drivers/scsi/qla2xxx/qla_isr.c         |  6 +++---
 drivers/scsi/qla2xxx/qla_mbx.c         |  6 +++---
 drivers/scsi/qla2xxx/qla_mr.c          | 21 +++++++++------------
 drivers/scsi/qla2xxx/qla_nx.c          |  2 +-
 drivers/scsi/qla2xxx/qla_nx2.c         |  2 +-
 drivers/scsi/qla2xxx/qla_os.c          |  6 +++---
 drivers/scsi/qla2xxx/qla_sup.c         |  2 +-
 drivers/scsi/qla2xxx/qla_target.c      |  8 ++++----
 drivers/target/target_core_alua.c      |  2 +-
 drivers/target/target_core_transport.c |  8 ++++----
 16 files changed, 52 insertions(+), 50 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 05293babb031..2d655a97b959 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -143,7 +143,9 @@ static int twa_poll_status_gone(TW_Device_Extension *tw_dev, u32 flag, int secon
 static int twa_post_command_packet(TW_Device_Extension *tw_dev, int request_id, char internal);
 static int twa_reset_device_extension(TW_Device_Extension *tw_dev);
 static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset);
-static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry *sglistarg);
+static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
+				   unsigned char *cdb, int use_sg,
+				   TW_SG_Entry *sglistarg);
 static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int request_id);
 static char *twa_string_lookup(twa_message_type *table, unsigned int aen_code);
 
@@ -278,7 +280,7 @@ static int twa_aen_complete(TW_Device_Extension *tw_dev, int request_id)
 static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
 {
 	int request_id = 0;
-	char cdb[TW_MAX_CDB_LEN];
+	unsigned char cdb[TW_MAX_CDB_LEN];
 	TW_SG_Entry sglist[1];
 	int finished = 0, count = 0;
 	TW_Command_Full *full_command_packet;
@@ -423,7 +425,7 @@ static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 /* This function will read the aen queue from the isr */
 static int twa_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 {
-	char cdb[TW_MAX_CDB_LEN];
+	unsigned char cdb[TW_MAX_CDB_LEN];
 	TW_SG_Entry sglist[1];
 	TW_Command_Full *full_command_packet;
 	int retval = 1;
@@ -1798,7 +1800,9 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 static DEF_SCSI_QCMD(twa_scsi_queue)
 
 /* This function hands scsi cdb's to the firmware */
-static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry *sglistarg)
+static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
+				   unsigned char *cdb, int use_sg,
+				   TW_SG_Entry *sglistarg)
 {
 	TW_Command_Full *full_command_packet;
 	TW_Command_Apache *command_packet;
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 266bdac75304..480cf82700e9 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -287,7 +287,9 @@ static int twl_post_command_packet(TW_Device_Extension *tw_dev, int request_id)
 } /* End twl_post_command_packet() */
 
 /* This function hands scsi cdb's to the firmware */
-static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry_ISO *sglistarg)
+static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
+				   unsigned char *cdb, int use_sg,
+				   TW_SG_Entry_ISO *sglistarg)
 {
 	TW_Command_Full *full_command_packet;
 	TW_Command_Apache *command_packet;
@@ -372,7 +374,7 @@ static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 /* This function will read the aen queue from the isr */
 static int twl_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 {
-	char cdb[TW_MAX_CDB_LEN];
+	unsigned char cdb[TW_MAX_CDB_LEN];
 	TW_SG_Entry_ISO sglist[1];
 	TW_Command_Full *full_command_packet;
 	int retval = 1;
@@ -554,7 +556,7 @@ static int twl_poll_response(TW_Device_Extension *tw_dev, int request_id, int se
 static int twl_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
 {
 	int request_id = 0;
-	char cdb[TW_MAX_CDB_LEN];
+	unsigned char cdb[TW_MAX_CDB_LEN];
 	TW_SG_Entry_ISO sglist[1];
 	int finished = 0, count = 0;
 	TW_Command_Full *full_command_packet;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 3df1428df317..311d23c727ce 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -790,12 +790,11 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	slot->n_elem = n_elem;
 	slot->slot_tag = tag;
 
-	slot->buf = dma_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
+	slot->buf = dma_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
 	if (!slot->buf) {
 		rc = -ENOMEM;
 		goto err_out_tag;
 	}
-	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
 
 	tei.task = task;
 	tei.hdr = &mvi->slot[tag];
@@ -1906,8 +1905,7 @@ static void mvs_work_queue(struct work_struct *work)
 
 		if (phy->phy_event & PHY_PLUG_OUT) {
 			u32 tmp;
-			struct sas_identify_frame *id;
-			id = (struct sas_identify_frame *)phy->frame_rcvd;
+
 			tmp = MVS_CHIP_DISP->read_phy_ctl(mvi, phy_no);
 			phy->phy_event &= ~PHY_PLUG_OUT;
 			if (!(tmp & PHY_READY_MASK)) {
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index b28f159fdaee..0bb9ac6ece92 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -218,7 +218,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 
 	mutex_lock(&ha->optrom_mutex);
 	if (qla2x00_chip_is_down(vha)) {
-		mutex_unlock(&vha->hw->optrom_mutex);
+		mutex_unlock(&ha->optrom_mutex);
 		return -EAGAIN;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c72d8012fe2a..6fe20c27acc1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -425,7 +425,7 @@ void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	__qla24xx_handle_gpdb_event(vha, ea);
 }
 
-int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+static int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_work_evt *e;
 
@@ -680,7 +680,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 					    fcport);
 					break;
 				}
-				/* drop through */
+				/* fall through */
 			default:
 				if (fcport_is_smaller(fcport)) {
 					/* local adapter is bigger */
@@ -1551,7 +1551,8 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 }
 
 
-void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea)
+static void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
+				      struct event_arg *ea)
 {
 	ql_dbg(ql_dbg_disc, vha, 0x2118,
 	    "%s %d %8phC post PRLI\n",
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 86fb8b21aa71..032635321ad6 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1195,8 +1195,8 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
  * @sp: SRB command to process
  * @cmd_pkt: Command type 3 IOCB
  * @tot_dsds: Total number of segments to transfer
- * @tot_prot_dsds:
- * @fw_prot_opts:
+ * @tot_prot_dsds: Total number of segments with protection information
+ * @fw_prot_opts: Protection options to be passed to firmware
  */
 inline int
 qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d73b04e40590..30d3090842f8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -25,7 +25,7 @@ static int qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
- * @irq:
+ * @irq: interrupt number
  * @dev_id: SCSI driver HA context
  *
  * Called by system whenever the host adapter generates an interrupt.
@@ -144,7 +144,7 @@ qla2x00_check_reg16_for_disconnect(scsi_qla_host_t *vha, uint16_t reg)
 
 /**
  * qla2300_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
- * @irq:
+ * @irq: interrupt number
  * @dev_id: SCSI driver HA context
  *
  * Called by system whenever the host adapter generates an interrupt.
@@ -3109,7 +3109,7 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 
 /**
  * qla24xx_intr_handler() - Process interrupts for the ISP23xx and ISP24xx.
- * @irq:
+ * @irq: interrupt number
  * @dev_id: SCSI driver HA context
  *
  * Called by system whenever the host adapter generates an interrupt.
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2f3e5075ae76..191b6b7c8747 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3478,9 +3478,9 @@ qla8044_read_serdes_word(scsi_qla_host_t *vha, uint32_t addr, uint32_t *data)
 /**
  * qla2x00_set_serdes_params() -
  * @vha: HA context
- * @sw_em_1g:
- * @sw_em_2g:
- * @sw_em_4g:
+ * @sw_em_1g: serial link options
+ * @sw_em_2g: serial link options
+ * @sw_em_4g: serial link options
  *
  * Returns
  */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 521a51370554..60f964c53c01 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2212,7 +2212,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct bsg_job *bsg_job;
 	struct fc_bsg_reply *bsg_reply;
 	struct srb_iocb *iocb_job;
-	int res;
+	int res = 0;
 	struct qla_mt_iocb_rsp_fx00 fstatus;
 	uint8_t	*fw_sts_ptr;
 
@@ -2624,7 +2624,7 @@ qlafx00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
  * qlafx00_multistatus_entry() - Process Multi response queue entries.
  * @vha: SCSI driver HA context
  * @rsp: response queue
- * @pkt:
+ * @pkt: received packet
  */
 static void
 qlafx00_multistatus_entry(struct scsi_qla_host *vha,
@@ -2681,12 +2681,10 @@ qlafx00_multistatus_entry(struct scsi_qla_host *vha,
  * @vha: SCSI driver HA context
  * @rsp: response queue
  * @pkt: Entry pointer
- * @estatus:
- * @etype:
  */
 static void
 qlafx00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp,
-		    struct sts_entry_fx00 *pkt, uint8_t estatus, uint8_t etype)
+		    struct sts_entry_fx00 *pkt)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
@@ -2695,9 +2693,6 @@ qlafx00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp,
 	struct req_que *req = NULL;
 	int res = DID_ERROR << 16;
 
-	ql_dbg(ql_dbg_async, vha, 0x507f,
-	    "type of error status in response: 0x%x\n", estatus);
-
 	req = ha->req_q_map[que];
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
@@ -2745,9 +2740,11 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 
 		if (pkt->entry_status != 0 &&
 		    pkt->entry_type != IOCTL_IOSB_TYPE_FX00) {
+			ql_dbg(ql_dbg_async, vha, 0x507f,
+			       "type of error status in response: 0x%x\n",
+			       pkt->entry_status);
 			qlafx00_error_entry(vha, rsp,
-			    (struct sts_entry_fx00 *)pkt, pkt->entry_status,
-			    pkt->entry_type);
+					    (struct sts_entry_fx00 *)pkt);
 			continue;
 		}
 
@@ -2867,7 +2864,7 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 /**
  * qlafx00x_mbx_completion() - Process mailbox command completions.
  * @vha: SCSI driver HA context
- * @mb0:
+ * @mb0: value to be written into mailbox register 0
  */
 static void
 qlafx00_mbx_completion(scsi_qla_host_t *vha, uint32_t mb0)
@@ -2893,7 +2890,7 @@ qlafx00_mbx_completion(scsi_qla_host_t *vha, uint32_t mb0)
 
 /**
  * qlafx00_intr_handler() - Process interrupts for the ISPFX00.
- * @irq:
+ * @irq: interrupt number
  * @dev_id: SCSI driver HA context
  *
  * Called by system whenever the host adapter generates an interrupt.
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 121e18b3b9f8..f2f54806f4da 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2010,7 +2010,7 @@ qla82xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 
 /**
  * qla82xx_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
- * @irq:
+ * @irq: interrupt number
  * @dev_id: SCSI driver HA context
  *
  * Called by system whenever the host adapter generates an interrupt.
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 3a2b0282df14..fe856b602e03 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3878,7 +3878,7 @@ qla8044_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 #define PF_BITS_MASK		(0xF << 16)
 /**
  * qla8044_intr_handler() - Process interrupts for the ISP8044
- * @irq:
+ * @irq: interrupt number
  * @dev_id: SCSI driver HA context
  *
  * Called by system whenever the host adapter generates an interrupt.
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dba672f87cb2..01607d2f2c34 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1749,7 +1749,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 static void
 __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 {
-	int cnt, status;
+	int cnt;
 	unsigned long flags;
 	srb_t *sp;
 	scsi_qla_host_t *vha = qp->vha;
@@ -1799,8 +1799,8 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 					if (!sp_get(sp)) {
 						spin_unlock_irqrestore
 							(qp->qp_lock_ptr, flags);
-						status = qla2xxx_eh_abort(
-						    GET_CMD_SP(sp));
+						qla2xxx_eh_abort(
+							GET_CMD_SP(sp));
 						spin_lock_irqsave
 							(qp->qp_lock_ptr, flags);
 					}
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 4499c787165f..2a3055c799fb 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2229,7 +2229,7 @@ qla2x00_erase_flash_sector(struct qla_hw_data *ha, uint32_t addr,
 
 /**
  * qla2x00_get_flash_manufacturer() - Read manufacturer ID from flash chip.
- * @ha:
+ * @ha: host adapter
  * @man_id: Flash manufacturer ID
  * @flash_id: Flash ID
  */
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 39828207bc1d..c4504740f0e2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4540,7 +4540,7 @@ static int qlt_issue_task_mgmt(struct fc_port *sess, u64 lun,
 	case QLA_TGT_CLEAR_TS:
 	case QLA_TGT_ABORT_TS:
 		abort_cmds_for_lun(vha, lun, a->u.isp24.fcp_hdr.s_id);
-		/* drop through */
+		/* fall through */
 	case QLA_TGT_CLEAR_ACA:
 		h = qlt_find_qphint(vha, mcmd->unpacked_lun);
 		mcmd->qpair = h->qpair;
@@ -6598,9 +6598,9 @@ static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
  * qla_tgt_lport_register - register lport with external module
  *
  * @target_lport_ptr: pointer for tcm_qla2xxx specific lport data
- * @phys_wwpn:
- * @npiv_wwpn:
- * @npiv_wwnn:
+ * @phys_wwpn: physical port WWPN
+ * @npiv_wwpn: NPIV WWPN
+ * @npiv_wwnn: NPIV WWNN
  * @callback:  lport initialization callback for tcm_qla2xxx code
  */
 int qlt_lport_register(void *target_lport_ptr, u64 phys_wwpn,
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index e46ca968009c..4f134b0c3e29 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -268,7 +268,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	}
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, rd_len + 4);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4cf33e2cc705..e31e4fc31aa1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -205,19 +205,19 @@ void transport_subsystem_check_init(void)
 	if (sub_api_initialized)
 		return;
 
-	ret = request_module("target_core_iblock");
+	ret = IS_ENABLED(CONFIG_TCM_IBLOCK) && request_module("target_core_iblock");
 	if (ret != 0)
 		pr_err("Unable to load target_core_iblock\n");
 
-	ret = request_module("target_core_file");
+	ret = IS_ENABLED(CONFIG_TCM_FILEIO) && request_module("target_core_file");
 	if (ret != 0)
 		pr_err("Unable to load target_core_file\n");
 
-	ret = request_module("target_core_pscsi");
+	ret = IS_ENABLED(CONFIG_TCM_PSCSI) && request_module("target_core_pscsi");
 	if (ret != 0)
 		pr_err("Unable to load target_core_pscsi\n");
 
-	ret = request_module("target_core_user");
+	ret = IS_ENABLED(CONFIG_TCM_USER2) && request_module("target_core_user");
 	if (ret != 0)
 		pr_err("Unable to load target_core_user\n");
 
