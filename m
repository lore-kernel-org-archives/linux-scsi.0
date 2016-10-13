From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] scsi: Handle Unit Attention when issuing SCSI command
Date: Thu, 13 Oct 2016 15:47:56 -0300
Message-ID: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32807 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754941AbcJMSsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 14:48:17 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DIicVS112612
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 14:48:06 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 262c6bccxh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 14:48:05 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Thu, 13 Oct 2016 15:48:03 -0300
Received: from d24relay04.br.ibm.com (d24relay04.br.ibm.com [9.18.232.146])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id EBD81352006C
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 14:47:34 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9DIm0Mc39977050
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:48:00 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9DIm0EK031772
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:48:00 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Hi James,

Thanks for your review.  Please see the v2 below.

> OK, so really this isn't what you want, because blk_execute_req may
> have used several of your retries, so you now get a maximum possible
> set of retries at UNIT_ATTENTION_RETRIES*retries.  You need to start
> from the returned req->retries, which probably means this loop needs to
> be inside __scsi_execute.

Hmm, I was aware of that, but I saw there were other places that may
have run retries^2 times, like scsi_test_unit_ready and scsi_mode_sense,
if I read the code correctly.  But, I see your point and I fixed it on
v2.  I also updated the second patch to rework these cases.

Another thing that got me confused is where the blk layer updates
req->retries.

What do you think about the v2 below?

Thanks,

-- >8 --

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
 drivers/scsi/scsi_lib.c    | 27 ++++++++++++++++++++++++---
 include/scsi/scsi_common.h |  9 +++++++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c71344aebdbb..9c6623abf120 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -187,15 +187,24 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct request *req;
 	int write = (data_direction == DMA_TO_DEVICE);
 	int ret = DRIVER_ERROR << 24;
+	bool priv_sense = false;
 
+	if (!sense) {
+		sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+		if (!sense)
+			return ret;
+		priv_sense = true;
+	}
+
+ retry:
 	req = blk_get_request(sdev->request_queue, write, __GFP_RECLAIM);
 	if (IS_ERR(req))
-		return ret;
+		goto free_sense;
 	blk_rq_set_block_pc(req);
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_RECLAIM))
-		goto out;
+		goto put_req;
 
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(req->cmd, cmd, req->cmd_len);
@@ -210,6 +219,13 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
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
@@ -222,9 +238,14 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (resid)
 		*resid = req->resid_len;
 	ret = req->errors;
- out:
+
+ put_req:
 	blk_put_request(req);
 
+ free_sense:
+	if (priv_sense)
+		kfree(sense);
+
 	return ret;
 }
 EXPORT_SYMBOL(scsi_execute);
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

