Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6F9C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 14:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E83161412
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 14:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhELOIi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 10:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhELOIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 10:08:37 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C815C061574;
        Wed, 12 May 2021 07:07:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id f1so5007124edt.4;
        Wed, 12 May 2021 07:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xkX4RuB/NiZK6BTfiPwydeiPPCc7ucc6NYoKB5Y8RXM=;
        b=PFKqRkTY6twIzciHACYubY4QrEg28sGdBPnGiecpz1n+teGjKcqzzk33KBBQ58Ulx5
         4u7YhDF4pQiFa/4kjw8pyo9D2aMGeJEslgzm2lc64CWTrZzLdLChJOqDgjVAGoEeuh3z
         JghvZKDo/kyaJFCRiK8j8cuRRInpmqvGwwK1n2rn9XZpyOYthCawCp/Pnd1RRpaJnxNV
         L2u2VQXQe5jEpWHtQsLny3vlYT7xiwJbS2lAYeVWx0XoncS2g0TBmLSQsYIXSiBls0D6
         WkDqyHoidE6TWVCGI2DcD6pipPJ4wsZTfXUF1fiOEZ36ZjfsnTnG/C+1eIiQOAl/i7j+
         KtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xkX4RuB/NiZK6BTfiPwydeiPPCc7ucc6NYoKB5Y8RXM=;
        b=NWnFTTmEn4yOEijJNNYOi1HZPQ2gQ9hLwSR+Y3JtKiXLtj4b12C3UXLabkhbSTq3jH
         HT6P2PRK+Y4bKvmwNniv5XRR809G6JOQoNG5aw7lMR6us3d0YVoRIrYlhAyRK6jj3EKT
         74DmbqySyog4mJkoRfO9ZQDpSsDrnWhipajvv95IlReo+/8zrVB9Ew/S7M0H3QCuJtmz
         RPTfZEDGEvknYc+hRmSm4/EOOAUQTHIE8epJtTOeA8pksBcZdyCucGh3VbzOVC3P+5qu
         29/G/No4EK2KB9A3uZN+6tbUKem2BBvMZ7mdYgb/ASIoJ+76JdHcibzN/9iqQ8nEHPIq
         LXXA==
X-Gm-Message-State: AOAM532jveVqfd2ekOazcQ5HihU99o9u9PLL7dU/+Vkay3+Lf1homJYZ
        qq8uFYP5Sh575qWqDTjUoaoWqgn3T6Y=
X-Google-Smtp-Source: ABdhPJwWzIAXg0sj+A3tzXLdDkzzC/S90ihYT040VwrgaLGcisWN1cidbJP5+CAHQFdiH8qyGGwBVQ==
X-Received: by 2002:a05:6402:3546:: with SMTP id f6mr43825548edd.267.1620828447459;
        Wed, 12 May 2021 07:07:27 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id t9sm18710289edf.70.2021.05.12.07.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 07:07:27 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH] scsi: target: tcmu: Rename TCM_DEV_BIT_PLUGGED to TCMU_DEV_BIT_PLUGGED
Date:   Wed, 12 May 2021 16:06:54 +0200
Message-Id: <20210512140654.31249-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The bit definition TCM_DEV_BIT_PLUGGED should correctly be named
TCMU_DEV_BIT_PLUGGED, since all other bits in the same bitfield
have prefix TCMU_

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index bb3b997849e5..18a4742569cd 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -121,7 +121,7 @@ struct tcmu_dev {
 #define TCMU_DEV_BIT_BROKEN 1
 #define TCMU_DEV_BIT_BLOCKED 2
 #define TCMU_DEV_BIT_TMR_NOTIFY 3
-#define TCM_DEV_BIT_PLUGGED 4
+#define TCMU_DEV_BIT_PLUGGED 4
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -981,7 +981,7 @@ static void tcmu_unplug_device(struct se_dev_plug *se_plug)
 	struct se_device *se_dev = se_plug->se_dev;
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 
-	clear_bit(TCM_DEV_BIT_PLUGGED, &udev->flags);
+	clear_bit(TCMU_DEV_BIT_PLUGGED, &udev->flags);
 	uio_event_notify(&udev->uio_info);
 }
 
@@ -989,7 +989,7 @@ static struct se_dev_plug *tcmu_plug_device(struct se_device *se_dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 
-	if (!test_and_set_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
+	if (!test_and_set_bit(TCMU_DEV_BIT_PLUGGED, &udev->flags))
 		return &udev->se_plug;
 
 	return NULL;
@@ -1123,7 +1123,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
 
-	if (!test_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
+	if (!test_bit(TCMU_DEV_BIT_PLUGGED, &udev->flags))
 		uio_event_notify(&udev->uio_info);
 
 	return 0;
-- 
2.12.3

