Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2EDC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 00:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 082CC21A49
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 00:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKMA4C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 19:56:02 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34256 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKMA4C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 19:56:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id z188so189566pgb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2019 16:56:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=2O1FNFyWws46Y6hhGo0QfQJpcyfRSOs26FedOMALACg=;
        b=Wv2/OwvyXk+v8jlZbZH5oP+0Kp5kbmsHsnIanmOYS7y4unljTm6VYLyf97P/ALCqaJ
         yFKxGHAYHV/atbewwNa7BA5vOAZvPR9SvZqTM3EWwioJcRnyyg7FgAz7Ki9Z2GvFGoK0
         sxtRKr+UqYjeEuEJxyzEbtwD9y6VHiVwUuh7XzbLUniY84Dyv2Hp+YSguae6Z2k7S6Ko
         VTgqNbN0FaXl5dI8PRGwftRAhphxVSoDgM3gaIEhD1vTDCOtqxXt88WoQuUDfs6DQgIn
         Tt2On0QdtEQD55CTMLHYrGpxglJ8pNgLD3ahmzHr2BbRg0B638CRR75w3mndGjshkxVw
         Cufw==
X-Gm-Message-State: APjAAAUs0rhkM3DdNRhJ7cAcG/lGDX1QuUU+FHQH/HAFjoRSLOc10cms
        W/bOPKXfqGFapxM1HlPfVhM=
X-Google-Smtp-Source: APXvYqyVtUNdmL3xkQxkGFjMBZVGon3pOYcs2y/xqODGVMKjgqZ7YpMzPPSOl9KDtA6tRvJtHaWo/g==
X-Received: by 2002:a63:9b09:: with SMTP id r9mr494019pgd.88.1573606561358;
        Tue, 12 Nov 2019 16:56:01 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w7sm176489pfb.101.2019.11.12.16.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 16:56:00 -0800 (PST)
Subject: Re: [PATCH v5 4/4] ufs: Simplify the clock scaling mechanism
 implementation
To:     cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
Date:   Tue, 12 Nov 2019 16:55:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
Content-Type: multipart/mixed;
 boundary="------------FA0A0CE911270FBEEBEDDE48"
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------FA0A0CE911270FBEEBEDDE48
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/12/19 4:11 PM, cang@codeaurora.org wrote:
> On 2019-11-13 01:37, Bart Van Assche wrote:
>> @@ -1528,7 +1492,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>>           */
>>          /* fallthrough */
>>      case CLKS_OFF:
>> -        ufshcd_scsi_block_requests(hba);
>> +        ufshcd_block_requests(hba, ULONG_MAX);
> 
> ufshcd_hold(async == true) is used in ufshcd_queuecommand() path because
> ufshcd_queuecommand() can be entered under atomic contexts.
> Thus ufshcd_block_requests() here has the same risk causing scheduling 
> while atomic.
> FYI, it is not easy to hit above scenario in small scale of test.

Hi Bean,

How about replacing patch 4/4 with the attached patch?

Thanks,

Bart.


--------------FA0A0CE911270FBEEBEDDE48
Content-Type: text/x-patch;
 name="0001-ufs-Simplify-the-clock-scaling-mechanism-implementat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ufs-Simplify-the-clock-scaling-mechanism-implementat.pa";
 filename*1="tch"

From 112fd52ef68927ab9b19fd84765ea31aacd2d0de Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 10 Oct 2019 15:56:35 -0700
Subject: [PATCH] ufs: Simplify the clock scaling mechanism implementation

Scaling the clock is only safe while no commands are in progress. Use
blk_mq_{un,}freeze_queue() to block submission of new commands and to
wait for ongoing commands to complete. This patch removes a semaphore
down and up operation pair from the hot path.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 132 ++++++++++++++------------------------
 drivers/scsi/ufs/ufshcd.h |   1 -
 2 files changed, 48 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 99ce1d651f03..f00d665715d1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -302,6 +302,52 @@ static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
 		scsi_block_requests(hba->host);
 }
 
+static void ufshcd_unblock_requests(struct ufs_hba *hba)
+{
+	struct scsi_device *sdev;
+
+	blk_mq_unfreeze_queue(hba->tmf_queue);
+	blk_mq_unfreeze_queue(hba->cmd_queue);
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
+}
+
+static int ufshcd_block_requests(struct ufs_hba *hba, unsigned long timeout)
+{
+	struct scsi_device *sdev;
+	unsigned long deadline = jiffies + timeout;
+
+	if (timeout == ULONG_MAX) {
+		shost_for_each_device(sdev, hba->host)
+			blk_mq_freeze_queue(sdev->request_queue);
+		blk_mq_freeze_queue(hba->cmd_queue);
+		blk_mq_freeze_queue(hba->tmf_queue);
+		return 0;
+	}
+
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	blk_freeze_queue_start(hba->cmd_queue);
+	blk_freeze_queue_start(hba->tmf_queue);
+	shost_for_each_device(sdev, hba->host) {
+		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0) {
+			goto err;
+		}
+	}
+	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0)
+		goto err;
+	if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0)
+		goto err;
+	return 0;
+
+err:
+	ufshcd_unblock_requests(hba);
+	return -ETIMEDOUT;
+}
+
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		const char *str)
 {
@@ -971,65 +1017,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
 	return false;
 }
 
-static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
-					u64 wait_timeout_us)
-{
-	unsigned long flags;
-	int ret = 0;
-	u32 tm_doorbell;
-	u32 tr_doorbell;
-	bool timeout = false, do_last_check = false;
-	ktime_t start;
-
-	ufshcd_hold(hba, false);
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	/*
-	 * Wait for all the outstanding tasks/transfer requests.
-	 * Verify by checking the doorbell registers are clear.
-	 */
-	start = ktime_get();
-	do {
-		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		if (!tm_doorbell && !tr_doorbell) {
-			timeout = false;
-			break;
-		} else if (do_last_check) {
-			break;
-		}
-
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		schedule();
-		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
-		    wait_timeout_us) {
-			timeout = true;
-			/*
-			 * We might have scheduled out for long time so make
-			 * sure to check if doorbells are cleared by this time
-			 * or not.
-			 */
-			do_last_check = true;
-		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
-	} while (tm_doorbell || tr_doorbell);
-
-	if (timeout) {
-		dev_err(hba->dev,
-			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
-			__func__, tm_doorbell, tr_doorbell);
-		ret = -EBUSY;
-	}
-out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_release(hba);
-	return ret;
-}
-
 /**
  * ufshcd_scale_gear - scale up/down UFS gear
  * @hba: per adapter instance
@@ -1079,27 +1066,16 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 
 static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
-	int ret = 0;
 	/*
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
-	ufshcd_scsi_block_requests(hba);
-	down_write(&hba->clk_scaling_lock);
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
-		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
-		ufshcd_scsi_unblock_requests(hba);
-	}
-
-	return ret;
+	return ufshcd_block_requests(hba, HZ);
 }
 
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
-	up_write(&hba->clk_scaling_lock);
-	ufshcd_scsi_unblock_requests(hba);
+	ufshcd_unblock_requests(hba);
 }
 
 /**
@@ -2394,9 +2370,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -2462,7 +2435,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -2616,8 +2588,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	struct completion wait;
 	unsigned long flags;
 
-	down_read(&hba->clk_scaling_lock);
-
 	/*
 	 * Get free slot, sleep if slots are unavailable.
 	 * Even though we use wait_event() which sleeps indefinitely,
@@ -2653,7 +2623,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 out_put_tag:
 	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -5771,8 +5740,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	unsigned long flags;
 	u32 upiu_flags;
 
-	down_read(&hba->clk_scaling_lock);
-
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -5852,7 +5819,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	}
 
 	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -8321,8 +8287,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize mutex for device management commands */
 	mutex_init(&hba->dev_cmd.lock);
 
-	init_rwsem(&hba->clk_scaling_lock);
-
 	ufshcd_init_clk_gating(hba);
 
 	ufshcd_init_clk_scaling(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5865e16f53a6..5ebb920ae874 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -724,7 +724,6 @@ struct ufs_hba {
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
 
-	struct rw_semaphore clk_scaling_lock;
 	struct ufs_desc_size desc_size;
 	atomic_t scsi_block_reqs_cnt;
 

--------------FA0A0CE911270FBEEBEDDE48--
