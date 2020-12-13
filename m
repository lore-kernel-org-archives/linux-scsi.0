Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB5EC4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 444612310E
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390867AbgLMDLN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:11:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60624 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388169AbgLMDKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD34Csh176122;
        Sun, 13 Dec 2020 03:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=SHEDIs9iszvmhf4NKirwkQl+TIr2cpW14d+mIkbdGho=;
 b=UKJt66XNooxUPAOOwiM/7aUaBKBFUfgStCgtGym6CfSX16QGOZeJrGBUv9Tw35sopGB0
 KXNu1WexDH5OIRW9H/uNAb/dVV885ec8HaeunDrMpz5+YIYvDL5s79dnUNmDEc+LkfNg
 sfP4Jn07OpE93xOX3beOAe6RxGz0/fTGGO9kiDz1llWjMDwzhtOeM1uATwty+knlXfUn
 31ypodyN/ZfNUJzsgB76mQ/lmPlj+EPmhPpy1mRDCB+pKKO7jxgQp/PlQKwBWRiLHfSt
 kgL10gz14453IBHzWdpbneSszYwWyiFvlqOGFrm+1k5oD5ros/PNa2BJjQxpfP8jE5/m nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb1ph8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD351dR107815;
        Sun, 13 Dec 2020 03:09:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7ejakjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BD39AZj013862;
        Sun, 13 Dec 2020 03:09:10 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:10 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 14/18] iscsi_tcp, libcxgbi: set scsi_host_template cmd_size
Date:   Sat, 12 Dec 2020 21:08:42 -0600
Message-Id: <1607828926-3658-15-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate the
iscsi structs for the driver.

Note: Because for cxgbi we do not have access to the specific session we
are creating cmds for, all sessions get the max of what is on the host
but this is normally going to one so it should not be any different.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   5 ++
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   5 ++
 drivers/scsi/cxgbi/libcxgbi.c      |  10 ----
 drivers/scsi/iscsi_tcp.c           |  10 ++--
 drivers/scsi/libiscsi_tcp.c        | 102 ++++++++++++++++++++-----------------
 include/scsi/libiscsi_tcp.h        |   5 +-
 6 files changed, 72 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 37d9935..d45babc 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -98,6 +98,11 @@
 	.dma_boundary	= PAGE_SIZE - 1,
 	.this_id	= -1,
 	.track_queue_depth = 1,
+	.cmd_size	= sizeof(struct iscsi_tcp_task) +
+			  sizeof(struct cxgbi_task_data) +
+			  sizeof(struct iscsi_task),
+	.init_cmd_priv	= iscsi_tcp_init_cmd_priv,
+	.exit_cmd_priv	= iscsi_tcp_exit_cmd_priv,
 };
 
 static struct iscsi_transport cxgb3i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2c34915..d6647fa 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -116,6 +116,11 @@
 	.dma_boundary	= PAGE_SIZE - 1,
 	.this_id	= -1,
 	.track_queue_depth = 1,
+	.cmd_size	= sizeof(struct iscsi_tcp_task) +
+			  sizeof(struct cxgbi_task_data) +
+			  sizeof(struct iscsi_task),
+	.init_cmd_priv	= iscsi_tcp_init_cmd_priv,
+	.exit_cmd_priv	= iscsi_tcp_exit_cmd_priv,
 };
 
 static struct iscsi_transport cxgb4i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c..e45989c 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2727,7 +2727,6 @@ struct iscsi_cls_session *cxgbi_create_session(struct iscsi_endpoint *ep,
 	struct cxgbi_hba *chba;
 	struct Scsi_Host *shost;
 	struct iscsi_cls_session *cls_session;
-	struct iscsi_session *session;
 
 	if (!ep) {
 		pr_err("missing endpoint.\n");
@@ -2748,17 +2747,9 @@ struct iscsi_cls_session *cxgbi_create_session(struct iscsi_endpoint *ep,
 	if (!cls_session)
 		return NULL;
 
-	session = cls_session->dd_data;
-	if (iscsi_tcp_r2tpool_alloc(session))
-		goto remove_session;
-
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"ep 0x%p, cls sess 0x%p.\n", ep, cls_session);
 	return cls_session;
-
-remove_session:
-	iscsi_session_teardown(cls_session);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(cxgbi_create_session);
 
@@ -2767,7 +2758,6 @@ void cxgbi_destroy_session(struct iscsi_cls_session *cls_session)
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"cls sess 0x%p.\n", cls_session);
 
-	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 }
 EXPORT_SYMBOL_GPL(cxgbi_destroy_session);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index df47557..185110d1 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -879,12 +879,8 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 	tcp_sw_host->session = session;
 
 	shost->can_queue = session->scsi_cmds_max;
-	if (iscsi_tcp_r2tpool_alloc(session))
-		goto remove_session;
 	return cls_session;
 
-remove_session:
-	iscsi_session_teardown(cls_session);
 remove_host:
 	iscsi_host_remove(shost);
 free_host:
@@ -900,7 +896,6 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	if (WARN_ON_ONCE(session->leadconn))
 		return;
 
-	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 
 	iscsi_host_remove(shost);
@@ -995,6 +990,11 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct iscsi_tcp_task) +
+				  sizeof(struct iscsi_sw_tcp_hdrbuf) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= iscsi_tcp_init_cmd_priv,
+	.exit_cmd_priv		= iscsi_tcp_exit_cmd_priv,
 };
 
 static struct iscsi_transport iscsi_sw_tcp_transport = {
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index ea11788..9619097 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1147,68 +1147,75 @@ void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_teardown);
 
-int iscsi_tcp_r2tpool_alloc(struct iscsi_session *session)
+static int iscsi_tcp_calc_max_r2t(struct device *dev, void *data)
 {
-	int i;
-	int cmd_i;
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *session;
+	int *max_r2t = data;
 
-	/*
-	 * initialize per-task: R2T pool and xmit queue
-	 */
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-	        struct iscsi_task *task = session->cmds[cmd_i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
+	if (!iscsi_is_session_dev(dev))
+		return 0;
 
-		/*
-		 * pre-allocated x2 as much r2ts to handle race when
-		 * target acks DataOut faster than we data_xmit() queues
-		 * could replenish r2tqueue.
-		 */
+	cls_session = iscsi_dev_to_session(dev);
+	session = cls_session->dd_data;
+	if (session->max_r2t > *max_r2t)
+		*max_r2t = session->max_r2t;
+	return 0;
+}
 
-		/* R2T pool */
-		if (iscsi_pool_init(&tcp_task->r2tpool,
-				    session->max_r2t * 2, NULL,
-				    sizeof(struct iscsi_r2t_info))) {
-			goto r2t_alloc_fail;
-		}
+int iscsi_tcp_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	struct iscsi_task *task;
+	struct iscsi_tcp_task *tcp_task;
+	int max_r2t = 1;
 
-		/* R2T xmit queue */
-		if (kfifo_alloc(&tcp_task->r2tqueue,
-		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL)) {
-			iscsi_pool_free(&tcp_task->r2tpool);
-			goto r2t_alloc_fail;
-		}
-		spin_lock_init(&tcp_task->pool2queue);
-		spin_lock_init(&tcp_task->queue2pool);
-	}
+	iscsi_init_cmd_priv(shost, sc);
 
-	return 0;
+	/*
+	 * cxgbi does not have access to the session so we use the max of all
+	 * sessions on the host.
+	 */
+	device_for_each_child(&shost->shost_gendev, &max_r2t,
+			      iscsi_tcp_calc_max_r2t);
 
-r2t_alloc_fail:
-	for (i = 0; i < cmd_i; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
+	task = scsi_cmd_priv(sc);
+	tcp_task = task->dd_data;
 
-		kfifo_free(&tcp_task->r2tqueue);
+	/*
+	 * pre-allocated x2 as much r2ts to handle race when
+	 * target acks DataOut faster than we data_xmit() queues
+	 * could replenish r2tqueue.
+	 */
+	if (iscsi_pool_init(&tcp_task->r2tpool, max_r2t * 2, NULL,
+			    sizeof(struct iscsi_r2t_info)))
+		return -ENOMEM;
+
+	/* R2T xmit queue */
+	if (kfifo_alloc(&tcp_task->r2tqueue, max_r2t * 4 * sizeof(void *),
+			GFP_KERNEL)) {
 		iscsi_pool_free(&tcp_task->r2tpool);
+		goto r2t_queue_alloc_fail;
 	}
+	spin_lock_init(&tcp_task->pool2queue);
+	spin_lock_init(&tcp_task->queue2pool);
+	return 0;
+
+r2t_queue_alloc_fail:
+	iscsi_pool_free(&tcp_task->r2tpool);
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(iscsi_tcp_r2tpool_alloc);
+EXPORT_SYMBOL_GPL(iscsi_tcp_init_cmd_priv);
 
-void iscsi_tcp_r2tpool_free(struct iscsi_session *session)
+int iscsi_tcp_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
 
-		kfifo_free(&tcp_task->r2tqueue);
-		iscsi_pool_free(&tcp_task->r2tpool);
-	}
+	kfifo_free(&tcp_task->r2tqueue);
+	iscsi_pool_free(&tcp_task->r2tpool);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(iscsi_tcp_r2tpool_free);
+EXPORT_SYMBOL_GPL(iscsi_tcp_exit_cmd_priv);
 
 int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf)
 {
@@ -1223,8 +1230,7 @@ int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf)
 		return -EINVAL;
 
 	session->max_r2t = r2ts;
-	iscsi_tcp_r2tpool_free(session);
-	return iscsi_tcp_r2tpool_alloc(session);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_set_max_r2t);
 
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 7c8ba9d..4d502f6 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -89,6 +89,9 @@ extern int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 extern void iscsi_tcp_cleanup_task(struct iscsi_task *task);
 extern int iscsi_tcp_task_init(struct iscsi_task *task);
 extern int iscsi_tcp_task_xmit(struct iscsi_task *task);
+extern int iscsi_tcp_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+extern int iscsi_tcp_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+
 
 /* segment helpers */
 extern int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn);
@@ -118,8 +121,6 @@ extern void iscsi_tcp_dgst_header(struct ahash_request *hash, const void *hdr,
 extern void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn);
 
 /* misc helpers */
-extern int iscsi_tcp_r2tpool_alloc(struct iscsi_session *session);
-extern void iscsi_tcp_r2tpool_free(struct iscsi_session *session);
 extern int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf);
 extern void iscsi_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 				     struct iscsi_stats *stats);
-- 
1.8.3.1

