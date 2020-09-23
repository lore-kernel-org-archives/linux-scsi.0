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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3774C4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 05:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C31A221EB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 05:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CH3Se/5E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgIWFxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 01:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgIWFw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2020 01:52:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAF4C061755
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 22:52:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id bw23so2648926pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 22:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dyqT5DAvLDgsGMi6Y/ooNL+LKnGqQcxgtFjfUSbSM2I=;
        b=CH3Se/5EJCMjBzsjprzZ0piXXnGcN1kFDC+AvG79KsBkcl9hYso65JQlWurB81YV3p
         WhBEJMjM4qr4fyU9IR1I/ehz7iNTxXqcaGo+R20qr5+hxZnj6+esBWwsyk02kDwXq8MY
         sfILrYJEwyd0WVt9uLFJip/lAK/f5Pu4yfRUchIJLdRRp+s0WzKMLNuoYhyQHd4yOFVr
         jHQXKDeXEYgRPEBvL0asNHrAexroqk+2NgFTBNs80eWmwtQ8tlzQOHggWqAnGZ4GWvQ3
         EL+zJVsAvYeyGANqPHRs2PWSA4PzboSMnlyC9hDhIsO7ETNU3ldTw4P5IGbCsCRnAQyS
         kZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dyqT5DAvLDgsGMi6Y/ooNL+LKnGqQcxgtFjfUSbSM2I=;
        b=eFU/xxbQCX88nMyLvfakXOX7LRlEmG1AJi4Oky7fJNVMcVCmeSsfAjYwiVMcEtUBgn
         hCMosN+P10jyAYd9xaCimPeM2Prx8H2pj5GRZFBu6wRHDEVKJiuqRYMg2uCIKWPP/NNs
         bDgZoXdVozJOmNVHjWjux78T2/0P508xwcZBpoF+Vgh4UW1mZfBkAHRETNBuHJAFbjM8
         jq4H+dLr/bVjrddSZW47Bap796OrPR1Uwc9cVfeq1EXMxtPBAdJm/jvbzOgWGVRQVO31
         Yn9zJxfEq2T6+hD5OOXXx14ag0JWXv745iMd/+QfZUGzuTl0c8zjrYdgOtR91QwDGkbB
         NspA==
X-Gm-Message-State: AOAM533kv0acaPNXOrxF0e65ABf8kU1LjctnwZC/SEY4GS4froI6WxAt
        VeMbgj87NICHz1ILrRsB+B6oRVLQZHgQmA==
X-Google-Smtp-Source: ABdhPJzpo1RO0xCcOR+10lbhN73Pr8wdvEqa5/Z9WNlQXcWuQ5562WiPZf4h3qKcv37HjrYvxqo5kQ==
X-Received: by 2002:a17:90a:120f:: with SMTP id f15mr7027092pja.120.1600840378732;
        Tue, 22 Sep 2020 22:52:58 -0700 (PDT)
Received: from localhost.localdomain ([161.81.44.186])
        by smtp.gmail.com with ESMTPSA id hg16sm3719883pjb.37.2020.09.22.22.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 22:52:57 -0700 (PDT)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 2/2] block/scsi_ioctl.c: use queue_logical_block_size() in max_sectors_bytes()
Date:   Wed, 23 Sep 2020 13:52:48 +0800
Message-Id: <20200923055248.1901-2-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923055248.1901-1-tom.ty89@gmail.com>
References: <20200923055248.1901-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Logical block size was never / is no longer necessarily 512.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/scsi_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ef722f04f88a..82ed73f07460 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -73,10 +73,11 @@ static int sg_set_timeout(struct request_queue *q, int __user *p)
 static int max_sectors_bytes(struct request_queue *q)
 {
 	unsigned int max_sectors = queue_max_sectors(q);
+	max_sectors *= queue_logical_block_size(q);
 
-	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+	max_sectors = min_t(unsigned int, max_sectors, INT_MAX);
 
-	return max_sectors << 9;
+	return max_sectors;
 }
 
 static int sg_get_reserved_size(struct request_queue *q, int __user *p)
-- 
2.28.0

