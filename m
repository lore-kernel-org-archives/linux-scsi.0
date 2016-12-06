From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 2/6] qla2xxx: Fix mailbox command timeout due to starvation
Date: Tue, 6 Dec 2016 11:07:42 -0800
Message-ID: <1481051266-32362-3-git-send-email-himanshu.madhani@cavium.com>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:44864
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752854AbcLFTIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 14:08:09 -0500
In-Reply-To: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Samy <samy@purestorage.com>

This patch helps resolve some of the mailbox timeout issue discovered
during large SAN emulation testing where 1000+ initiators are trying
to log into target mode personality. Since current mailbox interface
handles submission and processing of commands in a sequential order,
command could timeout resulting in some initiator not being able to
log into target.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Samy <samy@purestorage.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  3 ++
 drivers/scsi/qla2xxx/qla_mbx.c | 88 ++++++++++++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_os.c  | 24 ++++++++++++
 3 files changed, 91 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5236e3f..9a6ddcb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3553,6 +3553,9 @@ struct qla_hw_data {
 	uint32_t	idc_audit_ts;
 	uint32_t	idc_extend_tmo;
 
+	/* mail box work queue */
+	struct workqueue_struct *mbx_wq;
+
 	/* DPC low-priority workqueue */
 	struct workqueue_struct *dpc_lp_wq;
 	struct work_struct idc_aen;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b31c36b..14068fb 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -10,6 +10,14 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
+struct mbx_cmd_info_t {
+	mbx_cmd_t		*mcp;
+	scsi_qla_host_t		*vha;
+	struct work_struct	work;
+	struct completion	comp;
+	int			status;
+};
+
 struct rom_cmd {
 	uint16_t cmd;
 } rom_cmds[] = {
@@ -68,7 +76,7 @@ static int is_rom_cmd(uint16_t cmd)
  *	Kernel context.
  */
 static int
-qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
+__qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 {
 	int		rval, i;
 	unsigned long    flags = 0;
@@ -140,19 +148,6 @@ static int is_rom_cmd(uint16_t cmd)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
-	/*
-	 * Wait for active mailbox commands to finish by waiting at most tov
-	 * seconds. This is to serialize actual issuing of mailbox cmds during
-	 * non ISP abort time.
-	 */
-	if (!wait_for_completion_timeout(&ha->mbx_cmd_comp, mcp->tov * HZ)) {
-		/* Timeout occurred. Return error. */
-		ql_log(ql_log_warn, vha, 0x1005,
-		    "Cmd access timeout, cmd=0x%x, Exiting.\n",
-		    mcp->mb[0]);
-		return QLA_FUNCTION_TIMEOUT;
-	}
-
 	ha->flags.mbox_busy = 1;
 	/* Save mailbox command for debug */
 	ha->mcp = mcp;
@@ -217,7 +212,7 @@ static int is_rom_cmd(uint16_t cmd)
 				ql_dbg(ql_dbg_mbx, vha, 0x1010,
 				    "Pending mailbox timeout, exiting.\n");
 				rval = QLA_FUNCTION_TIMEOUT;
-				goto premature_exit;
+				goto mbx_done;
 			}
 			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
 		} else if (IS_FWI2_CAPABLE(ha))
@@ -251,7 +246,7 @@ static int is_rom_cmd(uint16_t cmd)
 				ql_dbg(ql_dbg_mbx, vha, 0x1012,
 				    "Pending mailbox timeout, exiting.\n");
 				rval = QLA_FUNCTION_TIMEOUT;
-				goto premature_exit;
+				goto mbx_done;
 			}
 			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
 		} else if (IS_FWI2_CAPABLE(ha))
@@ -297,7 +292,7 @@ static int is_rom_cmd(uint16_t cmd)
 			rval = QLA_FUNCTION_FAILED;
 			ql_log(ql_log_warn, vha, 0x1015,
 			    "FW hung = %d.\n", ha->flags.isp82xx_fw_hung);
-			goto premature_exit;
+			goto mbx_done;
 		}
 
 		if (ha->mailbox_out[0] != MBS_COMMAND_COMPLETE)
@@ -353,7 +348,7 @@ static int is_rom_cmd(uint16_t cmd)
 					set_bit(PCI_ERR, &base_vha->dpc_flags);
 				ha->flags.mbox_busy = 0;
 				rval = QLA_FUNCTION_TIMEOUT;
-				goto premature_exit;
+				goto mbx_done;
 			}
 
 			/* Attempt to capture firmware dump for further
@@ -431,8 +426,6 @@ static int is_rom_cmd(uint16_t cmd)
 				    command, mcp->mb[0]);
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
 				clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-				/* Allow next mbx cmd to come in. */
-				complete(&ha->mbx_cmd_comp);
 				if (ha->isp_ops->abort_isp(vha)) {
 					/* Failed. retry later. */
 					set_bit(ISP_ABORT_NEEDED,
@@ -446,10 +439,6 @@ static int is_rom_cmd(uint16_t cmd)
 		}
 	}
 
-premature_exit:
-	/* Allow next mbx cmd to come in. */
-	complete(&ha->mbx_cmd_comp);
-
 mbx_done:
 	if (rval) {
 		ql_dbg(ql_dbg_disc, base_vha, 0x1020,
@@ -474,6 +463,57 @@ static int is_rom_cmd(uint16_t cmd)
 	return rval;
 }
 
+static void
+qla2x00_mailbox_work(struct work_struct *work)
+{
+	struct mbx_cmd_info_t *cmd_info =
+	    container_of(work, struct mbx_cmd_info_t, work);
+
+	cmd_info->status =
+	    __qla2x00_mailbox_command(cmd_info->vha, cmd_info->mcp);
+
+	complete(&cmd_info->comp);
+}
+
+static int
+qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
+{
+	struct mbx_cmd_info_t cmd_info;
+	struct qla_hw_data *ha = vha->hw;
+	int rval;
+	uint16_t command = mcp->mb[0];
+
+	if (!ha->mbx_wq) {
+		ql_log(ql_log_warn, vha, 0x1005,
+			"mbx work queue doesn't exist: cmd=0x%x.\n", command);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	ql_dbg(ql_dbg_mbx, vha, 0x1021, "Enter %s/%d: %p 0x%x.\n",
+		current->comm, task_pid_nr(current), mcp, command);
+
+	cmd_info.vha = vha;
+	cmd_info.mcp = mcp;
+	init_completion(&cmd_info.comp);
+	INIT_WORK(&cmd_info.work, qla2x00_mailbox_work);
+	queue_work(ha->mbx_wq, &cmd_info.work);
+
+	rval = wait_for_completion_timeout(&cmd_info.comp, mcp->tov * HZ);
+
+	if (rval <= 0) {
+		ql_log(ql_log_warn, vha, 0x1005,
+			"cmd failed: %s, cmd=0x%x, rval=%d Exiting.\n",
+			rval ? "signal" : "timeout", command, rval);
+		cancel_work_sync(&cmd_info.work);
+		return QLA_FUNCTION_TIMEOUT;
+	}
+
+	ql_dbg(ql_dbg_mbx, vha, 0x1021, "Done %s/%d: %p 0x%x.\n",
+		current->comm, task_pid_nr(current), mcp, command);
+
+	return cmd_info.status;
+}
+
 int
 qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
     uint32_t risc_code_size)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 56d6142..4616424 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2370,6 +2370,17 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	return atomic_read(&vha->loop_state) == LOOP_READY;
 }
 
+static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
+{
+	struct workqueue_struct *wq = ha->mbx_wq;
+
+	if (wq) {
+		ha->mbx_wq = NULL;
+		flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
 /*
  * PCI driver interface
  */
@@ -2806,6 +2817,15 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	    "req->req_q_in=%p req->req_q_out=%p rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
+	sprintf(wq_name, "qla2xxx_%lu_mbx", base_vha->host_no);
+	ha->mbx_wq = create_singlethread_workqueue(wq_name);
+	if (!ha->mbx_wq) {
+		ql_log(ql_log_fatal, base_vha, 0x00f0,
+			"Unable to start mail box thread!\n");
+		ret = -ENODEV;
+		goto probe_failed;
+	}
+
 	if (ha->isp_ops->initialize_adapter(base_vha)) {
 		ql_log(ql_log_fatal, base_vha, 0x00d6,
 		    "Failed to initialize adapter - Adapter flags %x.\n",
@@ -3278,6 +3298,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 	qla2x00_unmap_iobases(ha);
 
+	qla2x00_destroy_mbx_wq(ha);
+
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
 	ha = NULL;
@@ -5046,6 +5068,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 
 	qla2x00_unmap_iobases(ha);
 
+	qla2x00_destroy_mbx_wq(ha);
+
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
-- 
1.8.3.1

