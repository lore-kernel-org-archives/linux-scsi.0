Return-Path: <SRS0=6jMo=EN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6950FC388F9
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 08:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1942320872
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 08:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h9pkFZyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgKGILx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Nov 2020 03:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgKGILx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Nov 2020 03:11:53 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B59BC0613CF
        for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2020 00:11:53 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z11so2247869pln.0
        for <linux-scsi@vger.kernel.org>; Sat, 07 Nov 2020 00:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=zIepqu5/kHd0BQ24VYrLjVuZ9zG/2BQ74NYjRDAUWZk=;
        b=h9pkFZyLB00WFqfhQWIrex8QbgyMxv2aGiLaAQD6RWUvp1KCihBehoqFvRhmzkEaLz
         +PMY8hbu+9mOTcmczSVH2lXRLMEvG/LaOcKj2vY5XdvrXzqJrQJDabu9lm2kCONypsBU
         BDnF7HEiG1hiWUdyhCJnoS6m5qenuZhyLMA6QGUIh553vIK0g7R2zVKGNl8cJ1ILoKGm
         WkD3bf65biqhtohrgQssuBKC1UN/6Xujs1QE2LoJ+EZo8BXdZPtp8cNgt/xo0ZfC93t3
         n+VJvZJMgu5CPZ101GTYuLwvUBeipGzdk+5ZUIi9Xisn+jRa3M/k51/DD+Dg3RPdfAm4
         5SGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=zIepqu5/kHd0BQ24VYrLjVuZ9zG/2BQ74NYjRDAUWZk=;
        b=ftMX9ousR+jSL4zABD5QTMKvn5za93gGotYn0JM7RxZLwLKRUILxqGR9v2YT3j6dTS
         Xr5yNV3YSYxJ7XnaNftK7lK4gG8VyVrWj2mJPYW4wHbioWVHrGTzP3MfNS3JCF/W5U0X
         puZU74MeLoWY8zbEkYnF140tu2jmZMa9FfhdhEK889nzt3qLQ8zF+WlAc0fnwHEBMvWR
         +sAiJIlJpPzp5X752izSk33idyEOKJdXSRA2k7twwyb+g0MSnCpZqKW6rhtnDw0AxmKo
         lm3m+WCQM3FB9gHjB/2HC+usmNxax9i2iA+k8DfVxrL4PjnTBc/2naNqCD17XCTZ9R+Y
         IcxQ==
X-Gm-Message-State: AOAM533FV0r8NQyVkgCacoMyOIgZX46t+pAALlHiGbYUlo+w9qCI6Bb1
        KviU+q0vcLDymRculh9MeU9oRJzMz2pThDmA1lA=
X-Google-Smtp-Source: ABdhPJwEL7T+O1e2iauW1GrgFhIHR8xYyqNtRH+/uGQ1qGcXanxqYu0SYiKnNOYEtcAGNqjtw9KtVJba8Qd+Nr5eYio=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a17:90a:9dcb:: with SMTP id
 x11mr3322415pjv.132.1604736712313; Sat, 07 Nov 2020 00:11:52 -0800 (PST)
Date:   Sat,  7 Nov 2020 00:11:32 -0800
Message-Id: <20201107081132.2629071-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH] scsi: core: fix -Wformat
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang is more aggressive about -Wformat warnings when the format flag
specifies a type smaller than the parameter. Turns out, struct
Scsi_Host's member can_queue is actually an int. Fixes:

warning: format specifies type 'short' but the argument has type 'int'
[-Wformat]
shost_rd_attr(can_queue, "%hd\n");
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                          %d
Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6e344fa33ad..b6378c8ca783 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -370,7 +370,7 @@ static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store
 
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
-shost_rd_attr(can_queue, "%hd\n");
+shost_rd_attr(can_queue, "%d\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(sg_prot_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
-- 
2.29.2.222.g5d2a92d10f8-goog

