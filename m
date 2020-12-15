Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8D2C4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84B1522258
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 10:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgLOKz1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgLOKzR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 05:55:17 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE8DC06179C;
        Tue, 15 Dec 2020 02:54:36 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x12so10354948plr.10;
        Tue, 15 Dec 2020 02:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JMJn4WueT4E0rHp/hcFMMf2nSPTGv/vUW9tNOsgvr4g=;
        b=HdhBMBJW7JnM9qt75gYLEMGH8DcG4Cj6D2L1miXChxgCvcfH9Cad5vGvTChRV1FIBI
         zwJRfct5v2bb/1a1Lg2vfcFT7+7f+yRZqmdyP8jE+cDgAyaeHjrsamRGa+MyS6F4M43L
         L53mOzyQeJn9T27bE5W8GuoyHdv6rc12CeKbFIdRC35B69ur5m2sE6XCCdC5ohr3JZrS
         q/hsT3OMePDGu3U04fh3+P1rBgJgAxstJueM7T7Lc4rzrMAV8MlWnPFrqFcI3PASAAzp
         SEu64FYjrpOJnta/6cI28R7NUTGHP/+AiAqjAdDS65ppGAB27HV7xC4xgiTpS5QufCQt
         FjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JMJn4WueT4E0rHp/hcFMMf2nSPTGv/vUW9tNOsgvr4g=;
        b=QVOyL0M+GBLXj/4NpMUHsSWepPbx3bzeiqF8/UyssXhSNJ3XXQ1l0iorLGfnAXq9Mk
         6RVvYTc8cwDKAp7eh1bCQVTViOjSSzSDpSNJdiQITBTVxNWsqzPRWHNWHH5RK3Qr0crq
         jdoTfU6rJamQVA+CWSEl3D+gNXXJIL/CxJrwfYWUUFyZALoLBRI4A6N10nF8e3fvAhDo
         /fKtu81LaliRRtqk3RqpUOqhzssAtqmlPxqEDdAqr8d0eCVwX25FZ1RVe+ryOIENDN/s
         9ZVqqeesXt/VjlFoyXk6cw7w8eUuUj4Eh8+KZw0+xhQT6OvgyMWXU2KzuaxDis8lncvH
         fCaA==
X-Gm-Message-State: AOAM532lA9bxd9Dy33TniIZ/q30kSuS8UCaUsNT2jVXMTEXi3u9rQp93
        vWm6v9HiIid72l36b3NePht0ZEJ6G/w=
X-Google-Smtp-Source: ABdhPJyeSNZhH0DfbJJ3D3oSZKAADqYrxi1E1BFqyQUHLJawAEuVEBatwjl+W/3WhcdMuyEnEzgQCg==
X-Received: by 2002:a17:90a:9e5:: with SMTP id 92mr29832816pjo.176.1608029676281;
        Tue, 15 Dec 2020 02:54:36 -0800 (PST)
Received: from archlinux.. ([161.81.68.216])
        by smtp.gmail.com with ESMTPSA id x15sm7682247pfa.80.2020.12.15.02.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 02:54:35 -0800 (PST)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH] block: Avoid fragmented discard splits for ATA drives
Date:   Tue, 15 Dec 2020 18:54:15 +0800
Message-Id: <20201215105415.5219-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When 0xffffffff >> 9 are splited by 0xffff * 64, there will be a
remainder of 127. Avoid these small fragments by aligning the split
to 128.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/blk.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index dfab98465db9..1dc12fc86de8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -281,8 +281,11 @@ static inline unsigned int bio_allowed_max_sectors(struct request_queue *q)
 static inline unsigned int bio_aligned_discard_max_sectors(
 					struct request_queue *q)
 {
-	return round_down(UINT_MAX, q->limits.discard_granularity) >>
-			SECTOR_SHIFT;
+	unsigned int granularity = q->limits.discard_granularity;
+	/* Avoid fragmented splits for ATA drives */
+	if (128 % granularity == 0)
+		granularity = 128;
+	return round_down(UINT_MAX, granularity) >> SECTOR_SHIFT;
 }
 
 /*
-- 
2.29.2

