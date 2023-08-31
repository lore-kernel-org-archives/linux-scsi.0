Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F39C83F10
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 05:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbjHaFVV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Aug 2023 01:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjHaFVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2023 01:21:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A98D2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 22:21:18 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c0c6d4d650so3245865ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 22:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693459278; x=1694064078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hea6ttDxoQcRjJHuwIEdHNc/cVhyEoaQmE2rNnsX2qg=;
        b=eSsmzR0ogMqO49FqNcxcZgLC9tko4DoF4M4b+hBtjNO8OeGKWJusi2DZKwzRsQAao4
         bxFwA92Swd8cSu5lg8WsDPsMYQGe7FVYTC3E011MBsS7FvcCqrbYO3DDcwsDVRWm0WQ4
         3hsm2uTBWgVJPDIhkznYpe5RO3SaywsRPFJmK5yZ54ItrbuRafbime1qe8j3epbbGfcD
         ehyXiD2jZ87ZSZlu+I1fTxvuqKWH+CWsQs/+GA4SPgingPMnYUcR86fI+y2lPqR6YY5R
         inXWcMao+cvRH2T9Qxy5AA9ob7JzixhQNSIcPUYmC8eFRBgKgCgijeM21xgdhxdyTW0E
         WVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693459278; x=1694064078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hea6ttDxoQcRjJHuwIEdHNc/cVhyEoaQmE2rNnsX2qg=;
        b=E03aRxpn/XwypfdrU/Wa4HnG/mF6qo2tcFbqwfiWAeVVF4Uak3jyE/oeVAFv/HXdrs
         ahBaoKp1RGYbGhQrnfSe3wZk1k9jG73R9NkbJpxtiXcBwsr1C9CQtbzPdgHX0OUAbG7C
         bT1+BTD2e1Hqb9RQDFRXV1azP2G6uza4o4cZLNyXbkYyfWRLDAVJQWxq0VROACUxmUWr
         I+mesP5ZnzB0xfz2+fAYIKkdbdBpn/K+KGlFaACHPbKl6m9SKgAp/ryTYb8siWzmc9JF
         AK6P3HweYxYKZo4rNqkFYyE/gughQEmeG2yH0l9P+1PwKaiYDVHZhMotbdbpZ+Vdj0K1
         Nhiw==
X-Gm-Message-State: AOJu0YyM8mIgReUzDN+GG83gFtKNMtthtlZZwM4UF7LWxa29OL+Yw4uZ
        MXCpgbGgzeTJdDBLxV68aS2VARzTlczRrg==
X-Google-Smtp-Source: AGHT+IFPqFpP8L99leVam6oGRV+FB41UblVN2+n4u6sVkchpZ7TLgXNG9o8yG/D1Txzvm3kR/qEmag==
X-Received: by 2002:a17:902:ea8d:b0:1b8:400a:48f2 with SMTP id x13-20020a170902ea8d00b001b8400a48f2mr4396141plb.62.1693459277570;
        Wed, 30 Aug 2023 22:21:17 -0700 (PDT)
Received: from xavier.lan ([166.70.251.153])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e80a00b001aadd0d7364sm414006plg.83.2023.08.30.22.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 22:21:17 -0700 (PDT)
From:   Alex Henrie <alexhenrie24@gmail.com>
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        martin.petersen@oracle.com
Cc:     Alex Henrie <alexhenrie24@gmail.com>
Subject: [PATCH] scsi: ppa: Fix accidentally reversed conditions for 16-bit and 32-bit EPP
Date:   Wed, 30 Aug 2023 23:19:42 -0600
Message-ID: <20230831051945.515476-1-alexhenrie24@gmail.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conditions were correct in the ppa_in function but not in the
ppa_out function.

Fixes: 68a4f84a17c1 ("scsi: ppa: Add a module parameter for the transfer mode")
Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
---
 drivers/scsi/ppa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 19f0b93fa3d8..d592ee9170c1 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -307,9 +307,9 @@ static int ppa_out(ppa_struct *dev, char *buffer, int len)
 	case PPA_EPP_8:
 		epp_reset(ppb);
 		w_ctr(ppb, 0x4);
-		if (dev->mode == PPA_EPP_32 && !(((long) buffer | len) & 0x01))
+		if (dev->mode == PPA_EPP_32 && !(((long) buffer | len) & 0x03))
 			outsl(ppb + 4, buffer, len >> 2);
-		else if (dev->mode == PPA_EPP_16 && !(((long) buffer | len) & 0x03))
+		else if (dev->mode == PPA_EPP_16 && !(((long) buffer | len) & 0x01))
 			outsw(ppb + 4, buffer, len >> 1);
 		else
 			outsb(ppb + 4, buffer, len);
-- 
2.42.0

