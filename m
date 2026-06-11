Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166842C3268;
	Thu, 11 Jun 2026 02:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781145845; cv=none; b=cMo8LV008QBrO+WBCULdbJzuXl7HXtw3hrZk5yyanCiBt/7poHmNlGb0LDCMmpg7Io0CFlcE10zEfsHWplu0O7a12RZKwPG9ODUDZnX43yQZWpoL4qgxC0ROMfX14C+zL5T4/+VTraR/7dTMvgOUYlwkkp4aklX6Axz4GQDAllM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781145845; c=relaxed/simple;
	bh=kvnFMPzErC5rcQ7UfyvZP+e6dXLXP3d/9dahDjswQhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0yQk3fOtdRvZSiQH8/wZMqlvqm7u3BGtjaFilGv1Q9RLegWBLowl1QOyYddCSLugEMJf6FBJSRcdh2PIvrFRTfxLmGKaapyawKT/1fEwbdOCEIJ1ZcrTkY3REWuDYQj8cRc92NJNuJEP9erFHwFbHG6kimfJHrnr97Jm/WcZeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=CYt2YJ5L; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="CYt2YJ5L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1781145841;
	bh=kvnFMPzErC5rcQ7UfyvZP+e6dXLXP3d/9dahDjswQhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYt2YJ5LvTzU0t6AGaI2j0GC1aOFTaQaISLuMBjnmOHv9ZD3ZZC/B5/ygdKPnn4IX
	 hZ4JTF5rE3copqA/p7hcbucVF9bxkRwl68G97NbYIjNGon3chrsOtxw8YM44mLz1+V
	 fNzGhOYf+EE+jqvejsV7Vce30d/hguz+GroLgqJg=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 73A0DBD899;
	Thu, 11 Jun 2026 02:44:01 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 2BADF5FC3D;
	Thu, 11 Jun 2026 03:44:01 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v7 2/6] ata: libata-scsi: convert dev->sdev to per-LUN array
Date: Thu, 11 Jun 2026 03:43:52 +0100
Message-ID: <20260611024356.2769320-3-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611024356.2769320-1-philpem@philpem.me.uk>
References: <20260611024356.2769320-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multi-LUN ATAPI devices (PD/CD combos, CD changers) share a single
ata_device but expose multiple scsi_devices.  The previous single
dev->sdev pointer could only track one LUN, making all other LUNs
invisible to code that operates on sdevs: port detach, suspend/resume,
ACPI uevent, ZPODD, media change notification, and EH teardown.

Replace the scalar struct scsi_device *sdev with a fixed-size array
dev->sdev[ATAPI_MAX_LUN] indexed by LUN number, where ATAPI_MAX_LUN
is 8 (the SCSI-2 ceiling, LUN values 0..7).  All callers are updated
to iterate the full array and skip NULL slots; only populated LUN slots
are ever non-NULL so single-LUN devices (the vast majority) see no
change in behaviour.

Add an inline helper ata_dev_scsi_device(dev, lun) that returns
dev->sdev[lun] guarded by a WARN_ON_ONCE(lun >= ATAPI_MAX_LUN) bounds
check.  Use it for the hardcoded LUN-0 references in libata-acpi
(uevent kobj), libata-zpodd (disk events, wake notify for all LUNs),
and the door-lock and OF-node paths in libata-scsi.

Key changes per call site:
  - ata_scsi_dev_config:    bounds-check lun, assign sdev to dev->sdev[sdev->lun]
  - ata_scsi_sdev_destroy:  clear per-LUN slot; trigger ATA detach only
                            when the last populated LUN is destroyed
  - ata_port_detach:        iterate all ATAPI_MAX_LUN slots descending;
                            clear dev->sdev[lun] before unlock to close
                            the UAF window (Hannes Reinecke)
  - ata_scsi_offline_dev:   iterate all slots
  - ata_scsi_remove_dev:    snapshot all LUN slots then remove outside lock
  - ata_scsi_media_change_notify: send event to all populated LUNs
  - ata_scsi_dev_rescan:    snapshot all LUNs under lock, then resume and
                            rescan each; release remaining refs on early exit
  - ACPI, ZPODD, door-lock: use ata_dev_scsi_device(dev, 0)
  - ZPODD disk-events:      iterate all LUNs for enable/disable and wake

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-acpi.c  |   9 +-
 drivers/ata/libata-core.c  |  11 ++-
 drivers/ata/libata-scsi.c  | 164 +++++++++++++++++++++----------------
 drivers/ata/libata-zpodd.c |  27 ++++--
 include/linux/libata.h     |  10 ++-
 5 files changed, 138 insertions(+), 83 deletions(-)

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
index d39ac4292f81..11f8a341252d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6275,11 +6275,16 @@ static void ata_port_detach(struct ata_port *ap)
 	/* Remove scsi devices */
 	ata_for_each_link(link, ap, HOST_FIRST) {
 		ata_for_each_dev(dev, link, ALL) {
-			if (dev->sdev) {
+			int lun;
+
+			for (lun = ATAPI_MAX_LUN - 1; lun >= 0; lun--) {
+				struct scsi_device *sdev = dev->sdev[lun];
+				if (!sdev)
+					continue;
+				dev->sdev[lun] = NULL;
 				spin_unlock_irqrestore(ap->lock, flags);
-				scsi_remove_device(dev->sdev);
+				scsi_remove_device(sdev);
 				spin_lock_irqsave(ap->lock, flags);
-				dev->sdev = NULL;
 			}
 		}
 	}
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 32c6a0e497cf..b65358955cf1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1131,7 +1131,9 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 	if (dev->flags & ATA_DFLAG_TRUSTED)
 		sdev->security_supported = 1;
 
-	dev->sdev = sdev;
+	if (WARN_ON_ONCE(sdev->lun >= ATAPI_MAX_LUN))
+		return -EINVAL;
+	dev->sdev[sdev->lun] = sdev;
 	return 0;
 }
 
@@ -1202,10 +1204,10 @@ EXPORT_SYMBOL_GPL(ata_scsi_sdev_configure);
  *
  *	@sdev is about to be destroyed for hot/warm unplugging.  If
  *	this unplugging was initiated by libata as indicated by NULL
- *	dev->sdev, this function doesn't have to do anything.
+ *	dev->sdev[], this function doesn't have to do anything.
  *	Otherwise, SCSI layer initiated warm-unplug is in progress.
- *	Clear dev->sdev, schedule the device for ATA detach and invoke
- *	EH.
+ *	Clear the per-LUN slot; when the last LUN (LUN 0) is destroyed,
+ *	schedule ATA-level detach via EH.
  *
  *	LOCKING:
  *	Defined by SCSI layer.  We don't really care.
@@ -1220,11 +1222,23 @@ void ata_scsi_sdev_destroy(struct scsi_device *sdev)
 
 	spin_lock_irqsave(ap->lock, flags);
 	dev = __ata_scsi_find_dev(ap, sdev);
-	if (dev && dev->sdev) {
-		/* SCSI device already in CANCEL state, no need to offline it */
-		dev->sdev = NULL;
-		dev->flags |= ATA_DFLAG_DETACH;
-		ata_port_schedule_eh(ap);
+	if (dev && !WARN_ON_ONCE(sdev->lun >= ATAPI_MAX_LUN) &&
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
 
@@ -2909,12 +2923,9 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
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
 
 		ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
 		return;
@@ -4658,7 +4669,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
 #ifdef CONFIG_OF
 static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_port *ap)
 {
-	struct scsi_device *sdev = dev->sdev;
+	struct scsi_device *sdev = ata_dev_scsi_device(dev, 0);
 	struct device *d = ap->host->dev;
 	struct device_node *np = d->of_node;
 	struct device_node *child;
@@ -4696,7 +4707,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			struct scsi_device *sdev;
 			int channel = 0, id = 0;
 
-			if (dev->sdev)
+			if (dev->sdev[0])
 				continue;
 
 			if (ata_is_host_link(link))
@@ -4707,11 +4718,11 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
 			if (!IS_ERR(sdev)) {
-				dev->sdev = sdev;
+				dev->sdev[0] = sdev;
 				ata_scsi_assign_ofnode(dev, ap);
 				scsi_device_put(sdev);
 			} else {
-				dev->sdev = NULL;
+				dev->sdev[0] = NULL;
 			}
 		}
 	}
@@ -4722,7 +4733,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	 */
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			if (!dev->sdev)
+			if (!dev->sdev[0])
 				goto exit_loop;
 		}
 	}
@@ -4763,7 +4774,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
  *
  *	This function is called from ata_eh_detach_dev() and is responsible for
  *	taking the SCSI device attached to @dev offline.  This function is
- *	called with host lock which protects dev->sdev against clearing.
+ *	called with host lock which protects dev->sdev[] against clearing.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -4773,11 +4784,16 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
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
@@ -4793,49 +4809,38 @@ bool ata_scsi_offline_dev(struct ata_device *dev)
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
 
@@ -4872,9 +4877,12 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
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
@@ -5007,7 +5015,8 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			struct scsi_device *sdev = dev->sdev;
+			struct scsi_device *sdevs[ATAPI_MAX_LUN] = {};
+			int lun;
 
 			/*
 			 * If the port was suspended before this was scheduled,
@@ -5016,28 +5025,43 @@ void ata_scsi_dev_rescan(struct work_struct *work)
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
+					ret = scsi_resume_device(sdevs[lun]);
+					if (ret == -EWOULDBLOCK) {
+						scsi_device_put(sdevs[lun]);
+						while (++lun < ATAPI_MAX_LUN)
+							if (sdevs[lun])
+								scsi_device_put(sdevs[lun]);
+						goto unlock_scan;
+					}
+				}
+				ret = scsi_rescan_device(sdevs[lun]);
+				scsi_device_put(sdevs[lun]);
+				spin_lock_irqsave(ap->lock, flags);
+
+				if (ret) {
+					while (++lun < ATAPI_MAX_LUN)
+						if (sdevs[lun])
+							scsi_device_put(sdevs[lun]);
+					goto unlock_ap;
 				}
-				dev->flags &= ~ATA_DFLAG_RESUMING;
 			}
-			ret = scsi_rescan_device(sdev);
-			scsi_device_put(sdev);
-			spin_lock_irqsave(ap->lock, flags);
 
-			if (ret)
-				goto unlock_ap;
+			if (do_resume)
+				dev->flags &= ~ATA_DFLAG_RESUMING;
 		}
 	}
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 414e7c63bd85..151ae5726aca 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -184,8 +184,13 @@ bool zpodd_zpready(struct ata_device *dev)
 void zpodd_enable_run_wake(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
+	int lun;
 
-	sdev_disable_disk_events(dev->sdev);
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		struct scsi_device *sdev = dev->sdev[lun];
+		if (sdev)
+			sdev_disable_disk_events(sdev);
+	}
 
 	zpodd->powered_off = true;
 	acpi_pm_set_device_wakeup(&dev->tdev, true);
@@ -218,6 +223,7 @@ void zpodd_disable_run_wake(struct ata_device *dev)
 void zpodd_post_poweron(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
+	int lun;
 
 	if (!zpodd->powered_off)
 		return;
@@ -233,18 +239,27 @@ void zpodd_post_poweron(struct ata_device *dev)
 	zpodd->zp_sampled = false;
 	zpodd->zp_ready = false;
 
-	sdev_enable_disk_events(dev->sdev);
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		struct scsi_device *sdev = dev->sdev[lun];
+		if (sdev)
+			sdev_enable_disk_events(sdev);
+	}
 }
 
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
 	struct zpodd *zpodd = ata_dev->zpodd;
-	struct device *dev = &ata_dev->sdev->sdev_gendev;
+	int lun;
 
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
-		zpodd->from_notify = true;
-		pm_runtime_resume(dev);
+	if (event != ACPI_NOTIFY_DEVICE_WAKE)
+		return;
+	for (lun = 0; lun < ATAPI_MAX_LUN; lun++) {
+		struct scsi_device *sdev = ata_dev->sdev[lun];
+		if (sdev && pm_runtime_suspended(&sdev->sdev_gendev)) {
+			zpodd->from_notify = true;
+			pm_runtime_resume(&sdev->sdev_gendev);
+		}
 	}
 }
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3e33ee30628d..237a8d259ba7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -722,7 +722,7 @@ struct ata_device {
 	unsigned int		devno;		/* 0 or 1 */
 	u64			quirks;		/* List of broken features */
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
-	struct scsi_device	*sdev;		/* attached SCSI device */
+	struct scsi_device	*sdev[ATAPI_MAX_LUN];	/* per-LUN SCSI devices */
 	void			*private_data;
 #ifdef CONFIG_ATA_ACPI
 	union acpi_object	*gtf_cache;
@@ -1715,6 +1715,14 @@ static inline unsigned int ata_dev_absent(const struct ata_device *dev)
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

