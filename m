Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86995C7EE24
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 16:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbjFBQja (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jun 2023 12:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbjFBQjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2023 12:39:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9B61A2;
        Fri,  2 Jun 2023 09:39:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7845C21A41;
        Fri,  2 Jun 2023 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685723962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9OEDtirDdPxMdKXugNer/vMTQpbJcSihzhcFKHZfe4=;
        b=azUE1btUpaczu20RjTRAtrnutqHE2OTIvs8RB3wJ33isstVqrA/CznmPI126nKykTYxl89
        KJkw1Ljt8G/75Tm2oYT2/nsKlfD3AuIUXyvJKvCqDiP2qqwxEFO0J6lS1ZGG4mgjc0dwE2
        Kx0H+Rv1fQxQ6C05qkM5JmSk6uhwDdM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A52D133E6;
        Fri,  2 Jun 2023 16:39:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YKWXCDobemSEDwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 02 Jun 2023 16:39:22 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi: simplify scsi_stop_queue()
Date:   Fri,  2 Jun 2023 18:38:45 +0200
Message-Id: <20230602163845.32108-4-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602163845.32108-1-mwilck@suse.com>
References: <20230602163845.32108-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

scsi_target_block() calls scsi_stop_queue() for each scsi_device
and scsi_stop_queue() calls blk_mq_wait_quiesce_done() for each LUN.
As blk_mq_wait_quiesce_done() comes down to synchronize_rcu() for
SCSI queues, this can cause substantial delay for scsi_target_block()
on a target with a lot of logical units (we measured more than 100s
delay for blocking a FC rport with 2048 LUNs).

Simplify scsi_stop_queue(), which is only called in this code path, to
never wait for the quiescing to finish. Rather call synchronize_rcu()
from scsi_target_block() after iterating over all devices.
Also, move the call to scsi_stop_queue() in scsi_internal_device_block()
out of the code section where the state_mutex is held.

This patch uses the same basic idea as commit f983622ae605 ("scsi: core:
Avoid calling synchronize_rcu() for each device in scsi_host_block()").

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..ed5bc9e1dbed 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2725,24 +2725,18 @@ void scsi_start_queue(struct scsi_device *sdev)
 		blk_mq_unquiesce_queue(sdev->request_queue);
 }
 
-static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
+static void scsi_stop_queue(struct scsi_device *sdev)
 {
 	/*
 	 * The atomic variable of ->queue_stopped covers that
 	 * blk_mq_quiesce_queue* is balanced with blk_mq_unquiesce_queue.
 	 *
 	 * However, we still need to wait until quiesce is done
-	 * in case that queue has been stopped.
+	 * in case that queue has been stopped. This is done in
+	 * scsi_target_block() for all devices of the target.
 	 */
-	if (!cmpxchg(&sdev->queue_stopped, 0, 1)) {
-		if (nowait)
-			blk_mq_quiesce_queue_nowait(sdev->request_queue);
-		else
-			blk_mq_quiesce_queue(sdev->request_queue);
-	} else {
-		if (!nowait)
-			blk_mq_wait_quiesce_done(sdev->request_queue->tag_set);
-	}
+	if (!cmpxchg(&sdev->queue_stopped, 0, 1))
+		blk_mq_quiesce_queue_nowait(sdev->request_queue);
 }
 
 /**
@@ -2769,7 +2763,7 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	 * request queue.
 	 */
 	if (!ret)
-		scsi_stop_queue(sdev, true);
+		scsi_stop_queue(sdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
@@ -2795,9 +2789,9 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
-	if (err == 0)
-		scsi_stop_queue(sdev, false);
 	mutex_unlock(&sdev->state_mutex);
+	if (err == 0)
+		scsi_stop_queue(sdev);
 
 	return err;
 }
@@ -2910,6 +2904,13 @@ scsi_target_block(struct device *dev)
 					device_block);
 	else
 		device_for_each_child(dev, NULL, target_block);
+
+	/*
+	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag,
+	 * so blk_mq_wait_quiesce_done() comes down to just synchronize_rcu().
+	 * Just calling it once is enough.
+	 */
+	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(scsi_target_block);
 
-- 
2.40.1

