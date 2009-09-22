From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/2] libiscsi: iscsi_session_setup to allow for private
	space
Date: Tue, 22 Sep 2009 08:21:22 +0530
Message-ID: <20090922025104.GA19957@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:56858 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751152AbZIVCvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2009 22:51:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch contains changes that allow iscsi_session_setup
 to allocate private space for LLD's

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 drivers/scsi/be2iscsi/be_iscsi.c         |    6 ++++--
 drivers/scsi/be2iscsi/be_main.h          |    5 +++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |    2 +-
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |    2 +-
 drivers/scsi/iscsi_tcp.c                 |    2 +-
 drivers/scsi/libiscsi.c                  |    6 ++++--
 include/scsi/libiscsi.h                  |    3 ++-
 8 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 0ba6ec8..add9188 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -426,7 +426,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	 * because we preallocate so many resources
 	 */
 	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
-					  ISCSI_DEF_XMIT_CMDS_MAX,
+					  ISCSI_DEF_XMIT_CMDS_MAX, 0,
 					  sizeof(struct iscsi_iser_task),
 					  initial_cmdsn, 0);
 	if (!cls_session)
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index b23526c..f18e643 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -44,9 +44,10 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 	struct Scsi_Host *shost;
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_cls_session *cls_session;
-	struct iscsi_session *sess;
 	struct beiscsi_hba *phba;
 	struct iscsi_task *task;
+	struct iscsi_session *sess;
+	struct beiscsi_session *beiscsi_sess;
 	struct beiscsi_io_task *io_task;
 	unsigned int max_size, num_cmd;
 	dma_addr_t bus_add;
@@ -73,7 +74,8 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 
 	 cls_session = iscsi_session_setup(&beiscsi_iscsi_transport,
 					   shost, cmds_max,
-					   sizeof(struct beiscsi_io_task),
+					   sizeof(*beiscsi_sess),
+					   sizeof(*io_task),
 					   initial_cmdsn, ISCSI_MAX_TARGET);
 	if (!cls_session)
 		return NULL;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 2520c39..387e363 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -327,6 +327,10 @@ struct beiscsi_hba {
 	struct be_ctrl_info ctrl;
 };
 
+struct beiscsi_session {
+	struct pci_pool *bhs_pool;
+};
+
 /**
  * struct beiscsi_conn - iscsi connection structure
  */
@@ -338,6 +342,7 @@ struct beiscsi_conn {
 	struct beiscsi_endpoint *ep;
 	unsigned short login_in_progress;
 	struct sgl_handle *plogin_sgl_handle;
+	struct beiscsi_session *beiscsi_sess;
 };
 
 /* This structure is used by the chip */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 9a7ba71..cafb888 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1243,7 +1243,7 @@ bnx2i_session_create(struct iscsi_endpoint *ep,
 		cmds_max = BNX2I_SQ_WQES_MIN;
 
 	cls_session = iscsi_session_setup(&bnx2i_iscsi_transport, shost,
-					  cmds_max, sizeof(struct bnx2i_cmd),
+					  cmds_max, 0, sizeof(struct bnx2i_cmd),
 					  initial_cmdsn, ISCSI_MAX_TARGET);
 	if (!cls_session)
 		return NULL;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index c399f48..2631bdd 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -422,7 +422,7 @@ cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
 	BUG_ON(hba != iscsi_host_priv(shost));
 
 	cls_session = iscsi_session_setup(&cxgb3i_iscsi_transport, shost,
-					  cmds_max,
+					  cmds_max, 0,
 					  sizeof(struct iscsi_tcp_task) +
 					  sizeof(struct cxgb3i_task_data),
 					  initial_cmdsn, ISCSI_MAX_TARGET);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2b1b834..edc49ca 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -811,7 +811,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		goto free_host;
 
 	cls_session = iscsi_session_setup(&iscsi_sw_tcp_transport, shost,
-					  cmds_max,
+					  cmds_max, 0,
 					  sizeof(struct iscsi_tcp_task) +
 					  sizeof(struct iscsi_sw_tcp_hdrbuf),
 					  initial_cmdsn, 0);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8dc73c4..f1a4246 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2436,7 +2436,7 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
  */
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
-		    uint16_t cmds_max, int cmd_task_size,
+		    uint16_t cmds_max, int dd_size, int cmd_task_size,
 		    uint32_t initial_cmdsn, unsigned int id)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
@@ -2486,7 +2486,8 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
 
 	cls_session = iscsi_alloc_session(shost, iscsit,
-					  sizeof(struct iscsi_session));
+					  sizeof(struct iscsi_session) +
+					  dd_size);
 	if (!cls_session)
 		goto dec_session_count;
 	session = cls_session->dd_data;
@@ -2503,6 +2504,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
 	session->tt = iscsit;
+	session->dd_data = cls_session->dd_data + sizeof(*session);
 	mutex_init(&session->eh_mutex);
 	spin_lock_init(&session->lock);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 887e57e..a72edd4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -303,6 +303,7 @@ struct iscsi_session {
 	int			cmds_max;	/* size of cmds array */
 	struct iscsi_task	**cmds;		/* Original Cmds arr */
 	struct iscsi_pool	cmdpool;	/* PDU's pool */
+	void			*dd_data;	/* LLD private data */
 };
 
 enum {
@@ -363,7 +364,7 @@ extern int iscsi_target_alloc(struct scsi_target *starget);
  */
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
-		    uint16_t, int, uint32_t, unsigned int);
+		    uint16_t, int, int, uint32_t, unsigned int);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
-- 
1.6.4

