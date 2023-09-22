Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55678CD4F35
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 08:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjIVI7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 04:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbjIVI7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 04:59:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23256198
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 01:59:25 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-690bd8f89baso1694565b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 01:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1695373164; x=1695977964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HaTCJAnPpNWA+hL+ZaGbfhKHNW/aJAEE+SMYIWeebKA=;
        b=qNuo2SixK1QmIfVO9UCO0fq9I7vZMBbDWkxlOhW4mW2drF9UJU56OnuyPp5clF3Ep8
         4FEReZHYCmXdbOoIN59Zc8HOujPT81+cHkf18gKP8nOD0O2OqXAG+rPrbt2Hje7l/MYe
         xbRx+zd8YbHWl405bJjvxM2o3gov9Hrzs4FBnoRcgz6NC0BHlQbr8Mxgsf6i8g9XlM8s
         4N2O3MYDa/eVVG3ehDoAUOcEuCTF0WGjt2CkiTuv9e7+5ud9x3/4Z78+N09fdNxrlRyf
         9+lP2IyaZEXwTt7Xlf8sB0j51UjlhiwOvBA6+QG9rcLmRvL436UUXLs496vJNYSMH6CD
         FY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695373164; x=1695977964;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HaTCJAnPpNWA+hL+ZaGbfhKHNW/aJAEE+SMYIWeebKA=;
        b=m5HglyTS5zJzSKm8mAXhDGUm1ceKQf3mq5KpG6iKUuNwel93y5O7NjkpOjv/ZBYdNk
         HaW4bnRbqiDDojpW2VX2+w87sUFUhA7cxo3c8ruOnO2hX/Z8FeX/rTejz9M5RFtn4ETy
         i0O5DMOGVb9NZ1V+JL5/q1zdx+wuRvNgDspOBIBrD9gjgeLnwfv2jM4doF3pbPFiu5HV
         kXa2Sdff1eQ3PyJvZ7QRWVN9c6s7GWe6rJckKjIHa389mcpkF6WEAYb/Xx8jQ/hNzCuY
         nHJWa5X5McYtZIoARz4wNRlsXzt3897dmyCuJDZB/AdZKxElly6RVSDkLj/EY6s0g1ed
         xhcg==
X-Gm-Message-State: AOJu0YxxAKjEuF3s7rfc9slosRBzgfqEHlvnha0/B9pVVAmDWz5vpMZS
        1E+7uuIHaXLxnlv03HcoFFHWdg==
X-Google-Smtp-Source: AGHT+IF908zNeyhLj+FFOak9pOjcMCnQv/Am5lRWt8+dnS43wTzERnpZHX2jAV0QZqoAOKkyv3c7XA==
X-Received: by 2002:a05:6a00:847:b0:68f:c1e0:a2a2 with SMTP id q7-20020a056a00084700b0068fc1e0a2a2mr8662337pfk.2.1695373164550;
        Fri, 22 Sep 2023 01:59:24 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id d17-20020aa78e51000000b0064d74808738sm2733778pfr.214.2023.09.22.01.59.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Sep 2023 01:59:24 -0700 (PDT)
Message-ID: <9e27ba1341a5474d444165891b0853137eae2579.camel@areca.com.tw>
Subject: [PATCH V2 3/3] scsi: arcmsr: updated driver's version to
 v1.51.00.14-20230915
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 22 Sep 2023 16:59:24 +0800
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

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 2f80a6a..12c4148 100644
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

