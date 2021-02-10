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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C79C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C603564E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhBJTnL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhBJTmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 14:42:23 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EA0C061574;
        Wed, 10 Feb 2021 11:41:42 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g10so4453768eds.2;
        Wed, 10 Feb 2021 11:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q0ZYYedlw5LOvhCfCiElWY0D9bk2dk9Ia76Gg6QIpTQ=;
        b=lAP2jAKhOQ3g1mp/dbLqzaWINy+0Ncn3pgj0k7uaco3vPcQAG3BPLf65jRVhPA9s+h
         FJEcERkYDZSswJ9R7eUvhSHU0/UsPUzeE1h/OHZ/KvFIEGrMkwm0SJSTFWGJLQi+5a15
         W8s3EZ88mZ9Dq/jev/x888ZnfNXuFtcq0LH5n4Caihy7uQk1UOTW9GiuOfyhvIxTzryq
         CnTXwuuEi7B+oim9MjbAjInXjQa4vgykV1BCF8rSeEbSXciprXUq+sOA4zs9B1VFezS2
         tBegwVFTCta6GNsFv2VeInw1EuhoX5ZszadYM1zrfSNyI5tbhlBV6d5yp1jY7mwCfnjM
         ET1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q0ZYYedlw5LOvhCfCiElWY0D9bk2dk9Ia76Gg6QIpTQ=;
        b=p6SENnR5fNLwWEE+m8YSJcZFnZDK6GctbBV+xEQwjnga1eh+36aEJXRn8rPMkbWYMb
         zPwoLy9wPO9S0wptOZHVEV9ymrqCIQLCX3rCH2+AE0lb4gwKYEhBQLty8jsULWIZ22YJ
         8eaBB3uxJ2PKkG9gYmpa4JxZ6MVRfHVg7RBxjRQtmr/yWlAlkouyEqEE70g5NrXsNn+R
         xZrSF2iV2DRTkX09IoQ25SubtzkomAr+rqjP9sOZjW4hvxLYxZQMF2jXge8i1bmYMbI/
         AFYU2UVGYN5MxLAMlQRaP+4fcR+3wNoVn4yW/LtOtES9UZiyNRDGNzxxq9pXeFJNofeO
         TYLQ==
X-Gm-Message-State: AOAM530KjfvlHAZhDXtWdsT8eCB0NLFMyYSIKMOC9GOZbcjJeZzK9MHg
        3936xIfR8rD9OESCNiH5dtfX7bpJ0Bg=
X-Google-Smtp-Source: ABdhPJyT8jQRcWlCc/eUC7+zXjdbLVne5UJ8STeiQNHJDIZLak4Kyoeu+BjlCI1wD/nNphYQz7NDbA==
X-Received: by 2002:aa7:c0cd:: with SMTP id j13mr4716867edp.319.1612986101231;
        Wed, 10 Feb 2021 11:41:41 -0800 (PST)
Received: from localhost (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id t19sm1989848ejc.62.2021.02.10.11.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:41:40 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/2] scsi: target: tcmu: Fix memory leak by using new uio callback
Date:   Wed, 10 Feb 2021 20:40:31 +0100
Message-Id: <20210210194031.7422-3-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210210194031.7422-1-bostroesser@gmail.com>
References: <20210210194031.7422-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use new uio_info->late_release callback to fix memory leak.

If userspace daemon still holds uio device open or mmap'ed while
tcmu device is removed from configFS, refcount of the tcmu device
never drops down to 0, because uio does not call
uio_info->release - which is tcmu_release - after tcmu had
executed uio_unregister_device. So tcmu device and its allocated
resources are not freed in this situation.

tcmu now sets uio_info->late_release which is called by uio in
the described situation. That way the memory leak is fixed.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 6b171fff007b..bf61705ca92b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2092,6 +2092,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	info->mmap = tcmu_mmap;
 	info->open = tcmu_open;
 	info->release = tcmu_release;
+	info->late_release = tcmu_release;
 
 	ret = uio_register_device(tcmu_root_device, info);
 	if (ret)
-- 
2.12.3

