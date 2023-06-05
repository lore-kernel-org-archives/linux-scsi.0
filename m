Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07AEC7EE32
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 10:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjFEKxB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 06:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjFEKwv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 06:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C753F9;
        Mon,  5 Jun 2023 03:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08EF362281;
        Mon,  5 Jun 2023 10:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD39EC433EF;
        Mon,  5 Jun 2023 10:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685962367;
        bh=rQ8/mjK/Dgp1u1RF/QawrvRn8L8w+/XbQ7He6zsazhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYs+s72H6WJnielhczNqRrCgHb9pLnkPTMnQSAtTODwIEE+LitDhxWdrXLrN8WfYN
         DdTy0vZoz0f53VePyzmkZxQwNOLQTOuGvKQ+Wq+JqvaGzRgXaznGmw9chAtyi9Onu8
         VBlXSXBehxT/wiqR9XL/DXddRhS1Wh4GWGKTNagVQH5EoFpivGw45WKdF2PeLmtPn4
         UVAU6EQdAaNHx0odF+9pa2WQRZR1aeXIxQgC3R31+N5kxV6qZ8m3/Y+nBNVI3k3GKE
         vY03XPTDLdnymY0WVuQ91GrNrAE8C8UTYgkQ47Vg+3L7IOmdIh1fWBcEsCCcTbGMMK
         M4zuDAyIVCopg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 1/3] ata: libata-sata: Improve ata_change_queue_depth()
Date:   Mon,  5 Jun 2023 19:52:42 +0900
Message-Id: <20230605105244.1045490-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605105244.1045490-1-dlemoal@kernel.org>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ata_change_queue_depth() implements different behaviors for ATA devices
managed by libsas than for those managed by libata directly.
Specifically, if a user attempts to set a device queue depth to a value
larger than 32 (ATA_MAX_QUEUE), the queue depth is capped to the maximum
and set to 32 for libsas managed devices whereas for libata managed
devices, the queue depth is unchanged and an error returned to the user.
This is due to the fact that for libsas devices, sdev->host->can_queue
may indicate the host (HBA) maximum number of commands that can be
queued rather than the device maximum queue depth.

Change ata_change_queue_depth() to provide a consistent behavior for all
devices by changing the queue depth capping code to a check that the
user provided value does not exceed the device maximum queue depth.
This check is moved before the code clearing or setting the
ATA_DFLAG_NCQ_OFF flag to ensure that this flag is not modified when an
invlaid queue depth is provided.

While at it, two other small improvements are added:
1) Use ata_ncq_supported() instead of ata_ncq_enabled() and clear the
   ATA_DFLAG_NCQ_OFF flag only and only if needed.
2) If the user provided queue depth is equal to the current queue depth,
   do not return an error as that is useless.

Overall, the behavior of ata_change_queue_depth() for libata managed
devices is unchanged. The behavior with libsas managed devices becomes
consistent with libata managed devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/ata/libata-sata.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index e3c9cb617048..6c07025011ed 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1035,6 +1035,7 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
 {
 	struct ata_device *dev;
 	unsigned long flags;
+	int max_queue_depth;
 
 	spin_lock_irqsave(ap->lock, flags);
 
@@ -1044,22 +1045,32 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
 		return sdev->queue_depth;
 	}
 
-	/* NCQ enabled? */
-	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
-	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
+	/*
+	 * Make sure that the queue depth requested does not exceed the device
+	 * capabilities.
+	 */
+	max_queue_depth = min(ATA_MAX_QUEUE, sdev->host->can_queue);
+	max_queue_depth = min(max_queue_depth, ata_id_queue_depth(dev->id));
+	if (queue_depth > max_queue_depth) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EINVAL;
+	}
+
+	/*
+	 * If NCQ is not supported by the device or if the target queue depth
+	 * is 1 (to disable drive side command queueing), turn off NCQ.
+	 */
+	if (queue_depth == 1 || !ata_ncq_supported(dev)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
 		queue_depth = 1;
+	} else {
+		dev->flags &= ~ATA_DFLAG_NCQ_OFF;
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	/* limit and apply queue depth */
-	queue_depth = min(queue_depth, sdev->host->can_queue);
-	queue_depth = min(queue_depth, ata_id_queue_depth(dev->id));
-	queue_depth = min(queue_depth, ATA_MAX_QUEUE);
-
-	if (sdev->queue_depth == queue_depth)
-		return -EINVAL;
+	if (queue_depth == sdev->queue_depth)
+		return sdev->queue_depth;
 
 	return scsi_change_queue_depth(sdev, queue_depth);
 }
-- 
2.40.1

