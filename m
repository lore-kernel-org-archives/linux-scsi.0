From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI command
Date: Mon, 24 Oct 2016 01:20:15 -0200
Message-ID: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44585 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756464AbcJXDUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Oct 2016 23:20:30 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9O3JCrV091857
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2016 23:20:29 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2692cawwjw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2016 23:20:29 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Mon, 24 Oct 2016 01:20:27 -0200
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id 3D107352005C
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2016 23:19:58 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9O3KOHk25690518
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 01:20:24 -0200
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
        by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9O3KOG1000938
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 01:20:24 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, gabriel@krisman.be, brking@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

James,

I fixed the things you pointed out on the previous review.  As
discussed, I didn't change the code to reuse the request yet.  We can
follow up on that later.

Thanks,

>8

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

Link: https://patchwork.kernel.org/patch/9336763/
Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c71344aebdbb..4f6a91d6ee34 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -163,6 +163,16 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
 	__scsi_queue_insert(cmd, reason, 1);
 }
+
+static inline bool scsi_sense_unit_attention(const char *sense)
+{
+	int resp = sense[0] & 0x7f;
+
+	return ((resp & 0x70) &&
+		((resp >= 0x72 && (sense[1] & 0xf) == UNIT_ATTENTION) ||
+		 (resp < 0x72 && (sense[2] & 0xf) == UNIT_ATTENTION)));
+}
+
 /**
  * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
@@ -187,7 +197,14 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct request *req;
 	int write = (data_direction == DMA_TO_DEVICE);
 	int ret = DRIVER_ERROR << 24;
+	unsigned char sense_buf[SCSI_SENSE_BUFFERSIZE];
 
+	if (!sense) {
+		sense = sense_buf;
+		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
+	}
+
+ retry:
 	req = blk_get_request(sdev->request_queue, write, __GFP_RECLAIM);
 	if (IS_ERR(req))
 		return ret;
@@ -210,6 +227,13 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 */
 	blk_execute_rq(req->q, NULL, req, 1);
 
+	if (scsi_sense_unit_attention(sense) && req->retries > 0) {
+		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
+		retries = req->retries - 1;
+		blk_put_request(req);
+		goto retry;
+	}
+
 	/*
 	 * Some devices (USB mass-storage in particular) may transfer
 	 * garbage data together with a residue indicating that the data
-- 
2.7.4

