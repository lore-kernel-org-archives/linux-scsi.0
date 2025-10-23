Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9D0343D6D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761238342; cv=none; b=ONdYHEGRh6eph9IHtenE+qxRjnCnhcrnib14ZyJwQ+gSXpfbf8T/gCvT91Xzp4u61+yf54AdNC4gZ4aYOoKbHQ4g9LXmU4c5ZvD6ZtATeb/imdhMlafBRUwYpbEFKLvokaOSRA65xt1eTUYsrgrIlBCUceqoGRGornAvB2NOn6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761238342; c=relaxed/simple;
	bh=YB5vMCRjB9QPskO5XK+pNnZDz2mYSkJyS9y8gLprh0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzJk63SEvSFnNCJdCs8BbTiwmbNJb1ZueyI9SFSLIie8Z3nKq/EuieBhnjyBzKpg6Hnf8LWE3hjyr13txpbKjVJrxD4VQS5TEx9vQt0Aq2ZudN2DkNgC3ZWd2r7zn7T7ZekBnwIZWk8koRAepP5emFVaObUGDCIIBh77CsbRcOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=oott5cFz; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="oott5cFz"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 3EA0A240106
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 18:52:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1761238333; bh=Dbt3NnD8sk2nT0Ba1QoNSWABHJA4DcmFebCEDEx7J+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Autocrypt:OpenPGP:From;
	b=oott5cFz8y5dGZEMdcfPNOeVrZh+Km1qf+OGp0fbGP7a+yw0pqs0Ca0qsNqpVa0g+
	 v5Q9JB8X7Wg9z7ANa5OEXl7nwAtqPip2rXf4Hy9CWbSOerFY/KRkFsvH6ssi6rnHfn
	 cMNjS/EgH+xOkhaOn7Rp9gwsnfBCLMNH1PdrniTts5fMGfn+Qnbj6D+067oqsno2Ad
	 HpZ96LOotXDJd7VeufkFX45Dmj1y+1qbakdNxxdzWskq7DD6z+o64TYSmRbpPzNhAm
	 mp1rMJtyITC0xeIwcjvu0G4fkNd1l8wI0FCaImFwUvSTqFcdVdoTALDyMuTrNxTzBL
	 UbvHavvFRxj5w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cssWw214nz9rxG;
	Thu, 23 Oct 2025 18:52:12 +0200 (CEST)
From: Markus Probst <markus.probst@posteo.de>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus Probst <markus.probst@posteo.de>
Subject: [PATCH v4 3/3] ata: Use ACPI methods to power on disks
Date: Thu, 23 Oct 2025 16:52:13 +0000
Message-ID: <20251023165151.722252-4-markus.probst@posteo.de>
In-Reply-To: <20251023165151.722252-1-markus.probst@posteo.de>
References: <20251023165151.722252-1-markus.probst@posteo.de>
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
provided to the disks via the SATA power connector or not. If power
resources are defined on ATA ports / devices in ACPI, we should try to set
the power state to D0 before probing the disk to ensure that any power
supply or power gate that may exist is providing power to the disk.

An example for such devices would be newer synology NAS devices. Every
disk slot has its own SATA power connector. Whether the connector is
providing power is controlled via an gpio, which is *off by default*.
Also the disk loses power on reboots.

Add a new function, ata_acpi_port_power_on(), that will be used to power
on the SATA power connector if usable ACPI power resources on the
associated ATA port / device are found. It will be called right before
probing the port, therefore the disk will be powered on just in time.

Signed-off-by: Markus Probst <markus.probst@posteo.de>
---
 drivers/ata/libata-acpi.c | 40 +++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c |  2 ++
 drivers/ata/libata.h      |  2 ++
 3 files changed, 44 insertions(+)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index f05c247d25bc..9d6177420e82 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -273,6 +273,46 @@ bool ata_acpi_dev_manage_restart(struct ata_device *dev)
 	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));
 }
 
+/**
+ * ata_acpi_port_power_on - set the power state of the ata port to D0
+ * @ap: target ATA port
+ *
+ * This function is called at the beginning of ata_port_probe.
+ */
+void ata_acpi_port_power_on(struct ata_port *ap)
+{
+	acpi_handle handle;
+	int i;
+
+	/* If `ATA_FLAG_ACPI_SATA` is set, the acpi fwnode is attached to the
+	 * `ata_device` instead of the `ata_port`.
+	 */
+	if (ap->flags & ATA_FLAG_ACPI_SATA) {
+		for (i = 0; i < ATA_MAX_DEVICES; i++) {
+			if (!is_acpi_device_node(ap->link.device[i].tdev.fwnode))
+				continue;
+			handle = ACPI_HANDLE(&ap->link.device[i].tdev);
+			if (!acpi_bus_power_manageable(handle))
+				continue;
+			if (!acpi_bus_set_power(handle, ACPI_STATE_D0))
+				ata_dev_dbg(&ap->link.device[i], "acpi: power on\n");
+			else
+				ata_dev_err(&ap->link.device[i], "acpi: failed to power state\n");
+		}
+		return;
+	}
+	if (!is_acpi_device_node(ap->tdev.fwnode))
+		return;
+	handle = ACPI_HANDLE(&ap->tdev);
+	if (!acpi_bus_power_manageable(handle))
+		return;
+
+	if (!acpi_bus_set_power(handle, ACPI_STATE_D0))
+		ata_port_dbg(ap, "acpi: power on\n");
+	else
+		ata_port_err(ap, "acpi: failed to set power state\n");
+}
+
 /**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2a210719c4ce..a6813ced3ec2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5901,6 +5901,8 @@ void ata_port_probe(struct ata_port *ap)
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	unsigned long flags;
 
+	ata_acpi_port_power_on(ap);
+
 	/* kick EH for boot probing */
 	spin_lock_irqsave(ap->lock, flags);
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index af08bb9b40d0..0e7ecac73680 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -130,6 +130,7 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern void ata_acpi_bind_port(struct ata_port *ap);
 extern void ata_acpi_bind_dev(struct ata_device *dev);
+extern void ata_acpi_port_power_on(struct ata_port *ap);
 extern bool ata_acpi_dev_manage_restart(struct ata_device *dev);
 extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
 #else
@@ -141,6 +142,7 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline void ata_acpi_bind_port(struct ata_port *ap) {}
 static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
+static inline void ata_acpi_port_power_on(struct ata_port *ap) {}
 static inline bool ata_acpi_dev_manage_restart(struct ata_device *dev) { return 0; }
 #endif
 
-- 
2.51.0

