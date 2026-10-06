Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51394F6491;
	Tue,  6 Oct 2026 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330133; cv=none; b=RyfeR4T0A5ixT589jiB3DawlsGesy507haTRCQPF1ykKcx+MgOJsbklVSzTVj/hnbMLY/YQvettE4IVHT8h2NxhxgCjbMb1fmczk1ZOYrks92Au51H0bqzyAHbT7xYqE7hEEYsFSmOVCqg2nuXUuqUkpyyGwoaoT3d1DM2Rbz9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330133; c=relaxed/simple;
	bh=rJ47A8QQIFdnksoiIpETw/llVf7dNVDbZmCZT6GuDJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnXGNBJpNwTBrSl3Y5xP8QeJ/E9jI6LdrBpbIlQPI1URM79RuIjEmj5NMnhNRuUBquOtNQLfQEcRAEszfezNlD648oY/Q1qpSNAWI0wYprW4VkABFpGvaBjSehnisr4fYfntYNl2m8HaJhZckyKeCmnPhgFlJlOAvl+S6q3s+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=ovYn878h; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="ovYn878h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791330125;
	bh=rJ47A8QQIFdnksoiIpETw/llVf7dNVDbZmCZT6GuDJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovYn878hFHU8p6AhzrM2XvvrHGCakS79s/CDP0v94bTUZqgya+mp5fQGeOTJ4LGas
	 Xb82Qt8fIRqC9fchsDeunlew8UIQYoLIB8IZ/0jp8KBaAoDzFi4y1LWYULO1Smv9oR
	 w7uBOMLYyY5PE/KacT+gHnzeq8Wng/x8nH64PZ8w=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id CD2C9BE5FE;
	Tue,  6 Oct 2026 23:42:05 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 6F9245FC57;
	Wed,  7 Oct 2026 00:42:05 +0100 (BST)
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
Subject: [PATCH v9 07/11] ata: libata-scsi: convert dev->sdev to per-LUN array
Date: Wed,  7 Oct 2026 00:41:57 +0100
Message-ID: <20261006234202.1139018-8-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006234202.1139018-1-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
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

Take references to populated slots under ap->lock before resuming or
rescanning them. Release all references outside the lock because device
release can sleep. If one LUN needs a retry, continue with the others,
keep ATA_DFLAG_RESUMING set and schedule another pass.

Pass the referenced LUN-0 device to ata_scsi_assign_ofnode(). Concurrent
removal can clear its array slot while the reference is held.

Clear slots under ap->lock before removing devices. Schedule ATA detach
when the last populated LUN is destroyed.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-acpi.c  |   9 +-
 drivers/ata/libata-core.c  |  11 ++-
 drivers/ata/libata-scsi.c  | 167 +++++++++++++++++++++----------------
 drivers/ata/libata-zpodd.c |  48 ++++++-----
 include/linux/libata.h     |  10 ++-
 5 files changed, 144 insertions(+), 101 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 4433f626246b..2d1662f6f064 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -153,10 +153,13 @@ static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
 	char *envp[] = { event_string, NULL };
 
 	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
-	} else
+		struct scsi_device *sdev = ata_dev_scsi_device(dev, 0);
+
+		if (sdev)
+			kobj = &sdev->sdev_gendev.kobj;
+	} else {
 		kobj = &ap->dev->kobj;
+	}
 
 	if (kobj) {
 		snprintf(event_string, 20, "BAY_EVENT=%d", event);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f2f5ad727d20..8cf1ea24fe0b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6393,12 +6393,15 @@ static void ata_port_detach(struct ata_port *ap)
 	/* Remove scsi devices */
 	ata_for_each_link(link, ap, HOST_FIRST) {
 		ata_for_each_dev(dev, link, ALL) {
-			if (dev->sdev) {
-				struct scsi_device *sdev = dev->sdev;
+			int lun;
 
-				/* The host driver may already be unloading. */
+			for (lun = ATAPI_MAX_LUN - 1; lun >= 0; lun--) {
+				struct scsi_device *sdev = dev->sdev[lun];
+
+				if (!sdev)
+					continue;
 				get_device(&sdev->sdev_gendev);
-				dev->sdev = NULL;
+				dev->sdev[lun] = NULL;
 				spin_unlock_irqrestore(ap->lock, flags);
 				scsi_remove_device(sdev);
 				put_device(&sdev->sdev_gendev);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3131d84204ed..68d6ca1f791d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1135,7 +1135,9 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 	if (dev->flags & ATA_DFLAG_TRUSTED)
 		sdev->security_supported = 1;
 
-	dev->sdev = sdev;
+	if (sdev->lun >= ATAPI_MAX_LUN)
+		return -EINVAL;
+	dev->sdev[sdev->lun] = sdev;
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
@@ -1224,11 +1226,23 @@ void ata_scsi_sdev_destroy(struct scsi_device *sdev)
 
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
 
@@ -3052,12 +3066,9 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
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
@@ -5259,9 +5270,9 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
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
@@ -5281,7 +5292,8 @@ static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_port *ap)
 	}
 }
 #else
-static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_port *ap)
+static void ata_scsi_assign_ofnode(struct scsi_device *sdev,
+				   struct ata_device *dev, struct ata_port *ap)
 {
 }
 #endif
@@ -5299,7 +5311,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			struct scsi_device *sdev;
 			int channel = 0, id = 0;
 
-			if (dev->sdev)
+			if (dev->sdev[0])
 				continue;
 
 			if (ata_is_host_link(link))
@@ -5310,11 +5322,11 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
 			if (!IS_ERR(sdev)) {
-				dev->sdev = sdev;
-				ata_scsi_assign_ofnode(dev, ap);
+				dev->sdev[0] = sdev;
+				ata_scsi_assign_ofnode(sdev, dev, ap);
 				scsi_device_put(sdev);
 			} else {
-				dev->sdev = NULL;
+				dev->sdev[0] = NULL;
 			}
 		}
 	}
@@ -5325,7 +5337,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	 */
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			if (!dev->sdev)
+			if (!dev->sdev[0])
 				goto exit_loop;
 		}
 	}
@@ -5366,7 +5378,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
  *
  *	This function is called from ata_eh_detach_dev() and is responsible for
  *	taking the SCSI device attached to @dev offline.  This function is
- *	called with host lock which protects dev->sdev against clearing.
+ *	called with host lock which protects dev->sdev[] against clearing.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -5376,11 +5388,16 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
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
@@ -5396,49 +5413,38 @@ bool ata_scsi_offline_dev(struct ata_device *dev)
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
 
@@ -5475,9 +5481,12 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
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
@@ -5610,7 +5619,9 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			struct scsi_device *sdev = dev->sdev;
+			struct scsi_device *sdevs[ATAPI_MAX_LUN] = {};
+			bool retry = false;
+			int lun, err;
 
 			/*
 			 * If the port was suspended before this was scheduled,
@@ -5619,34 +5630,42 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 			if (ap->pflags & ATA_PFLAG_SUSPENDED)
 				goto unlock_ap;
 
-			if (!sdev)
-				continue;
-			if (scsi_device_get(sdev))
-				continue;
+			for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+				if (dev->sdev[lun] &&
+				    !scsi_device_get(dev->sdev[lun]))
+					sdevs[lun] = dev->sdev[lun];
+			}
 
 			do_resume = dev->flags & ATA_DFLAG_RESUMING;
 
-			spin_unlock_irqrestore(ap->lock, flags);
-			if (do_resume) {
-				ret = scsi_resume_device(sdev);
-				if (ret == -EWOULDBLOCK) {
-					scsi_device_put(sdev);
-					goto unlock_scan;
+			for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+				if (!sdevs[lun])
+					continue;
+
+				spin_unlock_irqrestore(ap->lock, flags);
+				if (do_resume) {
+					err = scsi_resume_device(sdevs[lun]);
+					if (err == -EWOULDBLOCK)
+						goto put_sdev;
 				}
-				dev->flags &= ~ATA_DFLAG_RESUMING;
+				err = scsi_rescan_device(sdevs[lun]);
+put_sdev:
+				/* A deferred LUN must not prevent scanning its siblings. */
+				if (err) {
+					ret = err;
+					retry = true;
+				}
+				scsi_device_put(sdevs[lun]);
+				spin_lock_irqsave(ap->lock, flags);
 			}
-			ret = scsi_rescan_device(sdev);
-			scsi_device_put(sdev);
-			spin_lock_irqsave(ap->lock, flags);
 
-			if (ret)
-				goto unlock_ap;
+			if (do_resume && !retry)
+				dev->flags &= ~ATA_DFLAG_RESUMING;
 		}
 	}
 
 unlock_ap:
 	spin_unlock_irqrestore(ap->lock, flags);
-unlock_scan:
 	mutex_unlock(&ap->scsi_scan_mutex);
 
 	/* Reschedule with a delay if scsi_rescan_device() returned an error */
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 581eb41ea0f3..bbdcaaa35798 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -174,14 +174,14 @@ bool zpodd_zpready(struct ata_device *dev)
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
@@ -200,11 +200,15 @@ static struct scsi_device *zpodd_get_sdev(struct ata_device *dev)
 void zpodd_enable_run_wake(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
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
 
 	zpodd->powered_off = true;
@@ -238,7 +242,7 @@ void zpodd_disable_run_wake(struct ata_device *dev)
 void zpodd_post_poweron(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
-	struct scsi_device *sdev;
+	int lun;
 
 	if (!zpodd->powered_off)
 		return;
@@ -254,10 +258,13 @@ void zpodd_post_poweron(struct ata_device *dev)
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
 
@@ -265,18 +272,21 @@ static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
 	struct zpodd *zpodd = ata_dev->zpodd;
-	struct scsi_device *sdev;
+	int lun;
 
 	if (event != ACPI_NOTIFY_DEVICE_WAKE)
 		return;
-	sdev = zpodd_get_sdev(ata_dev);
-	if (!sdev)
-		return;
-	if (pm_runtime_suspended(&sdev->sdev_gendev)) {
-		zpodd->from_notify = true;
-		pm_runtime_resume(&sdev->sdev_gendev);
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		struct scsi_device *sdev = zpodd_get_sdev(ata_dev, lun);
+
+		if (!sdev)
+			continue;
+		if (pm_runtime_suspended(&sdev->sdev_gendev)) {
+			zpodd->from_notify = true;
+			pm_runtime_resume(&sdev->sdev_gendev);
+		}
+		scsi_device_put(sdev);
 	}
-	scsi_device_put(sdev);
 }
 
 static void ata_acpi_add_pm_notifier(struct ata_device *dev)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 03511280800f..b9831be8dae2 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -733,7 +733,7 @@ struct ata_device {
 	unsigned int		devno;		/* 0 or 1 */
 	u64			quirks;		/* List of broken features */
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
-	struct scsi_device	*sdev;		/* attached SCSI device */
+	struct scsi_device	*sdev[ATAPI_MAX_LUN];	/* per-LUN SCSI devices */
 	void			*private_data;
 #ifdef CONFIG_ATA_ACPI
 	union acpi_object	*gtf_cache;
@@ -1730,6 +1730,14 @@ static inline unsigned int ata_dev_absent(const struct ata_device *dev)
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

