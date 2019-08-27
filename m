Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BIGNUM_EMAILS,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9603C3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 997D520656
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:27:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAX0hunp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfH0V1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 17:27:55 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44993 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0V1y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 17:27:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so155278plr.11
        for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2019 14:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BeQaHKw3ZuT2lX0C278defXCS68h8O4TAbVUH2e3kqI=;
        b=XAX0hunphpypuIEpxTNMZZr1obqw/7pzEER8VUe6i0836J++/lmEyn8KEwqNK8h8yW
         dnHnmcHqD+xTdgX0/fxPUQGg6qII3YPzbJjc0In5wQZut6uTilPFvtdtlblQWE8Su7RY
         Gw4kMtfTOZTf6EkXGK0ph1dnfX/Ntzc1TKsG9PSNDHuxK5VmYHZ8+6Iy6Cfji9aWnf2A
         pM3xfiMbF7pkdIurMooIF/RgX95LC2MHSd3ODTt0Na6c3a2VmkLs8vWdg6zjxkLMTBYK
         akybWIN0CdvP4Ods7pDktIsruITLuhWtiL0b9fWh1zRwDi9ANSPFpSaoKgaHq6WeryRg
         Uq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BeQaHKw3ZuT2lX0C278defXCS68h8O4TAbVUH2e3kqI=;
        b=q6BlkwKnKwPilQaIslRHMDtAT/Gjn7YQleoxzCEZmxLHamrjlr9BWmwbSGtYC8pVpY
         XFpInj1fb2H6z8rd1gCstm8pJ0JuNT+FKh6YIVcETF/XCjes/u7H1BrlUdYAoI6lrplM
         RHy3SfPSDqKttXyV5U7MYHzASAkPXX9vdkLIdTlwKYHbpGom2QoXlO18zR64yMuB1rqR
         KHfssyGZAR7VI+FI4rV7Rbvwb8uxL57wlvHeMvUiGaqjYn8T2UYPG2IxNB7ceQFSGCyO
         xBA4zvDa28JTy/w6zoVjZi0Yw3Ud38qlNg9qTuPELrzoeF1/YoVAjbH2q99mC2MIztLP
         beRw==
X-Gm-Message-State: APjAAAWCtX+u3vcWnbQMUl4H1tQy9v1VM74OUSUQjmcxWncN1t9plbaB
        GkYhoj8vNOwMhsYwr5+HeOoPNlCu
X-Google-Smtp-Source: APXvYqyTYXm8hnjPdWutF6wkB30STC0cbT265XHQA9ZkEmrLl4uwmZ1L3W447YVMh+XS6k9wRm8yfg==
X-Received: by 2002:a17:902:76c7:: with SMTP id j7mr960704plt.247.1566941274103;
        Tue, 27 Aug 2019 14:27:54 -0700 (PDT)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm270659pfg.102.2019.08.27.14.27.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 27 Aug 2019 14:27:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] lpfc: Resolve checker warning for lpfc_new_io_buf()
Date:   Tue, 27 Aug 2019 14:27:46 -0700
Message-Id: <20190827212746.30011-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Per Dan Carpenter:
The patch d79c9e9d4b3d: "scsi: lpfc: Support dynamic unbounded SGL
lists on G7 hardware." from Aug 14, 2019, leads to the following
static checker warning:

   drivers/scsi/lpfc/lpfc_init.c:4107 lpfc_new_io_buf()
  error: not allocating enough data 784 vs 768

There was no need to compare sizes nor to allocate size based on a
define.

Change allocation to use actual structure length

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 11 +----------
 drivers/scsi/lpfc/lpfc_sli4.h |  3 ---
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9600d1ecc518..9e83ed8ec6a6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4087,18 +4087,9 @@ lpfc_new_io_buf(struct lpfc_hba *phba, int num_to_alloc)
 	LIST_HEAD(post_nblist);
 	LIST_HEAD(nvme_nblist);
 
-	/* Sanity check to ensure our sizing is right for both SCSI and NVME */
-	if (sizeof(struct lpfc_io_buf) > LPFC_COMMON_IO_BUF_SZ) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-				"6426 Common buffer size %zd exceeds %d\n",
-				sizeof(struct lpfc_io_buf),
-				LPFC_COMMON_IO_BUF_SZ);
-		return 0;
-	}
-
 	phba->sli4_hba.io_xri_cnt = 0;
 	for (bcnt = 0; bcnt < num_to_alloc; bcnt++) {
-		lpfc_ncmd = kzalloc(LPFC_COMMON_IO_BUF_SZ, GFP_KERNEL);
+		lpfc_ncmd = kzalloc(sizeof(*lpfc_ncmd), GFP_KERNEL);
 		if (!lpfc_ncmd)
 			break;
 		/*
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index a4be83d1f37e..0d4882a9e634 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -49,9 +49,6 @@
 #define LPFC_FCP_MQ_THRESHOLD_MAX	256
 #define LPFC_FCP_MQ_THRESHOLD_DEF	8
 
-/* Common buffer size to accomidate SCSI and NVME IO buffers */
-#define LPFC_COMMON_IO_BUF_SZ	768
-
 /*
  * Provide the default FCF Record attributes used by the driver
  * when nonFIP mode is configured and there is no other default
-- 
2.13.7

