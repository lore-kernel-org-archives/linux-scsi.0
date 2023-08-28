Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B59C83F14
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Aug 2023 22:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjH1W0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Aug 2023 18:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjH1WZ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2023 18:25:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD07E13D
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2023 15:25:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5924b2aac52so50772597b3.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2023 15:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693261555; x=1693866355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WL1tQymiA0QNtSV27nV5+wlwcB60k6N2NSD+c5q8HQg=;
        b=JoHOoN5AHuQ86eXhnjG3U070yK9cvNyS2AVvroFNhguy50VpeQ6WU9xS9/gk+nVAW8
         cB8tMKGkgUUYQ7fBsfIXzzgEUTzDq1UXuakUOvqqjLSyjTSUfSlvxTT2LARSAcZCsL+6
         qb2mda588RKdSlMncA/n0D8yWn/Pb/YH/EzPY/9s+I2xe65rmxP+Zibu7Uj+CeUAwaFK
         LnYAkfhxfXxdUg66d9HTkdIepibDIgth6uCGBkmKPmIdVHDcWJKPY2US7FNfuaioy3Z6
         Z0kBxnEJ61tDFKgoC79rSf2QJwuSxRyoBJCn1REEKlemHGgSt2TQ/310romCB3WlO2oN
         tO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693261555; x=1693866355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WL1tQymiA0QNtSV27nV5+wlwcB60k6N2NSD+c5q8HQg=;
        b=aGF6f6yl0xQcG2DAy5tpg/EOZHq37ovgykuUgt8qbcY0W3qYdOi3dPeoKUlGI3lNea
         t0Dpe9MI3oW7Ifw+E7Ncp5HkO2k/ttW4gsaxyaZ2s4Bcgv2T9ogp50epMtug8cl1wq4d
         J4cegadZAE2TKQq340M89q2eVkSuh9BxL/axg5IAeD1Bj0AvK1oLKBXnS0mDrHrm9G5j
         VonapotOxaZkZaEGU4RnyoWEAtZKmHLrruy7JTqgNfV1hVafGGCjRuT76q8/mo7YDH1n
         E7FDAtqTP+ZhQMhIHxIM0LuEJZRrMKalWwLaGyVZC09+ULifjCX5qyBMb6A9NMmCZ2Li
         V/3Q==
X-Gm-Message-State: AOJu0Yz95aS1jvbFihafrsb1/c45XPHjRKQt1R3EQw5gBVYAomw+fZwt
        ovIyUnH6CB+E+K2xRE+Vhzwr5Qb4OFFT+zpKXSM=
X-Google-Smtp-Source: AGHT+IEHx1L4auj/EdI7SADc9H3MwvX/vPnn5w8vp1/S1Yz4HvTE6wVG99CwlClV81ou70LXLC9pxdtTeMr8Ap710PU=
X-Received: from ndesaulniers-desktop.svl.corp.google.com ([2620:15c:2d1:203:b64:7817:9989:9eba])
 (user=ndesaulniers job=sendgmr) by 2002:a81:ae06:0:b0:573:87b9:7ee9 with SMTP
 id m6-20020a81ae06000000b0057387b97ee9mr829678ywh.4.1693261555125; Mon, 28
 Aug 2023 15:25:55 -0700 (PDT)
Date:   Mon, 28 Aug 2023 15:25:48 -0700
In-Reply-To: <20230828-scsi_fortify-v1-0-8dde624a3b2c@google.com>
Mime-Version: 1.0
References: <20230828-scsi_fortify-v1-0-8dde624a3b2c@google.com>
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=eMOZeIQ4DYNKvsNmDNzVbQZqpdex34Aww3b8Ah957X4=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1693261549; l=3338;
 i=ndesaulniers@google.com; s=20230823; h=from:subject:message-id;
 bh=QVZghMLPP42usKlaJQTZjiZHzXDWVKPfY+QwZHJyIKk=; b=PtTKGhzagQppTiG/eusxtBe/ncoCdao9ylHQtdEesrL9MNPm094c3VNQzvmSFiFi+bCIdx0j0
 /87XN3v+sIwCZ8O5qbGc7RbENymwoeWEuxMauBVAgPfdGfwDIBsvuap
X-Mailer: b4 0.12.3
Message-ID: <20230828-scsi_fortify-v1-2-8dde624a3b2c@google.com>
Subject: [PATCH 2/2] scsi: myrs: fix -Wfortify-source
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     Tom Rix <trix@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clang-18 has improved its support for detecting operations that will
truncate values at runtime via -Wfortify-source.

Fixes the warning:
  drivers/scsi/myrs.c:1089:10: warning: 'snprintf' will always be
  truncated; specified size is 32, but format string expands to at least
  34 [-Wfortify-source]

In particular, the string literal "physical device - not rebuilding\n"
is indeed 34B by my count.

When we have a string literal that does not contain any format flags,
rather than use snprintf (sometimes with a size that's too small), let's
use sprintf.

This is pattern is cleaned up throughout the file.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/1923
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 drivers/scsi/myrs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index a1eec65a9713..729f08379bd0 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -939,7 +939,7 @@ static ssize_t raid_state_show(struct device *dev,
 	int ret;
 
 	if (!sdev->hostdata)
-		return snprintf(buf, 16, "Unknown\n");
+		return sprintf(buf, "Unknown\n");
 
 	if (sdev->channel >= cs->ctlr_info->physchan_present) {
 		struct myrs_ldev_info *ldev_info = sdev->hostdata;
@@ -1058,7 +1058,7 @@ static ssize_t raid_level_show(struct device *dev,
 	const char *name = NULL;
 
 	if (!sdev->hostdata)
-		return snprintf(buf, 16, "Unknown\n");
+		return sprintf(buf, "Unknown\n");
 
 	if (sdev->channel >= cs->ctlr_info->physchan_present) {
 		struct myrs_ldev_info *ldev_info;
@@ -1086,7 +1086,7 @@ static ssize_t rebuild_show(struct device *dev,
 	unsigned char status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not rebuilding\n");
+		return sprintf(buf, "physical device - not rebuilding\n");
 
 	ldev_info = sdev->hostdata;
 	ldev_num = ldev_info->ldev_num;
@@ -1102,7 +1102,7 @@ static ssize_t rebuild_show(struct device *dev,
 				(size_t)ldev_info->rbld_lba,
 				(size_t)ldev_info->cfg_devsize);
 	} else
-		return snprintf(buf, 32, "not rebuilding\n");
+		return sprintf(buf, "not rebuilding\n");
 }
 
 static ssize_t rebuild_store(struct device *dev,
@@ -1190,7 +1190,7 @@ static ssize_t consistency_check_show(struct device *dev,
 	unsigned short ldev_num;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not checking\n");
+		return sprintf(buf, "physical device - not checking\n");
 
 	ldev_info = sdev->hostdata;
 	if (!ldev_info)
@@ -1202,7 +1202,7 @@ static ssize_t consistency_check_show(struct device *dev,
 				(size_t)ldev_info->cc_lba,
 				(size_t)ldev_info->cfg_devsize);
 	else
-		return snprintf(buf, 32, "not checking\n");
+		return sprintf(buf, "not checking\n");
 }
 
 static ssize_t consistency_check_store(struct device *dev,
@@ -1376,7 +1376,7 @@ static ssize_t processor_show(struct device *dev,
 			       info->cpu[1].cpu_name,
 			       second_processor, info->cpu[1].cpu_count);
 	else
-		ret = snprintf(buf, 64, "1: absent\n2: absent\n");
+		ret = sprintf(buf, "1: absent\n2: absent\n");
 
 	return ret;
 }

-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

