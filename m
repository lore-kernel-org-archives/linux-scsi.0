Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D42CC41604
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 10:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10E0520870
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 10:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGAfa3mk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgJGKmk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 06:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgJGKmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 06:42:40 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0666C061755;
        Wed,  7 Oct 2020 03:42:39 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l17so1613106edq.12;
        Wed, 07 Oct 2020 03:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6KY06uHjT4FGbr1jf7LkxmngoS8t8NSmf8ERDU+3OjU=;
        b=gGAfa3mkIonhmBL6mXR/klqY56zNyofwXg+JPtC6R6ez3a3Nu2HSqq3FUSTMHAE+Rh
         /TpJo4uZuk/pZo62SVAw0hs5jWL2OAV69uugtNb9w7D11hXN19zPBhuge8IgL5RJu3Kv
         KXbnJvg9THd9CYkx074JsNmXC1chsn/4zGhZZfjHmV83E9VrDXDxrZdhx9XccEW87vZh
         Hya2Rc3jxmkY3UMFCV+U5OdAEMdCkXbFC1zQ/2MqkRfFoF996WvujkI3+GantGXCb6F8
         WskAE3xAtGonvtG27k25IDbzyfuq6ebeLmSWuqewjBrKedtj4GYDbq5FdVTBe/OdhVFa
         mj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6KY06uHjT4FGbr1jf7LkxmngoS8t8NSmf8ERDU+3OjU=;
        b=Pk8lMAyuusvvPezLePLNZGsGjncCb+kogEUubcot1X/kobwYUZ61F2UF3m7NYHvhY7
         01CZ15y+UgGveQAEglbGTa+yLFOUJ0wxTDMBCg+x1qjf2+Pu6UBEORjr2pBt/ea24OUa
         AQZdPtFz5r9OsmRaUSyBNzi3JZinJevOZLIpv/lo6segtbZImKTTpZ9B+g3weMxnfTyl
         oMgpRE59n+cfRL89GU4Jp6U/S52gJAhW0WrFaPPkSf2Q6A1pXg/sQyfMlkf0Law3x4Gf
         DiqoHjrJ1YnWeAxtFjlSYVK6k53kYAG2DVUxHiOeRpUpWdomh/EqQzFcgpLqHtBy9QEv
         hHHQ==
X-Gm-Message-State: AOAM532W2pFsckJaW7NILQJGPbbeu6DugAzBrzaTlcEmLY8/rRcSpWCs
        hkHuEbodNLJyLKoMbuFFJgo=
X-Google-Smtp-Source: ABdhPJyqraldx1BIB6BRIuIJPwg9j4l6EUxFmwO3fNVtOe98PCix4WME4TrObcyaxcQQ8ZICb4EanQ==
X-Received: by 2002:a50:cfc5:: with SMTP id i5mr2800301edk.151.1602067358476;
        Wed, 07 Oct 2020 03:42:38 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b907:5772:ec4c:df78:2ef4:dfa8])
        by smtp.gmail.com with ESMTPSA id s25sm1231482ejc.29.2020.10.07.03.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:42:37 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH] scsi: sd: Use UNMAP in case the device doesn't support WRITE_SAME
Date:   Wed,  7 Oct 2020 12:42:20 +0200
Message-Id: <20201007104220.8772-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

There exists a storage device that supports READ_CAPACITY, but doesn't
support WRITE_SAME. The problem is that WRITE SAME heuristics doesn't work
for this kind of storage device since its block limits VPD page doesn't
contain the LBP information. Currently we set its provisioning_mode
"writesame_16" and didn't check "no_write_same". If we didn't manually change
this default provisioning_mode to "unmap" through sysfs, provisioning_mode
will be set to "disabled" after the first WRITE_SAME command with the following
error occurs:

sd 0:0:0:3: [sdd] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08 cmd_age=0s
sd 0:0:0:3: [sdd] tag#4 Sense Key : 0x5 [current]
sd 0:0:0:3: [sdd] tag#4 ASC=0x20 ASCQ=0x0
sd 0:0:0:3: [sdd] tag#4 CDB: opcode=0x93 93 08 00 00 00 00 00 00 05 4b 00 00 00 1f 00 00
blk_update_request: critical target error, dev sdd, sector 10840 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0

Comparing to manually change provisioning_mode in sysfs, it is better to set
provisioning_mode to "unmap" in case WRITE_SAME is not supported.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/sd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95018e650f2d..93fb41741b21 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2372,7 +2372,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
 
-		sd_config_discard(sdkp, SD_LBP_WS16);
+		if (sdp->no_write_same)
+			sd_config_discard(sdkp, SD_LBP_UNMAP);
+		else
+			sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
-- 
2.17.1

