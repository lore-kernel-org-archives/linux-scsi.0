From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] cxgb3i, iser, iscsi_tcp: set target can queue
Date: Tue, 21 Apr 2009 15:32:32 -0500
Message-ID: <12403459572661-git-send-email-michaelc@cs.wisc.edu>
References: <1240345955183-git-send-email-michaelc@cs.wisc.edu>
 <1240345956764-git-send-email-michaelc@cs.wisc.edu>
 <1240345956886-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35814 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbZDUUck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:40 -0400
In-Reply-To: <1240345956886-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Set target can queue limit to the number of preallocated
session tasks we have.

This along with the cxgb3i can_queue patch will fix a throughput
problem where it could only queue one LU worth of data at a time.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |    1 +
 drivers/scsi/iscsi_tcp.c                 |    1 +
 drivers/scsi/libiscsi.c                  |   10 ++++++++++
 include/scsi/libiscsi.h                  |    2 ++
 5 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 13d7674..75223f5 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -599,6 +599,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler= iscsi_eh_target_reset,
+	.target_alloc		= iscsi_target_alloc,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index fff8e43..b3ca3a0 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -883,6 +883,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.target_alloc		= iscsi_target_alloc,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.this_id		= -1,
 };
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f97fc7e..b7c092d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -851,6 +851,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.use_clustering         = DISABLE_CLUSTERING,
 	.slave_alloc            = iscsi_sw_tcp_slave_alloc,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
+	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 };
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6896283..e72b4ad 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1463,6 +1463,16 @@ int iscsi_change_queue_depth(struct scsi_device *sdev, int depth)
 }
 EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
 
+int iscsi_target_alloc(struct scsi_target *starget)
+{
+	struct iscsi_cls_session *cls_session = starget_to_session(starget);
+	struct iscsi_session *session = cls_session->dd_data;
+
+	starget->can_queue = session->scsi_cmds_max;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_target_alloc);
+
 void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7ffaed2..0289f57 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -36,6 +36,7 @@ struct scsi_transport_template;
 struct scsi_host_template;
 struct scsi_device;
 struct Scsi_Host;
+struct scsi_target;
 struct scsi_cmnd;
 struct socket;
 struct iscsi_transport;
@@ -350,6 +351,7 @@ extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 					  bool xmit_can_sleep);
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
+extern int iscsi_target_alloc(struct scsi_target *starget);
 
 /*
  * session management
-- 
1.6.0.6

