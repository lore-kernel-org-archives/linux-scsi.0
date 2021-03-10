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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A532C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 18:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC8E61601
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 18:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhCJSpa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 13:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbhCJSpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 13:45:15 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4C6C061760;
        Wed, 10 Mar 2021 10:45:15 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id mm21so40723173ejb.12;
        Wed, 10 Mar 2021 10:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F4UjQbhKYU2VqHSu0Zfac1os9kgjl7Y8/tyWFDYx5sE=;
        b=aThQHTEykges9z2Nq9ZU1A5HKuge7XBI+MX3Ov5oWhpT2fbpl15txm2ubW2A1YSPRn
         KxtIyDcdzCG80x6Q7rby5O40nWp1+CSch5KC/UUQYyRNqGDvzKrpP9pg8Q1Q5zXrNcsh
         arPAjNmVmPDjmnvMtbGiJuSJSEqcFQIwlqA9PeqxQS3d1KsibSsVrV+LxdxxmNpZJ7gT
         QWw7oy+6frgxSZ+apu1/6qA4U35jzJksMnIrGhJJ5nE/5QarbOb1bbdVItcLhNP5spsr
         iGtHEXeQhw5dV8JLdNzWZ/1/WV+M6iEsgO7Zocrnfg5eiO0j1HjPyvwxfxJqr9QxV6Cv
         v2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F4UjQbhKYU2VqHSu0Zfac1os9kgjl7Y8/tyWFDYx5sE=;
        b=ahzdBbuQRWH9NJlMAmr70nXA74WaXIbYEl/eIy7iPSM/H3CFm+ii/MvCnRvOqBp0PM
         nSVQhlHRUVPLQ1bva9IGHytORV3GwovrmmMzUKE2bf5sIZW2qtLUQTCA5nvKVvmoUMKB
         tBH1EjJqABya6KmTj31SrgTPw9v7/ePMJlT337G6cK6PYRuCJMJe34YpdIbcwlPkaGhm
         +qs+1GDurOfW8NCX/S1gk2zDV+bD/Hz9CwwZgSxKNbrLUAS1utnbdzrB6ZWrKzSQTtS9
         2Gp7eZN4rg9X08ag9u7FoZejkEGbk408dSTE7u7JF0xEZHb+AisM5yFSjxZFmedoMKeh
         N7uQ==
X-Gm-Message-State: AOAM531OKRJbUvooiooYMD7g915JT/yD0r2Khl1jS00D+FuFMltaU5sA
        t+BnvHX8D47Rha7UiXcS2dEuqU5SVb0=
X-Google-Smtp-Source: ABdhPJyVd72b1ky1LfRQTrpZj3FHlkQ9KAYE722u1OTMlW/8BaFtYeCVBpzBIpX3MbTO15Esn39xLA==
X-Received: by 2002:a17:906:f283:: with SMTP id gu3mr5010838ejb.91.1615401914113;
        Wed, 10 Mar 2021 10:45:14 -0800 (PST)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id rs24sm153645ejb.75.2021.03.10.10.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 10:45:13 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH] scsi: target: tcmu: Adjust parameter in call to tcmu_blocks_release
Date:   Wed, 10 Mar 2021 19:44:58 +0100
Message-Id: <20210310184458.10741-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In patch
 "scsi: target: tcmu: Replace radix_tree with XArray"
meaning of last parameter of tcmu_blocks_release was changed.
So in the callers we should subtract 1 from the previous
parameter.

Unfortunately that change got lost at one of the two places
where tcmu_blocks_release is called. That does not lead to any
problems, but we should adjust it anyway.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9e1b115cb032..bdfc057f000c 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1658,7 +1658,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	xa_destroy(&udev->commands);
 	WARN_ON(!all_expired);
 
-	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
+	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max);
 	bitmap_free(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
-- 
2.12.3

