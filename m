Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879E8EB64D0
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 17:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbjFMRmu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 13:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239711AbjFMRmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 13:42:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623B5172A;
        Tue, 13 Jun 2023 10:42:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0379B1FD6A;
        Tue, 13 Jun 2023 17:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686678155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WARlW0ctsOI2JMnNUsK/jUGw66QCGXMKobk6JXuk3io=;
        b=W8VR2KPC4F5Arth6QD6acH1f9atoAgoomXWCWBYOmHZHYf9yWaBdMmn/C88Pe5s+qjycq9
        /jDJU2aaAO6jikmYijsngSpZbBtVNmnZmIbrUlhyzDyaB1ZbijojOpjkwFVNmGRnMVOfvN
        XYDss3YFxIkxXHVn49GWraNvWcuadLI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B9C713483;
        Tue, 13 Jun 2023 17:42:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CKsoJIqqiGSWXwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 13 Jun 2023 17:42:34 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 4/7] scsi: don't wait for quiesce in scsi_stop_queue()
Date:   Tue, 13 Jun 2023 19:42:24 +0200
Message-Id: <20230613174227.11235-5-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613174227.11235-1-mwilck@suse.com>
References: <20230613174227.11235-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

scsi_stop_queue() has just two callers, one with and one without
"nowait". As blk_mq_quiesce_queue() comes down to
blk_mq_quiesce_queue_nowait() followed by blk_mq_wait_quiesce_done(),
we might as well open-code this in scsi_device_block().

Also, add a comment explaining why blk_mq_quiesce_queue_nowait() must
be called with the state_mutex held, see
https://lore.kernel.org/linux-scsi/3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org/.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 69fb7a9d8883..3e12cc61569d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2731,24 +2731,16 @@ void scsi_start_queue(struct scsi_device *sdev)
 		blk_mq_unquiesce_queue(sdev->request_queue);
 }
 
-static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
+static void scsi_stop_queue(struct scsi_device *sdev)
 {
 	/*
 	 * The atomic variable of ->queue_stopped covers that
 	 * blk_mq_quiesce_queue* is balanced with blk_mq_unquiesce_queue.
 	 *
-	 * However, we still need to wait until quiesce is done
-	 * in case that queue has been stopped.
+	 * The caller needs to wait until quiesce is done.
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
@@ -2775,7 +2767,7 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	 * request queue.
 	 */
 	if (!ret)
-		scsi_stop_queue(sdev, true);
+		scsi_stop_queue(sdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
@@ -2800,9 +2792,17 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
-	if (err == 0)
-		scsi_stop_queue(sdev, false);
-	mutex_unlock(&sdev->state_mutex);
+	if (err == 0) {
+		/*
+		 * scsi_stop_queue() must be called with the state_mutex
+		 * held. Otherwise a simultaneous scsi_start_queue() call
+		 * might unquiesce the queue before we quiesce it.
+		 */
+		scsi_stop_queue(sdev);
+		mutex_unlock(&sdev->state_mutex);
+		blk_mq_wait_quiesce_done(sdev->request_queue->tag_set);
+	} else
+		mutex_unlock(&sdev->state_mutex);
 
 	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
 		  dev_name(&sdev->sdev_gendev), err);
-- 
2.40.1

