Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F033C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 18:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhLBSQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 13:16:51 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:36763 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355847AbhLBSQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 13:16:50 -0500
Received: by mail-pf1-f172.google.com with SMTP id n26so356968pff.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Dec 2021 10:13:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y/6Lx9pbndDuku49wbM5Z/PhzhjdYmV8y4hXVGoxepc=;
        b=mtWyrbg/SlfYVoT/elRUUP8yXizYysU91zax1fyOlby0YnUsFXKlx7EU2AI6VnQTk6
         h4/rb1YmZNCMzEEl2XkB3Imoe1f8rirnOS5XvcWlJJgHW4zl5wP+q4iesT56mLquhwZT
         yNsKHClRAswBMfDE8+lRoVAuoRoTSMIvuNqNNVV0ej2c29R+JprEi8zBVT/Jc9ghgNEF
         caIk1twc0rp1kye43+qRt/B9zDDONECtkMdODXT3EqFaO0aylICqL7XuYMndosD0Bncp
         J+Y9JsSm8jpg1UvGzotTObiMWkx2Ex5rnbAFR94ThEkduJ2XCW53arne0qYektizbx/i
         /ddg==
X-Gm-Message-State: AOAM531FxGroeizzQ3K/HW0lNttngzFH9rQxzTxfIFYp5YDaazG8Yr9Y
        +4F0FH+mB1soo8crChSu6wY=
X-Google-Smtp-Source: ABdhPJwJWHlNAqVAESgxqdqfzYpR94uTLoUHI3+XpUqLzOcdYqkKP3SkgLMBPc4b5O/ZEEt1tAXA+w==
X-Received: by 2002:a63:b0e:: with SMTP id 14mr587520pgl.229.1638468806839;
        Thu, 02 Dec 2021 10:13:26 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:fac5:b2eb:ef0d:f30b])
        by smtp.gmail.com with ESMTPSA id oc10sm3484052pjb.26.2021.12.02.10.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 10:13:26 -0800 (PST)
Subject: Re: [PATCH v3 16/17] scsi: ufs: Optimize the command queueing code
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-17-bvanassche@acm.org>
 <1be2859c-c698-7bfd-2ed1-ea17bbeedad7@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1be02f4a-2ab6-63fd-f6f2-3825c28ef4e5@acm.org>
Date:   Thu, 2 Dec 2021 10:13:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1be2859c-c698-7bfd-2ed1-ea17bbeedad7@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/21 3:33 PM, Asutosh Das (asd) wrote:
> Hi Bart,
> Say an IO (req1) has crossed the scsi_host_queue_ready() check but hasn't yet reached ufshcd_queuecommand() and DBR is 0.
> ufshcd_clock_scaling_prepare() is invoked and completes and scaling proceeds to change the clocks and gear.
> I wonder if the IO (req1) would be issued while scaling is in progress.
> If so, do you think a check should be added in ufshcd_queuecommand() to see if scaling is in progress or if host is blocked?

How about using the patch below instead of patch 16/17 from this patch
series? The patch below should not trigger the race condition mentioned
above.

Thanks,

Bart.


Subject: [PATCH] scsi: ufs: Optimize the command queueing code

Remove the clock scaling lock from ufshcd_queuecommand() since it is a
performance bottleneck. Instead, wait until all budget_maps have cleared
to wait for ongoing ufshcd_queuecommand() calls.

Cc: Asutosh Das (asd) <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++++++----------
  drivers/scsi/ufs/ufshcd.h |  1 +
  2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c4cf5c4b4893..be679f2a97da 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1070,13 +1070,31 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
  	return false;
  }

+/*
+ * Determine the number of pending commands by counting the bits in the SCSI
+ * device budget maps. This approach has been selected because a bit is set in
+ * the budget map before scsi_host_queue_ready() checks the host_self_blocked
+ * flag. The host_self_blocked flag can be modified by calling
+ * scsi_block_requests() or scsi_unblock_requests().
+ */
+static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
+{
+	struct scsi_device *sdev;
+	u32 pending;
+
+	shost_for_each_device(sdev, hba->host)
+		pending += sbitmap_weight(&sdev->budget_map);
+
+	return pending;
+}
+
  static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
  					u64 wait_timeout_us)
  {
  	unsigned long flags;
  	int ret = 0;
  	u32 tm_doorbell;
-	u32 tr_doorbell;
+	u32 tr_pending;
  	bool timeout = false, do_last_check = false;
  	ktime_t start;

@@ -1094,8 +1112,8 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
  		}

  		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		if (!tm_doorbell && !tr_doorbell) {
+		tr_pending = ufshcd_pending_cmds(hba);
+		if (!tm_doorbell && !tr_pending) {
  			timeout = false;
  			break;
  		} else if (do_last_check) {
@@ -1115,12 +1133,12 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
  			do_last_check = true;
  		}
  		spin_lock_irqsave(hba->host->host_lock, flags);
-	} while (tm_doorbell || tr_doorbell);
+	} while (tm_doorbell || tr_pending);

  	if (timeout) {
  		dev_err(hba->dev,
  			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
-			__func__, tm_doorbell, tr_doorbell);
+			__func__, tm_doorbell, tr_pending);
  		ret = -EBUSY;
  	}
  out:
@@ -2681,9 +2699,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)

  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);

-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
  	/*
  	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
  	 * calls.
@@ -2772,8 +2787,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
  out:
  	rcu_read_unlock();

-	up_read(&hba->clk_scaling_lock);
-
  	if (ufs_trigger_eh()) {
  		unsigned long flags;

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c3c2792f309f..411c6015bbfe 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -779,6 +779,7 @@ struct ufs_hba_monitor {
   * @clk_list_head: UFS host controller clocks list node head
   * @pwr_info: holds current power mode
   * @max_pwr_info: keeps the device max valid pwm
+ * @clk_scaling_lock: used to serialize device commands and clock scaling
   * @desc_size: descriptor sizes reported by device
   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
