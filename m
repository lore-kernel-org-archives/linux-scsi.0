Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99971C433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C48D2087C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBkwK5CA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgIDUGU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 16:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgIDUGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 16:06:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C4FC061244
        for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2020 13:06:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id w186so4860810pgb.8
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2020 13:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bg1T/4Ha1GXOocbDAQsf5gtGn1bi3WAb271zUVCosk8=;
        b=XBkwK5CA0CApuYZMzegPF4t+Xxim413gDj4R5lhx1BRnPYsKrDTq16u9Uv4rytwh4W
         xBhI35mqqC87mMXxzDoHPzu+S4QPnUtdQ4oxC2KfwOja4EGGj0qEggK/3q2YmVe2PO3u
         /rbCB4KfGkpwKehabVYBQ2lCFlRO/1UdxNQMBQ/Qob6gMo8YaBSsJHoxCgibBFRvMIwE
         q+4Kr6kGvD5twGcMVgb4x21RRj+Yo+dkyyAmKZpmDk/Iaq/Eqli+fsKZFFVjWx2KHtvU
         oIHsqDZ+OjwWBrKV8hlJxw4UbZnvPoxwJDm0X2mbZl/HK/8l3sTPcE/45/4uZCvI5Kct
         EUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bg1T/4Ha1GXOocbDAQsf5gtGn1bi3WAb271zUVCosk8=;
        b=l8DlelapmKox1zBpgFU+K3OFJMp4wY3+HusZOZrfMOO77Aiaikgv+dgSg13Idode8A
         03d2ZKyw/oiAuiteGbby5Rm46/e9syU1Q84I1wWIicbCSAumhO5NigYoqlL//rgbZ06g
         jv/4jfF2eZeotsmpT59HxgaK1yNdHBKIR2LH+EK+/6Yl7jvukAwjhn2wOXEW764NfZpI
         uog/IHIlxRWTtv8mt2WrI6ymlvEQCQsZg5J8IXzEUbwu+5NmQVFvvNg/NtOgBMD49fpS
         b+YMqs27Lf9cg9rL1bjxBgCuYepuBXyc+Sbn6rWhNscZaNLiwXHTiVa0nzrCKjugtoPh
         9yVg==
X-Gm-Message-State: AOAM531v1bOqR7f2m6h68TSl5H5MxURjEWCG1BqQpktwoN7WuqvaEihX
        Poa4Jk/ViWuhLQJVQZ2iBaUZe0lwHBI=
X-Google-Smtp-Source: ABdhPJxtgzwVWt89jgU4AKB3SpR+NtDBnBl8kMwQdX5yankr/j1IjHFyPMziNt5ixwnInA/C5lZdQQ==
X-Received: by 2002:a63:e1f:: with SMTP id d31mr8723418pgl.262.1599249974143;
        Fri, 04 Sep 2020 13:06:14 -0700 (PDT)
Received: from localhost.localdomain ([161.81.62.213])
        by smtp.gmail.com with ESMTPSA id k5sm21131905pjl.3.2020.09.04.13.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 13:06:13 -0700 (PDT)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc:     stern@rowland.harvard.edu, James.Bottomley@SteelEye.com,
        akinobu.mita@gmail.com, hch@lst.de, jens.axboe@oracle.com,
        Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 4/4] block/scsi_ioctl.c: use queue_logical_sector_size() in max_sectors_bytes()
Date:   Sat,  5 Sep 2020 04:05:54 +0800
Message-Id: <20200904200554.168979-4-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904200554.168979-1-tom.ty89@gmail.com>
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 block/scsi_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ef722f04f88a..ae6aae40a8b6 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -73,10 +73,11 @@ static int sg_set_timeout(struct request_queue *q, int __user *p)
 static int max_sectors_bytes(struct request_queue *q)
 {
 	unsigned int max_sectors = queue_max_sectors(q);
+	unsigned int logical_block_size = queue_logical_block_size(q);
 
-	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+	max_sectors = min_t(unsigned int, max_sectors, USHRT_MAX);
 
-	return max_sectors << 9;
+	return max_sectors * logical_block_size;
 }
 
 static int sg_get_reserved_size(struct request_queue *q, int __user *p)
-- 
2.28.0

