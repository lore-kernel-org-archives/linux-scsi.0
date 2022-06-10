Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3520DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 23:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240550AbiFJX3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 19:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiFJX3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 19:29:43 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2531C289707
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 16:29:40 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id y196so726985pfb.6
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 16:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6l+R6OqUDBjq3stM+ZNacKUllsAPIf7GsOoYWPsQHn8=;
        b=FW+hhMSeWpMdPv/LfHZxuXBATpgwoPvSDUmIMXnAASsdHp+tujDXau+FciKky9T+4/
         RVJIzHcgPwVTz+hunIVPyIV0wJGRktO08NhLilBqDoUEQevUpodPgiomC0DQlZaOA7ui
         LZVVHBtB77/MsdaQH5ESlU3M42O8zDsOeYSbMe1v2PtdMljSi47paHc5g0Mgo/oaJJ4m
         J8JuCzdPk0GqITzodvP0HZkmog9K6EaowXaem02zxwDTK71ZowZzlo/mQd7uwj78OTB2
         +/1DJOjEoDIW9lPrIxT1t4TNfYWeu6xBkBt9zz6OtNkGRpoM86QPxppZ3HbvQtsojeHV
         sCCQ==
X-Gm-Message-State: AOAM532U7Kodi+0fJOyyjYO4O/gD0vK+YVeiDLu51t9ke1gfUgWUbrXG
        0QIAB+kqkiHS0dTLFIrLsFc=
X-Google-Smtp-Source: ABdhPJxT6L+FWS1MtsCcPGyEZB7LgZSadhuVqWOycT74jdr+RWo17W03RHEX0b8AauZpbJ1JfHP13Q==
X-Received: by 2002:a05:6a00:1a91:b0:51c:2fab:7340 with SMTP id e17-20020a056a001a9100b0051c2fab7340mr24369967pfv.74.1654903779454;
        Fri, 10 Jun 2022 16:29:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9eb7:13f0:a1e0:550e])
        by smtp.gmail.com with ESMTPSA id ix13-20020a170902f80d00b0016160b33319sm243158plb.246.2022.06.10.16.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 16:29:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: ufs: Fix a race between the interrupt handler and the reset handler
Date:   Fri, 10 Jun 2022 16:29:15 -0700
Message-Id: <20220610232915.2916712-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prevent that both the interrupt handler and the reset handler try to
complete a request at the same time. This patch is the result of the
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
 drivers/scsi/ufs/ufshcd.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1fb3a8b9b03e..279691ff3562 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6966,6 +6966,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
  */
 static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
+	unsigned long flags, completed_reqs = 0;
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	u32 pos;
@@ -6984,13 +6985,18 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	}
 
 	/* clear the commands that were pending for corresponding LUN */
-	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lun) {
-			err = ufshcd_clear_cmd(hba, pos);
-			if (err)
-				break;
-			__ufshcd_transfer_req_compl(hba, 1U << pos);
-		}
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs)
+		if (hba->lrb[pos].lun == lun)
+			__set_bit(pos, &completed_reqs);
+	hba->outstanding_reqs &= ~completed_reqs;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	for_each_set_bit(pos, &completed_reqs, hba->nutrs) {
+		err = ufshcd_clear_cmd(hba, pos);
+		if (err)
+			break;
+		__ufshcd_transfer_req_compl(hba, 1U << pos);
 	}
 
 out:
