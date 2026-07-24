Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1F73CF1E1
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 08:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784881083; cv=none; b=KZ9Pdq1r2PiLe9KoHJT4HvHpYLHESXKafySKzY6SkdvtVpLRcfVFhsP9m5KurIJdKxMw2aZFwqmQ3RJxnPZPjqQ/qm4Efs/0ztTJnluws/m6M50PfVlzziYsbkhgiWyJhMo14I1BlMEg780S8Trl/NURUsh28Yuta5jUHhFIXyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784881083; c=relaxed/simple;
	bh=skDgVZGRD47UsFl2R0GBZsMV/aRMEpKrjCUYxfF2vzw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dUza9eBTev0cDnwrwppXFgUFPgjB4PLjPTXpKi719FOvJ71NskiOv249cP8jp9c9SRSQQtBbAAuDwi/MzbedmrnB1RVhubMjtbZ9BgAH5hSP8Dr+VLNFO520Oy9B1qRd6zvKCYH5wZF20XfUTuUVDG9CwOQWgaK/x30GKEsbT/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=I2aWUXDu; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="I2aWUXDu"
Received: (wp-smtpd smtp.wp.pl 34383 invoked from network); 24 Jul 2026 10:17:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1784881068; bh=qwv4nSg8nwvFMxg22jwPSBR5hXT0PFvfVV9/E/HwUNE=;
          h=From:To:Cc:Subject;
          b=I2aWUXDugs4y9LXCiAJAK1g3m/Qrxpvz+RVZVBuJ0Wv58A3y4W8F4nQ4OmtBN5TiH
           tG2IZfZvwREmhnOmHCwTpPZrNrOknJOnw+OzAHJ8o5Mv5ddNWhmshPuq3RO/domHIm
           HHlC1izADV6t3+UAg07usT6c9+nDUfl6gbLU8Nflk9YJlOPe9KjiiPuy4ggQqatbTE
           6BJkh8T74SWVz4PWjfAkqzNykYbZGRLy3DV9KGQG2eqxvAEl74F9MKDdF3sNukhJw9
           S4krd6u0xIDwi7WEG27lmNJoGyLSDAMXFP9CINwIlyN7KDFq4upFzjOM37iBf+ON8d
           OMxJe554VZ8og==
Received: from 77-236-11-167.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.167])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-scsi@vger.kernel.org>; 24 Jul 2026 10:17:48 +0200
From: stf_xl@wp.pl
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: wd719x: initialize all fields of eeprom_93cx6 struct
Date: Fri, 24 Jul 2026 10:17:47 +0200
Message-Id: <20260724081747.7726-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: d1366f29f76ec42662375fa3acd7638b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [ITOU]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Commit 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra
read clock cycle") added extra 'quirk' field to struct eeprom_93cx6,
which change how the data is read.

Some existing users of eeprom_93cx6, including wd719x driver, allocate
the structure on the stack without initialization of all the fields.
As a result, the added quirk field has undefined value, what can
randomly cause reading wrong data from the EEPROM.

Fix by using designated initialization.

Fixes: 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle")
Cc: stable@kernel.org # v6.13+
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/scsi/wd719x.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 830d40f57f6a..2bdfb2c759ed 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -739,15 +739,15 @@ static void wd719x_eeprom_reg_write(struct eeprom_93cx6 *eeprom)
 /* read config from EEPROM so it can be downloaded by the RISC on (re-)init */
 static void wd719x_read_eeprom(struct wd719x *wd)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {
+		.data = wd,
+		.register_read = wd719x_eeprom_reg_read,
+		.register_write = wd719x_eeprom_reg_write,
+		.width = PCI_EEPROM_WIDTH_93C46,
+	};
 	u8 gpio;
 	struct wd719x_eeprom_header header;
 
-	eeprom.data = wd;
-	eeprom.register_read = wd719x_eeprom_reg_read;
-	eeprom.register_write = wd719x_eeprom_reg_write;
-	eeprom.width = PCI_EEPROM_WIDTH_93C46;
-
 	/* set all outputs to low */
 	wd719x_writeb(wd, WD719X_PCI_GPIO_DATA, 0);
 	/* configure GPIO pins */
-- 
2.50.1

