Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2BE1D172E
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362625; cv=none; b=RCgD1T3k4msG9ZOG0icIiosqu6KnVNsnh9p25W+tTZ8L/BEClFFFl/fKhfOPvhBS3TXM7lboi4S/IdiJqR5tsi/Sq6t2fosTojK60rweeuBsUSgbXZ1oRNbwpOHqHZ++ZDEPWccgm68XRXds/5BzWWy5TKyRRZUAEvjv5TpcKuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362625; c=relaxed/simple;
	bh=YkhHAXhAWiKkZqXv6oyYvxDbrZcnvuqKCNANecfuSME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3951JomI7+9YOAjfd7D4nE7CbHM7d4SXAYYahsbeTbcNHoq2mhgM2DJqY7VdqxIh3tsgWv+Ir1EoxdHSOmzMtXEXsyjRLh584+sLn/Y242Mh85kZ7J7P3zNfb8PVk9VnAhcHbEzOYldoHb9rfqq10HCyD2oRgxYUaejqoW32zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u17Vi148; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u17Vi148"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc3g1jb3zlgVnK;
	Thu, 22 Aug 2024 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362619; x=1726954620; bh=nZjx0
	idykRFXTxU5sySZM8noGg3gIw8VanZLBw0eZio=; b=u17Vi148vxkdVe2U/U4n3
	K/3aOqiupiSczhsX3XNs0FKYumWv4ybv31RB4sOMpYcO51Lp7tX2X0L2RX7nMZez
	ebjXSqZPEUvuRFLFJr1yCjVPB4aM1zZI66lW27yA1I4wZQ+BwNRXfyoKXR8vcDzS
	1pXdqYqSOetZVZg7IS5ZN3FaG5XWKeA7LrT8iH427zK+2gE40QzRgCRdftHcTaDu
	17R7b+UA/UtuYCoZXi94DWe7HES6mopGwss0B8kSOrcZY5VP3H4GqMaag54CoBT2
	7pGgxtoxDeqXGS0wBFdsziC3N/4k4wd2a/kmR6MKskZXloaP2F16vqbZLAc6TS93
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vXgWQLRjqARk; Thu, 22 Aug 2024 21:36:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc3b1Fx9zlgVnf;
	Thu, 22 Aug 2024 21:36:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v2 2/9] ufs: core: Introduce ufshcd_activate_link()
Date: Thu, 22 Aug 2024 14:36:03 -0700
Message-ID: <20240822213645.1125016-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822213645.1125016-1-bvanassche@acm.org>
References: <20240822213645.1125016-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for introducing a second caller by moving the code for
activating the link between UFS controller and device into a new
function. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d29e469c3873..04d94bf5cc2d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8733,10 +8733,9 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 		 hba->nutrs);
 }
=20
-static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
+static int ufshcd_activate_link(struct ufs_hba *hba)
 {
 	int ret;
-	struct Scsi_Host *host =3D hba->host;
=20
 	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
=20
@@ -8753,6 +8752,18 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
=20
+	return 0;
+}
+
+static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
+{
+	struct Scsi_Host *host =3D hba->host;
+	int ret;
+
+	ret =3D ufshcd_activate_link(hba);
+	if (ret)
+		return ret;
+
 	/* Reconfigure MCQ upon reset */
 	if (hba->mcq_enabled && !init_dev_params) {
 		ufshcd_config_mcq(hba);
