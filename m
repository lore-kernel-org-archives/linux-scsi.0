From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 11/17] scsi: ufs: add retry for query descriptors
Date: Mon, 26 Oct 2015 17:41:06 +0200
Message-ID: <1445874072-25909-12-git-send-email-ygardi@codeaurora.org>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43584 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbJZPmP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 11:42:15 -0400
In-Reply-To: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

Query commands have 100ms timeout and it may timeout if they are
issued in parallel to ongoing read/write SCSI commands, this change
adds the retry (max: 10) in case command timeouts.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 55 +++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7558047..3c5b82a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1902,21 +1902,7 @@ static int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	return ret;
 }
 
-/**
- * ufshcd_query_descriptor - API function for sending descriptor requests
- * hba: per-adapter instance
- * opcode: attribute opcode
- * idn: attribute idn to access
- * index: index field
- * selector: selector field
- * desc_buf: the buffer that contains the descriptor
- * buf_len: length parameter passed to the device
- *
- * Returns 0 for success, non-zero in case of failure.
- * The buf_len parameter will contain, on return, the length parameter
- * received on the response.
- */
-static int ufshcd_query_descriptor(struct ufs_hba *hba,
+static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
 			u8 selector, u8 *desc_buf, int *buf_len)
 {
@@ -1981,6 +1967,39 @@ out:
 }
 
 /**
+ * ufshcd_query_descriptor_retry - API function for sending descriptor
+ * requests
+ * hba: per-adapter instance
+ * opcode: attribute opcode
+ * idn: attribute idn to access
+ * index: index field
+ * selector: selector field
+ * desc_buf: the buffer that contains the descriptor
+ * buf_len: length parameter passed to the device
+ *
+ * Returns 0 for success, non-zero in case of failure.
+ * The buf_len parameter will contain, on return, the length parameter
+ * received on the response.
+ */
+int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
+			enum query_opcode opcode, enum desc_idn idn, u8 index,
+			u8 selector, u8 *desc_buf, int *buf_len)
+{
+	int err;
+	int retries;
+
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		err = __ufshcd_query_descriptor(hba, opcode, idn, index,
+						selector, desc_buf, buf_len);
+		if (!err || err == -EINVAL)
+			break;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(ufshcd_query_descriptor_retry);
+
+/**
  * ufshcd_read_desc_param - read the specified descriptor parameter
  * @hba: Pointer to adapter instance
  * @desc_id: descriptor idn value
@@ -2022,9 +2041,9 @@ static int ufshcd_read_desc_param(struct ufs_hba *hba,
 			return -ENOMEM;
 	}
 
-	ret = ufshcd_query_descriptor(hba, UPIU_QUERY_OPCODE_READ_DESC,
-				      desc_id, desc_index, 0, desc_buf,
-				      &buff_len);
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+					desc_id, desc_index, 0, desc_buf,
+					&buff_len);
 
 	if (ret || (buff_len < ufs_query_desc_max_size[desc_id]) ||
 	    (desc_buf[QUERY_DESC_LENGTH_OFFSET] !=
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
