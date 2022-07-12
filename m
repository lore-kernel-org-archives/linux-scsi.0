Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB87C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 07:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiGLH6o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiGLH6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 03:58:41 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B16EB9;
        Tue, 12 Jul 2022 00:58:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q5so6579207plr.11;
        Tue, 12 Jul 2022 00:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QSLBth1UAZoBdoCqm60VueY2vh2tMmMd00GyQMuP4pM=;
        b=Yznmx/2cyIJ/Dfw0nJxPxpwzvjm2dFOpdWuosIre5BJq7zyV18WJ7eTiAoXPpfh+ja
         TM8FKijtqVvM8P2uvJoD6pk4qM4/dbuoP/VFsyu7b5Deq27O5+UoLGajCVfQ/nTXiuw+
         5UTX5hcpLxIsgDAuTsWsY78tqqOzAmXitTxaS1nOiU/CldhvWzxQIV+Pj9uv5ZQ7G2Un
         /+WuCHPyqog1+fPPfOSE4HmdhHvE83+LfY5E6hXm4yZtEtBEeI5J5x5UQS6g0zzysXAB
         1VWTYT6HKCeAVs00Bkyk35MXpBUktP4GkhfNNy8qCnCA1eCuFjzZiMlor8DBkBsc1XX7
         ck0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QSLBth1UAZoBdoCqm60VueY2vh2tMmMd00GyQMuP4pM=;
        b=2+sqGhwFNVOReCOACy826ySi3KtoiTFRx4Tj2NecV3qjYFqWVRfklPD4LQbjbyZra9
         o1/pFe5BChtwf9HqRAMV7TTz5uofLvQsvDqspnnhnSH0KUUEK3jvzGQRUFCNlK88QCoh
         On9zo0WHVQnR7B8YtKhDtLjG5n7s8iH9CbgeQY/kZwZvapcMs/M6Lvy4vIKnyg1PqN+X
         NKyDaQd2dgCkYPmtWPaVbc88LE+g3d/wlTesghXbXNqSiLTu6IMAcPlqsnEYi7BR9CW2
         Qy9aXiigVfIZFYKMspQMk+iv2CfbPDTx18E24UQB8PQ9BGtLHe02lgQOYRHQjCpuutkh
         4d6Q==
X-Gm-Message-State: AJIora9RWdj2uZG+Tv08+ou/jbwkXPbmVB3NKDVVvq5Sq+UeJLycBo8m
        QaT//Ch2OBTKHhyNudHpzVc=
X-Google-Smtp-Source: AGRyM1uDLquXzZxi7+k2QUZW+uwAslmddxmq4Xnuo07sGlLb12xPdp8PlRAGKBENSwkRdDpNTZHF8g==
X-Received: by 2002:a17:902:c947:b0:16c:1c97:16ec with SMTP id i7-20020a170902c94700b0016c1c9716ecmr22049349pla.7.1657612718266;
        Tue, 12 Jul 2022 00:58:38 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0040c74f0cdb5sm5451995pgr.6.2022.07.12.00.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:58:37 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 198C7360331; Tue, 12 Jul 2022 19:58:35 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v2 1/5] m68k - add MVME147 SCSI base address to mvme147hw.h
Date:   Tue, 12 Jul 2022 19:58:28 +1200
Message-Id: <20220712075832.23793-2-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712075832.23793-1-schmitzmic@gmail.com>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The base address for the WD33C93 SCSI host adapter on mvme147
boards is missing from mvme147hw.h. This information will be
needed for platform device conversion of the mvme147_scsi
driver, so add it here.

CC: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 arch/m68k/include/asm/mvme147hw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
index e28eb1c0e0bf..fd8c1e4fc7be 100644
--- a/arch/m68k/include/asm/mvme147hw.h
+++ b/arch/m68k/include/asm/mvme147hw.h
@@ -93,6 +93,7 @@ struct pcc_regs {
 #define M147_SCC_B_ADDR		0xfffe3000
 #define M147_SCC_PCLK		5000000
 
+#define MVME147_SCSI_BASE	0xfffe4000
 #define MVME147_IRQ_SCSI_PORT	(IRQ_USER+0x45)
 #define MVME147_IRQ_SCSI_DMA	(IRQ_USER+0x46)
 
-- 
2.17.1

