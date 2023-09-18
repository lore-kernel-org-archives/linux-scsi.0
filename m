Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EC3C46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 10:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbjIRKnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241252AbjIRKng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 06:43:36 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE207100
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 03:42:47 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68fe39555a0so4003119b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 03:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1695033767; x=1695638567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GhakMSRCgrG5y7MSzV78ej4e/GsQjMpKs2qHZk5LMcg=;
        b=JZTBcfXcncQR9bCbdeMRtnAilKtHE/vM7oIE+pYFd2EHq1YAD+XapmMxZfW9q9Aqev
         3S4q0vWGWb7+Ds3Oejpx9qEDPa8d+9uHjYXfGOuQLPfank16gd8lhk6Uwy4SAFXidGXJ
         QfjcjqBp9LvMHuNW9bR4KzW/ZAC+BYwxwmAihVT5D4Qh1Xq63oIXLwsh/qoKo56JeDqm
         IsAgMny9VTXnlXUv9Wg6ZUbtto3UYNTRm4d1WmtHHpL42Y7u+VA03A20+7j/psXmhMmP
         wqZBofwZ/EjzmSFcZ005iNIyNNKuVc2ELaGjEFXYM33jakhHqbFw5SBUzf3wbw65MuSz
         +aAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695033767; x=1695638567;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhakMSRCgrG5y7MSzV78ej4e/GsQjMpKs2qHZk5LMcg=;
        b=VlZDGlVXKBtcr/KYTfGhbNllomvDDWL9BSt1OQdXwWSynwA6EzUWvvOPb+9k8Enifk
         C7B2hANobHMmbVM7E5+75O2/7qweRo8miDOy3mYosfevd1clXa/9pFrKtsnRci0WwX4F
         04LQfJAGb/zzaS7w1ZBQeDCGxUCrv+EYtE6yLqB7iLvVSBd1p7jAHEY2HNIEwqXp3x79
         T+jTLBOKsWCCqedUs2RUQytCydLLcl8KUMTJhaVcgcww6urPdDKHT1Zdgzcd/CUVWY0I
         h0Ka7ZaBBGkqlEJjifM0KxJCfQw7sxLLZjkH6FhEeaoHYK4mflF/AxyfJihNegMePEqB
         byrw==
X-Gm-Message-State: AOJu0Yz+01Cz2QY3Gg1bFH0PVKP7ShvCSJvdUsJv7ARdrwL1aTIELeIn
        wPuYsGkIvcM3druAOS4rOFwg6g==
X-Google-Smtp-Source: AGHT+IG8PAxxbnGR1aEG+ZHbib2MX2jULEWMs4nBjZ5HsgPJyJbojA/pkRctyqIppA6hYZJRdBVwSw==
X-Received: by 2002:a05:6a00:22d0:b0:68f:d320:58bb with SMTP id f16-20020a056a0022d000b0068fd32058bbmr11204729pfj.8.1695033767228;
        Mon, 18 Sep 2023 03:42:47 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id j16-20020aa79290000000b0068c90e1ec84sm6961895pfa.167.2023.09.18.03.42.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2023 03:42:46 -0700 (PDT)
Message-ID: <741d8d7b037cde7d9344c61821caf79e2beeac49.camel@areca.com.tw>
Subject: [PATCH 3/3] scsi: arcmsr: updated driver's version to
 v1.51.00.14-20230915
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 18 Sep 2023 18:42:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch updates driver's version to v1.51.00.14-20230915

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h
b/drivers/scsi/arcmsr/arcmsr.h
index ef96b32..a7ce097 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -50,7 +50,7 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.50.00.13-20230206"
+#define ARCMSR_DRIVER_VERSION		"v1.51.00.14-20230915"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096

