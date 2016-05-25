From: mchristi@redhat.com
Subject: [PATCH 5/5] iscsi initiator: support eh_async_device_reset_handler
Date: Wed, 25 May 2016 02:55:03 -0500
Message-ID: <1464162903-14735-6-git-send-email-mchristi@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

Like a lot of drivers, iscsi already supported SG_SCSI_RESET_DEVICE
and did not need the host stopped, so supporting
eh_async_device_reset_handler just required some renames, and
changing the callout argument from a scsi_cmnd to a scsi_device.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  2 +-
 drivers/scsi/be2iscsi/be_main.c          | 10 +++++-----
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  2 +-
 drivers/scsi/iscsi_tcp.c                 |  2 +-
 drivers/scsi/libiscsi.c                  | 16 ++++++++--------
 include/scsi/libiscsi.h                  |  2 +-
 8 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 80b6bed..244e330 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -992,7 +992,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.max_sectors            = ISER_DEF_MAX_SECTORS,
 	.cmd_per_lun            = ISER_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
-	.eh_device_reset_handler= iscsi_eh_device_reset,
+	.eh_async_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.target_alloc		= iscsi_target_alloc,
 	.use_clustering         = ENABLE_CLUSTERING,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f05e773..fd1dd20 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -294,7 +294,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	return iscsi_eh_abort(sc);
 }
 
-static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
+static int beiscsi_eh_device_reset(struct scsi_device *sdev)
 {
 	struct iscsi_task *abrt_task;
 	struct beiscsi_io_task *abrt_io_task;
@@ -309,7 +309,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	int rc;
 
 	/* invalidate iocbs */
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(scsi_target(sdev));
 	session = cls_session->dd_data;
 	spin_lock_bh(&session->frwd_lock);
 	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN) {
@@ -329,7 +329,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (!abrt_task->sc || abrt_task->state == ISCSI_TASK_FREE)
 			continue;
 
-		if (sc->device->lun != abrt_task->sc->device->lun)
+		if (sdev->lun != abrt_task->sc->device->lun)
 			continue;
 
 		/* Invalidate WRB Posted for this Task */
@@ -371,7 +371,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	if (rc != -EBUSY)
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
-	return iscsi_eh_device_reset(sc);
+	return iscsi_eh_device_reset(sdev);
 }
 
 static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
@@ -560,7 +560,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.slave_configure = beiscsi_slave_configure,
 	.target_alloc = iscsi_target_alloc,
 	.eh_abort_handler = beiscsi_eh_abort,
-	.eh_device_reset_handler = beiscsi_eh_device_reset,
+	.eh_async_device_reset_handler = beiscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_session_reset,
 	.shost_attrs = beiscsi_attrs,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 7289437..e73ee8d 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2260,7 +2260,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.proc_name		= "bnx2i",
 	.queuecommand		= iscsi_queuecommand,
 	.eh_abort_handler	= iscsi_eh_abort,
-	.eh_device_reset_handler = iscsi_eh_device_reset,
+	.eh_async_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.target_alloc		= iscsi_target_alloc,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index e22a268..f70e9f5 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -91,7 +91,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.max_sectors	= 0xFFFF,
 	.cmd_per_lun	= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler = iscsi_eh_abort,
-	.eh_device_reset_handler = iscsi_eh_device_reset,
+	.eh_async_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.target_alloc	= iscsi_target_alloc,
 	.use_clustering	= DISABLE_CLUSTERING,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 339f6b7..230e7d2 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -100,7 +100,7 @@ static struct scsi_host_template cxgb4i_host_template = {
 	.max_sectors	= 0xFFFF,
 	.cmd_per_lun	= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler = iscsi_eh_abort,
-	.eh_device_reset_handler = iscsi_eh_device_reset,
+	.eh_async_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.target_alloc	= iscsi_target_alloc,
 	.use_clustering	= DISABLE_CLUSTERING,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2e4c82f..1123f98 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -968,7 +968,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
-	.eh_device_reset_handler= iscsi_eh_device_reset,
+	.eh_async_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.slave_alloc            = iscsi_sw_tcp_slave_alloc,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6bffd91..ccef7be 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2250,17 +2250,18 @@ failed_unlocked:
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_abort);
 
-static void iscsi_prep_lun_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
+static void iscsi_prep_lun_reset_pdu(struct scsi_device *sdev,
+				     struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
 	hdr->flags = ISCSI_TM_FUNC_LOGICAL_UNIT_RESET & ISCSI_FLAG_TM_FUNC_MASK;
 	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-	int_to_scsilun(sc->device->lun, &hdr->lun);
+	int_to_scsilun(sdev->lun, &hdr->lun);
 	hdr->rtt = RESERVED_ITT;
 }
 
-int iscsi_eh_device_reset(struct scsi_cmnd *sc)
+int iscsi_eh_device_reset(struct scsi_device *sdev)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -2268,11 +2269,10 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	struct iscsi_tm *hdr;
 	int rc = FAILED;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(scsi_target(sdev));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %llu]\n", sc,
-		     sc->device->lun);
+	ISCSI_DBG_EH(session, "LU Reset [lun %llu]\n", sdev->lun);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2290,7 +2290,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	conn->tmf_state = TMF_QUEUED;
 
 	hdr = &conn->tmhdr;
-	iscsi_prep_lun_reset_pdu(sc, hdr);
+	iscsi_prep_lun_reset_pdu(sdev, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->lu_reset_timeout)) {
@@ -2317,7 +2317,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
-	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
+	fail_scsi_tasks(conn, sdev->lun, DID_ABORT);
 	conn->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4d1c46a..8db2d22 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -381,7 +381,7 @@ struct iscsi_host {
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
 extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
-extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_device_reset(struct scsi_device *sdev);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 
 /*
-- 
2.7.2
