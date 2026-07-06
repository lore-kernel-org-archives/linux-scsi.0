Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4173E314F;
	Mon,  6 Jul 2026 06:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320992; cv=none; b=tcimqbIOkAe/IkX7HHjyj0zSNlHnDDbzEAhnRqVcUKruGcYvedQhLDvks5AlrSDUL2iyYTJCIbNGRHY0yTdO5UGVS2eeps7W64/fb4jrrAgBVTvOsaQ9Zi5IqrqNHrVSOz1Hn4WI8lF2vYDZcboiVgJydjvXVY37YzTyUgwnsv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320992; c=relaxed/simple;
	bh=1S8MukVQWAt2TvgKv8H9JHH+47XdYtjjKeM6dgApaag=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brS0acZIP7o5jrT1q9t1zVGnCtDPM8FP0LpFePcfMSzNWdOJ4sGpnRH0weQ7f+HbbdHHx2OS9m+yuq5rqxTqhcMjlA+PkEKNUay8w3iTILc2EUiCcUdVRxNdbQGbG4rP82lT80/TaULBzbc8OgCC/6cL6F2KVEF88Tzho1jj3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtXW0Ysh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtXW0Ysh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E611F00A3F;
	Mon,  6 Jul 2026 06:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320984;
	bh=FjbjPaF+PBCW2mgKIAOnT6ndXe156Obrd2ujFbbaRWU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=RtXW0YshupR+WrRAEvfieoJ3VirywRRIYxFAaFqHuoKJwMBDeqTMdgE1K6MWFEbwg
	 J07G5dWHN4KJzXIE1OGEMLSVfwACWh3YoVfBIqu/PcOoigpkUiUX93+Ski9ta2kTqk
	 wPDBvBTt0Eg82dWVKD7Beqmnsdzhx6c3zWkZb6o1wtNoKG33zhOCBs2YOTVPQy77qL
	 w76/gnnoKmP8YGGo3S1OcxpHA2+3BHz96gzI0s7zcXQktol3Y5thjmX3LON3GHFK1u
	 t2JBURCNScWPZSTxiIhDKZktXkQa96YnvFqjUxwUYqVzbOcQNqDTVbwTKJzl0TXnXV
	 FM294SA//MKiA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 3/9] ata: libata: improve the definition of device flags
Date: Mon,  6 Jul 2026 15:56:04 +0900
Message-ID: <20260706065610.3559692-4-dlemoal@kernel.org>
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

The flags field of struct ata_device has the unsigned long type. Define
all the ATA_DFLAG_XXX flags using a 1UL bit shift to match this type, thus
avoiding flags to become signed values (e.g. for bit 31 flag).

To avoid all other values defined in the same enum as the ATA_DFLAG_XXX
flags to implicitly also become unsigned long values, move the device
flags definition to a separate enum.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 include/linux/libata.h | 85 ++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 96e626d6a7ca..736ba8a6a77b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -121,6 +121,50 @@ enum {
 	ATA_QUIRK_NO_FUA		= BIT_ULL(__ATA_QUIRK_NO_FUA),
 };
 
+/*
+ * struct ata_device flags
+ */
+enum {
+	ATA_DFLAG_LBA		= (1UL << 0), /* device supports LBA */
+	ATA_DFLAG_LBA48		= (1UL << 1), /* device supports LBA48 */
+	ATA_DFLAG_CDB_INTR	= (1UL << 2), /* device asserts INTRQ when ready for CDB */
+	ATA_DFLAG_NCQ		= (1UL << 3), /* device supports NCQ */
+	ATA_DFLAG_FLUSH_EXT	= (1UL << 4), /* do FLUSH_EXT instead of FLUSH */
+	ATA_DFLAG_ACPI_PENDING	= (1UL << 5), /* ACPI resume action pending */
+	ATA_DFLAG_ACPI_FAILED	= (1UL << 6), /* ACPI on devcfg has failed */
+	ATA_DFLAG_AN		= (1UL << 7), /* AN configured */
+	ATA_DFLAG_TRUSTED	= (1UL << 8), /* device supports trusted send/recv */
+	ATA_DFLAG_FUA		= (1UL << 9), /* device supports FUA */
+	ATA_DFLAG_DMADIR	= (1UL << 10), /* device requires DMADIR */
+	ATA_DFLAG_NCQ_SEND_RECV = (1UL << 11), /* device supports NCQ SEND and RECV */
+	ATA_DFLAG_NCQ_PRIO	= (1UL << 12), /* device supports NCQ priority */
+	ATA_DFLAG_CDL		= (1UL << 13), /* supports cmd duration limits */
+	ATA_DFLAG_CFG_MASK	= (1UL << 14) - 1,
+
+	ATA_DFLAG_PIO		= (1UL << 14), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1UL << 15), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SLEEPING	= (1UL << 16), /* device is sleeping */
+	ATA_DFLAG_DUBIOUS_XFER	= (1UL << 17), /* data transfer not verified */
+	ATA_DFLAG_NO_UNLOAD	= (1UL << 18), /* device doesn't support unload */
+	ATA_DFLAG_UNLOCK_HPA	= (1UL << 19), /* unlock HPA */
+	ATA_DFLAG_INIT_MASK	= (1UL << 20) - 1,
+
+	ATA_DFLAG_NCQ_PRIO_ENABLED = (1UL << 20), /* Priority cmds sent to dev */
+	ATA_DFLAG_CDL_ENABLED	= (1UL << 21), /* cmd duration limits is enabled */
+	ATA_DFLAG_RESUMING	= (1UL << 22),  /* Device is resuming */
+	ATA_DFLAG_DETACH	= (1UL << 24),
+	ATA_DFLAG_DETACHED	= (1UL << 25),
+	ATA_DFLAG_DA		= (1UL << 26), /* device supports Device Attention */
+	ATA_DFLAG_DEVSLP	= (1UL << 27), /* device supports Device Sleep */
+	ATA_DFLAG_ACPI_DISABLED = (1UL << 28), /* ACPI for the device is disabled */
+	ATA_DFLAG_D_SENSE	= (1UL << 29), /* Descriptor sense requested */
+
+	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
+				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
+				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA | \
+				   ATA_DFLAG_CDL)
+};
+
 enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
@@ -146,46 +190,7 @@ enum {
 	ATA_TFLAG_FUA		= (1 << 5), /* enable FUA */
 	ATA_TFLAG_POLLING	= (1 << 6), /* set nIEN to 1 and use polling */
 
-	/* struct ata_device stuff */
-	ATA_DFLAG_LBA		= (1 << 0), /* device supports LBA */
-	ATA_DFLAG_LBA48		= (1 << 1), /* device supports LBA48 */
-	ATA_DFLAG_CDB_INTR	= (1 << 2), /* device asserts INTRQ when ready for CDB */
-	ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
-	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
-	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
-	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
-	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
-	ATA_DFLAG_TRUSTED	= (1 << 8), /* device supports trusted send/recv */
-	ATA_DFLAG_FUA		= (1 << 9), /* device supports FUA */
-	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
-	ATA_DFLAG_NCQ_SEND_RECV = (1 << 11), /* device supports NCQ SEND and RECV */
-	ATA_DFLAG_NCQ_PRIO	= (1 << 12), /* device supports NCQ priority */
-	ATA_DFLAG_CDL		= (1 << 13), /* supports cmd duration limits */
-	ATA_DFLAG_CFG_MASK	= (1 << 14) - 1,
-
-	ATA_DFLAG_PIO		= (1 << 14), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 15), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SLEEPING	= (1 << 16), /* device is sleeping */
-	ATA_DFLAG_DUBIOUS_XFER	= (1 << 17), /* data transfer not verified */
-	ATA_DFLAG_NO_UNLOAD	= (1 << 18), /* device doesn't support unload */
-	ATA_DFLAG_UNLOCK_HPA	= (1 << 19), /* unlock HPA */
-	ATA_DFLAG_INIT_MASK	= (1 << 20) - 1,
-
-	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 20), /* Priority cmds sent to dev */
-	ATA_DFLAG_CDL_ENABLED	= (1 << 21), /* cmd duration limits is enabled */
-	ATA_DFLAG_RESUMING	= (1 << 22),  /* Device is resuming */
-	ATA_DFLAG_DETACH	= (1 << 24),
-	ATA_DFLAG_DETACHED	= (1 << 25),
-	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
-	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
-	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
-	ATA_DFLAG_D_SENSE	= (1 << 29), /* Descriptor sense requested */
-
-	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
-				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
-				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA | \
-				   ATA_DFLAG_CDL),
-
+	/* sturct ata_device class. */
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
 	ATA_DEV_ATA_UNSUP	= 2,	/* ATA device (unsupported) */
-- 
2.54.0

