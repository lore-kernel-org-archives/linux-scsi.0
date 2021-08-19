Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D54C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E7A60240
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhHSJfi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:35:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:11681 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235556AbhHSJfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Aug 2021 05:35:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="213396952"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="213396952"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 02:35:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="424001675"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.174])
  by orsmga006.jf.intel.com with ESMTP; 19 Aug 2021 02:34:58 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung KLUFG8RHDA-B2D1
Date:   Thu, 19 Aug 2021 12:35:34 +0300
Message-Id: <20210819093534.17507-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Samsung KLUFG8RHDA-B2D1 does not clear the unit attention condition if the
length is zero. So go back to requesting all the sense data, as it was
before patch "scsi: ufs: Request sense data asynchronously". That is
simpler than creating and maintaining a quirk for affected devices.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a3b419848f0a..c7a130bc782d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7937,7 +7937,8 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
 {
 	if (error != BLK_STS_OK)
-		pr_err("%s: REQUEST SENSE failed (%d)", __func__, error);
+		pr_err("%s: REQUEST SENSE failed (%d)\n", __func__, error);
+	kfree(rq->end_io_data);
 	blk_put_request(rq);
 }
 
@@ -7946,22 +7947,38 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 {
 	/*
 	 * From SPC-6: the REQUEST SENSE command with any allocation length
-	 * clears the sense data.
+	 * clears the sense data, but not all UFS devices behave that way.
 	 */
-	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, 0, 0};
+	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
 	struct scsi_request *rq;
 	struct request *req;
+	char *buffer;
+	int ret;
+
+	buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, /*flags=*/0);
+	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
+			      /*flags=*/BLK_MQ_REQ_PM);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	ret = blk_rq_map_kern(sdev->request_queue, req,
+			      buffer, UFS_SENSE_SIZE, GFP_NOIO);
+	if (ret) {
+		blk_put_request(req);
+		kfree(buffer);
+		return ret;
+	}
+
 	rq = scsi_req(req);
 	rq->cmd_len = ARRAY_SIZE(cmd);
 	memcpy(rq->cmd, cmd, rq->cmd_len);
 	rq->retries = 3;
 	req->timeout = 1 * HZ;
 	req->rq_flags |= RQF_PM | RQF_QUIET;
+	req->end_io_data = buffer;
 
 	blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
 			      ufshcd_request_sense_done);
-- 
2.17.1

