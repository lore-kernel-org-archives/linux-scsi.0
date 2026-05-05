Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8B247F2EA;
	Tue,  5 May 2026 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777990368; cv=none; b=S4TnVcxdqCB2tsvxGe/wMzcYhD0M2+zrVSqhfr28Ou+LTOQvQRglUuRZ6fqHTtIByQTLL2agN4wavbec933MRy8lf5Pp2ToRqlvXZpZ+zmEiGhF3SS5U4MC82jgpziOSL1VQN7hq+NGN0ltLfBeQooYW0SbjJ5tQLuh5cn0UfY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777990368; c=relaxed/simple;
	bh=PQn62JhwDz9Sa7flQCbe72MOhKpt47xC2HlEX38VAEg=;
	h=Message-Id:From:Date:Subject:To:Cc; b=tlpcfz24kcqwONr7e9foTecHp4yPFbUjNFg6yrqNyvRbCnHO428H4NFxz/dIFjPGeezBD98GeprPSHvqzbSk2SYG3jODZitp+XPoppcOdOP25QKzypK60RoLH0A/tx4NbaboaADO+kKvjBjQzBuTH9CtK/1WkxjK707DpE0cy8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 97422313;
	Tue, 05 May 2026 16:12:34 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 91C21602D0D2; Tue,  5 May 2026 16:12:34 +0200 (CEST)
Message-Id: <c57e018b4dee8d9d913870b8101ee9357c0c4a55.1777989011.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 5 May 2026 16:12:36 +0200
Subject: [PATCH] scsi: elx: efct: Restore config space after error-induced
 reset
To: Ram Vegesna <ram.vegesna@broadcom.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, James Smart <jsmart2021@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

When a Fatal Error is handled by AER or DPC, the error-reporting PCIe
device is reset and its driver's ->slot_reset() callback is invoked to
bring the device back to working state.

That callback first needs to call pci_restore_state() to re-initialize
BAR assignments and other bits in config space.

The Emulex/Broadcom EFCT driver neglects to do that.  Fix it.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.14+
---
Compile-tested only, I do not have this hardware available for testing.
That said, it seems the code path has never been tested anyway.
If you have the hardware, consider injecting a Fatal Error as described
in Documentation/PCI/pcieaer-howto.rst and see if the hardware recovers
successfully.

 drivers/scsi/elx/efct/efct_driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 07c2f45..fe45009 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -688,6 +688,8 @@
 	int rc;
 	struct efct *efct = pci_get_drvdata(pdev);
 
+	pci_restore_state(pdev);
+
 	rc = pci_enable_device_mem(pdev);
 	if (rc) {
 		efc_log_err(efct, "failed to enable PCI device after reset\n");
-- 
2.51.0

