Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020545;
	b=OhLjsED0ALW6gG5/mff/zXV0quh1Obn+DP3BsEI3vxpKHsM6v7oCSZ3XEhcKxxT/bs2U
	 Lp1Pe0yK1FA4x0vapRVfZyVd15Fh65HLGJd0+Ob69aDC1Jxasklc3UWkS+ufrUfCHlurF
	 SqCuCFG7gTwuqzc7xWhJ74asFxdw8q9I5xJzQgq1s+ukmWIeSzq/7YTWYyFowLbHWfxZ/
	 ul6fXSBxoYZsgDjUhZpf7LQek44aMkHD6RCtVCRRka1XZ6KDLQZ0KyJuVQ3b13ZX/uwMT
	 WQLWUayo1I5DAyFXlvsnM3/JvH54wQ/2qlMy9sYntzZv5FOp/SBiWbqw/rYa29QUXdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RGNe2EMyxsnvsEaTX+Pjtf2oiHahHN9mOAFjtweH/sQ=;
	b=AgEcDKYiJvOzayMkkRuNUd1BeXDJ4RbNO9OQFH4xVvlfdUgW2yji7wshNWbEcRWu5hW6
	 5f957429RegneIfS/y1mJln5xJSUj6lze0/V4FcUpqrvLdHKas67QHP7c21RRi5lRFenI
	 /S35qIpBqHPKokQcrKWB/PXzCKy3ebjKPO/TF8ZbGsFNkv9f8Xe6WFzWhzz2QVApZhD2U
	 lnys3BTYFXcqJW9zE6CTXjhqoALkCVfKBjDmLifAscpLD8Y9xcNHkYn9EwiGt5v28sLrg
	 9C7m3IBXzcZ9w2Xh7DEofyGkb4iWdVyR4Fz3gYb92GxZkzFIX4/4A5c4Vh+Myyq2bUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmveuHIB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B989E606A31B;
	Mon, 26 Oct 2026 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmveuHIB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB9B1F01825;
	Mon, 26 Oct 2026 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793020544;
	bh=RGNe2EMyxsnvsEaTX+Pjtf2oiHahHN9mOAFjtweH/sQ=;
	h=From:To:Cc:Subject:Date;
	b=lmveuHIBw3NzrRNioS45fPA/x/ZEmPqKziYwNbCbHiOvmGNjQ7FxiTZyofXGlCFnM
	 wsCBgUiUgjOEA8N7/nWJfzxnTG4nCJ5tPrLBTbaV+lomDOdF1qwA40bH2Iym0QjyxN
	 VvxHH5dRf0N+Y1b4v1OfpPAlqCiGlz191dR2NqOuzqrvkwWHlpMdTgiBFBgcpYMfCj
	 evLwks/k7Ya3+GgoRDX9XFwz99W1Wo5HePxA2OvoOTEGWf0+7zNEGeuiiuMX6qBfRf
	 CVq86qBnnVc8E+b5RLn0KtiQPOmqzoQ1XpDPsxjNwWKDqiNmEu60b4mPYMQ9dZfzF+
	 J+sbmTUMICQ6Q==
From: Imre Kaloz <kaloz@kernel.org>
To: Hannes Reinecke <hare@suse.com>,
	James.Bottomley@HansenPartnership.com,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
Date: Mon, 26 Oct 2026 14:14:32 +0100
Message-ID: <20261026131432.26065-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SGI O2 firmware runs its onboard aic7880s without the Adaptec BIOS,
so scratch RAM holds no settings. The left over BIOS path reads
uninitialised bytes, and bad parity panics the boot.

Use the defaults there with host ID 0. ahc_init() keeps the default host
ID ahc_pci_config() chose, 7 on other PCI controllers, so only the O2
changes.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c |  8 ++++++--
 drivers/scsi/aic7xxx/aic7xxx_pci.c  | 20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index b9761f9f0bbc..8ad82171e925 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -5266,9 +5266,13 @@ ahc_init(struct ahc_softc *ahc)
 
 	/*
 	 * Assume we have a board at this stage and it has been reset.
+	 * PCI controllers keep the host ID ahc_pci_config() chose.
 	 */
-	if ((ahc->flags & AHC_USEDEFAULTS) != 0)
-		ahc->our_id = ahc->our_id_b = 7;
+	if ((ahc->flags & AHC_USEDEFAULTS) != 0) {
+		if ((ahc->chip & AHC_PCI) == 0)
+			ahc->our_id = 7;
+		ahc->our_id_b = 7;
+	}
 
 	/*
 	 * Default to allowing initiator operations.
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 2d4c85426dc3..5a04c7d55e4b 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -701,6 +701,21 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
 	return (NULL);
 }
 
+/*
+ * The SGI O2 firmware runs its onboard controllers, in slots 1 and 2 of the
+ * root bus, without the Adaptec BIOS and at host ID 0.  It leaves no settings
+ * in scratch RAM, which may still hold power-on contents with bad parity.
+ */
+static bool
+ahc_pci_sgi_o2_onboard(struct ahc_softc *ahc)
+{
+	int slot = ahc_get_pci_slot(ahc->dev_softc);
+
+	return IS_ENABLED(CONFIG_SGI_IP32) &&
+	       ahc_get_pci_bus(ahc->dev_softc) == 0 &&
+	       (slot == 1 || slot == 2);
+}
+
 int
 ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 {
@@ -782,6 +797,9 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 	ahc->bus_intr = ahc_pci_intr;
 	ahc->bus_chip_init = ahc_pci_chip_init;
 
+	if (ahc_pci_sgi_o2_onboard(ahc))
+		ahc->flags |= AHC_NO_BIOS_INIT;
+
 	/* Remember how the card was setup in case there is no SEEPROM */
 	if ((ahc_inb(ahc, HCNTRL) & POWRDN) == 0) {
 		ahc_pause(ahc);
@@ -898,7 +916,7 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 			 * Assume only one connector and always turn
 			 * on termination.
 			 */
- 			our_id = 0x07;
+			our_id = ahc_pci_sgi_o2_onboard(ahc) ? 0 : 0x07;
 			sxfrctl1 = STPWEN;
 		}
 		ahc_outb(ahc, SCSICONF, our_id|ENSPCHK|RESET_SCSI);
-- 
2.47.3

