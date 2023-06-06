Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31336C8300C
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 19:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbjFFTjP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 15:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjFFTiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 15:38:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9A410D7;
        Tue,  6 Jun 2023 12:38:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 53B5B1FD95;
        Tue,  6 Jun 2023 19:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686080332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bXxH/xRJ6ryUI8Yc/IKZBzn1JvzrziF9j7uphU/kqjg=;
        b=tOvRyK5YbJRNuxdRMUelNSEY+Xb3gniZOVr3L78+JxY3Y5GE0G9jSGTcR2z6eA8zhtwe0C
        1cbw7ZuGZrv2nKTXc2PlCElvJ5fhFQzYBiWkk4i3aUWdygch6VPXDy06PEl1ZRpuCSHhj3
        8MXj/QwoRdpF09aG44k1X3zKTg/7zws=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D69413776;
        Tue,  6 Jun 2023 19:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QGQtAUyLf2RaFwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 06 Jun 2023 19:38:52 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 3/3] scsi: simplify scsi_stop_queue()
Date:   Tue,  6 Jun 2023 21:38:45 +0200
Message-Id: <20230606193845.9627-4-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606193845.9627-1-mwilck@suse.com>
References: <20230606193845.9627-1-mwilck@suse.com>
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

Simplify scsi_stop_queue(), which is only called in this code path, to never
wait for the quiescing to finish. Rather call blk_mq_wait_quiesce_done()
from scsi_target_block() after iterating over all devices.

Also, move the call to scsi_stop_queue() in scsi_internal_device_block()
out of the code section where the state_mutex is held.

This patch uses the same basic idea as f983622ae605 ("scsi: core: Avoid
calling synchronize_rcu() for each device in scsi_host_block()").

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 25489fbd94c6..bc78bea62755 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2726,24 +2726,18 @@ void scsi_start_queue(struct scsi_device *sdev)
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
@@ -2770,7 +2764,7 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	 * request queue.
 	 */
 	if (!ret)
-		scsi_stop_queue(sdev, true);
+		scsi_stop_queue(sdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
@@ -2796,9 +2790,9 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
-	if (err == 0)
-		scsi_stop_queue(sdev, false);
 	mutex_unlock(&sdev->state_mutex);
+	if (err == 0)
+		scsi_stop_queue(sdev);
 
 	return err;
 }
@@ -2906,11 +2900,17 @@ target_block(struct device *dev, void *data)
 void
 scsi_target_block(struct device *dev)
 {
+	struct Scsi_Host *shost = dev_to_shost(dev);
+
 	if (scsi_is_target_device(dev))
 		starget_for_each_device(to_scsi_target(dev), NULL,
 					device_block);
 	else
 		device_for_each_child(dev, NULL, target_block);
+
+	/* Wait for ongoing scsi_queue_rq() calls to finish. */
+	if (!WARN_ON_ONCE(!shost))
+		blk_mq_wait_quiesce_done(&shost->tag_set);
 }
 EXPORT_SYMBOL_GPL(scsi_target_block);
 
-- 
2.40.1

