Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C30C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 21:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiCCVBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 16:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiCCVBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 16:01:12 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC9A1CFD1
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 13:00:25 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so3964226wmp.5
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 13:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TyE39n7MpFIkfgXARaAIpSs1PmIH4C+yx6k8CYAlWFg=;
        b=FuLEV7CWBA2IRdM3kwluhSlKzDLNU3gW7PxAY0Ipm4ZofSEH4MsdTojgyMhM3sr2P3
         nNRIFqWoW91Sa76ndAUsouRWzBhSYFBBD+vxAF3ybJpqJLtWcg90vaQtIlFnu4X+m60Q
         tlpyl899XZKw24BwYbT3BPlZYUv7GdRiFk85En0Vwn5W5St/B/xP7UKb4bCl+oIUwbeC
         KJTavbBRKAzE0aqmmH4SzrFIppUZiNgYNH9gQ7EEx+M9dLUi7K0fMncl54FjVyJfPaEK
         7Igs0eFZPLqIBLXjAMihne+WPLA61UHWl0hNv07SFKcqIl/8aGMI/CCBF9huzG9U+Iyb
         JDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TyE39n7MpFIkfgXARaAIpSs1PmIH4C+yx6k8CYAlWFg=;
        b=8AyJUTp1thDCPcQ80wuYJw8ffqxBO8OfTnWC5Qgcxu8uGBuaK1BcbDKyI2XGF5nAMm
         H00/ErhteuBe1SMzjcxb+KAgwYoyMkmMXECkrFMUJu6LGML5StfqjMjia2k8flI5ULM7
         AxUE7DkrZJF23UgAp+6RUEQ0Ju8gUBHLqj35LXYgQvgzdNqH9PfNu87ckUpUkMv1vj2r
         6zt0syZQQYeIb9smr435cCd/qkciwhVDLJIvUdYJSYt8WhPwOLMBu64k3c9kDzWP2SLe
         5Sn/ATTwDwQ2xTXe2RTKh8Ech01haeLwJ5xKyEyFDKLMFDJ1+yC/W2TaXcZuM1bPA6ry
         gmNg==
X-Gm-Message-State: AOAM533PUH273MAspVYfG3rc5w6Gsh9eNAahw7cf4Bjo0WRQiec++c3S
        1vfh23LOAIY+OB9A+/Vhe/Ig2Pp20CiZBw==
X-Google-Smtp-Source: ABdhPJwxSXAw+ly0rlQpXSn0/K2fXtbpHJ+Y5gAwLaApXdHU5IG28rKDtZKRdyzjZVLcOv2ALwCP8g==
X-Received: by 2002:a1c:730e:0:b0:381:103f:d6d9 with SMTP id d14-20020a1c730e000000b00381103fd6d9mr5137199wmb.46.1646341223736;
        Thu, 03 Mar 2022 13:00:23 -0800 (PST)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id e15-20020a5d6d0f000000b001ef7dca67fasm3394209wrq.114.2022.03.03.13.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 13:00:23 -0800 (PST)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH v3] scsi: aacraid: add missing manage_lock on management_fib_count
Date:   Thu,  3 Mar 2022 21:59:47 +0100
Message-Id: <20220303205946.1609-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All other places modify the management_fib_count under the manage_lock.
Avoid a possible race condition by also applying that lock in
aac_src_intr_message.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
Changes in v3:
  - Improve commit message.

Changes in v2:
  - Fix whitespace.

 drivers/scsi/aacraid/src.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 11ef58204e96..ca73439587ed 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -91,7 +91,9 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 					dev->sync_fib);
 			spin_lock_irqsave(&dev->sync_fib->event_lock, sflags);
 			if (dev->sync_fib->flags & FIB_CONTEXT_FLAG_WAIT) {
+				spin_lock(&dev->manage_lock);
 				dev->management_fib_count--;
+				spin_unlock(&dev->manage_lock);
 				complete(&dev->sync_fib->event_wait);
 			}
 			spin_unlock_irqrestore(&dev->sync_fib->event_lock,
-- 
2.35.1

