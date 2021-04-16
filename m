Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A5CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7AEE611AC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhDPD6c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 23:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238381AbhDPD6a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 23:58:30 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB136C061574
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:58:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so15575296pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=xa3dF3mWjOGHQTSXewzVQttORbJ1MeBGLJ4z7sU7nWs=;
        b=hDsbccfiO4QBRFKF7p2mclaEkEBZEAoFUo18DDp+TCGeURUfZa0ym1aJy3MucPH+gS
         uen2f6p0XPtPHyfAcBkTuRKVmq4GXMSBCYDwaPoOxVMyJUdrQHbBUxXeOHqvLys0LcK5
         2o1pqA0P0dIsr5My/0NEXgMl7+bQGL9273w6/ZMFJ3xeabmzw0Mx6sTFBc8kX86QUd2v
         lVXHJcaU7BdudghOpMsNfbstOZcniHpoBzTTpYOT3tPdVvC3560GsaWb9iXHLeQE3Zci
         VzxVvmSi3hP+geT0pT5Zkx0cSGNODArs7AebotLMZtqlqSRseEkeiFylRkqDlLZcSOnV
         L+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=xa3dF3mWjOGHQTSXewzVQttORbJ1MeBGLJ4z7sU7nWs=;
        b=Ie7EGYv/jMLaynmswqRJuq9cFABE/eBmymrTGBafw4TQi0bGTrI2bpqykeSrxnbn8q
         /7b7gs+wjhy2AUg+GJiz/i/egOE0wOX7MtId0/ALrlcP7MUifSu7qkeMOstRqPRd/kDs
         pHIS8ah6XBj6rvTRNRw3JKOVYU1AuhuyvCBnE8iKwAIKgXGoBQD8/RZrkKXbsDu/lTHA
         jxxH0r4AONGgWHSO17Mh8iDJWu9wLjUe6o8gspE4FQJjTO21b5tXitWLbEic9QM3TJRB
         /Wo8R1HzDYeiP7RT3PVXJQotvHv3JXVv4TonABnEVMhl382TROSRA3AkyCoeXH9bIy3I
         vcEg==
X-Gm-Message-State: AOAM5338TTYfyw7Vnx5d0n2HRYxo9bZ0qHUx0dld6BrLMmiaOpAsuhI/
        ACOdqASz/8UD/tjk09H4lK8BhA==
X-Google-Smtp-Source: ABdhPJyBCVgFDJt7lAZEwyqfQoG1JyoAPvR7ALiEabt1kcJvgo/pe9JbzJg5U4pl+r07xssEt+7e8g==
X-Received: by 2002:a17:90b:ed8:: with SMTP id gz24mr7209234pjb.98.1618545484393;
        Thu, 15 Apr 2021 20:58:04 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id i9sm4328017pjh.9.2021.04.15.20.58.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Apr 2021 20:58:04 -0700 (PDT)
Message-ID: <1ca5474a5c6fea59bf13cdf84f7bd17f0b20f562.camel@areca.com.tw>
Subject: [PATCH 2/2] scsi: arcmsr: update driver version to
 v1.50.00.04-20210414
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 16 Apr 2021 11:58:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Update driver version to v1.50.00.04-20210414.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 0f6abd2..eb0ef73 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -49,7 +49,7 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.50.00.02-20200819"
+#define ARCMSR_DRIVER_VERSION		"v1.50.00.04-20210414"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096

