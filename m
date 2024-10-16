Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3026E1D2F42
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 21:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113190; cv=none; b=cpFICl0QA2BcY5C73+6iDY9czJeGXtWb33PCJeTEzKDtauzo0grnFTbwmeNusVuJBmhtZf3Ays+7JnrY8bjxG9Re0AJveUacdpzNvs9gL5vIppXBkZ0DDVfuJ9UCGy1J2Jt517j2mjMXtF5aZcGsh2Ogbs9JJ2Eff7LolnZ126M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113190; c=relaxed/simple;
	bh=UCL7HwpmMrkOWCYTpoYSw3v+dXq2S/1324SQeV4xfUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pn8qMm4TWdSep5uXcyFRCaWRp4CpVMFRLYW4YKoCzu628+NUQl9AJqWhwmtOa+vyPEYNG1fou7wx82YbfohjZPZ4W18hP67sF7DZ8F7o4xJ8Dxw2fSwld6Y2UWjF6agdT1uHbctTD5VOVSSA4laE8cmGm3PYy/+YYrq2gF++9xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CtlA4nsK; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CtlA4nsK"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTNwh6n9hzlgMVr;
	Wed, 16 Oct 2024 21:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729113182; x=1731705183; bh=nBOJM
	e0B8AN1VXAmXtfYXEEKaQTpcbxJMNXSKJd0Kx8=; b=CtlA4nsKHJ3K/M0k2TCAe
	N827HRSaeqQgEFs299Y9fHHJhvLQDaG7GTLmt1RbK1h+RxGmJj/OaNr5vAIl8Wv/
	TTvASgenC0t+70rzcyyrg4q5GyHIWWi5hv+WR/v6hnCYywj66guCRodobrv9GJk9
	1Tjln+AhLJ02squZC1fJruV3UDqCyPSdwflJIGCBwHs0C9s5U/hp/rmKGx2xyXam
	vgaSlmxrzKQITeHHEfM7azIQ5ktTIpD+SBUDTVKm+lJZK7mEWMwlD2H8aJZbilcn
	HAVVlPWUSBT67RolXC+0CEutNRLwcPlIbYBXkawBGZvxr0gEDJjUphjnj47ewA6w
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z6LGICovOHu4; Wed, 16 Oct 2024 21:13:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTNwW0htWzlgTWP;
	Wed, 16 Oct 2024 21:12:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: [PATCH 7/7] scsi: ufs: core: Make DMA mask configuration more flexible
Date: Wed, 16 Oct 2024 14:11:18 -0700
Message-ID: <20241016211154.2425403-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016211154.2425403-1-bvanassche@acm.org>
References: <20241016211154.2425403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver accordingly.
This patch prepares for adding 36-bit DMA support. No functionality has
been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c      | 4 ++--
 drivers/ufs/host/ufs-renesas.c | 9 +++++++--
 include/ufs/ufshcd.h           | 9 +++------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 75e00e5b3f79..c1d4a9c8480f 100644
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
@@ -10280,6 +10278,8 @@ EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
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
index 8711e5cbc968..8b0aebf127b6 100644
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
@@ -364,14 +365,18 @@ static int ufs_renesas_init(struct ufs_hba *hba)
 		return -ENOMEM;
 	ufshcd_set_variant(hba, priv);
=20
-	hba->quirks |=3D UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS | UFSHCD_QUIRK_HIBER=
N_FASTAUTO;
-
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
