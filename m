Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF881C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 03:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F341650BE
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 03:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhCHDav (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 22:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhCHDad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 22:30:33 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D78C06174A;
        Sun,  7 Mar 2021 19:30:32 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id o38so5544712pgm.9;
        Sun, 07 Mar 2021 19:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9NeJFxwg5/9HqAra6BvIGrU2gHl21/gfkMaJofzZgXE=;
        b=eqc/wPFOihkuzvC1xZPO2wc/v0GbW/xbUGIc5NS25s4r3flb3e16+8/KkUUOHsTb9i
         GzzrJCnG6xiEks0vg1BmnkLA2feq1A0uGlkJWlM6tWw4x2BMK/sWN/CrCgnykkiY8u5o
         BoO5nWfWtv/ejLVv27Dv01ThVWZa7kOsi2PBXDFDhLub+M6B0tWTAtIAN4zYa0mYVlIo
         ok1crcxNtXBMn7a/2IyH8Pgpaopw2PwTbmyy/TBd6jOEwKyWwLCrxkY7hEp8BOkC22LD
         DjXDk8f95lX0c9cR/ljwawr/6gQ2aXZcMN/SR6Q741lKAaHjqryrkDOGszzUvSjqqE7j
         OkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9NeJFxwg5/9HqAra6BvIGrU2gHl21/gfkMaJofzZgXE=;
        b=ZJhJaJs/G7NqTe2MXZqlwukUvkon608AF27QMNSL+Z97yRsqgNIhtPAK8AmlisqJtH
         vKEMf2yNMKJg1snkwHvUFq6RFn7lBfU00rLtS1PLjPEnuT7+kITm+DiJp1C6pQ0t+t5J
         aAtwQ5c8ZzJCnxizjHj93DDSB8fl1c5FOYxdvazDTV9BHmTlSWmNyu4eFd73+LMHDJqo
         mSUnbzswyAUMUtCeTqy1239ro1dirDwAtQsmGVIwWl0rW6GCHsSUk6Y86YErqnOmGvHo
         3MJqH5u3n0irbXyxjN0AQurLgnDG8AE56zUy+iTe2pxNh/sWu1OKbZ5maBiE7AohhZUz
         Lh9g==
X-Gm-Message-State: AOAM533yjDfeB9FRUN5KtJTUHwNjDTzc0h5Mq1pgmUsFynfOr53E0dwP
        TOPOCtPVQtPC/bRo67IEBZzDIVcaBzWOEhqX
X-Google-Smtp-Source: ABdhPJzxtqgk81xTxUDUfQcfqkhZh9RdoSj3QHWWayGFhb/y7p2hP7QMKsy5wYGbPrIu+c3OwayDjw==
X-Received: by 2002:a05:6a00:22d6:b029:1cb:35ac:d8e0 with SMTP id f22-20020a056a0022d6b02901cb35acd8e0mr18964981pfj.17.1615174232422;
        Sun, 07 Mar 2021 19:30:32 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id mm12sm8740618pjb.49.2021.03.07.19.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:30:32 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     njavali@marvell.com, mrangankar@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: qedi: fix error return code of qedi_alloc_global_queues()
Date:   Sun,  7 Mar 2021 19:30:24 -0800
Message-Id: <20210308033024.27147-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When kzalloc() returns NULL to qedi->global_queues[i], no error return
code of qedi_alloc_global_queues() is assigned.
To fix this bug, status is assigned with -ENOMEM in this case.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 47ad64b06623..69c5b5ee2169 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1675,6 +1675,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		if (!qedi->global_queues[i]) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to allocation global queue %d.\n", i);
+			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
 
-- 
2.17.1

