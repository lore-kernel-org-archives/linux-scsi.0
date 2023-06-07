Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD24C83005
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 18:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjFGSY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjFGSYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 14:24:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363EF2680;
        Wed,  7 Jun 2023 11:24:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5A38D1FDBB;
        Wed,  7 Jun 2023 18:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686162199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PyVvtlhVYOHzbni4Ma+g7k27VybE606ANn6a+xC2doc=;
        b=It98T/59WnKkLnRTU9jRyl0ieB3hUfE6FfJGtdSiYvoTJjLkXD7o13ZAwVJLpNXom0T6Pq
        BfMTUlzBNUg7RJsD8cP0Q84OFuU1njuUfnfEufMIGUcohwKNzN7/xkwwoaG6jbUDy9M6Hg
        ldccRVnkr1RjJKuSjftqpCmLXxL7w2Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D27B71346D;
        Wed,  7 Jun 2023 18:23:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6B2sLxbLgGRzBQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 18:23:18 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 6/8] scsi: don't wait for quiesce in scsi_device_block()
Date:   Wed,  7 Jun 2023 20:22:47 +0200
Message-Id: <20230607182249.22623-7-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607182249.22623-1-mwilck@suse.com>
References: <20230607182249.22623-1-mwilck@suse.com>
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
---
 drivers/scsi/scsi_lib.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 657d10c57205..25ec6eb8df7f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2772,8 +2772,8 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
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
@@ -2788,10 +2788,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
 	mutex_unlock(&sdev->state_mutex);
-	if (err == 0) {
+	if (err == 0)
 		scsi_stop_queue(sdev);
-		blk_mq_wait_quiesce_done(sdev->request_queue->tag_set);
-	}
 
 	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
 		  dev_name(&sdev->sdev_gendev), err);
@@ -2889,11 +2887,15 @@ target_block(struct device *dev, void *data)
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

