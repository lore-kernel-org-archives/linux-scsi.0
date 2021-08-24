Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6AAC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 11:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECD05613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 11:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbhHXLmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 07:42:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:41495 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236786AbhHXLmQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="214168347"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="214168347"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 04:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="515378524"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.174])
  by fmsmga004.fm.intel.com with ESMTP; 24 Aug 2021 04:41:16 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH V3] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung KLUFG8RHDA-B2D1
Date:   Tue, 24 Aug 2021 14:41:50 +0300
Message-Id: <20210824114150.2105-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com>
References: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com>
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


Changes in V3:

	Fix missing buffer free.
	Correct "From" email address

Changes in V2:

	Alter comment to note the need for non-zero sense size.


 drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a3b419848f0a..3841ab49f556 100644
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
 
@@ -7945,16 +7946,30 @@ static int
 ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 {
 	/*
-	 * From SPC-6: the REQUEST SENSE command with any allocation length
-	 * clears the sense data.
+	 * Some UFS devices clear unit attention condition only if the sense
+	 * size used (UFS_SENSE_SIZE in this case) is non-zero.
 	 */
-	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, 0, 0};
+	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
 	struct scsi_request *rq;
 	struct request *req;
+	char *buffer;
+	int ret;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, /*flags=*/0);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
+			      /*flags=*/BLK_MQ_REQ_PM);
+	if (IS_ERR(req)) {
+		ret = PTR_ERR(req);
+		goto out_free;
+	}
+
+	ret = blk_rq_map_kern(sdev->request_queue, req,
+			      buffer, UFS_SENSE_SIZE, GFP_NOIO);
+	if (ret)
+		goto out_put;
 
 	rq = scsi_req(req);
 	rq->cmd_len = ARRAY_SIZE(cmd);
@@ -7962,10 +7977,17 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	rq->retries = 3;
 	req->timeout = 1 * HZ;
 	req->rq_flags |= RQF_PM | RQF_QUIET;
+	req->end_io_data = buffer;
 
 	blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
 			      ufshcd_request_sense_done);
 	return 0;
+
+out_put:
+	blk_put_request(req);
+out_free:
+	kfree(buffer);
+	return ret;
 }
 
 static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
-- 
2.17.1

