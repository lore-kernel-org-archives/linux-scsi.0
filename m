Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F42205AA9
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 19:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729280892; cv=none; b=LBgP079qHqYxEFQdR5j5NG+86+/JiyelkCEd4/R/lST+bA7tI0WhQUg/0HcXUJ2mI7KqSfvmS+3r+IvJ/NhF/y4f2VrCRm+E4FQtmdMiysyHertS+XP0GVLb1lLdQOfIGsKlQfwZ3wGcm77AapM6ZVFShpqamF9R9ghlvV+vVmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729280892; c=relaxed/simple;
	bh=REqRKU5ebDdKoBg4ARif0y8AuhjURlrcZmy4I0ipeTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eNcY5tsc9ihJMDAg+wpbNmzzfOaGxard7wfdrzVLZrrPSTY2SdfttlZB0SzpdDlTpWsNhSmi6yIyLjLL7HALUEgZydEYFyynAJo2yKdYcsXwwQ8vhEmJIJYHfVUIm8N940l/SkEOJ8JzI6i8V4AR5CitkzOcnn6bBEEuLrLx3x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OAg9msSE; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OAg9msSE"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XVZxk2GPbzlgT1K;
	Fri, 18 Oct 2024 19:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1729280880; x=1731872881; bh=EPOFOMfm3iCEJZmT8KSLCoJaxtfMVun48cO
	6Rijs4UU=; b=OAg9msSEJc5I37ScwEG93Wn9GtMJoknsusy1lNXpy36MkAAkaDl
	/nz5oC/M7jjYxWIDy1W9r6CKxH4BUGLgYLBj/pUR7BDD5qqy1mNnXYk+r1+zei1o
	ADAlYmicsh3/x+G7lEGmmDb3C38BPoO6RF4QweRFR6OEFGmqd4ztAKbBbudaY8fl
	/SHf8fSTWl9bqajx3aAHLEJcmFHTTh+Qndjon5/uPg7uBGMmqyrwki/7h4Yus4Tj
	I9NdFLJpHOGowbgpAEx6+htQ/2MefSSETEDiUFTQ9oT6+k0cPIhdG+hes06FWlPK
	D4t5Dfz76aI3GgqboCX4Ez2PvIOuWjVWdgg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AgPgr34sZfy8; Fri, 18 Oct 2024 19:48:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XVZxW45Zrzlgx6j;
	Fri, 18 Oct 2024 19:47:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more flexible
Date: Fri, 18 Oct 2024 12:47:39 -0700
Message-ID: <20241018194753.775074-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver accordingly.
This patch enables supporting other configurations than 32-bit or 64-bit
DMA addresses, e.g. 36-bit DMA addresses.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c      | 4 ++--
 drivers/ufs/host/ufs-renesas.c | 9 ++++++++-
 include/ufs/ufshcd.h           | 9 +++------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e0dba0e3d5b5..a1eb32d301ae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2389,8 +2389,6 @@ static inline int ufshcd_hba_capabilities(struct uf=
s_hba *hba)
 	int err;
=20
 	hba->capabilities =3D ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
-	if (hba->quirks & UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS)
-		hba->capabilities &=3D ~MASK_64_ADDRESSING_SUPPORT;
=20
 	/* nutrs and nutmrs are 0 based values */
 	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) +=
 1;
@@ -10277,6 +10275,8 @@ EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
  */
 static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 {
+	if (hba->vops && hba->vops->set_dma_mask)
+		return hba->vops->set_dma_mask(hba);
 	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
 		if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
 			return 0;
diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesa=
s.c
index 8711e5cbc968..3ff97112e1f6 100644
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -7,6 +7,7 @@
=20
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
@@ -364,14 +365,20 @@ static int ufs_renesas_init(struct ufs_hba *hba)
 		return -ENOMEM;
 	ufshcd_set_variant(hba, priv);
=20
-	hba->quirks |=3D UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS | UFSHCD_QUIRK_HIBER=
N_FASTAUTO;
+	hba->quirks |=3D UFSHCD_QUIRK_HIBERN_FASTAUTO;
=20
 	return 0;
 }
=20
+static int ufs_renesas_set_dma_mask(struct ufs_hba *hba)
+{
+	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
+}
+
 static const struct ufs_hba_variant_ops ufs_renesas_vops =3D {
 	.name		=3D "renesas",
 	.init		=3D ufs_renesas_init,
+	.set_dma_mask	=3D ufs_renesas_set_dma_mask,
 	.setup_clocks	=3D ufs_renesas_setup_clocks,
 	.hce_enable_notify =3D ufs_renesas_hce_enable_notify,
 	.dbg_register_dump =3D ufs_renesas_dbg_register_dump,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 36bd91ff3593..9ea2a7411bb5 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -299,6 +299,8 @@ struct ufs_pwr_mode_info {
  * @max_num_rtt: maximum RTT supported by the host
  * @init: called when the driver is initialized
  * @exit: called to cleanup everything done in init
+ * @set_dma_mask: For setting another DMA mask than indicated by the 64A=
S
+ *	capability bit.
  * @get_ufs_hci_version: called to get UFS HCI version
  * @clk_scale_notify: notifies that clks are scaled up/down
  * @setup_clocks: called before touching any of the controller registers
@@ -341,6 +343,7 @@ struct ufs_hba_variant_ops {
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
 	u32	(*get_ufs_hci_version)(struct ufs_hba *);
+	int	(*set_dma_mask)(struct ufs_hba *);
 	int	(*clk_scale_notify)(struct ufs_hba *, bool,
 				    enum ufs_notify_change_status);
 	int	(*setup_clocks)(struct ufs_hba *, bool,
@@ -623,12 +626,6 @@ enum ufshcd_quirks {
 	 */
 	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		=3D 1 << 16,
=20
-	/*
-	 * This quirk needs to be enabled if the host controller has
-	 * 64-bit addressing supported capability but it doesn't work.
-	 */
-	UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS		=3D 1 << 17,
-
 	/*
 	 * This quirk needs to be enabled if the host controller has
 	 * auto-hibernate capability but it's FASTAUTO only.
