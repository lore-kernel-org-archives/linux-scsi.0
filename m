Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EDE4503B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473525; cv=none; b=mGSL3JVQp8vP0X1YIyhfdNL0obf/IBM6slDiDIOj1uwdKCr5S+5sYpE7RFKZgHCL5qHq1fyhx7qHrZ9l+ixugoWRaa7m/j3GQF9Uo8YQv93XVCJnhTbDX+gUus8CtkRghPc0pboewZlNyYbTPnxqNNOI2ePO5iVT4LMIM1L9Cbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473525; c=relaxed/simple;
	bh=OF0AYM3jXojWz985L+ExGFni52V4rVaRVWAUJCFKAio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYFIZ0PCCEUaBpiWsCdOZfo+YIG53RJNnT3JiyGScCvH9n5k8Sr3dEo+SZu6k8a7cyVf8F91qyNxf6kvq+uu/sapdC6n2KuAW89RBJvQngfe/eZi79f8QPzrEZv1ghWH7RelVhBDXPs/4k6l6pNH7QCWWzbga3svS800wYUrJgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i6beVi0s; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i6beVi0s"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxnH5tqVz6Cnk9V;
	Mon,  8 Jul 2024 21:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473518; x=1723065519; bh=OREPE
	0UDeIjHWoZ7VAogE56R5+JeeizDDmjIl8AEMWI=; b=i6beVi0s7ZKzyE6h+FI+t
	lNmSb4OStnnZyjRcLbLgmttK0cbFXSsuYZhlMWsmwvPLxSGktZTX2HoAY5IQ1IVb
	Gtpa28TOCxrBBu/tS/Zju0QHn1GWrHYu+FRAo1v/b/j8n0dR7Nma0xQBovlN2toF
	lLZk+HB9lfeevt59fVvPuC6mHq3ZupVneZ1iJyQpdDFjgU9AEABitPtnVC//8w6N
	TM7zuYlFBPDpoW8C6RN6pImTVPH7GPKnZm7OFM9lrZr2n4MsR5smOb6qlFT6Vyf3
	mbDXAGb30fLF22X+iNKUFsnKNMoLM/q4XRVuUwu39VTeuAyd0neLZlG2KeZbyB1I
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i-4EqqT7W4E9; Mon,  8 Jul 2024 21:18:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxn773Q1z6CmR43;
	Mon,  8 Jul 2024 21:18:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 08/10] scsi: ufs: Move the ufshcd_mcq_enable() call
Date: Mon,  8 Jul 2024 14:16:03 -0700
Message-ID: <20240708211716.2827751-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the ufshcd_mcq_enable() call from inside ufshcd_config_mcq() to the
callers of this function. No functionality is changed by this patch. This
patch makes a later patch easier to read ("scsi: ufs: Make .get_hba_mac()
optional").

Cc: Peter Wang <peter.wang@mediatek.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7647d8969001..4c2b60dec43f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8703,8 +8703,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 	ufshcd_mcq_make_queues_operational(hba);
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
=20
-	ufshcd_mcq_enable(hba);
-
 	dev_info(hba->dev, "MCQ configured, nr_queues=3D%d, io_queues=3D%d, rea=
d_queue=3D%d, poll_queues=3D%d, queue_depth=3D%d\n",
 		 hba->nr_hw_queues, hba->nr_queues[HCTX_TYPE_DEFAULT],
 		 hba->nr_queues[HCTX_TYPE_READ], hba->nr_queues[HCTX_TYPE_POLL],
@@ -8732,8 +8730,10 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 	ufshcd_set_link_active(hba);
=20
 	/* Reconfigure MCQ upon reset */
-	if (hba->mcq_enabled && !init_dev_params)
+	if (hba->mcq_enabled && !init_dev_params) {
 		ufshcd_config_mcq(hba);
+		ufshcd_mcq_enable(hba);
+	}
=20
 	/* Verify device initialization by sending NOP OUT UPIU */
 	ret =3D ufshcd_verify_dev_init(hba);
@@ -8757,6 +8757,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 			ret =3D ufshcd_alloc_mcq(hba);
 			if (!ret) {
 				ufshcd_config_mcq(hba);
+				ufshcd_mcq_enable(hba);
 			} else {
 				/* Continue with SDB mode */
 				use_mcq_mode =3D false;
@@ -8772,6 +8773,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 		} else if (is_mcq_supported(hba)) {
 			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
 			ufshcd_config_mcq(hba);
+			ufshcd_mcq_enable(hba);
 		}
 	}
=20
