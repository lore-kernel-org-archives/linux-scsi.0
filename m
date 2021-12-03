Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7A4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383446AbhLCXZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:25:11 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:36658 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383434AbhLCXZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:25:10 -0500
Received: by mail-pf1-f181.google.com with SMTP id n26so4290190pff.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fQ0LbTq+9BDFFCnw0ZkvGkte2ZOCS6MD5p1A6DrPDvg=;
        b=i8OoaC33MCyS55XJfbAVMQXi5j4RPx2O+P81xLPizQaEoMy17ejt907atmLWGAwrhd
         np/5ci2oaiIYCp2y+ZhjhuOFaSY2rohnOKOJ1mf5hZVIOooAECgGZgHhrg1hy0X/HLH7
         DNwl56I2UnWlTKAZAb6G1mA5gUebVakIqFRE+cX0eP4aBBLY5Ub9LdlSWnFlhCp3RsmM
         9sF8YzlBFA9GUXRSpmnmh6KW9FNLhbR986wEdB7sodbkWqjwMMuka5O+HlJeLNId3LF4
         TF2F6D4SNvSxYJhSw+5zWc64chwCQRcmEKU4t0SRohaCCpvr/SRC7BACSMc3jStSHALz
         e78g==
X-Gm-Message-State: AOAM532p9g6O5TRjdf0yAln1DtQORuO44Ep9SUuvzx2m+zPTQSGc2TWd
        SFq1nTEFbQ3nBj8iwUWmiHk=
X-Google-Smtp-Source: ABdhPJy+bj8iG9122p5mP0VJGh6eBHDk9JldnE2P4XZcLJRUW7T2KCTRrkMlfKa4Y0WHeGAipeGkEw==
X-Received: by 2002:a05:6a00:2182:b0:4a7:ec46:29da with SMTP id h2-20020a056a00218200b004a7ec4629damr21586251pfi.68.1638573705717;
        Fri, 03 Dec 2021 15:21:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v4 16/17] scsi: ufs: Optimize the command queueing code
Date:   Fri,  3 Dec 2021 15:19:49 -0800
Message-Id: <20211203231950.193369-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the clock scaling lock from ufshcd_queuecommand() since it is a
performance bottleneck. Instead check the SCSI device budget bitmaps in
the code that waits for ongoing ufshcd_queuecommand() calls. A bit is
set in sdev->budget_map just before scsi_queue_rq() is called and a bit
is cleared from that bitmap if scsi_queue_rq() does not submit the
request or after the request has finished. See also the
blk_mq_{get,put}_dispatch_budget() calls in the block layer.

There is no risk for a livelock since the block layer delays queue
reruns if queueing a request fails because the SCSI host has been
blocked.

Cc: Asutosh Das (asd) <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9f0a1f637030..650dddf960c2 100644
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
+	u32 pending = 0;
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
index 8e942762e668..88c20f3608c2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -778,6 +778,7 @@ struct ufs_hba_monitor {
  * @clk_list_head: UFS host controller clocks list node head
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
+ * @clk_scaling_lock: used to serialize device commands and clock scaling
  * @desc_size: descriptor sizes reported by device
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
