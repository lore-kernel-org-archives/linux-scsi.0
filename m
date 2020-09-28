Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAE2C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B06321531
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="qTP++3s3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgI1Kba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 06:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgI1Kba (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 06:31:30 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115E7C0613CE
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:31:30 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x16so490223pgj.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=iPIzNR7xipLQXIVaHW927Eecco7V9ufvPVpB6b02lfs=;
        b=qTP++3s3eUWsyPcZithfoQqZ611mSchohThUUnBiloCgPeTyQguCbVm4nI8g3Mxx06
         YsKs35B+B18cyVRl02Ioqc1v7nT22XQ6MGceZpBQb32Q5JZAytyQFtsTKZBvR/VIaJFn
         Am/lV0bKWQlkCs9uRvmfWAxxFv56Y6hfvoljEFNTmpcCys4KEn/XUOHyc8VQv63afl7k
         jkEWyPtQuHQ3VtmmHaOGAFl+fEPLON5SdPOKnfwALAE+l10dU988hJjdbTao+pfG2oGd
         AuYXeWYsOq0FMFIdPRnLa0bf90m+3Azha1bc8f83j54CH/s3URkQvZvSH1BPkPeMtfWQ
         4oDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=iPIzNR7xipLQXIVaHW927Eecco7V9ufvPVpB6b02lfs=;
        b=XiVXBQcoK8C0yweOhKT4K18TfUvETAxoGIgXvVZx7vCQ01eu10HsJSiXQlrbHPpXsO
         IjxkNAHIfnyAc1carCbC8/7x1a4zydu2P7PxjlHVfTL7vb2GbtoJh2Bj/eLARqRX1Rkc
         CT+TS5s3weGtIEItgq0xe5K35EOwLrmPvrAcMj/4ycQqcM9quLC3Dz6UR5NUmIqybPnH
         KYknT3P/s/tatyJNyJwOeWi1WCSpK71spH+4UBTLfHkcp30lLBgsNvWO4dFbtWekn5Le
         xuRpESuAEIbaFsM1EtPNBvqlGCNlNfCXVye4CBvMa5uBO+Syi14iS4ypzRQciD+LPMBu
         LlQA==
X-Gm-Message-State: AOAM530Ut959pNixiAudZ8H54yR9lAYA4tFxmYXOt1gWPFPm2wqu5E4c
        LgER7jxShM9rCY+MsyM26BowVw==
X-Google-Smtp-Source: ABdhPJxwAJwOo4kz7l5VmAguW3fqWsMcug6pWlpGLDnomiNc64Ei1RITNpBFjO2dtgWKq7GdfRaiOg==
X-Received: by 2002:a63:4416:: with SMTP id r22mr670740pga.248.1601289089504;
        Mon, 28 Sep 2020 03:31:29 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id t9sm822419pgp.90.2020.09.28.03.31.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 03:31:29 -0700 (PDT)
Message-ID: <969213d4f124e230c3febc01e2b1db291bf4585c.camel@areca.com.tw>
Subject: [PATCH 2/4] scsi: arcmsr: Fix device hot-plug monitoring timer stop
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     dan.carpenter@oracle.com, hch@infradead.org,
        Colin King <colin.king@canonical.com>
Date:   Mon, 28 Sep 2020 18:31:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Fix device hot-plug monitoring timer stop.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 9220bcf..0ae401d 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -836,8 +836,6 @@ struct AdapterControlBlock
 #define	FW_NORMAL			0x0000
 #define	FW_BOG				0x0001
 #define	FW_DEADLOCK			0x0010
-	atomic_t 		rq_map_token;
-	atomic_t		ante_token_value;
 	uint32_t		maxOutstanding;
 	int			vector_count;
 	uint32_t		maxFreeCCB;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 5076480..86f84d7 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -777,7 +777,6 @@ static void arcmsr_message_isr_bh_fn(struct work_struct *work)
 	struct scsi_device *psdev;
 	char diff, temp;
 
-	acb->acb_flags &= ~ACB_F_MSG_GET_CONFIG;
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
 		struct MessageUnit_A __iomem *reg  = acb->pmuA;
@@ -815,7 +814,6 @@ static void arcmsr_message_isr_bh_fn(struct work_struct *work)
 		break;
 		}
 	}
-	atomic_inc(&acb->rq_map_token);
 	if (readl(signature) != ARCMSR_SIGNATURE_GET_CONFIG)
 		return;
 	for (target = 0; target < ARCMSR_MAX_TARGETID - 1;
@@ -846,6 +844,7 @@ static void arcmsr_message_isr_bh_fn(struct work_struct *work)
 		devicemap++;
 		acb_dev_map++;
 	}
+	acb->acb_flags &= ~ACB_F_MSG_GET_CONFIG;
 }
 
 static int
@@ -898,8 +897,6 @@ out_free_irq:
 static void arcmsr_init_get_devmap_timer(struct AdapterControlBlock *pacb)
 {
 	INIT_WORK(&pacb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
-	atomic_set(&pacb->rq_map_token, 16);
-	atomic_set(&pacb->ante_token_value, 16);
 	pacb->fw_flag = FW_NORMAL;
 	timer_setup(&pacb->eternal_timer, arcmsr_request_device_map, 0);
 	pacb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
@@ -3925,24 +3922,10 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 static void arcmsr_request_device_map(struct timer_list *t)
 {
 	struct AdapterControlBlock *acb = from_timer(acb, t, eternal_timer);
-	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
-		(acb->acb_flags & ACB_F_BUS_RESET) ||
-		(acb->acb_flags & ACB_F_ABORT)) {
-		mod_timer(&acb->eternal_timer,
-			jiffies + msecs_to_jiffies(6 * HZ));
+	if (acb->acb_flags & (ACB_F_MSG_GET_CONFIG | ACB_F_BUS_RESET | ACB_F_ABORT)) {
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	} else {
 		acb->fw_flag = FW_NORMAL;
-		if (atomic_read(&acb->ante_token_value) ==
-			atomic_read(&acb->rq_map_token)) {
-			atomic_set(&acb->rq_map_token, 16);
-		}
-		atomic_set(&acb->ante_token_value,
-			atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token)) {
-			mod_timer(&acb->eternal_timer, jiffies +
-				msecs_to_jiffies(6 * HZ));
-			return;
-		}
 		switch (acb->adapter_type) {
 		case ACB_ADAPTER_TYPE_A: {
 			struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -4362,8 +4345,6 @@ wait_reset_done:
 			goto wait_reset_done;
 		}
 		arcmsr_iop_init(acb);
-		atomic_set(&acb->rq_map_token, 16);
-		atomic_set(&acb->ante_token_value, 16);
 		acb->fw_flag = FW_NORMAL;
 		mod_timer(&acb->eternal_timer, jiffies +
 			msecs_to_jiffies(6 * HZ));
@@ -4372,8 +4353,6 @@ wait_reset_done:
 		pr_notice("arcmsr: scsi bus reset eh returns with success\n");
 	} else {
 		acb->acb_flags &= ~ACB_F_BUS_RESET;
-		atomic_set(&acb->rq_map_token, 16);
-		atomic_set(&acb->ante_token_value, 16);
 		acb->fw_flag = FW_NORMAL;
 		mod_timer(&acb->eternal_timer, jiffies +
 			msecs_to_jiffies(6 * HZ));

