Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50095C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 01:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7B96112D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 01:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhKJB0X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 20:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhKJB0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 20:26:22 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED495C061764;
        Tue,  9 Nov 2021 17:23:35 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u17so1603537plg.9;
        Tue, 09 Nov 2021 17:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=8KsAKNFuVz5kAl4IdR8XgWDYzhLIM4iFKTO/IbBl8jM=;
        b=l98xyTblDrwgpcixHuBMvmrGHTaL79voaUPmTqScyLLI/yZa576mu8h5IWKZiN4tW0
         G2SgpYkx49/m0jwcbWBufXMQwB66Y0naBKvLNLQaqDn0FwLRkGip/d8URMNzhzlwm3Sc
         8SUZWKHoiKNepKcAEgG+OtgUViYEn1jvpFYjgeW5faYUZv0m2OEwbJwso6p3lzr+c3b7
         zvgEel4IaemLb3Fkp2Mnn6q5RInoWTWU+JLVloBZAW7EXKPRrL59gylEX4AqEl5Ez2yx
         0LLzNOmEWdjowAPvvqxRWN20Tq4NVLfOD2w1vt56eES+5e+9lDdEfLltAdWbhf8TI3dL
         C+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8KsAKNFuVz5kAl4IdR8XgWDYzhLIM4iFKTO/IbBl8jM=;
        b=u4FwtD1xS9u4F5PFSasorFm6cw7UYMHiTlFisRd0wJ8ve3hJhKnW0XbkOZeB8GxUsW
         J+yK1m2xEeza0yogDN/mbbsAvMt9MXKt+XqjCODy7VNMxe4k874Xe0K8OCpEWIg9oufN
         ZL4dGPVGeC5qjDNqEXEihuEeLcG4b53G9c4oQDFer0NrBAhDfysOIMDxzw10zPqbzj5P
         SQbtsyI5L/O2t8YnnhIR8caVkHpqnN1vQJYI7HU/bUXGYDke1TDyArQJ0hg8AfxmKKiY
         Au2k/JokhMdhpfqvt2j7UyTMNx46PcaYNxRpsgJfKSq/UVegATbcT9X3MpjVLbhEDS71
         oWRQ==
X-Gm-Message-State: AOAM532iaSgUexOj55h+O+CS3YvaOtkWXHp6TonTfqHMMmuShiwuxcfI
        KEt0EFL9UWD65cSQIRkbBXi6/L9+bXA=
X-Google-Smtp-Source: ABdhPJw9EojWf0yLnUAZZFxA4gUUOqn3Osdr+3wuJzYohtAhx/+HYis5OJM2teZOTfWfGAy2C4Ua/A==
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr11921617plg.47.1636507415443;
        Tue, 09 Nov 2021 17:23:35 -0800 (PST)
Received: from VM-0-3-centos.localdomain ([101.32.213.191])
        by smtp.gmail.com with ESMTPSA id j6sm16099210pgq.0.2021.11.09.17.23.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Nov 2021 17:23:35 -0800 (PST)
From:   brookxu <brookxu.cn@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     hch@infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: core: use eh_timeout to timeout start_unit command
Date:   Wed, 10 Nov 2021 09:23:32 +0800
Message-Id: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

In some abnormal scenarios, STU may timeout. The recovery
time of 30 seconds is relatively large. Now we need to modify
rq_timeout to adjust STU timeout value, but it will affect the
actual IO.

commit 9728c0814ecb ("[SCSI] make scsi_eh_try_stu use block
timeout") use rq_timeout to timeout the STU command, but after
commit 0816c9251a71 ("[SCSI] Allow error handling timeout to
be specified") eh_timeout will init to SCSI_DEFAULT_EH_TIMEOUT,
so it is more reasonable to use eh_timeout as the timeout value
of STU command. In this way, we can uniformly control recovery
time through eh_timeout.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
v2: Update commit log and fix some format issues.

 drivers/scsi/scsi_error.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a531336..a665318 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1404,7 +1404,8 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 		enum scsi_disposition rtn = NEEDS_RETRY;
 
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
-			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
+			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
+						scmd->device->eh_timeout, 0);
 
 		if (rtn == SUCCESS)
 			return 0;
-- 
1.8.3.1

