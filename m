Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2083C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 09:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCVJI3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 05:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCVJIJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 05:08:09 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61F95DC9E
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:07:50 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w4so10591003plg.9
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20210112.gappssmtp.com; s=20210112; t=1679476069;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OUym5mR2BMTkr5dMZAiyWtrEULkoxuHuyPAHb5cL/yc=;
        b=6WTISs/T9RsY8/Bu3mDtU8yfUdtdENPdPhsDExlD61pY31Yxcs2eB9gyvSmawcYn+c
         YS5ZsepJYfsp9k0rFxFjxrVD0Lj3rrXAcgw/fAVbNar8JkXrj2EA0WFfAq8xJY0QWX78
         mtpuJirtvjZs2hT+3ORXt07Jjl3abRcGsuaeAu8TWj/slSWxnC6uPqoE2/zlYYQDKwNB
         zlioXgXC/qyGo3IdeCi75jZubWXL+sbPTfqRei4YEfYtI0nT/2/X9Cy+6ERCwW47y5+P
         IseISXJh+MpzxPe7YPFFqtuDMpzxwrrGEspIXXwtCygiWmU89zAsvtUs+93d34fFVnIb
         qOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679476069;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OUym5mR2BMTkr5dMZAiyWtrEULkoxuHuyPAHb5cL/yc=;
        b=LGP6GBmm1zkE2zdf8g+Lmy9sWD9/UX8Rz0Q1PzaJnUv6F3WoR6FV+O3d8OAxi5MG8/
         vIOfu4muB06QpARMhZhTVQGoBTN1e32JgfgRsZRGO8L3FMaUh9KeiC7/1XVESFADErpL
         cAvHMPLd/ePrAI5jlLuTxK0Odrcq9GGSo4aeKQtUOIKjy6OZZ6BEg1Z+8Z3OKOtTTjgJ
         P+q1HyHAEoV6sakE9hb3VsIG2lGlhb7JFk8fX10BX+yBQyq3p3FykA6bsaeqnV6xBmUq
         DdPueeR6UxHey6It3zQAkhoLyarceWwXasxtNRAFleiqUM33MnH0i7DMS2ifWBlru+mr
         Da+w==
X-Gm-Message-State: AO0yUKWkGJ8ZfJGU2AuwA2X7yPqfk1/HSD6C/Hw1pwB+ygtrm54qPP5z
        R23nspPW92c+vmLDoWexU2MhSQ==
X-Google-Smtp-Source: AK7set/Co1fFRC5QEGQCvwq/l/XilSzkUx9imltQ8lu0f1lMIJBdoIHjIx+50LcXrVYsmiqYlnUepw==
X-Received: by 2002:a05:6a20:6ca6:b0:da:1830:328a with SMTP id em38-20020a056a206ca600b000da1830328amr4498373pzb.44.1679476069314;
        Wed, 22 Mar 2023 02:07:49 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id q2-20020a63d602000000b00476dc914262sm9534815pgg.1.2023.03.22.02.07.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Mar 2023 02:07:48 -0700 (PDT)
Message-ID: <17c235f2fff960aefea33b50039e214f42164130.camel@areca.com.tw>
Subject: [PATCH 1/5] scsi: arcmsr: deprecated arcmsr_pci_unmap_dma() using
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 23 Mar 2023 01:07:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch deprecate arcmsr_pci_unmap_dma(...) using by
direct calling to scsi_dma_unmap(...).

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 9d04cb6..e8c12dd 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1299,20 +1299,13 @@ static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 	return rtnval;
 }
 
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
-{
-	struct scsi_cmnd *pcmd = ccb->pcmd;
-
-	scsi_dma_unmap(pcmd);
-}
-
 static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)
 {
 	struct AdapterControlBlock *acb = ccb->acb;
 	struct scsi_cmnd *pcmd = ccb->pcmd;
 	unsigned long flags;
 	atomic_dec(&acb->ccboutstandingcount);
-	arcmsr_pci_unmap_dma(ccb);
+	scsi_dma_unmap(ccb->pcmd);
 	ccb->startdone = ARCMSR_CCB_DONE;
 	spin_lock_irqsave(&acb->ccblist_lock, flags);
 	list_add_tail(&ccb->list, &acb->ccb_free_list);
@@ -1596,7 +1589,7 @@ static void arcmsr_remove_scsi_devices(struct AdapterControlBlock *acb)
 		ccb = acb->pccb_pool[i];
 		if (ccb->startdone == ARCMSR_CCB_START) {
 			ccb->pcmd->result = DID_NO_CONNECT << 16;
-			arcmsr_pci_unmap_dma(ccb);
+			scsi_dma_unmap(ccb->pcmd);
 			scsi_done(ccb->pcmd);
 		}
 	}

