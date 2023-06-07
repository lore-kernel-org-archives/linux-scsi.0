Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160B0C8300C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 18:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjFGSYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjFGSXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 14:23:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E6F2720;
        Wed,  7 Jun 2023 11:23:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B6EB821A1D;
        Wed,  7 Jun 2023 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686162198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UJ4ir9kZvluKUTzvJ/eU4h6e3nLkJg4Ew2XDi2iZvew=;
        b=a5fRaKQpdW6lbX/+5J3Za/WNgfwS/scHhHWQh7VETnQGdgIEvmWSmoOPQyw4X2wkzzhcFk
        TpHF4XrzusVRlhCM1h6nTgKCKhYagKl+ap2woHzDeFHOuDz8slwkaVa41TUXMm+IP/vwFS
        oQMOpMGCMUVwjkc6fzUuyV9YoAP8r3w=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2D2471346D;
        Wed,  7 Jun 2023 18:23:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0OYZBxbLgGRzBQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 18:23:18 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 5/8] scsi: don't wait for quiesce in scsi_stop_queue()
Date:   Wed,  7 Jun 2023 20:22:46 +0200
Message-Id: <20230607182249.22623-6-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607182249.22623-1-mwilck@suse.com>
References: <20230607182249.22623-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 26e7ce25fa05..657d10c57205 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2726,24 +2726,16 @@ void scsi_start_queue(struct scsi_device *sdev)
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
+	 * After return, we still need to wait until quiesce is done.
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
@@ -2770,7 +2762,7 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	 * request queue.
 	 */
 	if (!ret)
-		scsi_stop_queue(sdev, true);
+		scsi_stop_queue(sdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
@@ -2796,8 +2788,10 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
 	mutex_unlock(&sdev->state_mutex);
-	if (err == 0)
-		scsi_stop_queue(sdev, false);
+	if (err == 0) {
+		scsi_stop_queue(sdev);
+		blk_mq_wait_quiesce_done(sdev->request_queue->tag_set);
+	}
 
 	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
 		  dev_name(&sdev->sdev_gendev), err);
-- 
2.40.1

