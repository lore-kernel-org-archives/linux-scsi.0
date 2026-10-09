Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380154F30CF;
	Fri,  9 Oct 2026 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563233; cv=none; b=DtoO5YKvaglwt0q3H0Vr6eMcif7yfA76e43Nk031G7MAxNEt+GTmppaIwdQIFZynTmLkF+qrQFdIt96X4b4jJ97YA5qur7ioR+VJqtqXO49iS6pS6UkMNNnnLGEpoTHm6eLdc6oZbJDaL8TpjZgVt7SAuN6/bb/4uo8e9GCOr8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563233; c=relaxed/simple;
	bh=NPt/Ob0ddEpBa6HOewtsoIFTFH1FhZji197onDNB5cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUR6o/2TDLFli8/u+G8Qx0wooCW8q7jaYhxCq73Yx25jvz+2hGFdpN3VBVppBYCfVwMJ8WNOTmX+ZsVYblARjvcmACcW85BUr9zRYc940sL7zYD95sYOYyaGtWn8vy9VfbDJKZYm6tXPSk12vS6Ilf1g7Ltp61rMQk2GJQ3UuqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=Q0zZR+XM; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="Q0zZR+XM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=NPt/Ob0ddEpBa6HOewtsoIFTFH1FhZji197onDNB5cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0zZR+XMSl+ySF/LYSrJ1TZiPQTDjGllEvKm9m9KU5A8OF/IwwaoIW+9RDTrLopCf
	 GlLA+i//NeerN2wFTQtfwr5c/9AUV1iHFdNrXP+0N4M10LMFmfbBYPvqdK2a/caB3U
	 ZdZNmj50rohJnzKNSGd9vj7Fce0zJX4WaqaQe1Yw=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id A6D8DBE779;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 624D65FC54;
	Fri,  9 Oct 2026 17:26:55 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v10 11/15] ata: libata-scsi: convert dev->sdev to per-LUN array
Date: Fri,  9 Oct 2026 16:55:18 +0100
Message-ID: <20261009155522.593045-12-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multi-LUN ATAPI devices share one ata_device and expose several SCSI
devices. Replace dev->sdev with an eight-slot array indexed by LUN and
update its callers. Single-LUN devices use slot 0; unused slots are NULL.
Reject out-of-range scan requests with -EINVAL.

Publish each slot only after the SCSI core accepts the device. Serialize
lookup and publication with the SCSI host scan mutex, and update the slot
under ap->lock. This keeps configuration failures invisible to libata and
prevents SCSI removal from racing publication.

Take references to pending slots under ap->lock before resuming or
rescanning them. Track pending resume and rescan work separately for each
LUN, so a deferred LUN does not repeat its siblings' completed work and a
deferred rescan does not repeat a successful resume callback. Distinguish
new EH requests from retries so completion cannot erase newer work.

Request runtime resume asynchronously for suspended LUNs and hold a PM
reference across retries. Waiting for runtime resume inside this worker
could deadlock with port suspend, which waits for the worker. Release PM
references on completion, cancellation, reinitialization, device disable
and removal. Release SCSI references outside the lock because device
release can sleep.

Iterate over every referenced LUN in the ZPODD callbacks. Wake attribution
remains shared by the physical ATA device and is armed once for the whole
callback, so sibling resumes cannot produce duplicate or delayed ejections.

Pass the referenced LUN-0 device to ata_scsi_assign_ofnode(). Concurrent
removal can clear its array slot while the reference is held.

Clear slots under ap->lock before removing devices. Schedule ATA detach
when the last populated LUN is destroyed.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-acpi.c  |   2 +-
 drivers/ata/libata-core.c  |  17 +-
 drivers/ata/libata-eh.c    |  11 +-
 drivers/ata/libata-scsi.c  | 336 +++++++++++++++++++++++++++----------
 drivers/ata/libata-zpodd.c |  46 +++--
 drivers/ata/libata.h       |   3 +
 include/linux/libata.h     |  15 +-
 7 files changed, 311 insertions(+), 119 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index bee738b68b3f..6c98a26d9f81 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -156,7 +156,7 @@ static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
 
 	if (dev) {
 		spin_lock_irqsave(ap->lock, flags);
-		sdev = dev->sdev;
+		sdev = ata_dev_scsi_device(dev, 0);
 		if (sdev && scsi_device_get(sdev))
 			sdev = NULL;
 		spin_unlock_irqrestore(ap->lock, flags);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f2f5ad727d20..4df3518f7085 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5490,7 +5490,7 @@ static void ata_port_suspend(struct ata_port *ap, pm_message_t mesg,
 	 * The next resume will schedule the rescan again. So cancel any rescan
 	 * that is not done yet.
 	 */
-	cancel_delayed_work_sync(&ap->scsi_rescan_task);
+	ata_scsi_cancel_rescan(ap);
 
 	/*
 	 * On some hardware, device fails to respond after spun down for
@@ -5675,6 +5675,9 @@ void ata_dev_init(struct ata_device *dev)
 	spin_lock_irqsave(ap->lock, flags);
 	dev->flags &= ~ATA_DFLAG_INIT_MASK;
 	dev->quirks = 0;
+	for (unsigned int lun = 0; lun < ATAPI_MAX_LUN; lun++)
+		ata_scsi_clear_pending(dev, lun);
+	dev->scsi_rescan_seq++;
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	memset((void *)dev + ATA_DEVICE_CLEAR_BEGIN, 0,
@@ -6393,12 +6396,16 @@ static void ata_port_detach(struct ata_port *ap)
 	/* Remove scsi devices */
 	ata_for_each_link(link, ap, HOST_FIRST) {
 		ata_for_each_dev(dev, link, ALL) {
-			if (dev->sdev) {
-				struct scsi_device *sdev = dev->sdev;
+			int lun;
+
+			for (lun = ATAPI_MAX_LUN - 1; lun >= 0; lun--) {
+				struct scsi_device *sdev = dev->sdev[lun];
 
-				/* The host driver may already be unloading. */
+				if (!sdev)
+					continue;
 				get_device(&sdev->sdev_gendev);
-				dev->sdev = NULL;
+				ata_scsi_clear_pending(dev, lun);
+				dev->sdev[lun] = NULL;
 				spin_unlock_irqrestore(ap->lock, flags);
 				scsi_remove_device(sdev);
 				put_device(&sdev->sdev_gendev);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c93c24b22d9c..25d335c33d0a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -504,9 +504,18 @@ void ata_eh_release(struct ata_port *ap)
 
 static void ata_eh_dev_disable(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
+	unsigned long flags;
+	int lun;
+
 	ata_acpi_on_disable(dev);
 	ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 | ATA_DNXFER_QUIET);
+	spin_lock_irqsave(ap->lock, flags);
 	dev->class++;
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++)
+		ata_scsi_clear_pending(dev, lun);
+	dev->scsi_rescan_seq++;
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	/*
 	 * From now till the next successful probe, ering is used to
@@ -3360,7 +3369,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			ehc->i.flags |= ATA_EHI_SETMODE;
 
 			/* schedule the scsi_rescan_device() here */
-			schedule_delayed_work(&ap->scsi_rescan_task, 0);
+			ata_scsi_schedule_rescan(dev);
 		} else if (dev->class == ATA_DEV_UNKNOWN &&
 			   ehc->tries[dev->devno] &&
 			   ata_class_enabled(ehc->classes[dev->devno])) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3131d84204ed..efd0916f8180 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -33,6 +33,7 @@
 #include <linux/unaligned.h>
 #include <linux/ioprio.h>
 #include <linux/of.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -1135,7 +1136,8 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 	if (dev->flags & ATA_DFLAG_TRUSTED)
 		sdev->security_supported = 1;
 
-	dev->sdev = sdev;
+	if (sdev->lun >= ATAPI_MAX_LUN)
+		return -EINVAL;
 	return 0;
 }
 
@@ -1206,10 +1208,10 @@ EXPORT_SYMBOL_GPL(ata_scsi_sdev_configure);
  *
  *	@sdev is about to be destroyed for hot/warm unplugging.  If
  *	this unplugging was initiated by libata as indicated by NULL
- *	dev->sdev, this function doesn't have to do anything.
+ *	dev->sdev[], this function doesn't have to do anything.
  *	Otherwise, SCSI layer initiated warm-unplug is in progress.
- *	Clear dev->sdev, schedule the device for ATA detach and invoke
- *	EH.
+ *	Clear the per-LUN slot; when the last populated LUN is destroyed,
+ *	schedule ATA-level detach via EH.
  *
  *	LOCKING:
  *	Defined by SCSI layer.  We don't really care.
@@ -1224,11 +1226,24 @@ void ata_scsi_sdev_destroy(struct scsi_device *sdev)
 
 	spin_lock_irqsave(ap->lock, flags);
 	dev = __ata_scsi_find_dev(ap, sdev);
-	if (dev && dev->sdev) {
-		/* SCSI device already in CANCEL state, no need to offline it */
-		dev->sdev = NULL;
-		dev->flags |= ATA_DFLAG_DETACH;
-		ata_port_schedule_eh(ap);
+	if (dev && sdev->lun < ATAPI_MAX_LUN &&
+	    dev->sdev[sdev->lun] == sdev) {
+		int lun;
+		bool last;
+
+		ata_scsi_clear_pending(dev, sdev->lun);
+		dev->sdev[sdev->lun] = NULL;
+		last = true;
+		for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+			if (dev->sdev[lun]) {
+				last = false;
+				break;
+			}
+		}
+		if (last) {
+			dev->flags |= ATA_DFLAG_DETACH;
+			ata_port_schedule_eh(ap);
+		}
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
 
@@ -3052,12 +3067,9 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		 *
 		 * If door lock fails, always clear sdev->locked to
 		 * avoid this infinite loop.
-		 *
-		 * This may happen before SCSI scan is complete.  Make
-		 * sure qc->dev->sdev isn't NULL before dereferencing.
 		 */
-		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
-			qc->dev->sdev->locked = 0;
+		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL)
+			qc->scsicmd->device->locked = 0;
 
 		if (cmd->result)
 			ata_scsi_qc_done(qc, false, 0);
@@ -5259,9 +5271,9 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
 }
 
 #ifdef CONFIG_OF
-static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_port *ap)
+static void ata_scsi_assign_ofnode(struct scsi_device *sdev,
+				   struct ata_device *dev, struct ata_port *ap)
 {
-	struct scsi_device *sdev = dev->sdev;
 	struct device *d = ap->host->dev;
 	struct device_node *np = d->of_node;
 	struct device_node *child;
@@ -5281,11 +5293,48 @@ static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_port *ap)
 	}
 }
 #else
-static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_port *ap)
+static void ata_scsi_assign_ofnode(struct scsi_device *sdev,
+				   struct ata_device *dev, struct ata_port *ap)
 {
 }
 #endif
 
+/* Publish fully configured SCSI devices against concurrent removal. */
+static void ata_scsi_publish_sdevs(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	struct Scsi_Host *shost = ap->scsi_host;
+	unsigned int channel = 0, id = 0;
+	unsigned long flags;
+	unsigned int lun, max_lun;
+
+	if (ata_is_host_link(dev->link))
+		id = dev->devno;
+	else
+		channel = dev->link->pmp;
+
+	/* Serialize lookup and publication with SCSI device removal. */
+	max_lun = min_t(unsigned int, shost->max_lun, ATAPI_MAX_LUN);
+	mutex_lock(&shost->scan_mutex);
+	for (lun = 0; lun < max_lun; lun++) {
+		struct scsi_device *sdev;
+
+		sdev = scsi_device_lookup(shost, channel, id, lun);
+		if (!sdev)
+			continue;
+
+		spin_lock_irqsave(ap->lock, flags);
+		if (!dev->sdev[lun])
+			dev->sdev[lun] = sdev;
+		else
+			WARN_ON_ONCE(dev->sdev[lun] != sdev);
+		spin_unlock_irqrestore(ap->lock, flags);
+
+		scsi_device_put(sdev);
+	}
+	mutex_unlock(&shost->scan_mutex);
+}
+
 void ata_scsi_scan_host(struct ata_port *ap, int sync)
 {
 	int tries = 5;
@@ -5299,7 +5348,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			struct scsi_device *sdev;
 			int channel = 0, id = 0;
 
-			if (dev->sdev)
+			if (dev->sdev[0])
 				continue;
 
 			if (ata_is_host_link(link))
@@ -5309,13 +5358,12 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
-			if (!IS_ERR(sdev)) {
-				dev->sdev = sdev;
-				ata_scsi_assign_ofnode(dev, ap);
-				scsi_device_put(sdev);
-			} else {
-				dev->sdev = NULL;
-			}
+			if (IS_ERR(sdev))
+				continue;
+
+			ata_scsi_publish_sdevs(dev);
+			ata_scsi_assign_ofnode(sdev, dev, ap);
+			scsi_device_put(sdev);
 		}
 	}
 
@@ -5325,7 +5373,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	 */
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			if (!dev->sdev)
+			if (!dev->sdev[0])
 				goto exit_loop;
 		}
 	}
@@ -5366,7 +5414,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
  *
  *	This function is called from ata_eh_detach_dev() and is responsible for
  *	taking the SCSI device attached to @dev offline.  This function is
- *	called with host lock which protects dev->sdev against clearing.
+ *	called with host lock which protects dev->sdev[] against clearing.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -5376,11 +5424,16 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
  */
 bool ata_scsi_offline_dev(struct ata_device *dev)
 {
-	if (dev->sdev) {
-		scsi_device_set_state(dev->sdev, SDEV_OFFLINE);
-		return true;
+	bool found = false;
+	int lun;
+
+	for (lun = ATAPI_MAX_LUN - 1; lun >= 0; lun--) {
+		if (dev->sdev[lun]) {
+			scsi_device_set_state(dev->sdev[lun], SDEV_OFFLINE);
+			found = true;
+		}
 	}
-	return false;
+	return found;
 }
 
 /**
@@ -5396,49 +5449,39 @@ bool ata_scsi_offline_dev(struct ata_device *dev)
 static void ata_scsi_remove_dev(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
-	struct scsi_device *sdev;
+	struct scsi_device *sdevs[ATAPI_MAX_LUN] = {};
 	unsigned long flags;
+	int lun;
 
-	/* Alas, we need to grab scan_mutex to ensure SCSI device
-	 * state doesn't change underneath us and thus
-	 * scsi_device_get() always succeeds.  The mutex locking can
-	 * be removed if there is __scsi_device_get() interface which
-	 * increments reference counts regardless of device state.
-	 */
 	mutex_lock(&ap->scsi_host->scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
-	/* clearing dev->sdev is protected by host lock */
-	sdev = dev->sdev;
-	dev->sdev = NULL;
+	for (lun = ATAPI_MAX_LUN - 1; lun >= 0; lun--) {
+		struct scsi_device *sdev = dev->sdev[lun];
+
+		ata_scsi_clear_pending(dev, lun);
+		dev->sdev[lun] = NULL;
+		if (!sdev)
+			continue;
 
-	if (sdev) {
-		/* If user initiated unplug races with us, sdev can go
-		 * away underneath us after the host lock and
-		 * scan_mutex are released.  Hold onto it.
-		 */
 		if (scsi_device_get(sdev) == 0) {
-			/* The following ensures the attached sdev is
-			 * offline on return from ata_scsi_offline_dev()
-			 * regardless it wins or loses the race
-			 * against this function.
-			 */
 			scsi_device_set_state(sdev, SDEV_OFFLINE);
+			sdevs[lun] = sdev;
 		} else {
 			WARN_ON(1);
-			sdev = NULL;
 		}
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
 	mutex_unlock(&ap->scsi_host->scan_mutex);
 
-	if (sdev) {
+	for (lun = ATAPI_MAX_LUN - 1; lun >= 0; lun--) {
+		if (!sdevs[lun])
+			continue;
 		ata_dev_info(dev, "detaching (SCSI %s)\n",
-			     dev_name(&sdev->sdev_gendev));
-
-		scsi_remove_device(sdev);
-		scsi_device_put(sdev);
+			     dev_name(&sdevs[lun]->sdev_gendev));
+		scsi_remove_device(sdevs[lun]);
+		scsi_device_put(sdevs[lun]);
 	}
 }
 
@@ -5475,9 +5518,12 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
  */
 void ata_scsi_media_change_notify(struct ata_device *dev)
 {
-	if (dev->sdev)
-		sdev_evt_send_simple(dev->sdev, SDEV_EVT_MEDIA_CHANGE,
-				     GFP_ATOMIC);
+	int lun;
+
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++)
+		if (dev->sdev[lun])
+			sdev_evt_send_simple(dev->sdev[lun],
+					     SDEV_EVT_MEDIA_CHANGE, GFP_ATOMIC);
 }
 
 /**
@@ -5585,15 +5631,67 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 	return rc;
 }
 
+/* Called with ap->lock held, before clearing a SCSI device slot. */
+void ata_scsi_clear_pending(struct ata_device *dev, unsigned int lun)
+{
+	lockdep_assert_held(dev->link->ap->lock);
+
+	if (dev->sdev_rescan_pm & BIT(lun)) {
+		pm_runtime_put_noidle(&dev->sdev[lun]->sdev_gendev);
+		dev->sdev_rescan_pm &= ~BIT(lun);
+	}
+	dev->sdev_resume_pending &= ~BIT(lun);
+	dev->sdev_rescan_pending &= ~BIT(lun);
+}
+
+void ata_scsi_cancel_rescan(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+	unsigned long flags;
+	int lun;
+
+	cancel_delayed_work_sync(&ap->scsi_rescan_task);
+	spin_lock_irqsave(ap->lock, flags);
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, link, ALL) {
+			for (lun = 0; lun < ATAPI_MAX_LUN; lun++)
+				ata_scsi_clear_pending(dev, lun);
+			dev->scsi_rescan_seq++;
+		}
+	}
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
+/* Record a new revalidation separately from retries of the previous one. */
+void ata_scsi_schedule_rescan(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	unsigned long flags;
+	int lun;
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev->scsi_rescan_seq++;
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		if (!dev->sdev[lun])
+			continue;
+		dev->sdev_rescan_pending |= BIT(lun);
+		if (dev->flags & ATA_DFLAG_RESUMING)
+			dev->sdev_resume_pending |= BIT(lun);
+	}
+	dev->flags &= ~ATA_DFLAG_RESUMING;
+	schedule_delayed_work(&ap->scsi_rescan_task, 0);
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
 /**
- *	ata_scsi_dev_rescan - initiate scsi_rescan_device()
- *	@work: Pointer to ATA port to perform scsi_rescan_device()
+ * ata_scsi_dev_rescan - resume and rescan pending SCSI LUNs
+ * @work: Pointer to ATA port to perform scsi_rescan_device()
  *
- *	After ATA pass thru (SAT) commands are executed successfully,
- *	libata need to propagate the changes to SCSI layer.
+ * Propagate ATA revalidation to SCSI. Completed LUNs are not revisited on
+ * retry, and a deferred rescan does not repeat a completed resume callback.
  *
- *	LOCKING:
- *	Kernel thread context (may sleep).
+ * LOCKING: Kernel thread context (may sleep).
  */
 void ata_scsi_dev_rescan(struct work_struct *work)
 {
@@ -5602,55 +5700,107 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long flags;
-	bool do_resume;
-	int ret = 0;
+	bool retry = false;
 
 	mutex_lock(&ap->scsi_scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			struct scsi_device *sdev = dev->sdev;
+			struct scsi_device *sdevs[ATAPI_MAX_LUN] = {};
+			unsigned int seq = dev->scsi_rescan_seq;
+			u8 resume = dev->sdev_resume_pending;
+			int lun;
 
-			/*
-			 * If the port was suspended before this was scheduled,
-			 * bail out.
-			 */
 			if (ap->pflags & ATA_PFLAG_SUSPENDED)
 				goto unlock_ap;
 
-			if (!sdev)
-				continue;
-			if (scsi_device_get(sdev))
-				continue;
+			for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+				if (!(dev->sdev_rescan_pending & BIT(lun)))
+					continue;
+				if (!dev->sdev[lun] ||
+				    scsi_device_get(dev->sdev[lun])) {
+					ata_scsi_clear_pending(dev, lun);
+					continue;
+				}
+				sdevs[lun] = dev->sdev[lun];
+				if (!(dev->sdev_rescan_pm & BIT(lun))) {
+					pm_runtime_get_noresume(&sdevs[lun]->sdev_gendev);
+					dev->sdev_rescan_pm |= BIT(lun);
+				}
+			}
 
-			do_resume = dev->flags & ATA_DFLAG_RESUMING;
+			for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+				struct scsi_device *sdev = sdevs[lun];
+				bool resumed = false, put_pm = false;
+				int err;
 
-			spin_unlock_irqrestore(ap->lock, flags);
-			if (do_resume) {
-				ret = scsi_resume_device(sdev);
-				if (ret == -EWOULDBLOCK) {
+				if (!sdev)
+					continue;
+				if (dev->sdev[lun] != sdev ||
+				    dev->scsi_rescan_seq != seq) {
+					spin_unlock_irqrestore(ap->lock, flags);
 					scsi_device_put(sdev);
-					goto unlock_scan;
+					spin_lock_irqsave(ap->lock, flags);
+					continue;
 				}
-				dev->flags &= ~ATA_DFLAG_RESUMING;
-			}
-			ret = scsi_rescan_device(sdev);
-			scsi_device_put(sdev);
-			spin_lock_irqsave(ap->lock, flags);
 
-			if (ret)
-				goto unlock_ap;
+				spin_unlock_irqrestore(ap->lock, flags);
+				/*
+				 * Port suspend waits for this worker. Never wait for
+				 * runtime resume here: request it asynchronously and
+				 * retain the PM reference across retries instead.
+				 */
+				err = pm_runtime_get_if_active(&sdev->sdev_gendev);
+				if (!err) {
+					err = pm_request_resume(&sdev->sdev_gendev);
+					if (err >= 0 || err == -EINPROGRESS ||
+					    err == -EACCES)
+						err = -EWOULDBLOCK;
+					goto complete;
+				}
+				/* The pending-work reference already keeps it active. */
+				if (err > 0)
+					pm_runtime_put_noidle(&sdev->sdev_gendev);
+				if (resume & BIT(lun)) {
+					err = scsi_resume_device(sdev);
+					if (err == -EWOULDBLOCK)
+						goto complete;
+					resumed = true;
+				}
+				err = scsi_rescan_device(sdev);
+complete:
+				spin_lock_irqsave(ap->lock, flags);
+				/* Removal or a new EH request supersedes this pass. */
+				if (dev->sdev[lun] == sdev &&
+				    dev->scsi_rescan_seq == seq) {
+					if (resumed)
+						dev->sdev_resume_pending &= ~BIT(lun);
+					if (err != -EWOULDBLOCK) {
+						dev->sdev_resume_pending &= ~BIT(lun);
+						dev->sdev_rescan_pending &= ~BIT(lun);
+						put_pm = dev->sdev_rescan_pm & BIT(lun);
+						dev->sdev_rescan_pm &= ~BIT(lun);
+					}
+				}
+				spin_unlock_irqrestore(ap->lock, flags);
+				if (err && err != -EWOULDBLOCK)
+					sdev_printk(KERN_WARNING, sdev,
+						    "rescan failed: %d\n", err);
+				if (put_pm)
+					pm_runtime_put_autosuspend(&sdev->sdev_gendev);
+				scsi_device_put(sdev);
+				spin_lock_irqsave(ap->lock, flags);
+			}
+			retry |= dev->sdev_rescan_pending != 0;
 		}
 	}
 
 unlock_ap:
 	spin_unlock_irqrestore(ap->lock, flags);
-unlock_scan:
 	mutex_unlock(&ap->scsi_scan_mutex);
 
-	/* Reschedule with a delay if scsi_rescan_device() returned an error */
-	if (ret)
+	if (retry)
 		schedule_delayed_work(&ap->scsi_rescan_task,
 				      msecs_to_jiffies(5));
 }
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 309b3769ae01..6ff0a8ee11ba 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -114,7 +114,7 @@ static bool zpready(struct ata_device *dev)
 		return false;
 
 	sense_buf = dev->sector_buf;
-	ret = atapi_eh_request_sense(dev, sense_buf, sense_key);
+	ret = atapi_eh_request_sense(dev, 0, sense_buf, sense_key);
 	if (ret)
 		return false;
 
@@ -175,14 +175,14 @@ bool zpodd_zpready(struct ata_device *dev)
 }
 
 /* Return a referenced SCSI device; the caller must drop it outside ap->lock. */
-static struct scsi_device *zpodd_get_sdev(struct ata_device *dev)
+static struct scsi_device *zpodd_get_sdev(struct ata_device *dev, unsigned int lun)
 {
 	struct ata_port *ap = dev->link->ap;
 	struct scsi_device *sdev;
 	unsigned long flags;
 
 	spin_lock_irqsave(ap->lock, flags);
-	sdev = dev->sdev;
+	sdev = dev->sdev[lun];
 	if (sdev && scsi_device_get(sdev))
 		sdev = NULL;
 	spin_unlock_irqrestore(ap->lock, flags);
@@ -203,11 +203,15 @@ void zpodd_enable_run_wake(struct ata_device *dev)
 	struct ata_port *ap = dev->link->ap;
 	struct zpodd *zpodd = dev->zpodd;
 	unsigned long flags;
-	struct scsi_device *sdev = zpodd_get_sdev(dev);
+	int lun;
 
-	if (sdev) {
-		sdev_disable_disk_events(sdev);
-		scsi_device_put(sdev);
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		struct scsi_device *sdev = zpodd_get_sdev(dev, lun);
+
+		if (sdev) {
+			sdev_disable_disk_events(sdev);
+			scsi_device_put(sdev);
+		}
 	}
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -253,7 +257,7 @@ void zpodd_post_poweron(struct ata_device *dev)
 	struct zpodd *zpodd = dev->zpodd;
 	unsigned long flags;
 	bool from_notify;
-	struct scsi_device *sdev;
+	int lun;
 
 	spin_lock_irqsave(ap->lock, flags);
 	if (!zpodd->powered_off) {
@@ -271,10 +275,13 @@ void zpodd_post_poweron(struct ata_device *dev)
 	zpodd->zp_sampled = false;
 	zpodd->zp_ready = false;
 
-	sdev = zpodd_get_sdev(dev);
-	if (sdev) {
-		sdev_enable_disk_events(sdev);
-		scsi_device_put(sdev);
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		struct scsi_device *sdev = zpodd_get_sdev(dev, lun);
+
+		if (sdev) {
+			sdev_enable_disk_events(sdev);
+			scsi_device_put(sdev);
+		}
 	}
 }
 
@@ -283,8 +290,8 @@ static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 	struct ata_device *ata_dev = context;
 	struct ata_port *ap = ata_dev->link->ap;
 	struct zpodd *zpodd = ata_dev->zpodd;
-	struct scsi_device *sdev;
 	unsigned long flags;
+	int lun;
 
 	if (event != ACPI_NOTIFY_DEVICE_WAKE)
 		return;
@@ -296,11 +303,14 @@ static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 		zpodd->from_notify = true;
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	sdev = zpodd_get_sdev(ata_dev);
-	if (sdev) {
-		/* The PM core handles an already active or resuming device. */
-		pm_runtime_resume(&sdev->sdev_gendev);
-		scsi_device_put(sdev);
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		struct scsi_device *sdev = zpodd_get_sdev(ata_dev, lun);
+
+		if (sdev) {
+			/* PM handles an already active or resuming device. */
+			pm_runtime_resume(&sdev->sdev_gendev);
+			scsi_device_put(sdev);
+		}
 	}
 
 	/* Do not discard attribution while another wake callback is active. */
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index aedc6b61196b..e86052d4b067 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -171,6 +171,9 @@ extern void ata_scsi_set_sense(struct ata_device *dev,
 extern void ata_scsi_media_change_notify(struct ata_device *dev);
 extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
+void ata_scsi_schedule_rescan(struct ata_device *dev);
+void ata_scsi_clear_pending(struct ata_device *dev, unsigned int lun);
+void ata_scsi_cancel_rescan(struct ata_port *ap);
 extern int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, u64 lun);
 void ata_scsi_sdev_config(struct scsi_device *sdev);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 03511280800f..7cdad5096c06 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -733,7 +733,12 @@ struct ata_device {
 	unsigned int		devno;		/* 0 or 1 */
 	u64			quirks;		/* List of broken features */
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
-	struct scsi_device	*sdev;		/* attached SCSI device */
+	struct scsi_device	*sdev[ATAPI_MAX_LUN];	/* per-LUN SCSI devices */
+	/* SCSI rescan work, protected by the port lock. */
+	unsigned int		scsi_rescan_seq;
+	u8			sdev_resume_pending;
+	u8			sdev_rescan_pending;
+	u8			sdev_rescan_pm;
 	void			*private_data;
 #ifdef CONFIG_ATA_ACPI
 	union acpi_object	*gtf_cache;
@@ -1730,6 +1735,14 @@ static inline unsigned int ata_dev_absent(const struct ata_device *dev)
 	return ata_class_absent(dev->class);
 }
 
+static inline struct scsi_device *
+ata_dev_scsi_device(struct ata_device *dev, unsigned int lun)
+{
+	if (WARN_ON_ONCE(lun >= ATAPI_MAX_LUN))
+		return NULL;
+	return dev->sdev[lun];
+}
+
 /*
  * link helpers
  */
-- 
2.43.0

