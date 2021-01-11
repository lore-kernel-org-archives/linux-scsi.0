Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C297C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F31322D06
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 22:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390346AbhAKWcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390201AbhAKWcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 17:32:53 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F587C061794;
        Mon, 11 Jan 2021 14:32:13 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y24so145533edt.10;
        Mon, 11 Jan 2021 14:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vyo1bJ+4jkmQ32GbZPTDvoy8uoTVOxjsDAlZTGrNLAQ=;
        b=L0XHdnojyXkOOUg2qObCrr/sf8LlclKx8ol68mdSoYZ7QM29GDeKUCrfK06rVnWWZf
         XWw19/ynbZTNB77/kB7bW26k2bIqCfVsWiBO3y1BUBZFRPX59sdJP7AcCkBJHtQHkWkE
         56lu6IsZJhMHk0vaZgNCeDomTpMC8+L3khwh9lSsBsiq7ftVn2Ys9f3V0FiGpB/t818R
         WXC8UqRer9c44VLfm3uodkZMTPyOv4khMkeIwQwddOJsElaQrcR0RBO3Ul1EMQK3wkjn
         9iA1+Awp7eWM6kiGlOHe3mNeVFrQVO1KgjOQW4xn042YV0/94bB9XzJVfTCaUp2uw3UW
         Wr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vyo1bJ+4jkmQ32GbZPTDvoy8uoTVOxjsDAlZTGrNLAQ=;
        b=FfRWKP7SYolM8tOz6KCJ4DrTXqlgXE+58AFWDlEi161MqNH97FRNczVwZ4GGWK4SAp
         ItLCuxXBMowqXofFi8PJLPNhsnbbnomnsL4nPmkTyBxurDz8YWA/ioQliNLu8w52D13P
         Tcm0WGADjjsxCGO5aJas1oXPwXz/MMTMaYI548c+a5z0yXZ4BOOhXA293nACHiLeMLEL
         Hx4KW6E6cngGIMkm258/aZn0sYBYkkChpnaDVmViyh0Nxm2d+RTJ3oMV27sNrY2FxH+T
         U+ROlMqtcysYJRWzE8gYIuUEQC/lBltQaKLU0i61+6yLLaUaE7PhtNWVDbZ61jAAUFb6
         sj0Q==
X-Gm-Message-State: AOAM533GMqbBZhrSgyDmpEut+gI9Aoym1/PxQwkDS3eNNezCt0dLcfim
        NxBlXxS0M2Owx1B4Z2ImSIY=
X-Google-Smtp-Source: ABdhPJyYb2zXpeLqJ/i/JBDlfvkx4wewzrE6FLbsAolfXpZ8Ukt/6S+SMOszZO3El9FcHHC1/Eov5Q==
X-Received: by 2002:aa7:c44b:: with SMTP id n11mr1058604edr.216.1610404331906;
        Mon, 11 Jan 2021 14:32:11 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id r18sm550154edx.41.2021.01.11.14.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 14:32:11 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 0/2] Remove unnecessary devm_kfree
Date:   Mon, 11 Jan 2021 23:32:00 +0100
Message-Id: <20210111223202.26369-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

*** BLURB HERE ***

Bean Huo (2):
  scsi: hisi_sas: Remove unnecessary devm_kfree
  scsi: ufs: Remove unnecessary devm_kfree

 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 26 --------------------------
 drivers/scsi/ufs/ufshcd-crypto.c       |  4 +---
 2 files changed, 1 insertion(+), 29 deletions(-)

-- 
2.17.1

