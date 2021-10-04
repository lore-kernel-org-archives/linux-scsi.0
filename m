Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E470BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB9EB6139F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhJDML6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:11:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:5875 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbhJDMLv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 08:11:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="205532870"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="205532870"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 05:07:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="482927111"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 04 Oct 2021 05:07:16 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH RFC 5/6] scsi: ufs: Reorder dev_cmd locking
Date:   Mon,  4 Oct 2021 15:06:49 +0300
Message-Id: <20211004120650.153218-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004120650.153218-1-adrian.hunter@intel.com>
References: <20211004120650.153218-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Consolidate the locking for dev_cmd's in one new function
ufshcd_dev_cmd_lock() and reorder dev_cmd.lock mutex after
ufshcd_down_read() to pave the way to hold ufshcd_down_write() lock for the
entire error handler duration.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 69 +++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 64ac9e48c4d7..3c11a35ecba6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2908,18 +2908,14 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	int err;
 	int tag;
 
-	ufshcd_down_read(hba);
-
 	/*
 	 * Get free slot, sleep if slots are unavailable.
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by SCSI request timeout.
 	 */
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 	/* Set the timeout such that the SCSI error handler is not activated. */
@@ -2943,8 +2939,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 out:
 	blk_put_request(req);
-out_unlock:
-	ufshcd_up_read(hba);
 	return err;
 }
 
@@ -2995,6 +2989,25 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hba,
 	return ret;
 }
 
+static void ufshcd_dev_cmd_lock(struct ufs_hba *hba)
+{
+	/* Ungate while not holding other locks */
+	ufshcd_hold(hba, false);
+	ufshcd_down_read(hba);
+	/*
+	 * Take the mutex after ufshcd_down_read() to avoid deadlocking against
+	 * the owner of ufshcd_down_write().
+	 */
+	mutex_lock(&hba->dev_cmd.lock);
+}
+
+static void ufshcd_dev_cmd_unlock(struct ufs_hba *hba)
+{
+	mutex_unlock(&hba->dev_cmd.lock);
+	ufshcd_up_read(hba);
+	ufshcd_release(hba);
+}
+
 /**
  * ufshcd_query_flag() - API function for sending flag query requests
  * @hba: per-adapter instance
@@ -3015,8 +3028,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
-	mutex_lock(&hba->dev_cmd.lock);
+	ufshcd_dev_cmd_lock(hba);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
 
@@ -3058,8 +3070,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 				MASK_QUERY_UPIU_FLAG_LOC) & 0x1;
 
 out_unlock:
-	mutex_unlock(&hba->dev_cmd.lock);
-	ufshcd_release(hba);
+	ufshcd_dev_cmd_unlock(hba);
 	return err;
 }
 
@@ -3089,9 +3100,8 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		return -EINVAL;
 	}
 
-	ufshcd_hold(hba, false);
+	ufshcd_dev_cmd_lock(hba);
 
-	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
 
@@ -3121,8 +3131,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	*attr_val = be32_to_cpu(response->upiu_res.value);
 
 out_unlock:
-	mutex_unlock(&hba->dev_cmd.lock);
-	ufshcd_release(hba);
+	ufshcd_dev_cmd_unlock(hba);
 	return err;
 }
 
@@ -3185,9 +3194,8 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 		return -EINVAL;
 	}
 
-	ufshcd_hold(hba, false);
+	ufshcd_dev_cmd_lock(hba);
 
-	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
 	hba->dev_cmd.query.descriptor = desc_buf;
@@ -3220,8 +3228,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 
 out_unlock:
 	hba->dev_cmd.query.descriptor = NULL;
-	mutex_unlock(&hba->dev_cmd.lock);
-	ufshcd_release(hba);
+	ufshcd_dev_cmd_unlock(hba);
 	return err;
 }
 
@@ -4766,8 +4773,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	int err = 0;
 	int retries;
 
-	ufshcd_hold(hba, false);
-	mutex_lock(&hba->dev_cmd.lock);
+	ufshcd_dev_cmd_lock(hba);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
 					       NOP_OUT_TIMEOUT);
@@ -4777,8 +4783,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 
 		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
 	}
-	mutex_unlock(&hba->dev_cmd.lock);
-	ufshcd_release(hba);
+	ufshcd_dev_cmd_unlock(hba);
 
 	if (err)
 		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
@@ -6699,13 +6704,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	int tag;
 	u8 upiu_flags;
 
-	ufshcd_down_read(hba);
-
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
@@ -6783,8 +6784,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 out:
 	blk_put_request(req);
-out_unlock:
-	ufshcd_up_read(hba);
 	return err;
 }
 
@@ -6821,13 +6820,11 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 		cmd_type = DEV_CMD_TYPE_NOP;
 		fallthrough;
 	case UPIU_TRANSACTION_QUERY_REQ:
-		ufshcd_hold(hba, false);
-		mutex_lock(&hba->dev_cmd.lock);
+		ufshcd_dev_cmd_lock(hba);
 		err = ufshcd_issue_devman_upiu_cmd(hba, req_upiu, rsp_upiu,
 						   desc_buff, buff_len,
 						   cmd_type, desc_op);
-		mutex_unlock(&hba->dev_cmd.lock);
-		ufshcd_release(hba);
+		ufshcd_dev_cmd_unlock(hba);
 
 		break;
 	case UPIU_TRANSACTION_TASK_REQ:
-- 
2.25.1

