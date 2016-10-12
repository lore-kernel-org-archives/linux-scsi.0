From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 1/2] scsi: Handle Unit Attention when issuing SCSI command
Date: Wed, 12 Oct 2016 02:25:20 -0300
Message-ID: <1476249921-17017-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32981 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751521AbcJLFZ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Oct 2016 01:25:58 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9C5NmF1126561
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 01:25:36 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 261dxxjnm4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 01:25:36 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Wed, 12 Oct 2016 02:25:33 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.18.232.225])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 973FC1DC006D
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 01:25:30 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9C5PUvl40239292
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 02:25:30 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9C5PUMw029473
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 02:25:30 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Usually, re-sending the SCSI command is enough to recover from a Unit
Attention (UA).  This adds a generic retry code to the SCSI command path
in case of an UA, before giving up and returning the error condition to
the caller.

I added the UA verification into scsi_execute instead of
scsi_execute_req because there are at least a few callers that invoke
scsi_execute directly and would benefit from the internal UA retry.
Also, I didn't use scsi_normalize_sense to not duplicate functionality
with scsi_execute_req_flags.  Instead, scsi_execute uses a small helper
function that verifies only the UA condition directly from the raw sense
buffer.  If this design is not OK, I can refactor to use
scsi_normalize_sense.

This prevents us from duplicating the retry code in at least a few
places.  In particular, it fixes an issue found in some IBM enclosures,
in which the device may return an Unit Attention during probe, breaking
the bind with the ses module:

scsi 1:0:7:0: Failed to get diagnostic page 0x8000002
scsi 1:0:7:0: Failed to bind enclosure -19

Finally, should we have a NORETRY_UA flag to allow callers to disable
this mechanism?

Link: https://patchwork.kernel.org/patch/9336763/
Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c    | 47 +++++++++++++++++++++++++++++++++++++++++-----
 include/scsi/scsi_common.h |  9 +++++++++
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c71344aebdbb..a4af411de2a4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -47,6 +47,9 @@ struct kmem_cache *scsi_sdb_cache;
  */
 #define SCSI_QUEUE_DELAY	3
 
+/* Maximum number of retries when a scsi command triggers an Unit Attention. */
+#define UNIT_ATTENTION_RETRIES 5
+
 static void
 scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 {
@@ -164,7 +167,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, 1);
 }
 /**
- * scsi_execute - insert request and wait for the result
+ * __scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @data_direction: data direction
@@ -179,10 +182,10 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * returns the req->errors value which is the scsi_cmnd result
  * field.
  */
-int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, int timeout, int retries, u64 flags,
-		 int *resid)
+int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+		   int data_direction, void *buffer, unsigned bufflen,
+		   unsigned char *sense, int timeout, int retries, u64 flags,
+		   int *resid)
 {
 	struct request *req;
 	int write = (data_direction == DMA_TO_DEVICE);
@@ -227,6 +230,40 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	return ret;
 }
+
+int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+		 int data_direction, void *buffer, unsigned bufflen,
+		 unsigned char *sense, int timeout, int retries, u64 flags,
+		 int *resid)
+{
+	int result;
+	int retry = UNIT_ATTENTION_RETRIES;
+	bool priv_sense = false;
+
+	if (!sense) {
+		sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+		priv_sense = true;
+		if (!sense)
+			return DRIVER_ERROR << 24;
+	}
+
+	while (retry--) {
+		result = __scsi_execute(sdev, cmd, data_direction, buffer,
+					bufflen, sense, timeout, retries,
+					flags, resid);
+
+		if (!scsi_sense_unit_attention(sense))
+			break;
+
+		if (retry)
+			memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
+	}
+
+	if (priv_sense)
+		kfree(sense);
+
+	return result;
+}
 EXPORT_SYMBOL(scsi_execute);
 
 int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 20bf7eaef05a..747b632d5b57 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -58,6 +58,15 @@ static inline bool scsi_sense_valid(const struct scsi_sense_hdr *sshdr)
 	return (sshdr->response_code & 0x70) == 0x70;
 }
 
+static inline bool scsi_sense_unit_attention(const char *sense)
+{
+	int resp = sense[0] & 0x7f;
+
+	return ((resp & 0x70) &&
+		((resp >= 0x72 && (sense[1] & 0xf) == UNIT_ATTENTION) ||
+		 (resp < 0x72 && (sense[2] & 0xf) == UNIT_ATTENTION)));
+}
+
 extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				 struct scsi_sense_hdr *sshdr);
 
-- 
2.7.4

