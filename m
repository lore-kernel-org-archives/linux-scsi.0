Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9293C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 19:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B4BA233FE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 19:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbhATTWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:22:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:58620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387604AbhATSrB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 13:47:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611168373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=WqQ1la32Qz3ttoiShTW4ZA3tF5UG6C1ELZJ55KLooOs=;
        b=IvQHNQdS0G79QP4A2izoCzjL3IfnFIaeCEa2Zk87ULXFGkeu28cCJFPekg1P8qdJHbSot2
        bYaGjQ1kgxDA2R48e02xFcYwzJOYMMWb4ng6yzBUXP1sMylqFpT51Ry9gooVEbYQMv8dDs
        x7yttoYiXPYupy1gQIKR3ZH+jXaRzXc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 333DFAF37;
        Wed, 20 Jan 2021 18:46:13 +0000 (UTC)
From:   mwilck@suse.com
To:     Donald Buczek <buczek@molgen.mpg.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        John Garry <john.garry@huawei.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Date:   Wed, 20 Jan 2021 19:45:48 +0100
Message-Id: <20210120184548.20219-1-mwilck@suse.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Donald: please give this patch a try.

Commit 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
contained this hunk:

-       busy = atomic_inc_return(&shost->host_busy) - 1;
        if (atomic_read(&shost->host_blocked) > 0) {
-               if (busy)
+               if (scsi_host_busy(shost) > 0)
                        goto starved;

The previous code would increase the busy count before checking host_blocked.
With 6eb045e092ef, the busy count would be increased (by setting the
SCMD_STATE_INFLIGHT bit) after the if clause for host_blocked above.

Users have reported a regression with the smartpqi driver [1] which has been
shown to be caused by this commit [2].

It seems that by moving the increase of the busy counter further down, it could
happen that the can_queue limit of the controller could be exceeded if several
CPUs were executing this code in parallel on different queues.

This patch attempts to fix it by moving setting the SCMD_STATE_INFLIGHT before
the host_blocked test again. It also inserts barriers to make sure
scsi_host_busy() on once CPU will notice the increase of the count from another.

[1]: https://marc.info/?l=linux-scsi&m=160271263114829&w=2
[2]: https://marc.info/?l=linux-scsi&m=161116163722099&w=2

Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Don Brace <Don.Brace@microchip.com>
Cc: Kevin Barnett <Kevin.Barnett@microchip.com>
Cc: Donald Buczek <buczek@molgen.mpg.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/hosts.c    | 2 ++
 drivers/scsi/scsi_lib.c | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 2f162603876f..1c452a1c18fd 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -564,6 +564,8 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data,
 	int *count = data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
+	/* This pairs with set_bit() in scsi_host_queue_ready() */
+	smp_mb__before_atomic();
 	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
 		(*count)++;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b3f14f05340a..0a9a36c349ee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1353,8 +1353,12 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	if (scsi_host_in_recovery(shost))
 		return 0;
 
+	set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+	/* This pairs with test_bit() in scsi_host_check_in_flight() */
+	smp_mb__after_atomic();
+
 	if (atomic_read(&shost->host_blocked) > 0) {
-		if (scsi_host_busy(shost) > 0)
+		if (scsi_host_busy(shost) > 1)
 			goto starved;
 
 		/*
@@ -1379,8 +1383,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		spin_unlock_irq(shost->host_lock);
 	}
 
-	__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
-
 	return 1;
 
 starved:
-- 
2.29.2

