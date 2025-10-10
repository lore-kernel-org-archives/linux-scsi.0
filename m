Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EEF277CBF
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2025 22:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760135919; cv=none; b=oED4rMkRITgjR9wAOuRudgjn5G/007SV+9TnfMI+ZQWTuEnlrjdX1AVnQQrt0QdMnNt9sKSmZomLXgbMKw8UAjQGmrqB0w5sg5GCek8Yk+DDNbdVQLJNnS6b31/1r8b1YPNlWrXk9dq5B/qFrcjaDrHgdDzttpDul2wAgSKrv1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760135919; c=relaxed/simple;
	bh=CaZcc1spkTTgAbJ2EdWAtvEmvh7lALIBgStT3HSJZz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjXfUFtTAS2tAp5ru2LcYKrVgpOFPrz63mhneoLA1Oe0Lq62SUF9zPt/EX9SOgXua80sHJ43Sg8DzDQQ2cLbKH587nLLpzJ9fRz9jIoSf/q6ywGMrXKcyh+D6TGuEP5f740JSIxEQE+f/tHwuS/MEu793YqQG+6RjSbsmlMFmik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=Y1L5c/pd; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="Y1L5c/pd"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id B4C67240103
	for <linux-scsi@vger.kernel.org>; Sat, 11 Oct 2025 00:38:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1760135915; bh=8WfBtDqJWdX8I5lv1aEsXRV6uPM5skUQmEihOC4O6ps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Autocrypt:OpenPGP:From;
	b=Y1L5c/pdLIFF57ycOgAwc1vgT8h2+cGFkVNgx9J8iGSaQgJDLDoTaLgTlwQs+oWZn
	 uM7GfaNQYhC3rpN+AHTlpgqsKmXlEAbYnQO2tqTbU/Y1DGYAh75LPikJLvVxXf5H3K
	 Ml5sgjQXc+nMtXnp19bWDmpayHnz6NZ4RmU8u2McTNDVgYymYpzZChsIfSpkUSOmoT
	 N52ux4LOnrOKZabZxBMyanFKvMrgLAo1FLCS1Ohhac2YJHiuQ4FLD7yLXIIaUqJ5+Z
	 ikuJafWbNiBu4SRJZruQh7LAmtXHpCjoT9lWZYxPSqJtk25kW1EWklt85I3Ncc17sx
	 ZAhNOpFdXvugg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ck1qZ6tc4z6v15;
	Sat, 11 Oct 2025 00:38:34 +0200 (CEST)
From: Markus Probst <markus.probst@posteo.de>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus Probst <markus.probst@posteo.de>
Subject: [PATCH v3 2/2] ata: Use ACPI methods to power on disks
Date: Fri, 10 Oct 2025 22:38:35 +0000
Message-ID: <20251010223817.729490-3-markus.probst@posteo.de>
In-Reply-To: <20251010223817.729490-1-markus.probst@posteo.de>
References: <20251010223817.729490-1-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

Some embedded devices have the ability to control whether power is
provided to the disks via the sata power connector or not. If power
resources are defined on ata ports / devices in ACPI, we should try to set
the power state to D0 before probing the disk to ensure that any power
supply or power gate that may exist is providing power to the disk.

An example for such devices would be newer synology nas devices. Every
disk slot has its own sata power connector. Whether the connector is
providing power is controlled via an gpio, which is *off by default*.
Also the disk loses power on reboots.

Add a new function, ata_acpi_dev_manage_restart(), that will be used to
determine if a disk should be stopped before restarting the system. If a
usable ACPI power resource has been found, it is assumed that the disk
will lose power after a restart and should be stopped to avoid a power
failure. Also add a new function, ata_acpi_port_set_power_state(), that
will be used to power on the sata power connector if usable ACPI power
resources on the associated ata port are found. It will be called right
before probing the port, therefore the disk will be powered on just in
time.

Signed-off-by: Markus Probst <markus.probst@posteo.de>
---
 drivers/ata/libata-acpi.c | 71 +++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c |  2 ++
 drivers/ata/libata-scsi.c |  1 +
 drivers/ata/libata.h      |  4 +++
 4 files changed, 78 insertions(+)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index f2140fc06ba0..4a72a98b922c 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -245,6 +245,77 @@ void ata_acpi_bind_dev(struct ata_device *dev)
 				   ata_acpi_dev_uevent);
 }
 
+/**
+ * ata_acpi_dev_manage_restart - if the disk should be stopped (spun down) on
+ * system restart.
+ * @dev: target ATA device
+ *
+ * RETURNS:
+ * 1 if the disk should be stopped, otherwise 0
+ */
+bool ata_acpi_dev_manage_restart(struct ata_device *dev)
+{
+	// If the device is power manageable and we assume the disk loses power
+	// on reboot.
+	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA) {
+		if (!is_acpi_device_node(dev->tdev.fwnode))
+			return 0;
+		return acpi_bus_power_manageable(ACPI_HANDLE(&dev->tdev));
+	}
+
+	if (!is_acpi_device_node(dev->link->ap->tdev.fwnode))
+		return 0;
+	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));
+}
+
+/**
+ * ata_acpi_port_set_power_state - set the power state of the ata port
+ * @ap: target ATA port
+ * @enable: power state to be set
+ *
+ * This function is called at the beginning of ata_port_probe.
+ */
+void ata_acpi_port_set_power_state(struct ata_port *ap, bool enable)
+{
+	acpi_handle handle;
+	unsigned char state;
+	int i;
+
+	if (libata_noacpi)
+		return;
+
+	if (enable)
+		state = ACPI_STATE_D0;
+	else
+		state = ACPI_STATE_D3_COLD;
+
+	if (ap->flags & ATA_FLAG_ACPI_SATA) {
+		for (i = 0; i < ATA_MAX_DEVICES; i++) {
+			if (!is_acpi_device_node(ap->link.device[i].tdev.fwnode))
+				continue;
+			handle = ACPI_HANDLE(&ap->link.device[i].tdev);
+			if (!acpi_bus_power_manageable(handle))
+				continue;
+			if (!acpi_bus_set_power(handle, state))
+				ata_dev_dbg(&ap->link.device[i], "acpi: power was %s\n",
+					     enable ? "en" : "dis");
+			else
+				ata_dev_err(&ap->link.device[i], "acpi: failed to set power state\n");
+		}
+		return;
+	}
+	if (!is_acpi_device_node(ap->tdev.fwnode))
+		return;
+	handle = ACPI_HANDLE(&ap->tdev);
+	if (!acpi_bus_power_manageable(handle))
+		return;
+
+	if (!acpi_bus_set_power(handle, state))
+		ata_port_dbg(ap, "acpi: power %sabled\n", enable ? "en" : "dis");
+	else
+		ata_port_err(ap, "acpi: failed to set power state\n");
+}
+
 /**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ff53f5f029b4..ee8b504596b2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5904,6 +5904,8 @@ void ata_port_probe(struct ata_port *ap)
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	unsigned long flags;
 
+	ata_acpi_port_set_power_state(ap, true);
+
 	/* kick EH for boot probing */
 	spin_lock_irqsave(ap->lock, flags);
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2ded5e476d6e..12dd305afe26 100644
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
index e5b977a8d3e1..c6daa2b1d15f 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -130,6 +130,8 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern void ata_acpi_bind_port(struct ata_port *ap);
 extern void ata_acpi_bind_dev(struct ata_device *dev);
+extern void ata_acpi_port_set_power_state(struct ata_port *ap, bool enable);
+extern bool ata_acpi_dev_manage_restart(struct ata_device *dev);
 extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
@@ -140,6 +142,8 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline void ata_acpi_bind_port(struct ata_port *ap) {}
 static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
+static inline void ata_acpi_port_set_power_state(struct ata_port *ap, bool enable) {}
+static inline bool ata_acpi_dev_manage_restart(struct ata_device *dev) { return 0; }
 #endif
 
 /* libata-scsi.c */
-- 
2.49.1

