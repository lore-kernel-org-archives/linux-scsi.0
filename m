From: michaelc@cs.wisc.edu
Subject: [PATCH 13/19] libiscsi: make can_queue configurable
Date: Wed, 30 May 2007 12:57:19 -0500
Message-ID: <11805478601019-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu> <11805478592848-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbXE3R5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:48 -0400
In-Reply-To: <11805478592848-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch allows us to set can_queue and cmds_per_lun from userspace
when we create the session/host. From there we can set it on a per
target basis. The patch fully converts iscsi_tcp, but only hooks
up ib_iser for cmd_per_lun since it currently has a lots of preallocations
based on can_queue.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   11 +++++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.h |    4 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c |    4 ++--
 drivers/scsi/iscsi_tcp.c                 |    5 +++--
 drivers/scsi/libiscsi.c                  |   28 +++++++++++++++++++++++++++-
 drivers/scsi/scsi_transport_iscsi.c      |    2 ++
 include/scsi/iscsi_if.h                  |    2 ++
 include/scsi/libiscsi.h                  |    7 +++----
 include/scsi/scsi_transport_iscsi.h      |    3 ++-
 9 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9782190..bed583c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -373,7 +373,8 @@ static struct iscsi_transport iscsi_iser
 static struct iscsi_cls_session *
 iscsi_iser_session_create(struct iscsi_transport *iscsit,
 			 struct scsi_transport_template *scsit,
-			  uint32_t initial_cmdsn, uint32_t *hostno)
+			 uint16_t cmds_max, uint16_t qdepth,
+			 uint32_t initial_cmdsn, uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -384,7 +385,13 @@ iscsi_iser_session_create(struct iscsi_t
 	struct iscsi_iser_cmd_task *iser_ctask;
 	struct iser_desc *desc;
 
+	/*
+	 * we do not support setting can_queue cmd_per_lun from userspace yet
+	 * because we preallocate so many resources
+	 */
 	cls_session = iscsi_session_setup(iscsit, scsit,
+					  ISCSI_DEF_XMIT_CMDS_MAX,
+					  ISCSI_MAX_CMD_PER_LUN,
 					  sizeof(struct iscsi_iser_cmd_task),
 					  sizeof(struct iser_desc),
 					  initial_cmdsn, &hn);
@@ -543,7 +550,7 @@ iscsi_iser_ep_disconnect(__u64 ep_handle
 static struct scsi_host_template iscsi_iser_sht = {
 	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
 	.queuecommand           = iscsi_queuecommand,
-	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
+	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
 	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
 	.max_sectors		= 1024,
 	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 8960196..e235370 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -98,7 +98,7 @@ #define ISER_MAX_RX_MISC_PDUS		4 /* NOOP
 #define ISER_MAX_TX_MISC_PDUS		6 /* NOOP_OUT(2), TEXT(1),         *
 					   * SCSI_TMFUNC(2), LOGOUT(1) */
 
-#define ISER_QP_MAX_RECV_DTOS		(ISCSI_XMIT_CMDS_MAX + \
+#define ISER_QP_MAX_RECV_DTOS		(ISCSI_DEF_XMIT_CMDS_MAX + \
 					ISER_MAX_RX_MISC_PDUS    +  \
 					ISER_MAX_TX_MISC_PDUS)
 
@@ -110,7 +110,7 @@ #define ISER_QP_MAX_RECV_DTOS		(ISCSI_XM
 
 #define ISER_INFLIGHT_DATAOUTS		8
 
-#define ISER_QP_MAX_REQ_DTOS		(ISCSI_XMIT_CMDS_MAX *    \
+#define ISER_QP_MAX_REQ_DTOS		(ISCSI_DEF_XMIT_CMDS_MAX *    \
 					(1 + ISER_INFLIGHT_DATAOUTS) + \
 					ISER_MAX_TX_MISC_PDUS        + \
 					ISER_MAX_RX_MISC_PDUS)
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 3702e23..2044de1 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -155,8 +155,8 @@ static int iser_create_ib_conn_res(struc
 	params.max_pages_per_fmr = ISCSI_ISER_SG_TABLESIZE + 1;
 	/* make the pool size twice the max number of SCSI commands *
 	 * the ML is expected to queue, watermark for unmap at 50%  */
-	params.pool_size	 = ISCSI_XMIT_CMDS_MAX * 2;
-	params.dirty_watermark	 = ISCSI_XMIT_CMDS_MAX;
+	params.pool_size	 = ISCSI_DEF_XMIT_CMDS_MAX * 2;
+	params.dirty_watermark	 = ISCSI_DEF_XMIT_CMDS_MAX;
 	params.cache		 = 0;
 	params.flush_function	 = NULL;
 	params.access		 = (IB_ACCESS_LOCAL_WRITE  |
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8edcfdd..eca4d61 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2114,6 +2114,7 @@ iscsi_conn_get_stats(struct iscsi_cls_co
 static struct iscsi_cls_session *
 iscsi_tcp_session_create(struct iscsi_transport *iscsit,
 			 struct scsi_transport_template *scsit,
+			 uint16_t cmds_max, uint16_t qdepth,
 			 uint32_t initial_cmdsn, uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
@@ -2121,7 +2122,7 @@ iscsi_tcp_session_create(struct iscsi_tr
 	uint32_t hn;
 	int cmd_i;
 
-	cls_session = iscsi_session_setup(iscsit, scsit,
+	cls_session = iscsi_session_setup(iscsit, scsit, cmds_max, qdepth,
 					 sizeof(struct iscsi_tcp_cmd_task),
 					 sizeof(struct iscsi_tcp_mgmt_task),
 					 initial_cmdsn, &hn);
@@ -2164,7 +2165,7 @@ static struct scsi_host_template iscsi_s
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
-	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
+	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
 	.sg_tablesize		= ISCSI_SG_TABLESIZE,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 938f527..1632866 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1330,6 +1330,10 @@ #define hostdata_session(_hostdata) (isc
  * iscsi_session_setup - create iscsi cls session and host and session
  * @scsit: scsi transport template
  * @iscsit: iscsi transport template
+ * @cmds_max: scsi host can queue
+ * @qdepth: scsi host cmds per lun
+ * @cmd_task_size: LLD ctask private data size
+ * @mgmt_task_size: LLD mtask private data size
  * @initial_cmdsn: initial CmdSN
  * @hostno: host no allocated
  *
@@ -1339,6 +1343,7 @@ #define hostdata_session(_hostdata) (isc
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit,
 		    struct scsi_transport_template *scsit,
+		    uint16_t cmds_max, uint16_t qdepth,
 		    int cmd_task_size, int mgmt_task_size,
 		    uint32_t initial_cmdsn, uint32_t *hostno)
 {
@@ -1347,11 +1352,32 @@ iscsi_session_setup(struct iscsi_transpo
 	struct iscsi_cls_session *cls_session;
 	int cmd_i;
 
+	if (qdepth > ISCSI_MAX_CMD_PER_LUN || qdepth < 1) {
+		if (qdepth != 0)
+			printk(KERN_ERR "iscsi: invalid queue depth of %d. "
+			      "Queue depth must be between 1 and %d.\n",
+			      qdepth, ISCSI_MAX_CMD_PER_LUN);
+		qdepth = ISCSI_DEF_CMD_PER_LUN;
+	}
+
+	if (cmds_max < 2 || (cmds_max & (cmds_max - 1)) ||
+	    cmds_max >= ISCSI_MGMT_ITT_OFFSET) {
+		if (cmds_max != 0)
+			printk(KERN_ERR "iscsi: invalid can_queue of %d. "
+			       "can_queue must be a power of 2 and between "
+			       "2 and %d - setting to %d.\n", cmds_max,
+			       ISCSI_MGMT_ITT_OFFSET, ISCSI_DEF_XMIT_CMDS_MAX);
+		cmds_max = ISCSI_DEF_XMIT_CMDS_MAX;
+	}
+
 	shost = scsi_host_alloc(iscsit->host_template,
 				hostdata_privsize(sizeof(*session)));
 	if (!shost)
 		return NULL;
 
+	/* the iscsi layer takes one task for reserve */
+	shost->can_queue = cmds_max - 1;
+	shost->cmd_per_lun = qdepth;
 	shost->max_id = 1;
 	shost->max_channel = 0;
 	shost->max_lun = iscsit->max_lun;
@@ -1365,7 +1391,7 @@ iscsi_session_setup(struct iscsi_transpo
 	session->host = shost;
 	session->state = ISCSI_STATE_FREE;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
-	session->cmds_max = ISCSI_XMIT_CMDS_MAX;
+	session->cmds_max = cmds_max;
 	session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 341d4fb..859bd21 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -814,6 +814,8 @@ iscsi_if_create_session(struct iscsi_int
 	uint32_t hostno;
 
 	session = transport->create_session(transport, &priv->t,
+					    ev->u.c_session.cmds_max,
+					    ev->u.c_session.queue_depth,
 					    ev->u.c_session.initial_cmdsn,
 					    &hostno);
 	if (!session)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 1a18196..a046a32 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -72,6 +72,8 @@ struct iscsi_uevent {
 		/* messages u -> k */
 		struct msg_create_session {
 			uint32_t	initial_cmdsn;
+			uint16_t	cmds_max;
+			uint16_t	queue_depth;
 		} c_session;
 		struct msg_destroy_session {
 			uint32_t	sid;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8d48cf8..2f303a3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -48,9 +48,8 @@ #else
 #define debug_scsi(fmt...)
 #endif
 
-#define ISCSI_XMIT_CMDS_MAX	128	/* must be power of 2 */
-#define ISCSI_MGMT_CMDS_MAX	32	/* must be power of 2 */
-#define ISCSI_CONN_MAX			1
+#define ISCSI_DEF_XMIT_CMDS_MAX	128	/* must be power of 2 */
+#define ISCSI_MGMT_CMDS_MAX	16	/* must be power of 2 */
 
 #define ISCSI_MGMT_ITT_OFFSET	0xa00
 
@@ -268,7 +267,7 @@ extern int iscsi_host_get_param(struct S
  */
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct scsi_transport_template *,
-		    int, int, uint32_t, uint32_t *);
+		    uint16_t, uint16_t, int, int, uint32_t, uint32_t *);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern struct iscsi_session *class_to_transport_session(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index abc4068..706c0cd 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -90,7 +90,8 @@ struct iscsi_transport {
 	unsigned int max_conn;
 	unsigned int max_cmd_len;
 	struct iscsi_cls_session *(*create_session) (struct iscsi_transport *it,
-		struct scsi_transport_template *t, uint32_t sn, uint32_t *hn);
+		struct scsi_transport_template *t, uint16_t, uint16_t,
+		uint32_t sn, uint32_t *hn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
-- 
1.4.1.1

