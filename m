From: Rob Evers <revers@redhat.com>
Subject: [PATCH] scsi_io_completion: extend description of default host-byte handling
Date: Thu, 13 Oct 2011 17:31:16 -0400
Message-ID: <1318541476-27243-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1JMVbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2011 17:31:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9DLVK2b019569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2011 17:31:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Rob Evers <revers@redhat.com>

replace "unhandled error code" message in scsi_io_completion default
host-byte condition with a descriptive message of what the host-byte
indicates.  The descriptive messages for the host bytes were derived
from the corresponding comments for the DID_HOST_ definitions in scsi.h.

Also softened the corresponding default sense code message.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/constants.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_lib.c  |    4 ++--
 include/scsi/scsi_dbg.h  |    1 +
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 450e011..900333c 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1422,9 +1422,52 @@ static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
-"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST" };
+"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
+"DID_NEXUS_FAILURE" };
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
+/*
+ * derived from comments following 'Host byte codes' in scsi.h
+ */
+static char *hostbyte_table_ext_msg[] = {
+	"No Error",
+	"Couldn't connect before timeout period",
+	"Bus stayed busy through timeout period",
+	"Timed out for other reason",
+	"Bad target",
+	"Abort for some other reason",
+	"Parity Error",
+	"Internal Error",
+	"Reset",
+	"Interrupt that is not expected",
+	"Force command past mid-layer",
+	"Low level driver requests a retry",
+	"Retry immediately, don't decrement retry count",
+	"Requeue command, not immediate, don't decrement retry count",
+	"Transport disrupted, driver blocked port to recover link, transport class will retry or fail the IO",
+	"Transport class fastfailed the IO",
+	"Permanent target failure, don't retry other paths",
+	"Permanent nexus failure, retry on other paths may yield different results"
+};
+#define NUM_HOSTBYTE_EXT_MSG_STRS ARRAY_SIZE(hostbyte_table_ext_msg)
+
+#endif
+
+char *
+scsi_ext_host_byte_msg(unsigned char index)
+{
+#ifdef CONFIG_SCSI_CONSTANTS
+	if (index < NUM_HOSTBYTE_EXT_MSG_STRS)
+		return hostbyte_table_ext_msg[index];
+	else
+		return NULL;
+#else
+	return NULL;
+#endif
+}
+EXPORT_SYMBOL(scsi_ext_host_byte_msg);
+
+#ifdef CONFIG_SCSI_CONSTANTS
 static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc3f168..8e17824 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -920,12 +920,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
+			description = "Default sense code handling";
 			action = ACTION_FAIL;
 			break;
 		}
 	} else {
-		description = "Unhandled error code";
+		description = scsi_ext_host_byte_msg(host_byte(result));
 		action = ACTION_FAIL;
 	}
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index e89844c..61f3ee2 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -15,6 +15,7 @@ extern void scsi_print_sense(char *, struct scsi_cmnd *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
+extern char *scsi_ext_host_byte_msg(unsigned char);
 extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern void scsi_print_status(unsigned char);
-- 
1.7.4.2

