From: michaelc@cs.wisc.edu
Subject: [PATCH 02/25] iscsi class, iscsi drivers: remove unused iscsi_transport attrs
Date: Wed, 21 May 2008 15:53:57 -0500
Message-ID: <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936714AbYEUUya (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:30 -0400
In-Reply-To: <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

max_cmd_len and max_conn are not really used. max_cmd_len is
always 16 and can be set by the LLD. max_conn is always one
since we do not support MCS.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 -
 drivers/infiniband/ulp/iser/iscsi_iser.h |    1 -
 drivers/scsi/iscsi_tcp.c                 |    2 --
 drivers/scsi/libiscsi.c                  |    2 +-
 drivers/scsi/scsi_transport_iscsi.c      |    4 ----
 include/scsi/scsi_transport_iscsi.h      |    2 --
 6 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index efc1219..32f5d5e 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -592,7 +592,6 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.host_template          = &iscsi_iser_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_lun                = ISCSI_ISER_MAX_LUN,
-	.max_cmd_len            = ISCSI_ISER_MAX_CMD_LEN,
 	/* session management */
 	.create_session         = iscsi_iser_session_create,
 	.destroy_session        = iscsi_session_teardown,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index a8c1b30..66a2f30 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -96,7 +96,6 @@
 					/* support upto 512KB in one RDMA */
 #define ISCSI_ISER_SG_TABLESIZE         (0x80000 >> SHIFT_4K)
 #define ISCSI_ISER_MAX_LUN		256
-#define ISCSI_ISER_MAX_CMD_LEN		16
 
 /* QP settings */
 /* Maximal bounds on received asynchronous PDUs */
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 81c421a..aecadbd 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1978,8 +1978,6 @@ static struct iscsi_transport iscsi_tcp_transport = {
 				  ISCSI_HOST_NETDEV_NAME,
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
-	.max_conn		= 1,
-	.max_cmd_len		= 16,
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b43bf1d..01a1a4d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1830,7 +1830,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 	shost->max_id = 1;
 	shost->max_channel = 0;
 	shost->max_lun = iscsit->max_lun;
-	shost->max_cmd_len = iscsit->max_cmd_len;
+	shost->max_cmd_len = 16;
 	shost->transportt = scsit;
 	shost->transportt->create_work_queue = 1;
 	shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2a6669d..e6a090e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -102,15 +102,11 @@ static DEVICE_ATTR(name, S_IRUGO, show_transport_##name, NULL);
 
 show_transport_attr(caps, "0x%x");
 show_transport_attr(max_lun, "%d");
-show_transport_attr(max_conn, "%d");
-show_transport_attr(max_cmd_len, "%d");
 
 static struct attribute *iscsi_transport_attrs[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_caps.attr,
 	&dev_attr_max_lun.attr,
-	&dev_attr_max_conn.attr,
-	&dev_attr_max_cmd_len.attr,
 	NULL,
 };
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 02a8520..afed70e 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -89,8 +89,6 @@ struct iscsi_transport {
 	/* LLD session data size */
 	int sessiondata_size;
 	int max_lun;
-	unsigned int max_conn;
-	unsigned int max_cmd_len;
 	struct iscsi_cls_session *(*create_session) (struct iscsi_transport *it,
 		struct scsi_transport_template *t, struct Scsi_Host *shost,
 		uint16_t cmds_max, uint16_t qdepth, uint32_t sn, uint32_t *hn);
-- 
1.5.4.1

