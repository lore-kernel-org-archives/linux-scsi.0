Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C126C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B16225AB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbhAKKXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbhAKKXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 05:23:01 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDC5C061786;
        Mon, 11 Jan 2021 02:22:21 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a12so15766515wrv.8;
        Mon, 11 Jan 2021 02:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=q7Ut8wyd+vcrdq5TTR35m8gBt8Gz8AEpFHytc1d7o3o=;
        b=X6z5Ie2/PoLrjneF7/9zRg9FK3zHBOoBKJj44ntLsUEn4+kX0kiAWOrumhDW70sUJP
         PZpk5Zg3goIRX6HMnWCc8w6+33kxfrTv3SMRIzcaU/ukXvSTb08GXdMg+6X6l3X3EZja
         2uc/52BDjYSHW/p53bQ1r8UIrwovpF0VfLW7U6GqaptZ+rVo2XvVbWXgPNRc0T9HifRG
         cCogC5Jn/kf4RBKQBK3KPW4EtOOCbluZFeNv6A3Kk9PQ1ZM8wjIfhkj7mk3LTs7+eRzX
         tbmx3wfU+nUX2IBLV9JHMNVBvs9XNzcdmOGKDuz+5ggVehsTfN6lNZ0r2sWTs1udwoa9
         eSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q7Ut8wyd+vcrdq5TTR35m8gBt8Gz8AEpFHytc1d7o3o=;
        b=SDDifoXphnmK8mlDbkWPZNfqlkZZJeuJ1Jirtvv9d6Bz2fAts0KG7gNMdQfffP/4zR
         Ovis2om9O3ajMeQzfY9aHEaWq2+J8/FZ4RZlp4J8lP7eTIlNoXiBTJCS8sVpJFhB/e24
         urVB18BOJ9Qbs3IoIg1jbK/BxMb5dm5UZv/pySJ3WW8hbcClIY20H++zk521ZBEYBDh2
         V1BXsvp9stGILS/w+6BghKxHF8NnpdVJbCmAG/tmb2oVZs/1rDdASbgNoO6VXSGVF8m4
         jEUFtjaXzmsKQkpwli92GjNANYGw5+8LwjGl56devFlb1N70f/9lQQlhJomg8VhMVYMp
         FGag==
X-Gm-Message-State: AOAM533Wwl+En0zTDugpjO6DwbZpTvw+FSfm6ReTVFDNxL/2BgDJgGCL
        u1dcJ5tSkLMGkgB/asZqzgw=
X-Google-Smtp-Source: ABdhPJyV/RPT9lqtiYfVdLtTlc/+U9FXDn+2X4J5n0EhwjjTPRKrolDp81kRQ00Jy04M5oAWJy/gpw==
X-Received: by 2002:adf:e452:: with SMTP id t18mr14927572wrm.177.1610360539822;
        Mon, 11 Jan 2021 02:22:19 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d2f:cf00:597a:a5a4:31de:992e])
        by smtp.gmail.com with ESMTPSA id m11sm20879996wmi.16.2021.01.11.02.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 02:22:19 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH -next] scsi: docs: ABI: sysfs-driver-ufs: rectify table formatting
Date:   Mon, 11 Jan 2021 11:22:12 +0100
Message-Id: <20210111102212.19377-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 0b2894cd0fdf ("scsi: docs: ABI: sysfs-driver-ufs: Add DeepSleep
power mode") adds new entries in tables of sysfs-driver-ufs ABI
documentation, but formatted the table incorrectly.

Hence, make htmldocs warns:

  ./Documentation/ABI/testing/sysfs-driver-ufs:{915,956}:
  WARNING: Malformed table. Text in column margin in table line 15.

Rectify table formatting for DeepSleep power mode.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Adrian, please ack.

Martin, please pick on your scsi-next tree.

 Documentation/ABI/testing/sysfs-driver-ufs | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index e77fa784d6d8..75ccc5c62b3c 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -932,8 +932,9 @@ Description:	This entry could be used to set or show the UFS device
 		5   UFS device will be powered off, UIC link will
 		    be powered off
 		6   UFS device will be moved to deep sleep, UIC link
-		will be powered off. Note, deep sleep might not be
-		supported in which case this value will not be accepted
+		    will be powered off. Note, deep sleep might not be
+		    supported in which case this value will not be
+		    accepted
 		==  ====================================================
 
 What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
@@ -973,8 +974,9 @@ Description:	This entry could be used to set or show the UFS device
 		5   UFS device will be powered off, UIC link will
 		    be powered off
 		6   UFS device will be moved to deep sleep, UIC link
-		will be powered off. Note, deep sleep might not be
-		supported in which case this value will not be accepted
+		    will be powered off. Note, deep sleep might not be
+		    supported in which case this value will not be
+		    accepted
 		==  ====================================================
 
 What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
-- 
2.17.1

