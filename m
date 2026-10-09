Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3DD4F0526;
	Fri,  9 Oct 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563232; cv=none; b=WcfZ+lN9PuBxwJ+JInHv4HRnEkM/mVjPvXeXNo2i3CcJ89ysyHThqWhdnkoOz7NN7VowYgLCh2JryajRRF+Y0h6kOBzVmkG7pWiuGgpshssK3xswlr/Y3+vDaDqahA4eCJooBWGUCdUGGElIQZ+w3oKmU1u5/QZYKBWdwjuVTcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563232; c=relaxed/simple;
	bh=DBwdr5NIFgGVx5dF12yJGVFfJQiLChKTWtqChxaj640=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abhMVHFdCkur8HHy01jKC/Sc8NOgdv+/1JadiTA8fSTql4pb622oLtStSbGDzEqA1UfuiVFxHX17IjyFtGpGZCtK+Rxn494NCwIBPzDw8PagesTcLmDTDi55SbQ29eS/hgY6B7txykrh7TDZNhv8pF0ZTtw0hrq8SImp/8IieP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=Xy93fKUn; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="Xy93fKUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=DBwdr5NIFgGVx5dF12yJGVFfJQiLChKTWtqChxaj640=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy93fKUnG1n7qMUXjyiULc9dYLHTP2Gbl03i1cp1H5+aWw4SyxJ1jeTOK2THDXyDG
	 qg7pI94XQ7tcCG1R1MtB7g+I1cxUNggEr5R+ldIGRXq24LgAHwxU5ak7pK3rLVJwt1
	 Tt/kG1sTkd1JYYEFS4GjqN+McqS7X26J9mfMkU+k=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 498A7BE771;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id E14FD5FC52;
	Fri,  9 Oct 2026 17:26:54 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>,
	stable@vger.kernel.org
Subject: [PATCH v10 05/15] ata: libata-zpodd: serialize wake attribution with physical power-on
Date: Fri,  9 Oct 2026 16:55:12 +0100
Message-ID: <20261009155522.593045-6-philpem@philpem.me.uk>
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

The notification handler checks runtime suspension before setting
from_notify, while EH reads and clears that flag during physical power-on.
A concurrent resume can finish after the check but before the assignment,
leaving attribution behind for an unrelated later power cycle. Taking a
SCSI device reference does not serialize those state changes.

Protect powered_off and from_notify with ap->lock. Attribute a notification
only to the current powered-off physical device, and consume that
attribution atomically when EH completes power-on. Reset attribution when
a new power-off cycle starts. Keep PM calls and tray commands outside the
spinlock.

Let the PM core handle active or already-resuming SCSI devices instead of
using a lockless suspended-state check to gate notification attribution.
Track wake callbacks in progress, so an overlapping callback with no SCSI
device cannot clear attribution still needed by another callback. Clear
unconsumed attribution when the last synchronous wake callback returns,
including failed wakes.

Fixes: f064a20dded8 ("libata: move acpi notification code to zpodd")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-zpodd.c | 65 ++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index c57c49316fbd..309b3769ae01 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -22,14 +22,15 @@ struct zpodd {
 	enum odd_mech_type	mech_type; /* init during probe, RO afterwards */
 	struct ata_device	*dev;
 
+	/* The following fields are protected by the ATA port lock. */
+	unsigned int		notify_count; /* wake callbacks in progress */
+	bool			from_notify; /* power-on requested by notification */
+	bool			powered_off; /* powered off during suspend */
+
 	/* The following fields are synchronized by PM core. */
-	bool			from_notify; /* resumed as a result of
-					      * acpi wake notification */
 	bool			zp_ready; /* ZP ready state */
 	unsigned long		last_ready; /* last ZP ready timestamp */
 	bool			zp_sampled; /* ZP ready state sampled */
-	bool			powered_off; /* ODD is powered off
-					      *	during suspend */
 };
 
 static int eject_tray(struct ata_device *dev)
@@ -199,7 +200,9 @@ static struct scsi_device *zpodd_get_sdev(struct ata_device *dev)
  */
 void zpodd_enable_run_wake(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	struct zpodd *zpodd = dev->zpodd;
+	unsigned long flags;
 	struct scsi_device *sdev = zpodd_get_sdev(dev);
 
 	if (sdev) {
@@ -207,16 +210,25 @@ void zpodd_enable_run_wake(struct ata_device *dev)
 		scsi_device_put(sdev);
 	}
 
+	spin_lock_irqsave(ap->lock, flags);
 	zpodd->powered_off = true;
+	zpodd->from_notify = false;
+	spin_unlock_irqrestore(ap->lock, flags);
 	acpi_pm_set_device_wakeup(&dev->tdev, true);
 }
 
 /* Disable runtime wake capability if it is enabled */
 void zpodd_disable_run_wake(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	struct zpodd *zpodd = dev->zpodd;
+	unsigned long flags;
+	bool powered_off;
 
-	if (zpodd->powered_off)
+	spin_lock_irqsave(ap->lock, flags);
+	powered_off = zpodd->powered_off;
+	spin_unlock_irqrestore(ap->lock, flags);
+	if (powered_off)
 		acpi_pm_set_device_wakeup(&dev->tdev, false);
 }
 
@@ -237,19 +249,24 @@ void zpodd_disable_run_wake(struct ata_device *dev)
  */
 void zpodd_post_poweron(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	struct zpodd *zpodd = dev->zpodd;
+	unsigned long flags;
+	bool from_notify;
 	struct scsi_device *sdev;
 
-	if (!zpodd->powered_off)
+	spin_lock_irqsave(ap->lock, flags);
+	if (!zpodd->powered_off) {
+		spin_unlock_irqrestore(ap->lock, flags);
 		return;
-
+	}
 	zpodd->powered_off = false;
+	from_notify = zpodd->from_notify;
+	zpodd->from_notify = false;
+	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (zpodd->from_notify) {
-		zpodd->from_notify = false;
-		if (zpodd->mech_type == ODD_MECH_TYPE_DRAWER)
-			eject_tray(dev);
-	}
+	if (from_notify && zpodd->mech_type == ODD_MECH_TYPE_DRAWER)
+		eject_tray(dev);
 
 	zpodd->zp_sampled = false;
 	zpodd->zp_ready = false;
@@ -264,19 +281,33 @@ void zpodd_post_poweron(struct ata_device *dev)
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
+	struct ata_port *ap = ata_dev->link->ap;
 	struct zpodd *zpodd = ata_dev->zpodd;
 	struct scsi_device *sdev;
+	unsigned long flags;
 
 	if (event != ACPI_NOTIFY_DEVICE_WAKE)
 		return;
-	sdev = zpodd_get_sdev(ata_dev);
-	if (!sdev)
-		return;
-	if (pm_runtime_suspended(&sdev->sdev_gendev)) {
+
+	/* Attribute the notification to the current physical power cycle. */
+	spin_lock_irqsave(ap->lock, flags);
+	zpodd->notify_count++;
+	if (zpodd->powered_off)
 		zpodd->from_notify = true;
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	sdev = zpodd_get_sdev(ata_dev);
+	if (sdev) {
+		/* The PM core handles an already active or resuming device. */
 		pm_runtime_resume(&sdev->sdev_gendev);
+		scsi_device_put(sdev);
 	}
-	scsi_device_put(sdev);
+
+	/* Do not discard attribution while another wake callback is active. */
+	spin_lock_irqsave(ap->lock, flags);
+	if (!--zpodd->notify_count)
+		zpodd->from_notify = false;
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 static void ata_acpi_add_pm_notifier(struct ata_device *dev)
-- 
2.43.0

