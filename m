Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9078C4727F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A786E21531
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="DtYSjOrp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgI1KiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 06:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgI1KiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 06:38:12 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAB5C0613CE
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:38:12 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so504791pgl.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=i1pcc9oI2ymP/R7jfhbDU4KKfk6rWA2fSDx9MDktUoM=;
        b=DtYSjOrpKknZq+N68FeauZjnGlaqhGj9YfjNR6tHvEjuqYDivGpihXu6Wi59kVucU9
         GlrYIRaVS3kSgB2LCbAKZgGMzaeL1u0ECJUBBQ+yDd4apBDDU9SvHlw3xz7v4Q1CxMWh
         FrYZPilHUornOcRgCErukJIqHJDhPdSLYNDryLVYkeE3B/1gyidx1b9NE8yRnEIoPQDl
         Yg2/NYofdcBOwl+kmioB9a62kcvNRxxp5dRSwLXWXWLMuEnk1ESM6xfY4rlXl/xm+rs+
         30IrRHll/i/4MkIpVKnVv1LZdSK8zQpwPhZS/T4v9qkzp/McajxQBCOnHA2XNxEf+teB
         m0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=i1pcc9oI2ymP/R7jfhbDU4KKfk6rWA2fSDx9MDktUoM=;
        b=eeK5VXu3hDZjLvzmYHQqxjGIvTY8QQxsrBVFghWMr+D5zpVOPUrYL2Lz0hr8sbdabC
         kn60B+PyAVkKK5/Fq5jWs6NWjfGsi4K2Tk4f/Lrv4w5vzQo8T1mEivyBP8TKOdF975wJ
         /mFAOF7lXdpvDekRodnviiECg6wMM6G1+evWjTri5aQp3DQFFcDwXSL41Wdpf1vP5CNz
         /0k4t9ZZzk0beEFfYyi01CEGS8tKguxYhl8ABj+wUeireIu/rO+q2rvYR1+V5gyYOE7T
         crw4tNHnAxvjdYIAJ3xpgrfS+ej/JCGEOPp2lQJnRqSzxfIKP/GR6tPyvI5C6d/FfXq3
         2pgw==
X-Gm-Message-State: AOAM533RrjYSr7WUbXXQUCcmdj1ToHv7JuSMeeOgzp28GwSrAMaerQhf
        aQIcjc/MW8mtyT6+kXVdCAQY8g==
X-Google-Smtp-Source: ABdhPJw0S3vcuXHtMfaconrKJz9EMkaPVjPfq6pyIyZadAr4wDGVPNkONYBoNJXk13wwRPqhSvbUoA==
X-Received: by 2002:a17:902:6bc7:b029:d2:6aa:e177 with SMTP id m7-20020a1709026bc7b02900d206aae177mr985250plt.52.1601289491958;
        Mon, 28 Sep 2020 03:38:11 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id c9sm921588pgl.92.2020.09.28.03.38.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 03:38:11 -0700 (PDT)
Message-ID: <b41f9af781bc36f4e5f82fccabc86ebbd0e587f8.camel@areca.com.tw>
Subject: [PATCH 4/4] scsi: arcmsr: Update driver version to
 v1.50.00.02-20200819
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     dan.carpenter@oracle.com, hch@infradead.org,
        Colin King <colin.king@canonical.com>
Date:   Mon, 28 Sep 2020 18:38:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Update driver version to v1.50.00.02-20200819.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 5e32f17..5d054d5 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -49,7 +49,7 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.40.00.10-20190116"
+#define ARCMSR_DRIVER_VERSION		"v1.50.00.02-20200819"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096

