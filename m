Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1455EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0105D610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhKSUBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:34 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:46921 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhKSUBW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:22 -0500
Received: by mail-pf1-f170.google.com with SMTP id o4so10210817pfp.13
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkWk9sXvNAQPaDu4wVah/aJGRvG7nDNAJ/chorQDqpw=;
        b=ya/rwKBidG8b6G4kJyITcWa6VK5TVDdQHC5th24LxfGkykNtbecWp0sX9/jjchwteL
         DVQZDroiuddoqnQgLHMzovfsCtKc/dkrtuNq6d+UOjqCWkK7uoai5pTkk++kxFCGvVRq
         rd7qmvaPHZC79Y9/n0S4WQGJPWTE6I7uYd0cu0UWJDgGwZeBfsqsF7UT4LxdH9BFlr6i
         J64FG9KiQhTw1nJQm0UYPQtouFRgsiO6pH9HfP1+guk5kSsiJXt3ZxiWqvZ8KXlEj9yI
         QlE2jT0ngJ6UQWIxgk0gbCPOkxFUW/1yMMdGEHKjJ/fSsfuYFQ3zIJa7m0LkHJGEDNzx
         4jJg==
X-Gm-Message-State: AOAM533eF9b+8rILlHJ8kPLYnGuJWjMpuUBAq0dAbxfI5GbX8xRw+L8E
        0zXg54UND+ygqEwIIjs5EL8=
X-Google-Smtp-Source: ABdhPJyx/71M/Cnwxi3i3n/go98WlaW9ezNDvAAIt4guf/tBVSRM30aGvW9kafhfR3Vg5VtZsKL6PA==
X-Received: by 2002:a63:82c3:: with SMTP id w186mr10172344pgd.301.1637351899960;
        Fri, 19 Nov 2021 11:58:19 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 11/20] scsi: ufs: Switch to scsi_(get|put)_internal_cmd()
Date:   Fri, 19 Nov 2021 11:57:34 -0800
Message-Id: <20211119195743.2817-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The only functional change in this patch is the addition of a
blk_mq_start_request() call in ufshcd_issue_devman_upiu_cmd().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 46 +++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fced4528ee90..dfa5f127342b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2933,6 +2933,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 {
 	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
+	struct scsi_cmnd *scmd;
 	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err;
@@ -2945,15 +2946,18 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by SCSI request timeout.
 	 */
-	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
+	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
+	if (IS_ERR(scmd)) {
+		err = PTR_ERR(scmd);
 		goto out_unlock;
 	}
+	req = scsi_cmd_to_rq(scmd);
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
-	/* Set the timeout such that the SCSI error handler is not activated. */
-	req->timeout = msecs_to_jiffies(2 * timeout);
+	/*
+	 * Start the request such that blk_mq_tag_idle() is called when the
+	 * device management request finishes.
+	 */
 	blk_mq_start_request(req);
 
 	lrbp = &hba->lrb[tag];
@@ -2972,7 +2976,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
-	blk_mq_free_request(req);
+	scsi_put_internal_cmd(scmd);
+
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
@@ -6573,17 +6578,16 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	struct request_queue *q = hba->tmf_queue;
 	struct Scsi_Host *host = hba->host;
 	DECLARE_COMPLETION_ONSTACK(wait);
+	struct scsi_cmnd *scmd;
 	struct request *req;
 	unsigned long flags;
 	int task_tag, err;
 
-	/*
-	 * blk_mq_alloc_request() is used here only to get a free tag.
-	 */
-	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
+	if (IS_ERR(scmd))
+		return PTR_ERR(scmd);
 
+	req = scsi_cmd_to_rq(scmd);
 	req->end_io_data = &wait;
 	ufshcd_hold(hba, false);
 
@@ -6636,7 +6640,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	ufshcd_release(hba);
-	blk_mq_free_request(req);
+
+	scsi_put_internal_cmd(scmd);
 
 	return err;
 }
@@ -6714,6 +6719,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 {
 	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
+	struct scsi_cmnd *scmd;
 	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
@@ -6722,13 +6728,19 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	down_read(&hba->clk_scaling_lock);
 
-	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
+	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
+	if (IS_ERR(scmd)) {
+		err = PTR_ERR(scmd);
 		goto out_unlock;
 	}
+	req = scsi_cmd_to_rq(scmd);
 	tag = req->tag;
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	/*
+	 * Start the request such that blk_mq_tag_idle() is called when the
+	 * device management request finishes.
+	 */
+	blk_mq_start_request(req);
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
@@ -6797,6 +6809,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
+	scsi_put_internal_cmd(scmd);
+
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
