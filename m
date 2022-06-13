Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83515C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 21:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239622AbiFMVpg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 17:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiFMVpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 17:45:24 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3456463
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:23 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id l4so5664340pgh.13
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlJQWaQtzKYLaJO2jTeTrMzOBITTjl5zGC+qrwjiNv8=;
        b=aJG3SVTv5sfpHy/LS/WGevNE+PzKJbkunqUK2jcbuB3X5n4RQH/2bdCPVXy680poA0
         bn33jIW8SJWWD6MD0tToe34lLz/itsNYaC/4dghGqDAlPToUXxVthBRy0A+Fz0TgptjN
         OpkQ6EXveRFjdkW9mV2ReGTlywV3gyhEHhqFkicMbEkZVdGR/vWlTcIclKJM9oECVLFP
         BsWtyxhLEGUBt3hpxTn/L9g/P7bbaV5N58zWADYl6KUP80xqe2HhACeLhoSNaKUmJMij
         CGnU+6iSOFpi0t/ypgqLKEPfJ1wcWfp4g+Qw2OXolNWOFtIVzcxHsl11i9/OJ2dH0wQd
         vfwg==
X-Gm-Message-State: AOAM530jXZ0UsVO3wpJGoAfNXUTjkcikkHRkeVXoqJaidAKJ9P0729tJ
        O4wBTI9tIqf6kKC6rhEU1RE=
X-Google-Smtp-Source: ABdhPJxMgl8HkMzIxO4Kh66eF6Z15nP+OhNOFpkG1cEwQzxW6Etx/rMk0HqCQDOxT3fpg92mgC5aLA==
X-Received: by 2002:a05:6a00:10d3:b0:4fe:5d:75c8 with SMTP id d19-20020a056a0010d300b004fe005d75c8mr1364549pfu.6.1655156722845;
        Mon, 13 Jun 2022 14:45:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6862:a290:1a09:5af5])
        by smtp.gmail.com with ESMTPSA id ji2-20020a170903324200b001622c377c3esm5585833plb.117.2022.06.13.14.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 14:45:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 3/3] scsi: ufs: Fix a race between the interrupt handler and the reset handler
Date:   Mon, 13 Jun 2022 14:44:42 -0700
Message-Id: <20220613214442.212466-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220613214442.212466-1-bvanassche@acm.org>
References: <20220613214442.212466-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prevent that both the interrupt handler and the reset handler try to
complete a request at the same time. This patch is the result of an
analysis of the following crash:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000120
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE     5.10.107-android13-4-00051-g1e48e8970cca-ab8664745 #1
pc : ufshcd_release_scsi_cmd+0x30/0x46c
lr : __ufshcd_transfer_req_compl+0x4fc/0x9c0
Call trace:
 ufshcd_release_scsi_cmd+0x30/0x46c
 __ufshcd_transfer_req_compl+0x4fc/0x9c0
 ufshcd_poll+0xf0/0x208
 ufshcd_sl_intr+0xb8/0xf0
 ufshcd_intr+0x168/0x2f4
 __handle_irq_event_percpu+0xa0/0x30c
 handle_irq_event+0x84/0x178
 handle_fasteoi_irq+0x150/0x2e8
 __handle_domain_irq+0x114/0x1e4
 gic_handle_irq.31846+0x58/0x300
 el1_irq+0xe4/0x1c0
 cpuidle_enter_state+0x3ac/0x8c4
 do_idle+0x2fc/0x55c
 cpu_startup_entry+0x84/0x90
 kernel_init+0x0/0x310
 start_kernel+0x0/0x608
 start_kernel+0x4ec/0x608

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b7120c5f0920..ff3abda91bb6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6975,14 +6975,14 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 }
 
 /**
- * ufshcd_eh_device_reset_handler - device reset handler registered to
- *                                    scsi layer.
+ * ufshcd_eh_device_reset_handler() - Reset a single logical unit.
  * @cmd: SCSI command pointer
  *
  * Returns SUCCESS/FAILED
  */
 static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
+	unsigned long flags, pending_reqs = 0, not_cleared = 0;
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	u32 pos;
@@ -7001,14 +7001,24 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	}
 
 	/* clear the commands that were pending for corresponding LUN */
-	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lun) {
-			err = ufshcd_clear_cmds(hba, 1U << pos);
-			if (err)
-				break;
-			__ufshcd_transfer_req_compl(hba, 1U << pos);
-		}
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs)
+		if (hba->lrb[pos].lun == lun)
+			__set_bit(pos, &pending_reqs);
+	hba->outstanding_reqs &= ~pending_reqs;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	if (ufshcd_clear_cmds(hba, pending_reqs) < 0) {
+		spin_lock_irqsave(&hba->outstanding_lock, flags);
+		not_cleared = pending_reqs &
+			ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		hba->outstanding_reqs |= not_cleared;
+		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+		dev_err(hba->dev, "%s: failed to clear requests %#lx\n",
+			__func__, not_cleared);
 	}
+	__ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared);
 
 out:
 	hba->req_abort_count = 0;
