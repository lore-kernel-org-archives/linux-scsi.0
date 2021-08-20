Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9144C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B887B600D1
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbhHTDNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhHTDNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:13:24 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE2FC061575;
        Thu, 19 Aug 2021 20:12:47 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id m21so9464602qkm.13;
        Thu, 19 Aug 2021 20:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=akZ47LkIwJza3NQSjT7KsUOp7i2Wia4p8p52WL3MA+U=;
        b=CGBrFBV1rf31iSSYo4dsKmXUBY5wv+gI8d8hOHMuxSdqqTc35xM1BExNLqgpz0ktSL
         1SeBZWIfjcLPyLDVCol8sUS+ofj99pZsXC5EcS+w/gw+osD4SBLLLM9A8rHbUW+I9k0a
         vxLP45CozETKeuVE/TGvrtXWJpxbgvi2bTHRyZnmBV0IuAZ67VvipCWeR2cEQCj2otab
         TuwbgObZ4FMQIznzrknQlWXvfPntwfdby5bkY0GqKeMU2Nk66ql/CRfhgfyfDwzGMvyG
         rA/Pl578Q9v6RD72EPM4GdIgzLRsKi0QZqhVY8rpjagvojkkyVaY39W/5F1ZQJvqwIJb
         d+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=akZ47LkIwJza3NQSjT7KsUOp7i2Wia4p8p52WL3MA+U=;
        b=DMpxo/9jsfzWVB2rcRiLt2sbluWTVjQL5Ek074IaBjy+U/96Lc/4nApOOf9zDo5Kka
         u6nBoHfXTtycM4B6i61c8N3/L+pnjEU8sl5SabI9M14Zaqz4dsanK8Wlz6hIMCJsx1lg
         EVH5m7yld57FKfBUf4i7OMfbnbavYNCqvsFO3ZiSy89XIbfqUs6JIk1URiRGiHOTm9v0
         SnXQBjYpkAaLYNcIQYo7cfhsrylIMZ0QPJr/WhHb45ZyayJqxmwEJ+CNhWvJ0WJPxTjH
         qhJ5MKXYgRsHdc23tjI0crW1OQ2jiNjNg0iqJKamzOEgWDJL6qmN+cL2FK0aZvMYYT0W
         d5IA==
X-Gm-Message-State: AOAM531hY8F+nvpaqlp7sFJ6vSoxy4nU7GGALlyW7aPI3NUSSCxITzn0
        G1OpT9t2IUMTdZqsiE1H6mQ=
X-Google-Smtp-Source: ABdhPJw+KatUs12uZ3pwyM3LT4m2Jraj+KssxFGkMPnVratIdCrKKV/cBSD+LmOcyDkpmXFTNqd3Lw==
X-Received: by 2002:a05:620a:4495:: with SMTP id x21mr6633680qkp.378.1629429166399;
        Thu, 19 Aug 2021 20:12:46 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g131sm2664735qke.122.2021.08.19.20.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:12:45 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] scsi/ncr53c8xx: Use bitwise instead of arithmetic operator for flags 
Date:   Thu, 19 Aug 2021 20:12:35 -0700
Message-Id: <20210820031235.12535-1-jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

This silences the following coccinelle warning:

"WARNING: sum of probable bitmasks, consider |"

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 drivers/scsi/ncr53c8xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 09958f7..5c27afb 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7910,7 +7910,7 @@ static void __init ncr_getclock (struct ncb *np, int mult)
 	/*
 	**	True with 875 or 895 with clock multiplier selected
 	*/
-	if (mult > 1 && (stest1 & (DBLEN+DBLSEL)) == DBLEN+DBLSEL) {
+	if (mult > 1 && (stest1 & (DBLEN | DBLSEL)) == DBLEN | DBLSEL) {
 		if (bootverbose >= 2)
 			printk ("%s: clock multiplier found\n", ncr_name(np));
 		np->multiplier = mult;
-- 
1.8.3.1


