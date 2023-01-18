Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB92C38147
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 18:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjARSHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 13:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjARSHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 13:07:14 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C4959B48
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 10:06:02 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id o13so33104331pjg.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 10:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=12MX7zvsB246/bnKiWHteZB/s+YJbnZd/3jC+k76elQ=;
        b=n/jvmobei9056Ludsrr9LLdpG9DbPSBxDubnMJuiLE1PW1CaPNs4EMVR6EJ/QXAoVU
         v1kbNhgkCHNRWdiTnYO79jXWKxN1NbC4cB+prlcPnMkMI10g2Cmn39kldugxOLJlcCbJ
         w6zoh9bcpxcGUs1bk103FKsR7EO1at5f+0AtKILtHYyS70t/Cyf9IWv5T/YwfG4yWu2o
         4/YaoTEuDCKH3gwUQO8t5P+E54tps0jHHfuRa8EWz0Dy+Bhy45oyXMFly4ALQLKV2VWg
         jzM5US97sA7nP7B+lZybO487KN7ODUxiGbqgMoa3SiDL/1uIXPtaSQLsLJA3d6c8B9IC
         DySQ==
X-Gm-Message-State: AFqh2krwIgZ8pSZ0iDAyHOucRd3nRJk8mp+A64gCQOEK8nhroSBcIi45
        No2fqa9YLekfzbZxPAqx0nA=
X-Google-Smtp-Source: AMrXdXuPnmIhQYI38510QW3WDUBsG1jPd7SxbN+afUYRckbzFuPAJnV4KxrYZe+wx8xxK43TSDYk5Q==
X-Received: by 2002:a17:902:da8d:b0:194:7a42:2d33 with SMTP id j13-20020a170902da8d00b001947a422d33mr10523805plx.28.1674065161903;
        Wed, 18 Jan 2023 10:06:01 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id jd9-20020a170903260900b00186727e5f5csm23425177plb.248.2023.01.18.10.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 10:06:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: device_handler: alua: Remove a might_sleep() annotation
Date:   Wed, 18 Jan 2023 10:05:57 -0800
Message-Id: <20230118180557.1212577-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The might_sleep() annotation in alua_rtpg_queue() is not correct since the
command completion code may call this function from atomic context.
Calling alua_rtpg_queue() from atomic context in the command completion
path is fine since request submitters must hold an sdev reference until
command execution has completed. This patch fixes the following kernel
complaint:

BUG: sleeping function called from invalid context at drivers/scsi/device_handler/scsi_dh_alua.c:992
Call Trace:
 dump_stack_lvl+0xac/0x100
 __might_resched+0x284/0x2c8
 alua_rtpg_queue+0x3c/0x98 [scsi_dh_alua]
 alua_check+0x122/0x250 [scsi_dh_alua]
 alua_check_sense+0x172/0x228 [scsi_dh_alua]
 scsi_check_sense+0x8a/0x2e0
 scsi_decide_disposition+0x286/0x298
 scsi_complete+0x6a/0x108
 blk_complete_reqs+0x6e/0x88
 __do_softirq+0x13e/0x6b8
 __irq_exit_rcu+0x14a/0x170
 irq_exit_rcu+0x22/0x50
 do_ext_irq+0x10a/0x1d0

Reported-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Tested-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 55a5073248f8..362fa631f39b 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -987,6 +987,9 @@ static void alua_rtpg_work(struct work_struct *work)
  *
  * Returns true if and only if alua_rtpg_work() will be called asynchronously.
  * That function is responsible for calling @qdata->fn().
+ *
+ * Context: may be called from atomic context (alua_check()) only if the caller
+ *	holds an sdev reference.
  */
 static bool alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
@@ -995,8 +998,6 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 	int start_queue = 0;
 	unsigned long flags;
 
-	might_sleep();
-
 	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
 		return false;
 
