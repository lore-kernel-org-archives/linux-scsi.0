Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4227BC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 16:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CFE020730
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 16:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfKOQXh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 11:23:37 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44011 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfKOQXh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 11:23:37 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so6903485pfb.10
        for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2019 08:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+d2VGEguVJl5B+o01nWWdhM4WJwGnoYJbJ9Dl2USdM=;
        b=scYdlGidf7faN4HMjZ4GItO/blbUlrkJkPryBEq/hU4lnppTTEU4dB/lwZky3F68nz
         Mpn4GtQurW4RNH59jEJ0yuTL+zUh1roWRoUaA/uGk3NYoTfMIiOrn3T3t9MAxwLBCRP0
         76K0gb2Iah9ldcG2nXLpxu0Sxq2oEeIhy8Wo11xBiFevAR/tpBKvJdCPHiUd4ucQjXkH
         28zM68zNTzlydq8F1dhyJ6LaUwGWrakzspzrHDPAFioSpr4jqr3M7ODfaOBD4e+god9X
         BZ2TOwfwovV6ECtlrT2iy6P/VNL9Nq+BwPuxfnox/sTszQXRbqzesw7E1cnqxt9UzmNj
         49LA==
X-Gm-Message-State: APjAAAXXCwnCJzJRwJSHdMfu4Dd5ogsi0t5mtCRg5JqwWOpOnRavhvyS
        72p1SLm+JQB1WVgiD8y/TLU=
X-Google-Smtp-Source: APXvYqz8MiErk7IEHWdxAOATDjMJHJzBXwn0FrUnag07Mvg5ls1mqqVv3Xx3crtWZd+k4dWbvAOqTQ==
X-Received: by 2002:a63:4854:: with SMTP id x20mr16762997pgk.194.1573835015085;
        Fri, 15 Nov 2019 08:23:35 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id v19sm9512242pjr.14.2019.11.15.08.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 08:23:33 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
To:     Can Guo <cang@codeaurora.org>
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>, stummala@codeaurora.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
 <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
 <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <425c127b-d8f9-0a96-64c1-4c9862ca5f43@acm.org>
Date:   Fri, 15 Nov 2019 08:23:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/19 10:01 PM, Can Guo wrote:
> After ufshcd_clock_scaling_prepare() returns(no error), all request queues are frozen. If failure
> happens(say power mode change command fails) after this point and error handler kicks off,
> we need to send dev commands(in ufshcd_probe_hba()) to bring UFS back to functionality.
> However, as the hba->cmd_queue is frozen, dev commands cannot be sent, the error handler shall fail.

Hi Can,

I think that's easy to address. How about replacing patch 4/4 with the patch below?

Thanks,

Bart.


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
  drivers/scsi/ufs/ufshcd.c | 115 +++++++++++---------------------------
  drivers/scsi/ufs/ufshcd.h |   1 -
  2 files changed, 33 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5314e8bfeeb6..343f9b746b70 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -971,65 +971,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
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
@@ -1079,27 +1020,49 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)

  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
  {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
-	int ret = 0;
+	unsigned long deadline = jiffies + HZ;
+	struct scsi_device *sdev;
+	int res = 0;
+
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
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	blk_freeze_queue_start(hba->cmd_queue);
+	blk_freeze_queue_start(hba->tmf_queue);
+	shost_for_each_device(sdev, hba->host) {
+		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0) {
+			goto err;
+		}
  	}
+	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0)
+		goto err;
+	if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0)
+		goto err;

-	return ret;
+out:
+	blk_mq_unfreeze_queue(hba->tmf_queue);
+	blk_mq_unfreeze_queue(hba->cmd_queue);
+	return res;
+
+err:
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	res = -ETIMEDOUT;
+	goto out;
  }

  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
  {
-	up_write(&hba->clk_scaling_lock);
-	ufshcd_scsi_unblock_requests(hba);
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
  }

  /**
@@ -2394,9 +2357,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
  		BUG();
  	}

-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
  	spin_lock_irqsave(hba->host->host_lock, flags);
  	switch (hba->ufshcd_state) {
  	case UFSHCD_STATE_OPERATIONAL:
@@ -2462,7 +2422,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
  out_unlock:
  	spin_unlock_irqrestore(hba->host->host_lock, flags);
  out:
-	up_read(&hba->clk_scaling_lock);
  	return err;
  }

@@ -2616,8 +2575,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
  	struct completion wait;
  	unsigned long flags;

-	down_read(&hba->clk_scaling_lock);
-
  	/*
  	 * Get free slot, sleep if slots are unavailable.
  	 * Even though we use wait_event() which sleeps indefinitely,
@@ -2653,7 +2610,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,

  out_put_tag:
  	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
  	return err;
  }

@@ -5771,8 +5727,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
  	unsigned long flags;
  	u32 upiu_flags;

-	down_read(&hba->clk_scaling_lock);
-
  	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
  	if (IS_ERR(req))
  		return PTR_ERR(req);
@@ -5854,7 +5808,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
  	}

  	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
  	return err;
  }

@@ -8323,8 +8276,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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

