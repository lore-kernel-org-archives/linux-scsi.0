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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6976AC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 15:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36DDF613E4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 15:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243617AbhDWPCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 11:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243644AbhDWPCV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 11:02:21 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E837C061342;
        Fri, 23 Apr 2021 08:01:37 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id k17so18287228edr.7;
        Fri, 23 Apr 2021 08:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qqFKjPjehZp1lcJovDtw7kQfiNIpzZS/+aXj2RjdZVk=;
        b=Yf/PGb5iJfgQSSmYNGTSSn+OFdJWlKJz8+YoZH8OkfiZhI7GtROqcEeBqfSFTVpaop
         uV8LX+O/+ItSl2FFkvXddu1YFi5ssWMO2ID6VqAeKoR86+FHhhmzM1/10fi9C5ecTBX3
         CXqKYhRDjqUeIwUBpZKIQjezbRgRfwvoWH25bVa9U3dB0/sNrgJhwTIP1ifsMp36ApZy
         cLiE9c9Oh4xW0i/UbWku7/5FpEXIuuN/i2Og7a9EhII8IwzIpP9axVtkyLGFOuinjP1h
         3lbty5MQ5znUTywC80q5CJsjsKcmnxb0Y2jrStxrWXPJbtOwhW4mSz94R+Z8yYdkAsoh
         813A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qqFKjPjehZp1lcJovDtw7kQfiNIpzZS/+aXj2RjdZVk=;
        b=jqDU+x7lUnizjj/CZT8bpf1B9DSG3czOkB5FZReyRKW+BepjzQbN0XR0eQJMtoh+fg
         BBkNS0gphNhbnfMCNTSl1WqgRE3xArwNZipHTXIVNftB07hnTGKom/9iSt/dIXVSVUxE
         qvO+L7zqfrGrse7dsm0wg2u+xkymiWhMJTqN72kxwr2bigF296ZAqJyjPEQzUWS61yEI
         krPhMEGoKQvyOmKtNppSe9KM86CEoISzT8Ya2c8OtUZYU3UjEbyiwYkJoQIaPYCNpp1I
         a5ail0LP4Da/eHSBzOGr0tzExWoPj4XDzxkWJF8Fs/SnPrnYcRI9pBDZ5iPD9mm26upR
         3mHA==
X-Gm-Message-State: AOAM5325Vg9hsq88Qz+w+eeoXG6bePryA5kLg+iM/V+Bkj6PZpFr7Ebq
        g0uoUDF3he4v29kY0ngfnS+acYHyn/M=
X-Google-Smtp-Source: ABdhPJzQFihojxz2O3xplqA5gpscf8vyrYHFDoX0WgP0eJGvquKIGLX1PieAGbXwU1LYb0tBBxf1mQ==
X-Received: by 2002:aa7:cb97:: with SMTP id r23mr5009979edt.106.1619190096223;
        Fri, 23 Apr 2021 08:01:36 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id v8sm4506149edc.30.2021.04.23.08.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 08:01:35 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH] scsi: target: tcmu: Return from tcmu_handle_completions if cmd_id not found
Date:   Fri, 23 Apr 2021 17:01:23 +0200
Message-Id: <20210423150123.24468-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If tcmu_handle_completions finds an invalid cmd_id while looping
over cmd responses from userspace, it sets TCMU_DEV_BIT_BROKEN
and breaks the loop, which means that it does further handling
for the tcmu device.

Skip that handling by replacing 'break' with 'return'.

Additionally change tcmu_handle_completions from unsigned int to
bool, since the value used in return already is bool.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index eec2fd573e2b..198d25ae482a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1413,7 +1413,7 @@ static int tcmu_run_tmr_queue(struct tcmu_dev *udev)
 	return 1;
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1456,7 +1456,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.12.3

