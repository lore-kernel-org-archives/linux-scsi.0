Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DE2C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B0E610FB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbhDPDwa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 23:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbhDPDw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 23:52:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFEBC061756
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:52:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id o123so17478028pfb.4
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=xa3dF3mWjOGHQTSXewzVQttORbJ1MeBGLJ4z7sU7nWs=;
        b=H8Gy/Fb5XMHP3uA3YY/JTZVRZJQYbZ8rhPUUvF8++jKCop+8uh0i+e7VLFdLxkwUa9
         1ELHfXzFoOl356/lx5OpqKHCK67oAaO8P76Ts2xFC/DBD99LxzeC+RHh48DL03S52nZV
         1lr5RZ/YbDAUmbIWFCeJKyiUF0TzM+Y33miYkmT95PM8aNLbDSYP+hx/lSX0AjYkR0tE
         o2fv7saWCVNRt8e2/5gTHEkHALFo/Pf+qVN164hrHFjdi3lIhDBo2eQaWjey01b4ifhh
         eytK70rTOBKUgPZ7dcHcbyJEfWTp7sPvEAhMSNEOUMVL6h0gfZZwy61Cw71DUcSLRVfR
         0Yfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=xa3dF3mWjOGHQTSXewzVQttORbJ1MeBGLJ4z7sU7nWs=;
        b=N9Kox4z5TzOl/uhAK0mfVNtDlBKDvK902Hepz8+k3nLpxbGhQQwHWYvkxMO6bYcwtr
         s6yv3Ee3lYIhaua0qqaTEkS2N3eMLx35AA4NGHk9lAk7FE/GYQj4orCZ5fEJV0KcTtNd
         xP3IUiFOW2m4pKL3UB00XjnJIJIjhyWyJguIS4HiZT6FzgSsu0AUfb9oZH6N5kJFQMYw
         bou31C6yR5vSk1H/D60Cv2t/bE0R78GADeSYP77pgY9VeDXPWpSp5gxMzij1oy6GE28w
         H08UBYTnTb5ljkExZp85xAzJ1XDJa+MDJWY7JV6oO+g3IiRRQlp87bXnj5zHoHYWYD46
         v0eQ==
X-Gm-Message-State: AOAM532OjiJwSfqwkAv8EFXYqOUq7REKTPUeZ/kX+HDcOLy7JRwXMP1O
        yhsrNR/hLSnL/Bi8Jx++E+Gfnw==
X-Google-Smtp-Source: ABdhPJxEEFy28l5SGUuxFlvC3roQ4r/ScQbK4MIl3JpYg3srilQ1v/nNZbfinScmy5WvTXNg7thMdw==
X-Received: by 2002:a63:6ec5:: with SMTP id j188mr6133824pgc.394.1618545125170;
        Thu, 15 Apr 2021 20:52:05 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id g24sm3771557pgn.18.2021.04.15.20.52.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Apr 2021 20:52:04 -0700 (PDT)
Message-ID: <3a7f39b4f8d3a3a2400556e6ce410810f0508829.camel@areca.com.tw>
Subject: [PATH 2/2] scsi: arcmsr: update driver version to
 v1.50.00.04-20210414
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 16 Apr 2021 11:52:03 +0800
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

