Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125F6C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 17:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACE7610EA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 17:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbhJMRSf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhJMRSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 13:18:34 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0628BC061570;
        Wed, 13 Oct 2021 10:16:31 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w14so13035940edv.11;
        Wed, 13 Oct 2021 10:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=meUYWdb8BVH+ERVVUD1vNcavs7M1t/BOCZO4+emCVbE=;
        b=jVRR/+SbGLbMEQxv10T3/4LoFsR2rWpBdBg0FFEZ82YDaGexg+pQ0DYs97MtiPRrXf
         RlXvPOlqm79zVRD7/UriGjMfAL8PNkjkLb0O7mYpTbayYX9EbEi40m2TXwcVaEXQAmCH
         VxojX/R8cOeE6kW80Ff2ix3PfR1En00jaXM4cHOimNjeajtEqUnzp3j6LogK28xs2qf4
         AMijJn7Bskfh/hFe92Jpb7Ism0G1DT4OixOa8T5VOznF4WmU0Kq+gLY/we1D5cWpy7Mh
         lidnCk0VQD9pt9MyaH4YsOglzBMcmq+G9+DIwI4iT7NR8WPM3c9dFWdGFhlFfXjrEkCq
         KC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=meUYWdb8BVH+ERVVUD1vNcavs7M1t/BOCZO4+emCVbE=;
        b=qjgLYwvN2IyX/BDD+MhRddBy9Lf/mGoNCgenpJVRsICfByrX6m328HeK6bzPJse0Y9
         7i6BCJd7LZMZw3aYvVJXki+Fsf3vvv7QcuGJ9fylJdWgrJTtYVjKDQlMdVHWr/wFXJbz
         nTEdjttGH6YCa7ulNrzbK/+qY7mKKZdU95+bwoiPkrYDP7V/FgPW2/0PovAfQM/OxgUz
         1RwCdig418xwYDg/7r8k6ODXFla4vRdXV3OyqUr3hnOFhmgAbXMjG9x05MCfFn6xZPQK
         tolQGbt149AlyuLz0s50xGnWkcAT8ElSGAFWhtvWJ4flMm1QSPtaEnp7dBXXFSEhhy0N
         LRUA==
X-Gm-Message-State: AOAM530oojbRzkaHlZu/LS3lj5W31NXHLTValzpseAWmR8QOjhnSTNbk
        jKtpj80dQ51J9Ou+Lt8TZce8VF5uzkc=
X-Google-Smtp-Source: ABdhPJz+PMeUl1mCh5APvyddfyKOozejgyineYoZpcBqqKP6ej6Yl3Au0xMYJ8USF79wBd0X0P2CPg==
X-Received: by 2002:a17:906:da08:: with SMTP id fi8mr567732ejb.552.1634145389543;
        Wed, 13 Oct 2021 10:16:29 -0700 (PDT)
Received: from localhost (ipbcc061e7.dynamic.kabel-deutschland.de. [188.192.97.231])
        by smtp.gmail.com with ESMTPSA id i6sm129241ejd.57.2021.10.13.10.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 10:16:29 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH] scsi: target: tcmu: allocate zeroed pages for data area
Date:   Wed, 13 Oct 2021 19:16:06 +0200
Message-Id: <20211013171606.25197-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tcmu populates the data area (used for communication with
userspace) with pages that are allocated by calling
alloc_page(GFP_NOIO).
Therefore previous content of the allocated pages is exposed
to user space. Avoid this by adding __GFP_ZERO flag.

Zeroing the pages does (nearly) not affect tcmu throughput,
because allocated pages are re-used for the data transfers of
later SCSI cmds.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index dc220fad06fa..a19e53877b0b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2015 Arrikto, Inc.
  * Copyright (C) 2017 Chinamobile, Inc.
  */
+#include <linux/delay.h>
 
 #include <linux/spinlock.h>
 #include <linux/module.h>
@@ -523,8 +524,8 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 	rcu_read_unlock();
 
 	for (i = cnt; i < page_cnt; i++) {
-		/* try to get new page from the mm */
-		page = alloc_page(GFP_NOIO);
+		/* try to get new zeroed page from the mm */
+		page = alloc_page(GFP_NOIO | __GFP_ZERO);
 		if (!page)
 			break;
 
-- 
2.12.3

