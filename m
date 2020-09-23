Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE7FC4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 05:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75656221EB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 05:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A50k8tVR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgIWFw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 01:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgIWFw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2020 01:52:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DA2C061755
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 22:52:57 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f2so13703601pgd.3
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 22:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dL5bjsBTpI1WHY1Lul+C+ZXEBNZvu4AIQRGli0lUOx4=;
        b=A50k8tVRgwLxFX6dX3WLie7bUN04fF18rVK6VMuagjWGw0zkav2zad9jjoWwl+7YEp
         2o0YwU9LWdUlgGtBF9Sx+oJGXlEpUMTgTRkPn5rnGjQoDPfKvZqU8PnwMuKseoLa44sB
         TQBrydSWrMiab+3eWHl2KIf1fjNvqMSfRpc0bHTtFYo+oncqaekPCOW8AaI4AtkBQ1tb
         UmygILV8mn8IincbZSrXeg4XT5dXATGeADnSNWWqjl8bvHdf/vyh/ZxuIByBfjF9EY9T
         q4dx8uEkwSFlXu+4XoCFwtC9w6colzorfS0TcOpN5sYl1mTAynm71F8jB6nW49Axg+gl
         m34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dL5bjsBTpI1WHY1Lul+C+ZXEBNZvu4AIQRGli0lUOx4=;
        b=s3LlQmvZamHTFN4Wn2+dYG1Qy57irImYeHjrG2MOZXe7dV9KpU3nLkz4r9mK+VX8Wb
         csNvIVjo1uTh7GxdYAIM0qXTJycjO5NcI01ri4ZSL5w670ZSDufqoksQbGmZSWayOeKB
         /wTq6g5f3YCHaGlKg7kY15H8yP9qv0idx/3ASDQX7ap5YV98W1lnyZbeZMELpSi2Ttf9
         mgilTKbRmMQkvAm+pb02NhYE4UQh5dzFN+HNhJlyX/h8y+iOrAPMxGwEg6XlB6LZ0896
         SrF4pMxu7hlJpQ1/i+gyaTvs/3S2p0Zys8TbKINK0d8QCu+/5GpljILggU4s6w5rIKFb
         fI4g==
X-Gm-Message-State: AOAM531T/1wLsOjBduqO1C484QaeDPM4t8/O7VgPMpFucMORUbxcWlWN
        Lo1jOVDW0MleytWZpJjSR6FEIoZcw+87Aw==
X-Google-Smtp-Source: ABdhPJyH82oC4488S4whZofRCzGvvcAlyJ91NPs+7eCAjDRVgnlLy7Wgg2U9blUwuFaSPvbfwJRCaA==
X-Received: by 2002:a63:f922:: with SMTP id h34mr6660742pgi.235.1600840377057;
        Tue, 22 Sep 2020 22:52:57 -0700 (PDT)
Received: from localhost.localdomain ([161.81.44.186])
        by smtp.gmail.com with ESMTPSA id hg16sm3719883pjb.37.2020.09.22.22.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 22:52:56 -0700 (PDT)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 1/2] scsi: sg: use queue_logical_block_size() in max_sectors_bytes()
Date:   Wed, 23 Sep 2020 13:52:47 +0800
Message-Id: <20200923055248.1901-1-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Logical block size was never / is no longer necessarily 512.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 drivers/scsi/sg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630..8a2cca71017f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -848,10 +848,11 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 static int max_sectors_bytes(struct request_queue *q)
 {
 	unsigned int max_sectors = queue_max_sectors(q);
+	max_sectors *= queue_logical_block_size(q);
 
-	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+	max_sectors = min_t(unsigned int, max_sectors, INT_MAX);
 
-	return max_sectors << 9;
+	return max_sectors;
 }
 
 static void
-- 
2.28.0

