Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6CAC43331
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 19:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7056921924
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 19:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfKITOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 14:14:34 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56198 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfKITOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2019 14:14:33 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so9368763wmb.5;
        Sat, 09 Nov 2019 11:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NBu6sNDl+sHdYYDpy19HGzHjO1NLsTFIOQ2wBXdL9VQ=;
        b=AJfX3taAIBqZe8DHxgecu0xs08OoE0D1CTeI35/wp2VfRJ5wrDzjzjmB4i/o1fPrkB
         8r6MSaqjssYl3dEfmGPatNhDqsu2sYLqOBsXzvIH/JTq2j17jxljatc0CVI6Lpqardhd
         rk50UR+n5dJw/QcMoIYkv/7XAcEE+xa0pWll9le0g3Md1qyMW/aWlgwd7ef2Q8lMQGd0
         ZL46m8mEB5GKYFqEfh7uK5vm5JJ5EHYykg93p3AjnSwOq3n9TVuJmU9IlD2gvnUfTcbc
         C2I2Z7gNpw746IP4X5EDYeZ/XBYw4L+AhqM+zh6tdon9nUOZVZWp0QJjclsMQ93qA2dK
         xF7w==
X-Gm-Message-State: APjAAAVPocZcUv5oZfeMNsTS51OlVzZJVowb7auoy7htiYy7ST+96l2n
        uuZjQ4x+04yYYtzjN9JBJWE=
X-Google-Smtp-Source: APXvYqwIBuwvPIarWEbgba4BwnCeaED7Mr06Xe/dxiOQxMerUY7jOXAcnyZZe0RdvoHeSY+b6zaM5g==
X-Received: by 2002:a1c:3d57:: with SMTP id k84mr13058480wma.156.1573326871528;
        Sat, 09 Nov 2019 11:14:31 -0800 (PST)
Received: from localhost.localdomain (82-75-169-199.cable.dynamic.v4.ziggo.nl. [82.75.169.199])
        by smtp.gmail.com with ESMTPSA id t13sm9116929wrr.88.2019.11.09.11.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 11:14:31 -0800 (PST)
From:   Kars de Jong <jongk@linux-m68k.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        Kars de Jong <jongk@linux-m68k.org>
Subject: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
Date:   Sat,  9 Nov 2019 20:14:00 +0100
Message-Id: <20191109191400.8999-1-jongk@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When using this driver on a Blizzard 1260, there were failures whenever
DMA transfers from the SCSI bus to memory of 65535 bytes were followed by a
DMA transfer of 1 byte. This caused the byte at offset 65535 to be
overwritten with 0xff. The Blizzard hardware can't handle single byte DMA
transfers.

Besides this issue, limiting the DMA length to something that is not a
multiple of the page size is very inefficient on most file systems.

It seems this limit was chosen because the DMA transfer counter of the ESP
by default is 16 bits wide, thus limiting the length to 65535 bytes.
However, the value 0 means 65536 bytes, which is handled by the ESP and the
Blizzard just fine. It is also the default maximum used by esp_scsi when
drivers don't provide their own dma_length_limit() function.

Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
---
 drivers/scsi/zorro_esp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index ca8e3abeb2c7..4448567c495d 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -218,7 +218,7 @@ static int fastlane_esp_irq_pending(struct esp *esp)
 static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
 					u32 dma_len)
 {
-	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
+	return dma_len > (1U << 16) ? (1U << 16) : dma_len;
 }
 
 static void zorro_esp_reset_dma(struct esp *esp)
-- 
2.17.1

