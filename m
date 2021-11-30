Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D977DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345217AbhK3Xi0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:38:26 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:39834 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345130AbhK3XiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:38:23 -0500
Received: by mail-pf1-f177.google.com with SMTP id i12so22269897pfd.6
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:35:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CnZqmy35APeBK43FDLtAn48H00//bAqCefvaRW8D3WU=;
        b=XQMvtC3GC/52bW3nY8Q7Xqdu9qymJtI4w+uYdQO3szE3x6StH0m3UTm2vrR7Rs8Hk4
         4nRn0KC6rF7MmI6i9odLTXp5tMgKU7U/Ymfkypzz8Sx1zJQBjh5slYX5o0j9tn2Bf3hM
         1s+5ApmAa0qKkZaeP1bAGIKJqKT+kFBZmtP1c5hL9po6cGksbsewk+yJ8SvdHT5JjxMB
         Eaofn8+e9tm7aNEAva0osTUBCjjFhohKb3aH/I0/7/4uXaQV32x53FCIh6kn5ccDr4Dw
         WwOfVCnDamF36VPD8MZbs/j9LuzjmcOJFX5FLQR7Vg04XwG75HlBUrCoEx4N8mb1vujk
         HdkQ==
X-Gm-Message-State: AOAM532raD52EqHZ0ZcZixXmpGd1+VO0f6qhS+MkCwxDpnRqQJN3qt1Z
        vgpXpx6v1nL4Vaz+/LIJgYuAPAXRGec=
X-Google-Smtp-Source: ABdhPJwIdqafhnckBJbw/zfEo2ssqd/JzpZuXProVRI/dIMO0MZGvMGpMnyqULpL9n0ImJqeErmlDg==
X-Received: by 2002:a63:24c4:: with SMTP id k187mr1877766pgk.554.1638315303274;
        Tue, 30 Nov 2021 15:35:03 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:35:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 16/17] scsi: ufs: Optimize the command queueing code
Date:   Tue, 30 Nov 2021 15:33:23 -0800
Message-Id: <20211130233324.1402448-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the clock scaling lock from ufshcd_queuecommand() since it is a
performance bottleneck. Instead, use synchronize_rcu_expedited() to wait
for ongoing ufshcd_queuecommand() calls.

Cc: Asutosh Das (asd) <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c4cf5c4b4893..3e4c62c6f9d2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1196,6 +1196,13 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	/* let's not get into low power until clock scaling is completed */
 	ufshcd_hold(hba, false);
 
+	/*
+	 * Wait for ongoing ufshcd_queuecommand() calls. Calling
+	 * synchronize_rcu_expedited() instead of synchronize_rcu() reduces the
+	 * waiting time from milliseconds to microseconds.
+	 */
+	synchronize_rcu_expedited();
+
 out:
 	return ret;
 }
@@ -2681,9 +2688,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	/*
 	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
 	 * calls.
@@ -2772,8 +2776,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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
