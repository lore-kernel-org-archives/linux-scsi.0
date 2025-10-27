Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF512E5427
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 20:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761596631; cv=none; b=lD6dAxvD0EAPNLRsm3GtmrE7IIcNOvqBIRzWtj4lq5aTNtzHygMxrkP9fKY9LknnFcmEYRD69/jPCNOiX2Gvs3Pk9S1zsHA2cdbct7pcCSBfVffjyQTKhuUdj/Y7f5AkmTwwZH7vzyJM9B8Hv/5NTcU98HkoDsQ9h4cKZ38w/OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761596631; c=relaxed/simple;
	bh=ptGwpd+WzIqccIOIbCCmVciFaDLFlS8NnGcf1Zo9SyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMtgok2/PxeT7EoWis9nbk1UxS2kxE9dZ+G0EJe1kCMGsH70/FcFutmariz6VgMmeyLi/aoJVKxch8qhxoaCUGHj/znhfmZBhyI8s+rggpwrGsJDlSPyFbpKl7OUELfbzU3SX66bqBuV1nsCZBDPlXYu3MIy2fBXLqjXfsrpQ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=c6o7hZR4; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="c6o7hZR4"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 352DD240105
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 21:23:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1761596628; bh=0vNZm/MLeD0KHdfjj4IScMaJfeMKUSeReXmJhjR9x28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Autocrypt:OpenPGP:From;
	b=c6o7hZR4rqziBkqRcBQBj302DVTmDazcq/W399xNpwHhkH3q54ZHW/PjiNr8oVv2M
	 TDJDVPRWX+J35fnCoqquLWSCZUyTgHFg2vWQhjMt0RkJUHF3Jof75hskpYd92HVMTR
	 A8PwAsVGjbN3lMwpZL1dbO4Yy288BDNFFBLSPxrs+BY4CxTh40qdOknnxyKv3CX5u4
	 p+ThNgNvVOEsaU7POV6fHeGfHCJMuVu7pdtpebfFIE1i/L1O8WHWJqn8NEcpwN9UlC
	 3ep+InXbwp5HndnKw1kEO5CWoQRCzOPhZWz61QUpRC8MLyFPCQlXzW5bmR1ctmOFHy
	 YB9ip2aEQIaNQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cwQ2C1VWrz9rxK;
	Mon, 27 Oct 2025 21:23:47 +0100 (CET)
From: Markus Probst <markus.probst@posteo.de>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus Probst <markus.probst@posteo.de>
Subject: [PATCH v5 2/3] ata: stop disk on restart if ACPI power resources are found
Date: Mon, 27 Oct 2025 20:23:47 +0000
Message-ID: <20251027202339.1043723-3-markus.probst@posteo.de>
In-Reply-To: <20251027202339.1043723-1-markus.probst@posteo.de>
References: <20251027202339.1043723-1-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3539; i=markus.probst@posteo.de; h=from:subject; bh=ptGwpd+WzIqccIOIbCCmVciFaDLFlS8NnGcf1Zo9SyQ=; b=owEBbQKS/ZANAwAIATR2H/jnrUPSAcsmYgBo/9RcIE/3uX8nBW0BFwxS5bHP3XcqcNjEnIKd8 NPRpM1zBzaJAjMEAAEIAB0WIQSCdBjE9KxY53IwxHM0dh/4561D0gUCaP/UXAAKCRA0dh/4561D 0ostEACPluHdcqT/IOXIf8WLr5pgKfVzODtQprU8bwpU5TasP1Zg5zf5kM6z0+suv2Sz1XBvmi4 SL8lgAPMYaeuIpvxdHYu3upXry+jE3LnWrc7vGBnJNQilSAqeEodWmYTIthQSTIJppgILB4oHai 4AwapNFfEgQUUPnUcpANBkbDZU5Lr7yp8dll1/XB7D6aUmw9J03GKTp1DXL7ZhtXRbxEXckowAH xlbLltJFF8Fs8tM8S2So0wlSYaNVw2bAAdCARwp7phwWNo/+d0v37dR9lLw5ZUcoXxYOoznZ58m rGBCpSBq58xDgtYNw//UV6Sbo8RVjAWmtT82diSY+gcCGgMVMMVL7Q9119nZXlI0gN0dXGaJUtG mcq+/6WjBl1XL9WW+lL9s3VPtKldi+1egMokMsXc+sGttGOZ1uWF/bwsjQuBFw9jaDGPahOz1Qp zLSI0TzYdlNerK8XCF4UNKmcl51YnVHMcS3hokEIz3FUZ1vzu/obLCUXvTyao3V10DAS2sWl3oX Yw+LPIDcyLcO8LK3Ro8I+oHW7sK632zcLthrz4Hp028OczXQ4iuRq6t1hqoT8RhNVOBOr+Dhics ogOXWeIXatv6sjPeDXtuCa8GeE/PgWAqGPp6cOX2SgiRmx/BycO/zE6r/uMwdevr1p+DNn7lH8E BM7nMVFfljargCg=
 =
X-Developer-Key: i=markus.probst@posteo.de; a=openpgp; fpr=827418C4F4AC58E77230C47334761FF8E7AD43D2
Content-Transfer-Encoding: 8bit
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

Some embedded devices have the ability to control whether power is
provided to the disks via the SATA power connector or not. ACPI power
resources are usually off by default, thus making it unclear if the
specific power resource will retain its state after a restart. If power
resources are defined on ATA ports / devices in ACPI, we should stop the
disk on SYSTEM_RESTART, to ensure the disk will not lose power while
active.

Add a new function, ata_acpi_dev_manage_restart(), that will be used to
determine if a disk should be stopped before restarting the system. If a
usable ACPI power resource has been found, it is assumed that the disk
will lose power after a restart and should be stopped to avoid a power
failure.

Signed-off-by: Markus Probst <markus.probst@posteo.de>
---
 drivers/ata/libata-acpi.c | 26 ++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |  1 +
 drivers/ata/libata.h      |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index f2140fc06ba0..196ca1227d09 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -245,6 +245,32 @@ void ata_acpi_bind_dev(struct ata_device *dev)
 				   ata_acpi_dev_uevent);
 }
 
+/**
+ * ata_acpi_dev_manage_restart - if the disk should be stopped (spun down) on
+ *                               system restart.
+ * @dev: target ATA device
+ *
+ * RETURNS:
+ * true if the disk should be stopped, otherwise false.
+ */
+bool ata_acpi_dev_manage_restart(struct ata_device *dev)
+{
+	struct device *tdev;
+
+	/*
+	 * If ATA_FLAG_ACPI_SATA is set, the acpi fwnode is attached to the
+	 * ata_device instead of the ata_port.
+	 */
+	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA)
+		tdev = &dev->tdev;
+	else
+		tdev = &dev->link->ap->tdev;
+
+	if (!is_acpi_device_node(tdev->fwnode))
+		return false;
+	return acpi_bus_power_manageable(ACPI_HANDLE(tdev));
+}
+
 /**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b43a3196e2be..026122bb6f2f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1095,6 +1095,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 		 */
 		sdev->manage_runtime_start_stop = 1;
 		sdev->manage_shutdown = 1;
+		sdev->manage_restart = ata_acpi_dev_manage_restart(dev);
 		sdev->force_runtime_start_on_system_start = 1;
 	}
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index e5b977a8d3e1..af08bb9b40d0 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -130,6 +130,7 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern void ata_acpi_bind_port(struct ata_port *ap);
 extern void ata_acpi_bind_dev(struct ata_device *dev);
+extern bool ata_acpi_dev_manage_restart(struct ata_device *dev);
 extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
@@ -140,6 +141,7 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline void ata_acpi_bind_port(struct ata_port *ap) {}
 static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
+static inline bool ata_acpi_dev_manage_restart(struct ata_device *dev) { return 0; }
 #endif
 
 /* libata-scsi.c */
-- 
2.51.0

