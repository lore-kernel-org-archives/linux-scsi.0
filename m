Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1947C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B3912074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uHTC/G5m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgF3VuR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgF3VuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679A6C061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:16 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 17so21010294wmo.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3wf3s9QycewPJTwSUCt+jOfGb2KgZkZQ4U15nX6SOwM=;
        b=uHTC/G5mam3Z/gQ0jdNkH5CF1OZzWLcl7v0FWXJYZXJpjiyc1S5Em2qeFKc9e0jd72
         7nILvurDq1fQGRELpxXjuZddTRmbtn6yRN7COPb1xrHIXYi1//f95BFDzBG13VPHlzOd
         cy7pCYYhSfPQiDbbV8QrE1+1XwwAa8xwM2A6M8M40BRvUciaHJ8BiUFMe8iZ6zBV3bjb
         0WjgCMBoUBQMYLzmN3Cy7rL9XHB3ISU3H229X+6Wxjb0umpPrS0Ew2NeiQIDHjexkVt2
         QR1sTOJaJ1gRm5SL32lQ7+JYYPWnCDTIowddQOEauEr+Y7P/sOA2PsWWuJj991Acjw8I
         wVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3wf3s9QycewPJTwSUCt+jOfGb2KgZkZQ4U15nX6SOwM=;
        b=ohXHBR97s9g9V5DL9Gj5yqi5ugcIB0kmaiZ84EaaUcE4y9wcRLs1EaN+MpL54zjuBL
         qQVNecovC2Pq8SxVzDIQ8/mwjI3PRfCCY3WRgHjMWIrgQHEoKK3AeIIwzKXEFUb3T4UE
         iuUKvIDnR2RJBX/qraBiSW/m5eWA3Sde7o7qoQf8s4goDqUpmbtHvsC756mzx+FIgqrS
         d1iXb/IbtQgb+ShyUAH3zUAoqYtmKFHRX8zbkoOtaZj1MzvATyGPTGZa4YUQvnTZncyz
         kPXgWMtXEPQsts820CFw/xwoJQCSu1Wlhh/H3w9gxW2zrbkaWD0hEBa0kvk86WeMR9Bw
         8Tkg==
X-Gm-Message-State: AOAM530lprGN3j3uvHrjQmu6mYYTBXxrXYTy9AoKSgtUBZ+Jsolmgy73
        YFUyQZRwORy7ucfKxZIlXZGw+niH
X-Google-Smtp-Source: ABdhPJzrUQ2sTQMV/N/5V7IKj2p37TXr7s/UPzSueQRl+y8ioBWPlXeir2+LOYgc+WrCJcn9Sg7zfw==
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr23090347wmh.176.1593553813894;
        Tue, 30 Jun 2020 14:50:13 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/14] lpfc: Fix missing MDS functionality
Date:   Tue, 30 Jun 2020 14:49:49 -0700
Message-Id: <20200630215001.70793-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Visual code inspection of the MDS implementation revealed two errors in
the driver:
- The set features Feature Code had an incorrect value
- The routine that classifies command type for cmd completions was missing
  the Send Frame definition. Send Frame is used for MDS driver loopback.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 6dfff0376547..b8d3144a452d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3531,7 +3531,7 @@ struct lpfc_sli4_parameters {
 };
 
 #define LPFC_SET_UE_RECOVERY		0x10
-#define LPFC_SET_MDS_DIAGS		0x11
+#define LPFC_SET_MDS_DIAGS		0x12
 #define LPFC_SET_DUAL_DUMP		0x1e
 struct lpfc_mbx_set_feature {
 	struct mbox_header header;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 25653baba367..1575fccc8b0c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1491,6 +1491,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 	case DSSCMD_IWRITE64_CX:
 	case DSSCMD_IREAD64_CR:
 	case DSSCMD_IREAD64_CX:
+	case CMD_SEND_FRAME:
 		type = LPFC_SOL_IOCB;
 		break;
 	case CMD_ABORT_XRI_CN:
-- 
2.25.0

