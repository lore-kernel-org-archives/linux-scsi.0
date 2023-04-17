Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD226C77B78
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjDQTGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDQTGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:06:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006B665A9
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b621b1dabso995665b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758362; x=1684350362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2j9J060vLAlQowpKGJFGHePq4VIe6y0ksKckHdUIZBE=;
        b=R4V1J6WH+TVeWUAFdSsmADu094z1PhtxcO9B4jEcyWD1Bp0EtFeyilV5DwjJxeTxOX
         6RDpxtPn5dLTwbOekln7ejF4pucoxmCEfeG0L9c64C3DGHbkyuwz/J7RUpAGxT9pDFaU
         OjkoCxhE6HO0evkQeoX33weNxzMJiTap89OPY/Qs87PSfdWE6U1AFHg8FAb8Qij/in3t
         yHkrQ6OaTy9MkLMavyfVLvaJqGNAkQrc4MnJ8OSd+fAkON5MkD4HelCez0B8bF6xzAJ4
         waVb/7/yKy8KgsBd5XYrcpvL8drTYaz/6/dlCn/Pp8eAjSsT3/pBDKHUc5Djj6QR10Ge
         E26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758362; x=1684350362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2j9J060vLAlQowpKGJFGHePq4VIe6y0ksKckHdUIZBE=;
        b=hAr4KmCSPE7otfg/Xq6XNEl+K7H3w79JSDE7lLV0+ey5hsEPA4zJG8xq2Ut+E8J2oc
         /7ntO7uiaWB0SXv8PNYz1HpLQbpMZ4lgmg6mPzlWCX0oW7OZYm2HmvLnAd+Ksna1GKNs
         ucVCcqqahfvYO/+/Lyb251JqyMX9MbGLUzpXlBkSsaW0/ApWEYQfqmHO/XDv9FCLnR0w
         znxncBhskwwZ4jD/vsLDTEmhOJYk3cgkf4lJMc+Jo4ymoGAuLwQ5DSH7aH3mHzwilXwN
         IACTejEsYCn2F4foa1DhtlAZZDYjYBko3kW9gFbBqH1CcQfQEUzV0Eg2Lt3EfBx7X9SJ
         7MfQ==
X-Gm-Message-State: AAQBX9fw4iERccpWH4rr5jhe9f6y78psT0iBJoIjYpRAt7O5NrcNlRUH
        u7VQDRoDUXoIrS+DREzOF4SQEKKlPOI=
X-Google-Smtp-Source: AKy350Zgf2/3h9i4nbhKfCE96PqM1v57z2j7x6RJb5m1iymssxCMwWo05kZ9r8P+v6bfutjZVHYUgQ==
X-Received: by 2002:a05:6a00:310c:b0:624:bf7e:9d8c with SMTP id bi12-20020a056a00310c00b00624bf7e9d8cmr14091152pfb.1.1681758361979;
        Mon, 17 Apr 2023 12:06:01 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.06.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:06:01 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/7] lpfc: Update congestion warning notification period
Date:   Mon, 17 Apr 2023 12:15:55 -0700
Message-Id: <20230417191558.83100-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The CMF_SYNC_WQE command is updated to use an 8 bit field sync period.  All
related variables used to calculate congestion warning notifications are
updated to 8 bit fields accordingly.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 drivers/scsi/lpfc/lpfc_crtn.h | 2 +-
 drivers/scsi/lpfc/lpfc_hw4.h  | 4 ++--
 drivers/scsi/lpfc/lpfc_sli.c  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 3863a5341782..21c7ecd3ede5 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5858,8 +5858,8 @@ int lpfc_fabric_cgn_frequency = 100; /* 100 ms default */
 module_param(lpfc_fabric_cgn_frequency, int, 0444);
 MODULE_PARM_DESC(lpfc_fabric_cgn_frequency, "Congestion signaling fabric freq");
 
-int lpfc_acqe_cgn_frequency = 10; /* 10 sec default */
-module_param(lpfc_acqe_cgn_frequency, int, 0444);
+unsigned char lpfc_acqe_cgn_frequency = 10; /* 10 sec default */
+module_param(lpfc_acqe_cgn_frequency, byte, 0444);
 MODULE_PARM_DESC(lpfc_acqe_cgn_frequency, "Congestion signaling ACQE freq");
 
 int lpfc_use_cgn_signal = 1; /* 0 - only use FPINs, 1 - Use signals if avail  */
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 0b9edde26abd..f42fb6ebe448 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -663,7 +663,7 @@ extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
 extern unsigned long lpfc_no_hba_reset[];
-extern int lpfc_acqe_cgn_frequency;
+extern unsigned char lpfc_acqe_cgn_frequency;
 extern int lpfc_fabric_cgn_frequency;
 extern int lpfc_use_cgn_signal;
 
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 58fa39c403a0..a42811682ac7 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4813,8 +4813,8 @@ struct cmf_sync_wqe {
 #define cmf_sync_cqid_WORD	word11
 	uint32_t read_bytes;
 	uint32_t word13;
-#define cmf_sync_period_SHIFT	16
-#define cmf_sync_period_MASK	0x0000ffff
+#define cmf_sync_period_SHIFT	24
+#define cmf_sync_period_MASK	0x000000ff
 #define cmf_sync_period_WORD	word13
 	uint32_t word14;
 	uint32_t word15;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8693578888f1..35b1d5d4079f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1931,7 +1931,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	unsigned long iflags;
 	u32 ret_val;
 	u32 atot, wtot, max;
-	u16 warn_sync_period = 0;
+	u8 warn_sync_period = 0;
 
 	/* First address any alarm / warning activity */
 	atot = atomic_xchg(&phba->cgn_sync_alarm_cnt, 0);
-- 
2.38.0

