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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDD3C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 20:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 419BE6191C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 20:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCVU6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 16:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhCVU6i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 16:58:38 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C6BC061574;
        Mon, 22 Mar 2021 13:58:37 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id dc12so8503242qvb.4;
        Mon, 22 Mar 2021 13:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+i64MrNHZeNipUIh6gltiMTjMH/gV+ocvWjnAF2kjp0=;
        b=mAFh5WEgO1INbLn/eAZO6mUQDJl99WcSTfFk44CRc70nKKFGV3W43ma1h7eMc31vGS
         C23yLw1c6k2RfsuEkQAOOXKMsPmlMG/iniAcwporLUoTKO5dgqmWs35kT02o/BkXrihI
         +t6uTMQfcv6UTbjglr85NpXPN3EUN0o2CDT0HxesHRI1lJ3rJs5aDKIp4X2nJX85a/yK
         NgtLcFJ3beJeg/Xpddm5z3Pi24QshysdmbfCgYvLa6gMY8Nz7nkn6VzxXwkB9ktD2DS4
         Jxx6V9PDIOaAf3+Y7fa4zWkgMBjxcoHT7ZliglyjyUiF2zhb9u1nh3KzGL+POjy8ouSx
         usBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+i64MrNHZeNipUIh6gltiMTjMH/gV+ocvWjnAF2kjp0=;
        b=Ky9sbqLRLTPTYU0hTgXncNf5R82b3b+0KW8Y2szEDMHa3iepG1rhYREDO41m4FeqzG
         HHTnabsxPtYL+d8rxRDDlYss1JgXAOxOnI0aRWVAolT1RfAaeal2IUGD1ED2+aopaPFS
         bqeBoRWD4MnqPPjWTwOKm2Hs37+dR0ytnYLDQ581LEI4+knJPqhTtnJLaX4h0d5zP5xG
         Yz/s/+hsPUT4OCui1oh8qLn3WRTt9Ju3JklNU3NqYBEcMBXySrYjEPAP6hrHXUmBos5t
         RluwcLWUHQsQxh/jMlPNZO16d3zsDT9FaBvpFwymX6s4Rr4SUdn1FVRpBDftsuap44jn
         LiVA==
X-Gm-Message-State: AOAM531+4hJzhkb+7Bqs3z+7LL5jiESbAjDPwkIG7y+ysp3yfY/3lrvi
        U+Wex1dvbMKxbzpRosURpnd4IniZUDaCCtr+
X-Google-Smtp-Source: ABdhPJwF8WFth20bf6P3IQm/LFI6HDq1NZYOnO5OihwSX9M8OzJ9sqcWalEZi/vsddM5iLFgRW9QRQ==
X-Received: by 2002:a0c:f541:: with SMTP id p1mr2030073qvm.14.1616446716414;
        Mon, 22 Mar 2021 13:58:36 -0700 (PDT)
Received: from localhost.localdomain ([138.199.10.68])
        by smtp.gmail.com with ESMTPSA id h75sm11784134qke.80.2021.03.22.13.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:58:35 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: bfa: Fix a typo in two places
Date:   Tue, 23 Mar 2021 02:28:21 +0530
Message-Id: <20210322205821.1449844-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/defintions/definitions/  ....two different places.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/bfa/bfa_fc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index d536270bbe9f..0314e4b9e1fb 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -1193,7 +1193,7 @@ enum {
 };

 /*
- * defintions for CT reason code
+ * definitions for CT reason code
  */
 enum {
 	CT_RSN_INV_CMD		= 0x01,
@@ -1240,7 +1240,7 @@ enum {
 };

 /*
- * defintions for the explanation code for all servers
+ * definitions for the explanation code for all servers
  */
 enum {
 	CT_EXP_AUTH_EXCEPTION		= 0xF1,
--
2.31.0

