Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88725C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 05:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63737230FA
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgLFFy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 00:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgLFFyZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 00:54:25 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53469C0613D4;
        Sat,  5 Dec 2020 21:53:45 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id f1so5402112plt.12;
        Sat, 05 Dec 2020 21:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QQbA5rQ723r8QeqL5SQIpU3wuJWTt34+LMrl2zPvWzI=;
        b=kEeaItSLHlONkaJv0x51eFsNJj+NF0gxMzrjGqxHmMXWUn4fhrQmrltG9lMTdzE0cc
         VgoAV2apKcoA/2tVCuNLWtdfAASidy1m4haZysfQUux1KrW/dsHl4ThAXcxy4Z9evrEo
         F8H/9TcI4Puhr14HVGRqQCOxey25iyCW3Lz2+MQKN2NiGBffl6xp/WM2P37ZqCRK86w1
         7eh6K/6Docy2w2Keq1YuoOor3VngiMXreSB6Xat2Pn+ncun+BkouyTjWOLhsN6IFcsZY
         ClgN7ME7RngwyxYnT1jI3/475WitQv72EsHzgbELBgTusfajZZRTFX9t5ONflArOHiD8
         Kp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QQbA5rQ723r8QeqL5SQIpU3wuJWTt34+LMrl2zPvWzI=;
        b=ujeHulEC+rQ6f8hQ4vGSv9Dpny9QsIYAygY51b7aQLMoburO76yWw7qItTsseLLAIO
         HOIN3CJ4OI1ALURC9g9qA8XVw/tnOnsjKdu//A5ghffn21rt2xyYe3Qag7jLuNURtuTe
         3gwoM259814s9KvHb9D38ghIpPqnr77Dg8SR9Vf+qekhpoXJVS0rGvBoXRHklYBcs7nG
         1Bmv4BpF+Zfb9XBN32x4O12M7xzA22vFKgIrYjgsCRUoWh4NAsJaDDBmgEe+5M56q4HN
         AVDtCxqOIS1/ACtuG3+l18mcaY3QcpRyoXaapTpJ99pPpcut9daUcsRwcvhTnvRwF65O
         JR6Q==
X-Gm-Message-State: AOAM5325OhInw8ETc8mUSoBYE3/7uvrsJGs8D79lRLHF5++FKAMKferY
        GKA9SOz/pvqlm/VeP5DQHANyMQjgr6g=
X-Google-Smtp-Source: ABdhPJwgyllaAJUxLtjj7f/qRUGt0E4nRD+cNxYj3JetskReH7WtO788wO3U4+IY2vTy0vb3HywHHA==
X-Received: by 2002:a17:902:6a87:b029:da:e253:dd6a with SMTP id n7-20020a1709026a87b02900dae253dd6amr4399704plk.81.1607234024592;
        Sat, 05 Dec 2020 21:53:44 -0800 (PST)
Received: from archlinux.. ([161.81.68.216])
        by smtp.gmail.com with ESMTPSA id a14sm4360094pfl.141.2020.12.05.21.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 21:53:44 -0800 (PST)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 3/3] block: set REQ_PREFLUSH to the final bio from __blkdev_issue_zero_pages()
Date:   Sun,  6 Dec 2020 13:53:32 +0800
Message-Id: <20201206055332.3144-3-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206055332.3144-1-tom.ty89@gmail.com>
References: <20201206055332.3144-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mimicking blkdev_issue_flush(). Seems like a right thing to do, as
they are a bunch of REQ_OP_WRITE.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/blk-lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 354dcab760c7..5579fdea893d 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -422,6 +422,8 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	} else if (!(flags & BLKDEV_ZERO_NOFALLBACK)) {
 		ret = __blkdev_issue_zero_pages(bdev, sector, nr_sects,
 						gfp_mask, &bio);
+		if (bio)
+			bio->bi_opf |= REQ_PREFLUSH;
 	} else {
 		/* No zeroing offload support */
 		ret = -EOPNOTSUPP;
-- 
2.29.2

