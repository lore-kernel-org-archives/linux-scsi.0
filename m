Return-Path: <SRS0=2nUe=ID=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC00FC433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 19:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F638650A7
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 19:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhCETA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 14:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCETAZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 14:00:25 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582B6C061574;
        Fri,  5 Mar 2021 11:00:25 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id e19so5521130ejt.3;
        Fri, 05 Mar 2021 11:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KMdaJSUMmLRk5FOS+WMQdoLbWsr2JVXLoAfRRHzV4ac=;
        b=g+VuYp/6NZtF7tFXTNcHh54w/DG/LYdbEZOL99k+Fdtau+nNyAH/0/sJREFXLJTp60
         /I7dagVs2fx7vcT+MDtJeg8AnLxhYtVmdoo5dGR63cPaLS/SaIO9dvz19TGjilW2fHjH
         4x3g6MF1EF9FaNh/JN3Ca8WrxEmpoOURSKKOGtRL6vPs9CT3AEKSugb5i+t8Va+Wz8Nm
         xOqELjIWSdSmjM0AbSwOyacDD2Z42rvoBuQotgMwQu5i2Y/549peGaKsvplkTcdvvaNC
         slKdPLBOG/O4SXwxxF/RS7p3o7ZxnpDxtBaKF9vio1WhlOBNpycxg7lb9bzRfhY1afKX
         cz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KMdaJSUMmLRk5FOS+WMQdoLbWsr2JVXLoAfRRHzV4ac=;
        b=HqE04gUK2u7FNxiAqIdzmLGpibQOhvF+Bh+hdtrt5LjYMs7v8oGg554r6pyLvW0LcA
         FeVBvNf96jeTDzXNcq7/RgHIrB00NflVY4puBaozhBlh8pdPDc2GrmF4Uu62ZQVvnQ3r
         r0gObB+Qsnl56QFSKLB3G62szXDjzX6kFZHOhnp7icRyaTOtcHONCvLhdK8mvipCxAMi
         t141ccmal1LtMVax4FIXRcfYdeWdEbe8K7tSZj97Jojsh0ohe5GlCniqxqDOFADjvLmi
         en/PKok4wpO+3HVtXFyYjzvQgAEBrPxriuTCWogJ1oR3aiQAtu8b6WlMxs+OzDBaz/eO
         mijw==
X-Gm-Message-State: AOAM530W4a7FHsAm5FMg5v5gLOO98fz3CcCqvassbONIdoqJRTyXZaq8
        GXAesnl0/2YmXYCClwMl7FvKqguqql0=
X-Google-Smtp-Source: ABdhPJxZ1arKLdcaw7ZzQSDFL+ahdZ1OQzJpcpwVXD4iD9MPDZOTy/TFKFhuoXLQzT0w6CZyx/9lrw==
X-Received: by 2002:a17:906:38da:: with SMTP id r26mr3785618ejd.251.1614970821991;
        Fri, 05 Mar 2021 11:00:21 -0800 (PST)
Received: from localhost ([188.193.20.102])
        by smtp.gmail.com with ESMTPSA id bv9sm1946269ejb.21.2021.03.05.11.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 11:00:21 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH] scsi: target: tcmu: Use GFP_NOIO while handling cmds or holding cmdr_lock
Date:   Fri,  5 Mar 2021 20:00:09 +0100
Message-Id: <20210305190009.32242-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Especially when using tcmu with tcm_loop, memory allocations with
GFP_KERNEL for a LUN can cause write back to the same LUN.

So we have to use GFP_NOIO when allocation is done while handling
commands or while holding cmdr_lock.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---

This patch is based on Martin's for-next branch plus my short
series "scsi: target: tcmu: Replace IDR and radix_tree with XArray"
See:
 https://lore.kernel.org/linux-scsi/20210224185335.13844-1-bostroesser@gmail.com/

 drivers/target/target_core_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index ada3ef982969..9e1b115cb032 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -518,7 +518,7 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 		if (!page)
 			goto err_alloc;
 
-		if (xa_store(&udev->data_blocks, dbi, page, GFP_KERNEL))
+		if (xa_store(&udev->data_blocks, dbi, page, GFP_NOIO))
 			goto err_insert;
 	}
 
@@ -1272,7 +1272,7 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
 		 tcmu_tmr_type(tmf), udev->name, i, cmd_cnt);
 
-	tmr = kmalloc(sizeof(*tmr) + cmd_cnt * sizeof(*cmd_ids), GFP_KERNEL);
+	tmr = kmalloc(sizeof(*tmr) + cmd_cnt * sizeof(*cmd_ids), GFP_NOIO);
 	if (!tmr)
 		goto unlock;
 
-- 
2.12.3

