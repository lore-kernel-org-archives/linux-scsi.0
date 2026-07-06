Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DF13D953E;
	Mon,  6 Jul 2026 06:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320995; cv=none; b=Qdxx8qh527PG3/ufTx95G6nDs/AvH2xRen4RVnGHXZEBenn4qIaMwZLdvrJKLH0MR4XAtkHO2JSZTFyGJEcLvuCwgeC1C1ooyGcys/XeohCpgudiFlXLmQHoVpsRwPNMRV581N8cxwgmydfrzVaN+DIf1HLFmZ5QfWTSmGvvR3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320995; c=relaxed/simple;
	bh=i4K0a52HSytzVmP11kyFwZdC1zCLilHnY9LSscnrYL8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPj1YqXmwnZO1yTzo60qNmInpn+iKHU+jRHRAc9gVHxLBXEy/omcnLoEluhbtvVpetkoQMukrzaSgQcsVMHZeQs0qx4V7yg2tUK91BEAwkn3glr1rl3OIKj9mAJjdfhmzRDAP23cWRMsB2X3R1TtGuEzpIuFparIZt+9ckDXVUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmRcoJ7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmRcoJ7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167651F00AC4;
	Mon,  6 Jul 2026 06:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320985;
	bh=NERLpsh4pSWFYMKjF92Z0Bmn0mF76bSS4Pc+u0XW5UU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fmRcoJ7UFYQdwkVNqtEV7kgiRswTh6IQT/evxzDZxxk5G0sVw8plaxDNCsnFiWwzx
	 WSJs4whwM1KaeERGa/nzcL1o4LcPkvxiWcwvzEnoyaiVCU62Ma24eGUu2UcqnK9sGF
	 lzTxqX5ihWbYr8uQcZLUTgakvjnyl7jasNMWYTzTonX15cPOXIQEX2InoHDy1fkNu9
	 0vbdh7n8KNHL6R/x8wGp7C9ls8CbM4PAE3Wk/60dNlZatuK3tlUR4zBfjXnaeCXQYW
	 eEYs04IIB+U7lohncvYiBvSL5iSxj4yLBhB4mUvM3ov5Ns2W1dW4ExSoHxEy9gT3p8
	 WScaJb282ek6g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 5/9] ata: libata-core: detect support for depopulation capabilities
Date: Mon,  6 Jul 2026 15:56:06 +0900
Message-ID: <20260706065610.3559692-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706065610.3559692-1-dlemoal@kernel.org>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the device flags ATA_DFLAG_DEPOP to indicate support by a device
for the basic commands of the storage element depopulation feature set,
that is, the GET PHYSICAL ELEMENT STATUS and REMOVE ELEMENT AND TRUNCATE
commands. The device flag ATA_DFLAG_DEPOP_RESTORE flag is introduced to
indicate support for the RESTORE ELEMENTS AND REBUILD command. Both flags
are obtained from the command support bits of the qword at bytes 152 to
159 of the supported capabilities log page.

For ZAC devices, the device flag ATA_DFLAG_DEPOP_MODIFY is introduced to
indicate support for the REMOVE ELEMENT AND MODIFY ZONES command. This
support is indicated by the REMOVE ELEMENT AND MODIFY ZONES SUPPORTED bit
in the qword at byte 8 to 15 of the zoned device information log page.

The function ata_dev_config_depop() is introduced to set these flags
based on the content of the supported capabilities log and zoned device
information log. As per the ACS specifications, NCQ autosense support is
also mandatory if these flags are set.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-core.c | 73 +++++++++++++++++++++++++++++++++++++--
 include/linux/libata.h    | 45 +++++++++++++-----------
 2 files changed, 96 insertions(+), 22 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5121faf9738e..d893c916df0b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2705,6 +2705,71 @@ static void ata_dev_config_cdl(struct ata_device *dev)
 	ata_dev_cleanup_cdl_resources(dev);
 }
 
+static void ata_dev_config_depop(struct ata_device *dev)
+{
+	unsigned int err_mask;
+	u64 val;
+
+	/* Ignore old drives. */
+	if (ata_id_major_version(dev->id) < 11)
+		goto not_supported;
+
+	/* NCQ Autosense is required. */
+	if (!ata_identify_page_supported(dev, ATA_LOG_SUPPORTED_CAPABILITIES) ||
+	    !ata_id_has_ncq_autosense(dev->id))
+		goto not_supported;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
+				     ATA_LOG_SUPPORTED_CAPABILITIES,
+				     dev->sector_buf, 1);
+	if (err_mask)
+		goto not_supported;
+
+	/* Check depopulation capabilities bits. */
+	val = get_unaligned_le64(&dev->sector_buf[152]);
+	if (!(val & BIT_ULL(63)))
+		goto not_supported;
+
+	/*
+	 * Support for at least the GET PHYSICAL ELEMENT STATUS and
+	 * REMOVE ELEMENT AND TRUNCATE commands is mandated.
+	 */
+	if (!(val & BIT_ULL(0)) || !(val & BIT_ULL(1)))
+		goto not_supported;
+
+	dev->flags |= ATA_DFLAG_DEPOP;
+
+	/* Check if RESTORE ELEMENTS AND REBUILD is supported. */
+	if (val & BIT_ULL(2))
+		dev->flags |= ATA_DFLAG_DEPOP_RESTORE;
+
+	/*
+	 * For ZAC devices, check if REMOVE ELEMENT AND MODIFY ZONES is
+	 * supported.
+	 */
+	if (dev->class != ATA_DEV_ZAC)
+		return;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
+				     ATA_LOG_ZONED_INFORMATION,
+				     dev->sector_buf, 1);
+	if (err_mask)
+		return;
+
+	val = get_unaligned_le64(&dev->sector_buf[8]);
+	if (!(val & BIT_ULL(63)))
+		return;
+
+	if (val & BIT_ULL(1))
+		dev->flags |= ATA_DFLAG_DEPOP_MODIFY;
+
+	return;
+
+not_supported:
+	dev->flags &= ~(ATA_DFLAG_DEPOP | ATA_DFLAG_DEPOP_RESTORE |
+			ATA_DFLAG_DEPOP_MODIFY);
+}
+
 static int ata_dev_config_lba(struct ata_device *dev)
 {
 	const u16 *id = dev->id;
@@ -2942,7 +3007,7 @@ static void ata_dev_print_features(struct ata_device *dev)
 		return;
 
 	ata_dev_info(dev,
-		     "Features:%s%s%s%s%s%s%s%s%s%s\n",
+		     "Features:%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		     dev->flags & ATA_DFLAG_FUA ? " FUA" : "",
 		     dev->flags & ATA_DFLAG_TRUSTED ? " Trust" : "",
 		     dev->flags & ATA_DFLAG_DA ? " Dev-Attention" : "",
@@ -2952,7 +3017,10 @@ static void ata_dev_print_features(struct ata_device *dev)
 		     dev->flags & ATA_DFLAG_NCQ_SEND_RECV ? " NCQ-sndrcv" : "",
 		     dev->flags & ATA_DFLAG_NCQ_PRIO ? " NCQ-prio" : "",
 		     dev->flags & ATA_DFLAG_CDL ? " CDL" : "",
-		     dev->cpr_log ? " CPR" : "");
+		     dev->cpr_log ? " CPR" : "",
+		     dev->flags & ATA_DFLAG_DEPOP ? " Depop" : "",
+		     dev->flags & ATA_DFLAG_DEPOP_RESTORE ? " Depop-Restore" : "",
+		     dev->flags & ATA_DFLAG_DEPOP_MODIFY ? " Depop-Modify" : "");
 }
 
 /**
@@ -3115,6 +3183,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_trusted(dev);
 		ata_dev_config_cpr(dev);
 		ata_dev_config_cdl(dev);
+		ata_dev_config_depop(dev);
 		dev->cdb_len = 32;
 
 		if (print_info)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 736ba8a6a77b..3703ef433bd4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -139,30 +139,35 @@ enum {
 	ATA_DFLAG_NCQ_SEND_RECV = (1UL << 11), /* device supports NCQ SEND and RECV */
 	ATA_DFLAG_NCQ_PRIO	= (1UL << 12), /* device supports NCQ priority */
 	ATA_DFLAG_CDL		= (1UL << 13), /* supports cmd duration limits */
-	ATA_DFLAG_CFG_MASK	= (1UL << 14) - 1,
-
-	ATA_DFLAG_PIO		= (1UL << 14), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1UL << 15), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SLEEPING	= (1UL << 16), /* device is sleeping */
-	ATA_DFLAG_DUBIOUS_XFER	= (1UL << 17), /* data transfer not verified */
-	ATA_DFLAG_NO_UNLOAD	= (1UL << 18), /* device doesn't support unload */
-	ATA_DFLAG_UNLOCK_HPA	= (1UL << 19), /* unlock HPA */
-	ATA_DFLAG_INIT_MASK	= (1UL << 20) - 1,
-
-	ATA_DFLAG_NCQ_PRIO_ENABLED = (1UL << 20), /* Priority cmds sent to dev */
-	ATA_DFLAG_CDL_ENABLED	= (1UL << 21), /* cmd duration limits is enabled */
-	ATA_DFLAG_RESUMING	= (1UL << 22),  /* Device is resuming */
-	ATA_DFLAG_DETACH	= (1UL << 24),
-	ATA_DFLAG_DETACHED	= (1UL << 25),
-	ATA_DFLAG_DA		= (1UL << 26), /* device supports Device Attention */
-	ATA_DFLAG_DEVSLP	= (1UL << 27), /* device supports Device Sleep */
-	ATA_DFLAG_ACPI_DISABLED = (1UL << 28), /* ACPI for the device is disabled */
-	ATA_DFLAG_D_SENSE	= (1UL << 29), /* Descriptor sense requested */
+	ATA_DFLAG_DEPOP		= (1UL << 14), /* supports depopulation capability */
+	ATA_DFLAG_DEPOP_RESTORE	= (1UL << 15), /* supports depopulation restoration */
+	ATA_DFLAG_DEPOP_MODIFY	= (1UL << 16), /* supports zoned depopulation */
+	ATA_DFLAG_CFG_MASK	= (1UL << 17) - 1,
+
+	ATA_DFLAG_PIO		= (1UL << 17), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1UL << 18), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SLEEPING	= (1UL << 19), /* device is sleeping */
+	ATA_DFLAG_DUBIOUS_XFER	= (1UL << 20), /* data transfer not verified */
+	ATA_DFLAG_NO_UNLOAD	= (1UL << 21), /* device doesn't support unload */
+	ATA_DFLAG_UNLOCK_HPA	= (1UL << 22), /* unlock HPA */
+	ATA_DFLAG_INIT_MASK	= (1UL << 23) - 1,
+
+	ATA_DFLAG_NCQ_PRIO_ENABLED = (1UL << 23), /* Priority cmds sent to dev */
+	ATA_DFLAG_CDL_ENABLED	= (1UL << 24), /* cmd duration limits is enabled */
+	ATA_DFLAG_RESUMING	= (1UL << 25),  /* Device is resuming */
+	ATA_DFLAG_DETACH	= (1UL << 26),
+	ATA_DFLAG_DETACHED	= (1UL << 27),
+	ATA_DFLAG_DA		= (1UL << 28), /* device supports Device Attention */
+	ATA_DFLAG_DEVSLP	= (1UL << 29), /* device supports Device Sleep */
+	ATA_DFLAG_ACPI_DISABLED = (1UL << 30), /* ACPI for the device is disabled */
+	ATA_DFLAG_D_SENSE	= (1UL << 31), /* Descriptor sense requested */
 
 	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
 				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
 				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA | \
-				   ATA_DFLAG_CDL)
+				   ATA_DFLAG_CDL | ATA_DFLAG_DEPOP | \
+				   ATA_DFLAG_DEPOP_RESTORE |
+				   ATA_DFLAG_DEPOP_MODIFY)
 };
 
 enum {
-- 
2.54.0

