Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AACC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 04:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9DDB6190A
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 04:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhCaEvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:51:24 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:35811 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhCaEu4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 00:50:56 -0400
IronPort-SDR: G8Z1kkPgRh/ZG7cEbpfQM9G+Vd+TTZHvURYevO3ckFoQU7cFpjg0O9zDzobk4UcpaAHCd6DkDK
 7iRvfi3EI1u99juwZXVrSN9W5V4VSeWCZWUQZfsxLg5UEfrOh2Yp09eWTG+7I3Hh7U0jbuJAVE
 wpioQEEtv6r3QZCL7xrharLevjgHbzbo3TYTmS2L0IDLO0HGe4BECsmVUx0fAVkFnf7C0yMAkq
 lC7xjV0ar3bwFE9Rb9GzrZGOcaVkL9Q0HxvgYiFb3wZpxf2DNsqm14VABjLMjvh9Q9dkjgcGuL
 FU0=
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="47836050"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 30 Mar 2021 21:50:57 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 30 Mar 2021 21:50:54 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3E4BF21093; Tue, 30 Mar 2021 21:50:54 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 2/2] scsi: ufs: Fix wrong Task Tag used in task management request UPIUs
Date:   Tue, 30 Mar 2021 21:50:35 -0700
Message-Id: <1617166236-39908-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617166236-39908-1-git-send-email-cang@codeaurora.org>
References: <1617166236-39908-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs + req->tag as
the Task Tag in one TMR UPIU. Directly use req->tag as the Task Tag.

Fixes: e293313262d3 ("scsi: ufs: Fix broken task management command implementation")

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d4f8cb2..cdd8c3d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6446,38 +6446,35 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	unsigned long flags;
-	int free_slot, task_tag, err;
+	int task_tag, err;
 
 	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
+	 * blk_get_request() is used here only to get a free tag.
 	 */
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
 	req->end_io_data = &wait;
-	free_slot = req->tag;
 	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
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
 
@@ -6497,24 +6494,24 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-		if (ufshcd_clear_tm_cmd(hba, free_slot))
-			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
-					__func__, free_slot);
+		if (ufshcd_clear_tm_cmd(hba, task_tag))
+			dev_WARN(hba->dev, "%s: unable to clear tm cmd (slot %d) after timeout\n",
+					__func__, task_tag);
 		err = -ETIMEDOUT;
 	} else {
 		err = 0;
-		memcpy(treq, hba->utmrdl_base_addr + free_slot, sizeof(*treq));
+		memcpy(treq, hba->utmrdl_base_addr + task_tag, sizeof(*treq));
 
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_COMP);
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	__clear_bit(free_slot, &hba->outstanding_tasks);
+	__clear_bit(task_tag, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ufshcd_release(hba);
 	blk_put_request(req);
 
-	ufshcd_release(hba);
 	return err;
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

