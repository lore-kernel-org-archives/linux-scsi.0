From: michaelc@cs.wisc.edu
Subject: [PATCH 6/19] libiscsi, iscsi_tcp, ib_iser : add sw iscsi host get/set params helpers
Date: Wed, 30 May 2007 12:57:12 -0500
Message-ID: <11805478523188-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478511328-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsid and udev need to key off the hw address being
used so add some helpers for iser and iscsi tcp.

Also convert them.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    4 +++
 drivers/scsi/iscsi_tcp.c                 |    4 +++
 drivers/scsi/libiscsi.c                  |   40 ++++++++++++++++++++++++++++++
 include/scsi/libiscsi.h                  |   13 +++++++++-
 4 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index dd221ed..2a99b7b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -576,6 +576,7 @@ static struct iscsi_transport iscsi_iser
 				  ISCSI_PERSISTENT_ADDRESS |
 				  ISCSI_TARGET_NAME |
 				  ISCSI_TPGT,
+	.host_param_mask	= ISCSI_HOST_HWADDRESS,
 	.host_template          = &iscsi_iser_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_lun                = ISCSI_ISER_MAX_LUN,
@@ -592,6 +593,9 @@ static struct iscsi_transport iscsi_iser
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn             = iscsi_iser_conn_start,
 	.stop_conn              = iscsi_conn_stop,
+	/* iscsi host params */
+	.get_host_param		= iscsi_host_get_param,
+	.set_host_param		= iscsi_host_set_param,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_iser_conn_get_stats,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c9a3abf..9a42fc0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2181,6 +2181,7 @@ static struct iscsi_transport iscsi_tcp_
 				  ISCSI_PERSISTENT_ADDRESS |
 				  ISCSI_TARGET_NAME |
 				  ISCSI_TPGT,
+	.host_param_mask	= ISCSI_HOST_HWADDRESS,
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
@@ -2197,6 +2198,9 @@ static struct iscsi_transport iscsi_tcp_
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_tcp_conn_stop,
+	/* iscsi host params */
+	.get_host_param		= iscsi_host_get_param,
+	.set_host_param		= iscsi_host_set_param,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_conn_get_stats,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3f5b9b4..d430e22 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1462,6 +1462,7 @@ void iscsi_session_teardown(struct iscsi
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 
 	kfree(session->targetname);
+	kfree(session->hwaddress);
 
 	iscsi_destroy_session(cls_session);
 	scsi_host_put(shost);
@@ -1990,6 +1991,45 @@ int iscsi_conn_get_param(struct iscsi_cl
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_get_param);
 
+int iscsi_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
+			 char *buf)
+{
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	int len;
+
+	switch (param) {
+	case ISCSI_HOST_PARAM_HWADDRESS:
+		if (!session->hwaddress)
+			len = sprintf(buf, "%s\n", "default");
+		else
+			len = sprintf(buf, "%s\n", session->hwaddress);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_get_param);
+
+int iscsi_host_set_param(struct Scsi_Host *shost, enum iscsi_host_param param,
+			 char *buf, int buflen)
+{
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+
+	switch (param) {
+	case ISCSI_HOST_PARAM_HWADDRESS:
+		if (!session->hwaddress)
+			session->hwaddress = kstrdup(buf, GFP_KERNEL);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_set_param);
+
 MODULE_AUTHOR("Mike Christie");
 MODULE_DESCRIPTION("iSCSI library functions");
 MODULE_LICENSE("GPL");
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ea0816d..e202cc0 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -224,7 +224,8 @@ struct iscsi_session {
 	int			erl;
 	int			tpgt;
 	char			*targetname;
-
+	/* hw address being used for iscsi connection */
+	char			*hwaddress;
 	/* control data */
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
@@ -255,6 +256,16 @@ extern int iscsi_eh_host_reset(struct sc
 extern int iscsi_queuecommand(struct scsi_cmnd *sc,
 			      void (*done)(struct scsi_cmnd *));
 
+
+/*
+ * iSCSI host helpers.
+ */
+extern int iscsi_host_set_param(struct Scsi_Host *shost,
+				enum iscsi_host_param param, char *buf,
+				int buflen);
+extern int iscsi_host_get_param(struct Scsi_Host *shost,
+				enum iscsi_host_param param, char *buf);
+
 /*
  * session management
  */
-- 
1.4.1.1

