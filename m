Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914DF31CA7E
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 20:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761596634; cv=none; b=UE2Od/4vxpKhZqTZxWKD85ThiLGuseeTei+CJzgr9K+zbUpJWDI8TJmK5toRH2etNDVIF/04+/ZolB+aAhzC1adLuRCktcH1T3OPFiCaUUlsTOJc8TvsjaFMIk51KO9Kqv3PlvWnifxamUV0y2miQ2oR7jd0HuOqpAFDMJntvPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761596634; c=relaxed/simple;
	bh=NzCS936DXRtO+lTw11yYlbCEYOkxHPlAQUnF+H+KHmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iobMlv8o3Hb3RB7mcE71SB3eRI/qxQpdyQnodJbUmJlLht1DSmXVqdjCA745LyFhFYNe005u7buK07AYQQIxpRcXx0uHWUE+JoMQjxU943i5AyX/YOAYp6AmRTWnSRMKYoIG89sI4lodWto0Gd4DfCWYkUpTt+3/iJcfgPlkS3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=c9O0RZzn; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="c9O0RZzn"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id E611824002B
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 21:23:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1761596628; bh=Kncq0dou8uYIUnKlYWDuzCvWP6n2O97xejVC8EhMsjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Autocrypt:OpenPGP:From;
	b=c9O0RZzngjmJm2RXMprrtPBQcFI6myOnA4ua4gtnECiEjaPa3VHf+QHUi/o5V//wa
	 wYftw/Ou83UqewAyILyNaCQA42LiOcWHb5jxmzAiLp4nGDdq1o3TBc8nCB6HIKzOSp
	 xgjNmLl8AD5TtelAMm+DS1HxMJ+6eQnWQs6G7uYST1wx30MYOnehkHXMFs5vRCYoUy
	 5nj2Yn/GoQTjcKWFSwL3GjuGk/qNCU6cNz8iYN/YMr6BfrG8GmfAtODO4WG9RuGZZz
	 CmIrHPR2A28fx4WGW9FQf/4qMgsx+jfiVoQuumscF3saT4rntaAXW4PjeXbGTmv8J/
	 z9R5x/NbLU6Dg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cwQ2C6yVPz9rwn;
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
Subject: [PATCH v5 3/3] ata: Use ACPI methods to power on disks
Date: Mon, 27 Oct 2025 20:23:48 +0000
Message-ID: <20251027202339.1043723-4-markus.probst@posteo.de>
In-Reply-To: <20251027202339.1043723-1-markus.probst@posteo.de>
References: <20251027202339.1043723-1-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4153; i=markus.probst@posteo.de; h=from:subject; bh=NzCS936DXRtO+lTw11yYlbCEYOkxHPlAQUnF+H+KHmc=; b=owEBbQKS/ZANAwAIATR2H/jnrUPSAcsmYgBo/9R4GwBedxwt5upXcHk9g5mtG4TopLKYCo7KJ VePGlsW7h+JAjMEAAEIAB0WIQSCdBjE9KxY53IwxHM0dh/4561D0gUCaP/UeAAKCRA0dh/4561D 0sP/D/9u28g++LNhAix9AWyFZ6id3KKFDcfYaeScOzS9/r7gpBxDyt6NNvuUCZ/2rl8eEKe4TSU CggJI0tQbxQTPc21TfdTO1wzbLe0QbRk+vaeMi6pIT1YypqgtsYhEUObUonWhyD949DgPeV3JIy 1Jkbw2LiB4hzqSv8yp0YdfvnFIt0TBAIE9wQBzzbBq+g9eDG2MhGYhwCbff+9UpNi09hmAI5uvR m4VtwfCHbr+byK95prdpeZULAWMRBAESzzKfdm4tiXk8GR49g/yYnruXfLhNDoCeQsDs8WODrnL 0dMk4lszJv52PK0NTFITPRMDjn4VEa5sLa2dYuH1VGo1CnEF7Z4WGNsLSnyqNwuB1ZPm/B7iuIs IL53MEGSSwTNMdtd8gucpzK3cIMsjQeVhq5UG1G0gmIv+v7stI04fZx7LKYZVUXFwxwr6v/prkh nHq+1B/mTe8AWSiX/3zGPbLuqWewMnSH+GOL39bwDlK4zzRImHa5ty86po2yDfic8mUgwEX+lhz /56asvXf4ZdRyxB7Tyqkp+CERq3I/dpW2iCYpbHJZcuWZpipE/PJeWPYf7FHZrtMGX1fjDHK4fT gEjdwz+SZNalVpfDXt3WSIknOXoxdvw/CXYs0be6kzCDi7BQ9KZ1HoQM/478+CXlQQtXSbfTAYq J5H6toQ8oQxVsRQ=
 =
X-Developer-Key: i=markus.probst@posteo.de; a=openpgp; fpr=827418C4F4AC58E77230C47334761FF8E7AD43D2
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
index 196ca1227d09..b0d70e075cd2 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -271,6 +271,46 @@ bool ata_acpi_dev_manage_restart(struct ata_device *dev)
 	return acpi_bus_power_manageable(ACPI_HANDLE(tdev));
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
+			struct ata_device *dev = &ap->link.device[i];
+
+			if (!is_acpi_device_node(dev->tdev.fwnode))
+				continue;
+			handle = ACPI_HANDLE(&dev->tdev);
+			if (!acpi_bus_power_manageable(handle))
+				continue;
+			if (acpi_bus_set_power(handle, ACPI_STATE_D0))
+				ata_dev_err(dev,
+					    "acpi: failed to power state to D0\n");
+		}
+		return;
+	}
+
+	if (!is_acpi_device_node(ap->tdev.fwnode))
+		return;
+	handle = ACPI_HANDLE(&ap->tdev);
+	if (!acpi_bus_power_manageable(handle))
+		return;
+
+	if (acpi_bus_set_power(handle, ACPI_STATE_D0))
+		ata_port_err(ap, "acpi: failed to set power state to D0\n");
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

