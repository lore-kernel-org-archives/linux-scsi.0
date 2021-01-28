Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F221C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA2564D9D
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhA1ESh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:18:37 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:22726 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhA1ES2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:18:28 -0500
IronPort-SDR: +1Hantmt2t8cJXJgQgpH1FLK8wvv45XYPozdeR4PYgUE1ibN7LOhk3+moEfUewwPcUWCINjpFM
 JQ627oOiFi1rdjyEBtzWAQr7Vk7D0opRKLUEgrK4H56YUFis1c5+HfIeWGL2pUpAmaKayZqSWj
 7NxP7jBAWOovoq2wlFtlPHLV69odlMs9RFlEHgjndDNdYC0VROGQcFouuowxOCQGlOkhpX+zle
 iB7NSQ4UH6+xcbTL9+HlYGcPBKA5AsB6dEH5QfnOK6aGAxEzcuJvYRj+fGME5CJFn5ImLW0xQK
 /bw=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="47715651"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 27 Jan 2021 20:17:52 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 27 Jan 2021 20:17:52 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 159E5219A2; Wed, 27 Jan 2021 20:17:52 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     jaegeuk@kernel.org, bvanassche@acm.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/3] scsi: ufs: Fix wrong Task Tag used in task management request UPIUs
Date:   Wed, 27 Jan 2021 20:16:04 -0800
Message-Id: <1611807365-35513-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs + req->tag as
the Task Tag in one TMR UPIU. Directly use req->tag as the Task Tag.

Fixes: e293313262d3 ("scsi: ufs: Fix broken task management command implementation")

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 43894a3..72fa14b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6384,38 +6384,33 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	unsigned long flags;
-	int free_slot, task_tag, err;
+	int task_tag, err;
 
 	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
+	 * blk_get_request() used here is only to get a free tag.
 	 */
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	free_slot = req->tag;
-	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
-
 	spin_lock_irqsave(host->host_lock, flags);
 	req->end_io_data = &wait;
-	task_tag = hba->nutrs + free_slot;
 	blk_mq_start_request(req);
 
+	task_tag = req->tag;
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-	memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
-	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
+	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
+	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
 	/* send command to the controller */
-	__set_bit(free_slot, &hba->outstanding_tasks);
+	__set_bit(task_tag, &hba->outstanding_tasks);
 
 	/* Make sure descriptors are ready before ringing the task doorbell */
 	wmb();
 
-	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 
@@ -6437,24 +6432,23 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-		if (ufshcd_clear_tm_cmd(hba, free_slot))
-			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
-					__func__, free_slot);
+		if (ufshcd_clear_tm_cmd(hba, task_tag)) {
+			dev_WARN(hba->dev, "%s: unable to clear tm cmd (slot %d) after timeout\n",
+					__func__, task_tag);
+		} else {
+			__clear_bit(task_tag, &hba->outstanding_tasks);
+		}
 		err = -ETIMEDOUT;
 	} else {
 		err = 0;
-		memcpy(treq, hba->utmrdl_base_addr + free_slot, sizeof(*treq));
+		memcpy(treq, hba->utmrdl_base_addr + task_tag, sizeof(*treq));
 
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_COMP);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	__clear_bit(free_slot, &hba->outstanding_tasks);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
+	ufshcd_release(hba);
 	blk_put_request(req);
 
-	ufshcd_release(hba);
 	return err;
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

