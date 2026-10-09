Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554F4EFFCB;
	Fri,  9 Oct 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563223; cv=none; b=sJv2s588wZ0ZenDhUYYNT6ooujGrKRtqUmjnKCJWgIAZQNakL/jem3HPMu5H3eUEzDJK1fF3DTWzw41aFdQB1EidbH9szNSJKVctGd7pOPRQEfYVw689WZqrdU6iAFl0iEIKcCApPbMdvHY+HGa+7HGkz41UiBWVKNaXdV2+2ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563223; c=relaxed/simple;
	bh=AyN3YEu+suJowLh3kH/BloeQP0AHQY2LAWoCqPNjCRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmr0aT8OOa8o2ld7sVr+U1tXnVwPWzdVXtGG/3DFz+WD6hdUrrC1GhHD7iMO+sMxGoq1zQp02vPT8d8IF9Zl67eeEL5sWjJir7ii3IG5G6LmiQPRIx6PLAOie+hbASkYxDHcX7hDwYFdGeOHYKHywLb+vCyFJ1/wP8ULeisGEPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=jHd60AyM; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="jHd60AyM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=AyN3YEu+suJowLh3kH/BloeQP0AHQY2LAWoCqPNjCRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHd60AyM9c9wp4wykY99gW580ADCn1fNe3cLv4IMSByCvryrhWVSEChCO8udwqVbl
	 YQLMMFHqQ+ilhRrXifaoOI76AnKydxx8ck5BXBKTkbEr9rxSBCxoz5XBd18KYo6Ckr
	 CWttYm304MhdRjBcNI+JjJslCwzT61+a4RFoQ0f8=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 19F63BE729;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id BFF0D5FC4B;
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
Subject: [PATCH v10 03/15] ata: libata-zpodd: reference SCSI devices in PM callbacks
Date: Fri,  9 Oct 2026 16:55:10 +0100
Message-ID: <20261009155522.593045-4-philpem@philpem.me.uk>
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

The ZPODD wake callback accesses dev->sdev without locking or taking a
reference. Concurrent sysfs deletion can release the device before the
callback accesses its runtime PM state. The disk-event enable and disable
paths have the same problem.

Take a SCSI device reference under ap->lock, skipping missing or deleting
devices. Drop the lock before accessing PM or disk-event state and before
releasing the reference.

Fixes: f064a20dded8 ("libata: move acpi notification code to zpodd")
Link: https://lore.kernel.org/linux-ide/20260611030131.5285D1F00893@smtp.kernel.org/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-zpodd.c | 41 +++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 414e7c63bd85..581eb41ea0f3 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -173,6 +173,22 @@ bool zpodd_zpready(struct ata_device *dev)
 	return zpodd->zp_ready;
 }
 
+/* Return a referenced SCSI device; the caller must drop it outside ap->lock. */
+static struct scsi_device *zpodd_get_sdev(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	struct scsi_device *sdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+	sdev = dev->sdev;
+	if (sdev && scsi_device_get(sdev))
+		sdev = NULL;
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return sdev;
+}
+
 /*
  * Enable runtime wake capability through ACPI and set the powered_off flag,
  * this flag will be used during resume to decide what operations are needed
@@ -184,8 +200,12 @@ bool zpodd_zpready(struct ata_device *dev)
 void zpodd_enable_run_wake(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
+	struct scsi_device *sdev = zpodd_get_sdev(dev);
 
-	sdev_disable_disk_events(dev->sdev);
+	if (sdev) {
+		sdev_disable_disk_events(sdev);
+		scsi_device_put(sdev);
+	}
 
 	zpodd->powered_off = true;
 	acpi_pm_set_device_wakeup(&dev->tdev, true);
@@ -218,6 +238,7 @@ void zpodd_disable_run_wake(struct ata_device *dev)
 void zpodd_post_poweron(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
+	struct scsi_device *sdev;
 
 	if (!zpodd->powered_off)
 		return;
@@ -233,19 +254,29 @@ void zpodd_post_poweron(struct ata_device *dev)
 	zpodd->zp_sampled = false;
 	zpodd->zp_ready = false;
 
-	sdev_enable_disk_events(dev->sdev);
+	sdev = zpodd_get_sdev(dev);
+	if (sdev) {
+		sdev_enable_disk_events(sdev);
+		scsi_device_put(sdev);
+	}
 }
 
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
 	struct zpodd *zpodd = ata_dev->zpodd;
-	struct device *dev = &ata_dev->sdev->sdev_gendev;
+	struct scsi_device *sdev;
 
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
+	if (event != ACPI_NOTIFY_DEVICE_WAKE)
+		return;
+	sdev = zpodd_get_sdev(ata_dev);
+	if (!sdev)
+		return;
+	if (pm_runtime_suspended(&sdev->sdev_gendev)) {
 		zpodd->from_notify = true;
-		pm_runtime_resume(dev);
+		pm_runtime_resume(&sdev->sdev_gendev);
 	}
+	scsi_device_put(sdev);
 }
 
 static void ata_acpi_add_pm_notifier(struct ata_device *dev)
-- 
2.43.0

