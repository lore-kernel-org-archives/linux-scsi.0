Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83759C7EE29
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 22:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjFAW0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbjFAW0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 18:26:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF98193;
        Thu,  1 Jun 2023 15:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB2264A7C;
        Thu,  1 Jun 2023 22:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6197DC433D2;
        Thu,  1 Jun 2023 22:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685658369;
        bh=/bEiwvnUJ6kSXv+jGbT5WMyt4w66amdmPsuconbaKSw=;
        h=From:To:Cc:Subject:Date:From;
        b=TkY2If3hunyXXAkz0gmwAaThE3lGGKbgrVU7YO6tFq1Zaru177wo4UzDgn8ozmmdg
         QnadgBNAWpKmbsDgDCqFwd9Xp6QIwFTcxnG8pccayqlfN6A5pp4A3wO6GfPdlJwJR3
         POJz1fk40S/Wxlvd2eGlwqqo4zIBlMzQKpJOAnCsMBtBHSy4iqHLoMTs5tz6oJZbcr
         d+2xTwJuJPJxMjGFm1ZnCHBtp9bLJl4hVAUFn2/VwURhKHIf/Qv9G1vr33j6chacZ+
         ajkHOnbmuLMMRdjd0dnkyC6LQkxLPa+pHvzAbiyqiLxrlHTYY+DPhLPao0s+Zs098f
         Vyh8L/gAYnNtQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ata: libata-sata: Simplify ata_change_queue_depth()
Date:   Fri,  2 Jun 2023 07:26:07 +0900
Message-Id: <20230601222607.263024-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 141f3d6256e5 ("ata: libata-sata: Fix device queue depth control")
added a struct ata_device argument to ata_change_queue_depth() to
address problems with changing the queue depth of ATA devices managed
through libsas. This was due to problems with ata_scsi_find_dev() which
are now fixed with commit 7f875850f20a ("ata: libata-scsi: Use correct
device no in ata_find_dev()").

Undo some of the changes of commit 141f3d6256e5: remove the added struct
ata_device aregument and use again ata_scsi_find_dev() to find the
target ATA device structure. While doing this, also make sure that
ata_scsi_find_dev() is called with ap->lock held, as it should.

libsas and libata call sites of ata_change_queue_depth() are updated to
match the modified function arguments.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-sata.c           | 19 ++++++++++---------
 drivers/scsi/libsas/sas_scsi_host.c |  3 +--
 include/linux/libata.h              |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index f3e7396e3191..e3c9cb617048 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1023,7 +1023,6 @@ EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 /**
  *	ata_change_queue_depth - Set a device maximum queue depth
  *	@ap: ATA port of the target device
- *	@dev: target ATA device
  *	@sdev: SCSI device to configure queue depth for
  *	@queue_depth: new queue depth
  *
@@ -1031,24 +1030,27 @@ EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
  *	and libata.
  *
  */
-int ata_change_queue_depth(struct ata_port *ap, struct ata_device *dev,
-			   struct scsi_device *sdev, int queue_depth)
+int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
+			   int queue_depth)
 {
+	struct ata_device *dev;
 	unsigned long flags;
 
-	if (!dev || !ata_dev_enabled(dev))
-		return sdev->queue_depth;
+	spin_lock_irqsave(ap->lock, flags);
 
-	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev || queue_depth < 1 || queue_depth == sdev->queue_depth) {
+		spin_unlock_irqrestore(ap->lock, flags);
 		return sdev->queue_depth;
+	}
 
 	/* NCQ enabled? */
-	spin_lock_irqsave(ap->lock, flags);
 	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
 	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
 		queue_depth = 1;
 	}
+
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* limit and apply queue depth */
@@ -1082,8 +1084,7 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 
-	return ata_change_queue_depth(ap, ata_scsi_find_dev(ap, sdev),
-				      sdev, queue_depth);
+	return ata_change_queue_depth(ap, sdev, queue_depth);
 }
 EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index a36fa1c128a8..94c5f14f3c16 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -872,8 +872,7 @@ int sas_change_queue_depth(struct scsi_device *sdev, int depth)
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
 	if (dev_is_sata(dev))
-		return ata_change_queue_depth(dev->sata_dev.ap,
-					      sas_to_ata_dev(dev), sdev, depth);
+		return ata_change_queue_depth(dev->sata_dev.ap, sdev, depth);
 
 	if (!sdev->tagged_supported)
 		depth = 1;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 01f9fbb69f89..bc756f8586f3 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1144,8 +1144,8 @@ extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
-extern int ata_change_queue_depth(struct ata_port *ap, struct ata_device *dev,
-				  struct scsi_device *sdev, int queue_depth);
+extern int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
+				  int queue_depth);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
-- 
2.40.1

