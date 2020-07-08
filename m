Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A60BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286152078D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LlEuIaQu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgGHMCt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbgGHMCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:48 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00875C08E81A
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:48 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z13so48673021wrw.5
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gWJPxbY7PTu5jz1j2WvOZoYFlTAfYyf+i8sx4XKlA9Q=;
        b=LlEuIaQuyQtrD8o+C30o/JtGeWeUsbO/txVU+A6LYz63IfG9R93qINSLBUmVyZvT2U
         98bMPE8qF6hGv0pP16N3AKpuQrg/IZLSD2KwCZt18PPYtVp3G4iUBLsgI1dM3oWRe5ZR
         KyqTPJen03y7ssLSdaSFBg4O45HqvmY1X2qVlbfGTr7RMdhoKAc4fJ1Bz2Pik4kXtO0R
         VAEBah5CGh4GXJSueVHxYQRPFd2G5wCWL/Nv95H5us/2U1NYiSxKFKJvBW2L6G5FoEz1
         5yxFmy5tgLsjt+3sT0HOZ7GjvNGB0EdZfeSc3nlDxFwopJ6+W2Coc0aT9utnaV2rzyGH
         oL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gWJPxbY7PTu5jz1j2WvOZoYFlTAfYyf+i8sx4XKlA9Q=;
        b=oOT8WN0VQTqjrQmZy5dYphNgmnpwROYuJCMR0zd0NrwETVlPtz+eY8xlvPdsKeWgjE
         9FyQuaENfto7mlj0VYqbzKBx+xqfGsgVu8qVg0x2IoPZP9CbhtmGcaCXWjd+JTwXYLbH
         12g/QXdk/3b0MQ0l5kLMYgaVaRMXTsYlaKkmksAUot7UcDcTVlwiHvXKBxIgXiyBoNE7
         QKENoqe/kNOQMT9JdXcDfP0GnGDd8wSVZubG903+nIrRR+90z7ElAkLWMw6JmSY/8V1/
         1xNrjGclBpxdV9ifSMWwULgHnjqEklIsmW/smo5cc6gk+duh1PRYyTybT/q/Z95BHgz4
         QErw==
X-Gm-Message-State: AOAM533177GMgnszPUswbMNyiqVvhaeFuyQiWaiLQoTqXSE2V8yZ6xeh
        CwGR5OjeeLBZwt/5rgW12eZF5RPOSEQ=
X-Google-Smtp-Source: ABdhPJyoBWDur01GN3OGpWdPl+zjI7B005D70HmJyRtXG+8lIHhWFF5UJGc9jIyLm/qIhJzG+PFwkw==
X-Received: by 2002:adf:c404:: with SMTP id v4mr55879971wrf.85.1594209766662;
        Wed, 08 Jul 2020 05:02:46 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:45 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, support@areca.com.tw
Subject: [PATCH 15/30] scsi: arcmsr: arcmsr_hba: Remove some set but unused variables
Date:   Wed,  8 Jul 2020 13:02:06 +0100
Message-Id: <20200708120221.3386672-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/arcmsr/arcmsr_hba.c: In function ‘arcmsr_remap_pciregion’:
 drivers/scsi/arcmsr/arcmsr_hba.c:286:30: warning: variable ‘flags’ set but not used [-Wunused-but-set-variable]
 286 | unsigned long addr, range, flags;
 | ^~~~~
 drivers/scsi/arcmsr/arcmsr_hba.c: In function ‘arcmsr_suspend’:
 drivers/scsi/arcmsr/arcmsr_hba.c:1070:11: warning: variable ‘intmask_org’ set but not used [-Wunused-but-set-variable]
 1070 | uint32_t intmask_org;
 | ^~~~~~~~~~~
 drivers/scsi/arcmsr/arcmsr_hba.c: In function ‘arcmsr_done4abort_postqueue’:
 drivers/scsi/arcmsr/arcmsr_hba.c:1410:29: warning: variable ‘cdb_phy_hipart’ set but not used [-Wunused-but-set-variable]
 1410 | unsigned long ccb_cdb_phy, cdb_phy_hipart;
 | ^~~~~~~~~~~~~~
 drivers/scsi/arcmsr/arcmsr_hba.c: In function ‘arcmsr_hbaD_postqueue_isr’:
 drivers/scsi/arcmsr/arcmsr_hba.c:2448:36: warning: variable ‘cdb_phy_hipart’ set but not used [-Wunused-but-set-variable]
 2448 | unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
 | ^~~~~~~~~~~~~~
 drivers/scsi/arcmsr/arcmsr_hba.c: In function ‘arcmsr_hbaD_polling_ccbdone’:
 drivers/scsi/arcmsr/arcmsr_hba.c:3498:36: warning: variable ‘cdb_phy_hipart’ set but not used [-Wunused-but-set-variable]
 3498 | unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
 | ^~~~~~~~~~~~~~

Cc: support@areca.com.tw
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 30914c8f29cc2..1c252934409c7 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -283,11 +283,10 @@ static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
 	}
 	case ACB_ADAPTER_TYPE_D: {
 		void __iomem *mem_base0;
-		unsigned long addr, range, flags;
+		unsigned long addr, range;
 
 		addr = (unsigned long)pci_resource_start(pdev, 0);
 		range = pci_resource_len(pdev, 0);
-		flags = pci_resource_flags(pdev, 0);
 		mem_base0 = ioremap(addr, range);
 		if (!mem_base0) {
 			pr_notice("arcmsr%d: memory mapping region fail\n",
@@ -1067,12 +1066,11 @@ static void arcmsr_free_irq(struct pci_dev *pdev,
 
 static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	uint32_t intmask_org;
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
 
-	intmask_org = arcmsr_disable_outbound_ints(acb);
+	arcmsr_disable_outbound_ints(acb);
 	arcmsr_free_irq(pdev, acb);
 	del_timer_sync(&acb->eternal_timer);
 	if (set_date_time)
@@ -1407,7 +1405,7 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 	struct ARCMSR_CDB *pARCMSR_CDB;
 	bool error;
 	struct CommandControlBlock *pCCB;
-	unsigned long ccb_cdb_phy, cdb_phy_hipart;
+	unsigned long ccb_cdb_phy;
 
 	switch (acb->adapter_type) {
 
@@ -1489,8 +1487,7 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 					((toggle ^ 0x4000) + 1);
 				doneq_index = pmu->doneq_index;
 				spin_unlock_irqrestore(&acb->doneq_lock, flags);
-				cdb_phy_hipart = pmu->done_qbuffer[doneq_index &
-					0xFFF].addressHigh;
+				pmu->done_qbuffer[doneq_index & 0xFFF].addressHigh;
 				addressLow = pmu->done_qbuffer[doneq_index &
 					0xFFF].addressLow;
 				ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
@@ -2445,7 +2442,7 @@ static void arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
 	struct MessageUnit_D  *pmu;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	struct CommandControlBlock *ccb;
-	unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
+	unsigned long flags, ccb_cdb_phy;
 
 	spin_lock_irqsave(&acb->doneq_lock, flags);
 	pmu = acb->pmuD;
@@ -2459,8 +2456,7 @@ static void arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
 			pmu->doneq_index = index_stripped ? (index_stripped | toggle) :
 				((toggle ^ 0x4000) + 1);
 			doneq_index = pmu->doneq_index;
-			cdb_phy_hipart = pmu->done_qbuffer[doneq_index &
-				0xFFF].addressHigh;
+			pmu->done_qbuffer[doneq_index & 0xFFF].addressHigh;
 			addressLow = pmu->done_qbuffer[doneq_index &
 				0xFFF].addressLow;
 			ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
@@ -3495,7 +3491,7 @@ static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
 	bool error;
 	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb;
 	int rtn, doneq_index, index_stripped, outbound_write_pointer, toggle;
-	unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
+	unsigned long flags, ccb_cdb_phy;
 	struct ARCMSR_CDB *arcmsr_cdb;
 	struct CommandControlBlock *pCCB;
 	struct MessageUnit_D *pmu = acb->pmuD;
@@ -3527,8 +3523,7 @@ static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
 				((toggle ^ 0x4000) + 1);
 		doneq_index = pmu->doneq_index;
 		spin_unlock_irqrestore(&acb->doneq_lock, flags);
-		cdb_phy_hipart = pmu->done_qbuffer[doneq_index &
-				0xFFF].addressHigh;
+		pmu->done_qbuffer[doneq_index & 0xFFF].addressHigh;
 		flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 		if (acb->cdb_phyadd_hipart)
-- 
2.25.1

