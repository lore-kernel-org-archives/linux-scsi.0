From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.36-rc3
Date: Sat, 11 Sep 2010 19:07:44 +0000
Message-ID: <1284232064.2986.67.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This includes the oops from use after free, a set of qla2xxx fixes, some
misc warning cleanups from the recently introduced printk issue, an hpsa
lockup fix and a medium removal bug in sd introduced by the BKL
pushdown.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (1):
      fix use-after-free in scsi_init_io()

Jayamohan Kallickal (1):
      be2iscsi: Fix for Login failure

Jean Sacren (1):
      Fix warning: zero-length gnu_printf format string

Jiri Slaby (1):
      fix bio.bi_rw handling

Lalit Chandivade (2):
      qla2xxx: Cover UNDERRUN case where SCSI status is set.
      qla2xxx: Reset seconds_since_last_heartbeat correctly.

Madhuranath Iyengar (1):
      qla2xxx: Update version number to 8.03.04-k0.

Stephen M. Cameron (1):
      hpsa: disable doorbell reset on reset_devices

The diffstat:

 drivers/scsi/be2iscsi/be_iscsi.c    |    5 -
 drivers/scsi/be2iscsi/be_mgmt.c     |    2 
 drivers/scsi/constants.c            |    6 +-
 drivers/scsi/hpsa.c                 |    6 ++
 drivers/scsi/osd/osd_initiator.c    |    2 
 drivers/scsi/qla2xxx/qla_attr.c     |   23 +++++---
 drivers/scsi/qla2xxx/qla_dbg.h      |    2 
 drivers/scsi/qla2xxx/qla_def.h      |   20 +++++++
 drivers/scsi/qla2xxx/qla_init.c     |   94 +++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c      |    7 +-
 drivers/scsi/qla2xxx/qla_mbx.c      |    7 +-
 drivers/scsi/qla2xxx/qla_mid.c      |   68 ++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_nx.c       |   36 ++++++++++---
 drivers/scsi/qla2xxx/qla_os.c       |   30 +++++++++--
 drivers/scsi/qla2xxx/qla_version.h  |    4 -
 drivers/scsi/scsi_lib.c             |    2 
 drivers/scsi/sd.c                   |    8 +--
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   10 +--
 18 files changed, 262 insertions(+), 70 deletions(-)

and the full diff is attached below.

James

---

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 7d4d227..7f11f3e 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -300,8 +300,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf)
 {
 	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
-	int len = 0;
-	int status;
+	int status = 0;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_get_host_param, param= %d\n", param);
 	switch (param) {
@@ -315,7 +314,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 	default:
 		return iscsi_host_get_param(shost, param, buf);
 	}
-	return len;
+	return status;
 }
 
 int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 26350e4..877324f 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -368,7 +368,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	memset(req, 0, sizeof(*req));
 	wrb->tag0 |= tag;
 
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 1);
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
 			   sizeof(*req));
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index cd05e04..d0c8234 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1404,13 +1404,13 @@ void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 {
 	struct scsi_sense_hdr sshdr;
 
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_decode_sense_buffer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
 	scsi_show_sense_hdr(&sshdr);
 	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
 }
 EXPORT_SYMBOL(scsi_print_sense);
@@ -1453,7 +1453,7 @@ EXPORT_SYMBOL(scsi_show_result);
 
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_show_result(cmd->result);
 }
 EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4f5551b..c5d0606 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3231,6 +3231,12 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	misc_fw_support = readl(&cfgtable->misc_fw_support);
 	use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
 
+	/* The doorbell reset seems to cause lockups on some Smart
+	 * Arrays (e.g. P410, P410i, maybe others).  Until this is
+	 * fixed or at least isolated, avoid the doorbell reset.
+	 */
+	use_doorbell = 0;
+
 	rc = hpsa_controller_hard_reset(pdev, vaddr, use_doorbell);
 	if (rc)
 		goto unmap_cfgtable;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index fda4de3..e88bbdd 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -865,7 +865,7 @@ void osd_req_read(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, len);
 	WARN_ON(or->in.bio || or->in.total_bytes);
-	WARN_ON(1 == (bio->bi_rw & REQ_WRITE));
+	WARN_ON(bio->bi_rw & REQ_WRITE);
 	or->in.bio = bio;
 	or->in.total_bytes = len;
 }
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 420238c..114bc5a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1838,26 +1838,33 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	qla24xx_disable_vp(vha);
 
+	vha->flags.delete_progress = 1;
+
 	fc_remove_host(vha->host);
 
 	scsi_remove_host(vha->host);
 
-	qla2x00_free_fcports(vha);
+	if (vha->timer_active) {
+		qla2x00_vp_stop_timer(vha);
+		DEBUG15(printk(KERN_INFO "scsi(%ld): timer for the vport[%d]"
+		" = %p has stopped\n", vha->host_no, vha->vp_idx, vha));
+	}
 
 	qla24xx_deallocate_vp_id(vha);
 
+	/* No pending activities shall be there on the vha now */
+	DEBUG(msleep(random32()%10));  /* Just to see if something falls on
+					* the net we have placed below */
+
+	BUG_ON(atomic_read(&vha->vref_count));
+
+	qla2x00_free_fcports(vha);
+
 	mutex_lock(&ha->vport_lock);
 	ha->cur_vport_count--;
 	clear_bit(vha->vp_idx, ha->vp_idx_map);
 	mutex_unlock(&ha->vport_lock);
 
-	if (vha->timer_active) {
-		qla2x00_vp_stop_timer(vha);
-		DEBUG15(printk ("scsi(%ld): timer for the vport[%d] = %p "
-		    "has stopped\n",
-		    vha->host_no, vha->vp_idx, vha));
-        }
-
 	if (vha->req->id && !ha->flags.cpu_affinity_enabled) {
 		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
 			qla_printk(KERN_WARNING, ha,
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 6cfc28a..b74e6b5 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -29,8 +29,6 @@
 /* #define QL_DEBUG_LEVEL_17 */ /* Output EEH trace messages */
 /* #define QL_DEBUG_LEVEL_18 */ /* Output T10 CRC trace messages */
 
-/* #define QL_PRINTK_BUF */ /* Captures printk to buffer */
-
 /*
 * Macros use for debugging the driver.
 */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3a432ea..d2a4e15 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2641,6 +2641,7 @@ struct qla_hw_data {
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
 	struct mutex vport_lock;        /* Virtual port synchronization */
+	spinlock_t vport_slock; /* order is hardware_lock, then vport_slock */
 	struct completion mbx_cmd_comp; /* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 	struct completion dcbx_comp;	/* For set port config notification */
@@ -2828,6 +2829,7 @@ typedef struct scsi_qla_host {
 		uint32_t	management_server_logged_in :1;
 		uint32_t	process_response_queue	:1;
 		uint32_t	difdix_supported:1;
+		uint32_t	delete_progress:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2922,6 +2924,8 @@ typedef struct scsi_qla_host {
 	struct req_que *req;
 	int		fw_heartbeat_counter;
 	int		seconds_since_last_heartbeat;
+
+	atomic_t	vref_count;
 } scsi_qla_host_t;
 
 /*
@@ -2932,6 +2936,22 @@ typedef struct scsi_qla_host {
 	 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) || \
 	 atomic_read(&ha->loop_state) == LOOP_DOWN)
 
+#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		     \
+	atomic_inc(&__vha->vref_count);			     \
+	mb();						     \
+	if (__vha->flags.delete_progress) {		     \
+		atomic_dec(&__vha->vref_count);		     \
+		__bail = 1;				     \
+	} else {					     \
+		__bail = 0;				     \
+	}						     \
+} while (0)
+
+#define QLA_VHA_MARK_NOT_BUSY(__vha) do {		     \
+	atomic_dec(&__vha->vref_count);			     \
+} while (0)
+
+
 #define qla_printk(level, ha, format, arg...) \
 	dev_printk(level , &((ha)->pdev->dev) , format , ## arg)
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d863ed2..9c383ba 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -69,21 +69,29 @@ qla2x00_ctx_sp_free(srb_t *sp)
 {
 	struct srb_ctx *ctx = sp->ctx;
 	struct srb_iocb *iocb = ctx->u.iocb_cmd;
+	struct scsi_qla_host *vha = sp->fcport->vha;
 
 	del_timer_sync(&iocb->timer);
 	kfree(iocb);
 	kfree(ctx);
 	mempool_free(sp, sp->fcport->vha->hw->srb_mempool);
+
+	QLA_VHA_MARK_NOT_BUSY(vha);
 }
 
 inline srb_t *
 qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
     unsigned long tmo)
 {
-	srb_t *sp;
+	srb_t *sp = NULL;
 	struct qla_hw_data *ha = vha->hw;
 	struct srb_ctx *ctx;
 	struct srb_iocb *iocb;
+	uint8_t bail;
+
+	QLA_VHA_MARK_BUSY(vha, bail);
+	if (bail)
+		return NULL;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
 	if (!sp)
@@ -116,6 +124,8 @@ qla2x00_get_ctx_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size,
 	iocb->timer.function = qla2x00_ctx_sp_timeout;
 	add_timer(&iocb->timer);
 done:
+	if (!sp)
+		QLA_VHA_MARK_NOT_BUSY(vha);
 	return sp;
 }
 
@@ -1777,11 +1787,15 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		qla2x00_init_response_q_entries(rsp);
 	}
 
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	/* Clear RSCN queue. */
 	list_for_each_entry(vp, &ha->vp_list, list) {
 		vp->rscn_in_ptr = 0;
 		vp->rscn_out_ptr = 0;
 	}
+
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	ha->isp_ops->config_rings(vha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -3218,12 +3232,17 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		/* Bypass virtual ports of the same host. */
 		found = 0;
 		if (ha->num_vhosts) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 				if (new_fcport->d_id.b24 == vp->d_id.b24) {
 					found = 1;
 					break;
 				}
 			}
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			if (found)
 				continue;
 		}
@@ -3343,6 +3362,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
 	struct scsi_qla_host *tvp;
+	unsigned long flags = 0;
 
 	rval = QLA_SUCCESS;
 
@@ -3367,6 +3387,8 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 		/* Check for loop ID being already in use. */
 		found = 0;
 		fcport = NULL;
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			list_for_each_entry(fcport, &vp->vp_fcports, list) {
 				if (fcport->loop_id == dev->loop_id &&
@@ -3379,6 +3401,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 			if (found)
 				break;
 		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 		/* If not in use then it is free to use. */
 		if (!found) {
@@ -3791,14 +3814,27 @@ void
 qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 {
 	fc_port_t *fcport;
-	struct scsi_qla_host *tvp, *vha;
+	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha = base_vha->hw;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	/* Go with deferred removal of rport references. */
-	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list)
-		list_for_each_entry(fcport, &vha->vp_fcports, list)
+	list_for_each_entry(vha, &base_vha->hw->vp_list, list) {
+		atomic_inc(&vha->vref_count);
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport && fcport->drport &&
-			    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
+			    atomic_read(&fcport->state) != FCS_UNCONFIGURED) {
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 				qla2x00_rport_del(fcport);
+
+				spin_lock_irqsave(&ha->vport_slock, flags);
+			}
+		}
+		atomic_dec(&vha->vref_count);
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
 
 void
@@ -3806,7 +3842,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
-	struct scsi_qla_host *tvp;
+	unsigned long flags;
 
 	vha->flags.online = 0;
 	ha->flags.chip_reset_done = 0;
@@ -3824,8 +3860,18 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		qla2x00_mark_all_devices_lost(vha, 0);
-		list_for_each_entry_safe(vp, tvp, &base_vha->hw->vp_list, list)
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &base_vha->hw->vp_list, list) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			qla2x00_mark_all_devices_lost(vp, 0);
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			atomic_dec(&vp->vref_count);
+		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	} else {
 		if (!atomic_read(&vha->loop_down_timer))
 			atomic_set(&vha->loop_down_timer,
@@ -3862,8 +3908,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	uint8_t        status = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
-	struct scsi_qla_host *tvp;
 	struct req_que *req = ha->req_q_map[0];
+	unsigned long flags;
 
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
@@ -3970,10 +4016,21 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		DEBUG(printk(KERN_INFO
 				"qla2x00_abort_isp(%ld): succeeded.\n",
 				vha->host_no));
-		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-			if (vp->vp_idx)
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &ha->vp_list, list) {
+			if (vp->vp_idx) {
+				atomic_inc(&vp->vref_count);
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 				qla2x00_vp_abort_isp(vp);
+
+				spin_lock_irqsave(&ha->vport_slock, flags);
+				atomic_dec(&vp->vref_count);
+			}
 		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	} else {
 		qla_printk(KERN_INFO, ha,
 			"qla2x00_abort_isp: **** FAILED ****\n");
@@ -5185,7 +5242,7 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct scsi_qla_host *vp;
-	struct scsi_qla_host *tvp;
+	unsigned long flags;
 
 	status = qla2x00_init_rings(vha);
 	if (!status) {
@@ -5272,10 +5329,21 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 		DEBUG(printk(KERN_INFO
 			"qla82xx_restart_isp(%ld): succeeded.\n",
 			vha->host_no));
-		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-			if (vp->vp_idx)
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &ha->vp_list, list) {
+			if (vp->vp_idx) {
+				atomic_inc(&vp->vref_count);
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 				qla2x00_vp_abort_isp(vp);
+
+				spin_lock_irqsave(&ha->vport_slock, flags);
+				atomic_dec(&vp->vref_count);
+			}
 		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	} else {
 		qla_printk(KERN_INFO, ha,
 			"qla82xx_restart_isp: **** FAILED ****\n");
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6982ba7..28f65be 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1706,19 +1706,20 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				cp->result = DID_ERROR << 16;
 				break;
 			}
-		} else if (!lscsi_status) {
+		} else {
 			DEBUG2(qla_printk(KERN_INFO, ha,
 			    "scsi(%ld:%d:%d) Dropped frame(s) detected (0x%x "
 			    "of 0x%x bytes).\n", vha->host_no, cp->device->id,
 			    cp->device->lun, resid, scsi_bufflen(cp)));
 
-			cp->result = DID_ERROR << 16;
-			break;
+			cp->result = DID_ERROR << 16 | lscsi_status;
+			goto check_scsi_status;
 		}
 
 		cp->result = DID_OK << 16 | lscsi_status;
 		logit = 0;
 
+check_scsi_status:
 		/*
 		 * Check to see if SCSI Status is non zero. If so report SCSI
 		 * Status.
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 6009b0c..a595ec8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2913,7 +2913,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
-	scsi_qla_host_t *tvp;
+	unsigned long   flags;
 
 	if (rptid_entry->entry_status != 0)
 		return;
@@ -2945,9 +2945,12 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			return;
 		}
 
-		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(vp, &ha->vp_list, list)
 			if (vp_idx == vp->vp_idx)
 				break;
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 		if (!vp)
 			return;
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 987c5b0..2b69392 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -30,6 +30,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint32_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
 
 	/* Find an empty slot and assign an vp_id */
 	mutex_lock(&ha->vport_lock);
@@ -44,7 +45,11 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	set_bit(vp_id, ha->vp_idx_map);
 	ha->num_vhosts++;
 	vha->vp_idx = vp_id;
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_add_tail(&vha->list, &ha->vp_list);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	mutex_unlock(&ha->vport_lock);
 	return vp_id;
 }
@@ -54,12 +59,31 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint16_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags = 0;
 
 	mutex_lock(&ha->vport_lock);
+	/*
+	 * Wait for all pending activities to finish before removing vport from
+	 * the list.
+	 * Lock needs to be held for safe removal from the list (it
+	 * ensures no active vp_list traversal while the vport is removed
+	 * from the queue)
+	 */
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	while (atomic_read(&vha->vref_count)) {
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+		msleep(500);
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+	}
+	list_del(&vha->list);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
 	clear_bit(vp_id, ha->vp_idx_map);
-	list_del(&vha->list);
+
 	mutex_unlock(&ha->vport_lock);
 }
 
@@ -68,12 +92,17 @@ qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
 	struct scsi_qla_host *tvha;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	/* Locate matching device in database. */
 	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
-		if (!memcmp(port_name, vha->port_name, WWN_SIZE))
+		if (!memcmp(port_name, vha->port_name, WWN_SIZE)) {
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 			return vha;
+		}
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 	return NULL;
 }
 
@@ -93,6 +122,12 @@ qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 static void
 qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 {
+	/*
+	 * !!! NOTE !!!
+	 * This function, if called in contexts other than vp create, disable
+	 * or delete, please make sure this is synchronized with the
+	 * delete thread.
+	 */
 	fc_port_t *fcport;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
@@ -100,7 +135,6 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 		    "loop_id=0x%04x :%x\n",
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
 
-		atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 		qla2x00_mark_device_lost(vha, fcport, 0, 0);
 		atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	}
@@ -194,12 +228,17 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 void
 qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 {
-	scsi_qla_host_t *vha, *tvha;
+	scsi_qla_host_t *vha;
 	struct qla_hw_data *ha = rsp->hw;
 	int i = 0;
+	unsigned long flags;
 
-	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vha, &ha->vp_list, list) {
 		if (vha->vp_idx) {
+			atomic_inc(&vha->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			switch (mb[0]) {
 			case MBA_LIP_OCCURRED:
 			case MBA_LOOP_UP:
@@ -215,9 +254,13 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 				qla2x00_async_event(vha, rsp, mb);
 				break;
 			}
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			atomic_dec(&vha->vref_count);
 		}
 		i++;
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
 
 int
@@ -297,7 +340,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 	int ret;
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
-	struct scsi_qla_host *tvp;
+	unsigned long flags = 0;
 
 	if (vha->vp_idx)
 		return;
@@ -309,10 +352,19 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 	if (!(ha->current_topology & ISP_CFG_F))
 		return;
 
-	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		if (vp->vp_idx)
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		if (vp->vp_idx) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			ret = qla2x00_do_dpc_vp(vp);
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			atomic_dec(&vp->vref_count);
+		}
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
 
 int
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 915b77a..0a71cc7 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2672,6 +2672,19 @@ qla82xx_start_scsi(srb_t *sp)
 sufficient_dsds:
 		req_cnt = 1;
 
+		if (req->cnt < (req_cnt + 2)) {
+			cnt = (uint16_t)RD_REG_DWORD_RELAXED(
+				&reg->req_q_out[0]);
+			if (req->ring_index < cnt)
+				req->cnt = cnt - req->ring_index;
+			else
+				req->cnt = req->length -
+					(req->ring_index - cnt);
+		}
+
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
+
 		ctx = sp->ctx = mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
 		if (!sp->ctx) {
 			DEBUG(printk(KERN_INFO
@@ -3307,16 +3320,19 @@ qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			}
 			qla2xxx_wake_dpc(vha);
+			ha->flags.fw_hung = 1;
 			if (ha->flags.mbox_busy) {
-				ha->flags.fw_hung = 1;
 				ha->flags.mbox_int = 1;
 				DEBUG2(qla_printk(KERN_ERR, ha,
-				    "Due to fw hung, doing premature "
-				    "completion of mbx command\n"));
-				complete(&ha->mbx_intr_comp);
+					"Due to fw hung, doing premature "
+					"completion of mbx command\n"));
+				if (test_bit(MBX_INTR_WAIT,
+					&ha->mbx_cmd_flags))
+					complete(&ha->mbx_intr_comp);
 			}
 		}
-	}
+	} else
+		vha->seconds_since_last_heartbeat = 0;
 	vha->fw_heartbeat_counter = fw_heartbeat_counter;
 }
 
@@ -3418,13 +3434,15 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 				"%s(): Adapter reset needed!\n", __func__);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
+			ha->flags.fw_hung = 1;
 			if (ha->flags.mbox_busy) {
-				ha->flags.fw_hung = 1;
 				ha->flags.mbox_int = 1;
 				DEBUG2(qla_printk(KERN_ERR, ha,
-				    "Need reset, doing premature "
-				    "completion of mbx command\n"));
-				complete(&ha->mbx_intr_comp);
+					"Need reset, doing premature "
+					"completion of mbx command\n"));
+				if (test_bit(MBX_INTR_WAIT,
+					&ha->mbx_cmd_flags))
+					complete(&ha->mbx_intr_comp);
 			}
 		} else {
 			qla82xx_check_fw_alive(vha);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8c80b49..1e4bff6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2341,16 +2341,28 @@ probe_out:
 static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
-	scsi_qla_host_t *base_vha, *vha, *temp;
+	scsi_qla_host_t *base_vha, *vha;
 	struct qla_hw_data  *ha;
+	unsigned long flags;
 
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
 
-	list_for_each_entry_safe(vha, temp, &ha->vp_list, list) {
-		if (vha && vha->fc_vport)
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vha, &ha->vp_list, list) {
+		atomic_inc(&vha->vref_count);
+
+		if (vha && vha->fc_vport) {
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			fc_vport_terminate(vha->fc_vport);
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+		}
+
+		atomic_dec(&vha->vref_count);
 	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
@@ -2975,10 +2987,17 @@ static struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 {
 	struct qla_work_evt *e;
+	uint8_t bail;
+
+	QLA_VHA_MARK_BUSY(vha, bail);
+	if (bail)
+		return NULL;
 
 	e = kzalloc(sizeof(struct qla_work_evt), GFP_ATOMIC);
-	if (!e)
+	if (!e) {
+		QLA_VHA_MARK_NOT_BUSY(vha);
 		return NULL;
+	}
 
 	INIT_LIST_HEAD(&e->list);
 	e->type = type;
@@ -3135,6 +3154,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
+
+		/* For each work completed decrement vha ref count */
+		QLA_VHA_MARK_NOT_BUSY(vha);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index e75ccb9..8edbccb 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.03-k0"
+#define QLA2XXX_VERSION      "8.03.04-k0"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-#define QLA_DRIVER_PATCH_VER	3
+#define QLA_DRIVER_PATCH_VER	4
 #define QLA_DRIVER_BETA_VER	0
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ade720..ee02d38 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1011,8 +1011,8 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 err_exit:
 	scsi_release_buffers(cmd);
-	scsi_put_command(cmd);
 	cmd->request->special = NULL;
+	scsi_put_command(cmd);
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2714bec..ffa0689 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -870,7 +870,7 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
-	if (atomic_dec_return(&sdkp->openers) && sdev->removable) {
+	if (atomic_dec_return(&sdkp->openers) == 0 && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
@@ -2625,15 +2625,15 @@ module_exit(exit_sd);
 static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
-	sd_printk(KERN_INFO, sdkp, "");
+	sd_printk(KERN_INFO, sdkp, " ");
 	scsi_show_sense_hdr(sshdr);
-	sd_printk(KERN_INFO, sdkp, "");
+	sd_printk(KERN_INFO, sdkp, " ");
 	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
 {
-	sd_printk(KERN_INFO, sdkp, "");
+	sd_printk(KERN_INFO, sdkp, " ");
 	scsi_show_result(result);
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index a7bc8b7..2c3e89d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -72,10 +72,7 @@ static void sym_printl_hex(u_char *p, int n)
 
 static void sym_print_msg(struct sym_ccb *cp, char *label, u_char *msg)
 {
-	if (label)
-		sym_print_addr(cp->cmd, "%s: ", label);
-	else
-		sym_print_addr(cp->cmd, "");
+	sym_print_addr(cp->cmd, "%s: ", label);
 
 	spi_print_msg(msg);
 	printf("\n");
@@ -4558,7 +4555,8 @@ static void sym_int_sir(struct sym_hcb *np)
 			switch (np->msgin [2]) {
 			case M_X_MODIFY_DP:
 				if (DEBUG_FLAGS & DEBUG_POINTER)
-					sym_print_msg(cp, NULL, np->msgin);
+					sym_print_msg(cp, "extended msg ",
+						      np->msgin);
 				tmp = (np->msgin[3]<<24) + (np->msgin[4]<<16) + 
 				      (np->msgin[5]<<8)  + (np->msgin[6]);
 				sym_modify_dp(np, tp, cp, tmp);
@@ -4585,7 +4583,7 @@ static void sym_int_sir(struct sym_hcb *np)
 		 */
 		case M_IGN_RESIDUE:
 			if (DEBUG_FLAGS & DEBUG_POINTER)
-				sym_print_msg(cp, NULL, np->msgin);
+				sym_print_msg(cp, "1 or 2 byte ", np->msgin);
 			if (cp->host_flags & HF_SENSE)
 				OUTL_DSP(np, SCRIPTA_BA(np, clrack));
 			else
