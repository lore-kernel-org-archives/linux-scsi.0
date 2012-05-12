From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.3-rc6
Date: Sat, 12 May 2012 10:57:33 +0100
Message-ID: <1336816653.3034.2.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of minor qla and virto fixes plus one major regression fix
(oops in all legacy host drivers).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chad Dupuis (1):
      qla2xxx: Update version number to 8.04.00.03-k.

Giridhar Malavali (2):
      qla2xxx: Proper completion to scsi-ml for scsi status task_set_full and busy.
      qla2xxx: Block flash access from application when device is initialized for ISP82xx.

James Bottomley (1):
      fix oops in all legacy host adapters caused by 6f381fa

Paolo Bonzini (1):
      virtio_scsi: fix TMF use-after-free

Saurav Kashyap (1):
      qla2xxx: Properly check for current state after the fabric-login request.

Vikas Chaudhary (1):
      qla2xxx: Fix reset time out as qla2xxx not ack to reset request

and the diffstat:

 drivers/scsi/hosts.c               |    3 +++
 drivers/scsi/qla2xxx/qla_bsg.c     |    3 +++
 drivers/scsi/qla2xxx/qla_dbg.c     |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   15 +++++++++++++--
 drivers/scsi/qla2xxx/qla_nx.c      |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |   18 +++++++++++++++++-
 drivers/scsi/qla2xxx/qla_sup.c     |    3 +++
 drivers/scsi/qla2xxx/qla_version.h |    6 +++---
 drivers/scsi/virtio_scsi.c         |   24 +++++++++++++-----------
 9 files changed, 57 insertions(+), 18 deletions(-)

With the full diff below.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..a3a056a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -218,6 +218,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
+	if (!dma_dev)
+		dma_dev = shost->shost_gendev.parent;
+
 	shost->dma_dev = dma_dev;
 
 	error = device_add(&shost->shost_gendev);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index f74cc06..bc3cc6d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1367,6 +1367,9 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (ha->flags.isp82xx_reset_hdlr_active)
+		return -EBUSY;
+
 	rval = qla2x00_optrom_setup(bsg_job, vha, 0);
 	if (rval)
 		return rval;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 897731b..62324a1 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -15,7 +15,7 @@
  * | Mailbox commands             |       0x113e       | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
  * | Device Discovery             |       0x2086       | 0x2020-0x2022  |
- * | Queue Command and IO tracing |       0x302f       | 0x3006,0x3008  |
+ * | Queue Command and IO tracing |       0x3030       | 0x3006,0x3008  |
  * |                              |                    | 0x302d-0x302e  |
  * | DPC Thread                   |       0x401c       |		|
  * | Async Events                 |       0x505d       | 0x502b-0x502f  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f79844c..ce42288 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1715,13 +1715,24 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				res = DID_ERROR << 16;
 				break;
 			}
-		} else {
+		} else if (lscsi_status != SAM_STAT_TASK_SET_FULL &&
+			    lscsi_status != SAM_STAT_BUSY) {
+			/*
+			 * scsi status of task set and busy are considered to be
+			 * task not completed.
+			 */
+
 			ql_dbg(ql_dbg_io, fcport->vha, 0x301f,
 			    "Dropped frame(s) detected (0x%x "
-			    "of 0x%x bytes).\n", resid, scsi_bufflen(cp));
+			    "of 0x%x bytes).\n", resid,
+			    scsi_bufflen(cp));
 
 			res = DID_ERROR << 16 | lscsi_status;
 			goto check_scsi_status;
+		} else {
+			ql_dbg(ql_dbg_io, fcport->vha, 0x3030,
+			    "scsi_status: 0x%x, lscsi_status: 0x%x\n",
+			    scsi_status, lscsi_status);
 		}
 
 		res = DID_OK << 16 | lscsi_status;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index f052853..de722a9 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3125,6 +3125,7 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 		ql_log(ql_log_info, vha, 0x00b7,
 		    "HW State: COLD/RE-INIT.\n");
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_COLD);
+		qla82xx_set_rst_ready(ha);
 		if (ql2xmdenable) {
 			if (qla82xx_md_collect(vha))
 				ql_log(ql_log_warn, vha, 0xb02c,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a2f9992..7db8033 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3577,9 +3577,25 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 						continue;
 					/* Attempt a retry. */
 					status = 1;
-				} else
+				} else {
 					status = qla2x00_fabric_login(vha,
 					    fcport, &next_loopid);
+					if (status ==  QLA_SUCCESS) {
+						int status2;
+						uint8_t opts;
+
+						opts = 0;
+						if (fcport->flags &
+						    FCF_FCP2_DEVICE)
+							opts |= BIT_1;
+							status2 =
+							    qla2x00_get_port_database(
+								vha, fcport,
+								opts);
+						if (status2 != QLA_SUCCESS)
+							status = 1;
+					}
+				}
 			} else
 				status = qla2x00_local_device_login(vha,
 								fcport);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 3c13c0a..a683e76 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1017,6 +1017,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	    !IS_CNA_CAPABLE(ha) && !IS_QLA2031(ha))
 		return;
 
+	if (ha->flags.isp82xx_reset_hdlr_active)
+		return;
+
 	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
 	    ha->flt_region_npiv_conf << 2, sizeof(struct qla_npiv_header));
 	if (hdr.version == __constant_cpu_to_le16(0xffff))
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 29d780c..f5fdb16 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.07.13-k"
+#define QLA2XXX_VERSION      "8.04.00.03-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	3
-#define QLA_DRIVER_PATCH_VER	7
+#define QLA_DRIVER_MINOR_VER	4
+#define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	3
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index efccd72..1b38431 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
 
 	if (cmd->comp)
 		complete_all(cmd->comp);
-	mempool_free(cmd, virtscsi_cmd_pool);
+	else
+		mempool_free(cmd, virtscsi_cmd_pool);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -311,21 +312,22 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
-	int ret;
+	int ret = FAILED;
 
 	cmd->comp = &comp;
-	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
-			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
-			       GFP_NOIO);
-	if (ret < 0)
-		return FAILED;
+	if (virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
+			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
+			      GFP_NOIO) < 0)
+		goto out;
 
 	wait_for_completion(&comp);
-	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
-	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
-		return FAILED;
+	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
+	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
+		ret = SUCCESS;
 
-	return SUCCESS;
+out:
+	mempool_free(cmd, virtscsi_cmd_pool);
+	return ret;
 }
 
 static int virtscsi_device_reset(struct scsi_cmnd *sc)
