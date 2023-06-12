Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA08C88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 16:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbjFLQv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbjFLQvx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 12:51:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DD0E71;
        Mon, 12 Jun 2023 09:51:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0721B2281F;
        Mon, 12 Jun 2023 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686588711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eaXjyiFwyu8BbIFcqyMz4SgPWEfYQGPvjO58KOfHWA0=;
        b=RtvwmvvO0HK8CnFKCdI+/hNWs8L7SBPK4WIhJDPw+TPszP3E8QEHEoZKifhYreFHnvDRLT
        2Qus+OOBSvU6CVo+YoeFOW8S+WNptQQHnv0ui0bwWlIklW7hMMjuV2GrSBJmjSY8D/4kar
        Qp/tE7p7SrzkEFvx8qC74WE8YJIajFw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9EE191357F;
        Mon, 12 Jun 2023 16:51:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EDQFJSZNh2SOXwAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 16:51:50 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 5/7] scsi: don't wait for quiesce in scsi_device_block()
Date:   Mon, 12 Jun 2023 18:50:47 +0200
Message-Id: <20230612165049.29440-6-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612165049.29440-1-mwilck@suse.com>
References: <20230612165049.29440-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

scsi_device_block() is only called from scsi_target_block(), which
calls it repeatedly for every child device. For targets with many devices,
waiting for every queue to quiesce may cause a substantial delay
(we measured more than 100s delay for blocking a FC rport with 2048 LUNs).

Just call blk_mq_wait_quiesce_done() once from scsi_target_block() after
stopping all queues.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3e12cc61569d..f94677b3f5b6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2777,8 +2777,8 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
  * @sdev: device to block
  * @data: dummy argument, ignored
  *
- * Pause SCSI command processing on the specified device and wait until all
- * ongoing scsi_queue_rq() calls have finished. May sleep.
+ * Pause SCSI command processing on the specified device. Callers must wait until all
+ * ongoing scsi_queue_rq() calls have finished after this function returns.
  *
  * Note:
  * This routine transitions the device to the SDEV_BLOCK state (which must be
@@ -2792,17 +2792,15 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
-	if (err == 0) {
+	if (err == 0)
 		/*
 		 * scsi_stop_queue() must be called with the state_mutex
 		 * held. Otherwise a simultaneous scsi_start_queue() call
 		 * might unquiesce the queue before we quiesce it.
 		 */
 		scsi_stop_queue(sdev);
-		mutex_unlock(&sdev->state_mutex);
-		blk_mq_wait_quiesce_done(sdev->request_queue->tag_set);
-	} else
-		mutex_unlock(&sdev->state_mutex);
+
+	mutex_unlock(&sdev->state_mutex);
 
 	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
 		  dev_name(&sdev->sdev_gendev), err);
@@ -2900,11 +2898,15 @@ target_block(struct device *dev, void *data)
 void
 scsi_target_block(struct device *dev)
 {
+	struct Scsi_Host *shost = dev_to_shost(dev);
+
 	if (scsi_is_target_device(dev))
 		starget_for_each_device(to_scsi_target(dev), NULL,
 					scsi_device_block);
 	else
 		device_for_each_child(dev, NULL, target_block);
+
+	blk_mq_wait_quiesce_done(&shost->tag_set);
 }
 EXPORT_SYMBOL_GPL(scsi_target_block);
 
-- 
2.40.1

