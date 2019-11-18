Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C661DC432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 17:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9318E21D7A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 17:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfKRRtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 12:49:18 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42410 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfKRRtR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 12:49:17 -0500
Received: by mail-pf1-f194.google.com with SMTP id s5so10721522pfh.9
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 09:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MkRqVTvzRw3994vsh9VAMDm8kV9advJ/c8aIWpeCW4=;
        b=jWyXCnWTh0p0KvgMtC5En0yBNo/nwViS1B6PSuc+qfuiPVb5QS9G2JxQea4w7DllG4
         BLGsRzzfMoyR4PyLbS8hTXx/OT2U7a23bgHeQiqGmpBX2EDtDhublA2IFaqI//Nohf/Y
         0TTqyQBM3rDzvQHp8CwVHeJ2CPwdAYuvP7hu7hVcl1HxUlrtdqq79Yguf2thL/+G+Lw0
         WuLjTcBTC8YVK0t6GZyVWW1HrDZX3vB1CwFVnuYUxP3h+kCHjbiMcFumO6XUmyuQIWHE
         MwFB96mPjRRwd2dP/+59+X/Ywztwuw0/VsJK9JRyZGusEfAHeNXUqgsq9LvgWjiWMU9e
         o9bw==
X-Gm-Message-State: APjAAAUx0vxQYNrByXef9dDqwMjozUmkzItEPC0B2MrfR+jpdVHb3/Us
        jgwNr2KzT3BAHJCPaeD/vyvqS2oS
X-Google-Smtp-Source: APXvYqx7u6Z1u/jeJteNI+F4WfB9vGl0PSzjm86TxA/cO5MBMtSjHUDcP1qTWBbQ/7NQfbFEfQx9lQ==
X-Received: by 2002:a63:d70e:: with SMTP id d14mr589366pgg.10.1574099356775;
        Mon, 18 Nov 2019 09:49:16 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w5sm23154166pfd.31.2019.11.18.09.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 09:49:15 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
To:     cang@codeaurora.org
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
 <425c127b-d8f9-0a96-64c1-4c9862ca5f43@acm.org>
 <0101016e7ca0e791-30050d63-c260-4cc3-a12b-658b7aa70031-000000@us-west-2.amazonses.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <beab3391-a86a-fb8f-0f10-e3bfcd1211d2@acm.org>
Date:   Mon, 18 Nov 2019 09:49:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0101016e7ca0e791-30050d63-c260-4cc3-a12b-658b7aa70031-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/19 7:49 PM, cang@codeaurora.org wrote:
> After this point, dev commands can be sent on hba->cmd_queue.
> But there are multiple entries which users can send dev commands through in ufs-sysfs.c.
> So the clock scaling sequence lost its protection from being disturbed.

Hi Can,

My understanding of the current implementation (Martin's 5.5/scsi-queue branch)
is that hba->clk_scaling_lock serializes clock scaling and submission of SCSI
and device commands but not the submission of TMFs. I think that the following
call chain allows user space to submit TMFs while clock scaling is in progress:

submit UPIU_TRANSACTION_TASK_REQ on an UFS BSG queue
-> ufs_bsg_request()
   -> ufshcd_exec_raw_upiu_cmd(msgcode = UPIU_TRANSACTION_TASK_REQ)
     -> ufshcd_exec_raw_upiu_cmd()
       -> __ufshcd_issue_tm_cmd()

Is that a feature or is that rather unintended behavior?

Anyway, can you have a look at the patch below and verify whether it preserves
existing behavior?

Thank you,

Bart.


Subject: [PATCH] ufs: Simplify the clock scaling mechanism implementation

Scaling the clock is only safe while no commands are in progress. The
current clock scaling implementation uses hba->clk_scaling_lock to
serialize clock scaling against the following three functions:
* ufshcd_queuecommand()          (uses sdev->request_queue)
* ufshcd_exec_dev_cmd()          (uses hba->cmd_queue)
* ufshcd_issue_devman_upiu_cmd() (uses hba->cmd_queue)

__ufshcd_issue_tm_cmd(), which uses hba->tmf_queue, is not serialized
against clock scaling.

Use blk_mq_{un,}freeze_queue() to block submission of new commands and to
wait for ongoing commands to complete. This patch removes a semaphore
down and up operation pair from the hot path.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/ufs/ufshcd.c | 116 +++++++++++---------------------------
  drivers/scsi/ufs/ufshcd.h |   1 -
  2 files changed, 34 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5314e8bfeeb6..46950cc87dc5 100644
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
@@ -1079,27 +1020,50 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)

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
+	return res;
+
+err:
+	blk_mq_unfreeze_queue(hba->cmd_queue);
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
+	blk_mq_unfreeze_queue(hba->cmd_queue);
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
  }

  /**
@@ -2394,9 +2358,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
  		BUG();
  	}

-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
  	spin_lock_irqsave(hba->host->host_lock, flags);
  	switch (hba->ufshcd_state) {
  	case UFSHCD_STATE_OPERATIONAL:
@@ -2462,7 +2423,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
  out_unlock:
  	spin_unlock_irqrestore(hba->host->host_lock, flags);
  out:
-	up_read(&hba->clk_scaling_lock);
  	return err;
  }

@@ -2616,8 +2576,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
  	struct completion wait;
  	unsigned long flags;

-	down_read(&hba->clk_scaling_lock);
-
  	/*
  	 * Get free slot, sleep if slots are unavailable.
  	 * Even though we use wait_event() which sleeps indefinitely,
@@ -2653,7 +2611,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,

  out_put_tag:
  	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
  	return err;
  }

@@ -5771,8 +5728,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
  	unsigned long flags;
  	u32 upiu_flags;

-	down_read(&hba->clk_scaling_lock);
-
  	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
  	if (IS_ERR(req))
  		return PTR_ERR(req);
@@ -5854,7 +5809,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
  	}

  	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
  	return err;
  }

@@ -8323,8 +8277,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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

