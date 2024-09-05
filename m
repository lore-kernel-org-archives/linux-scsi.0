Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770F71AD5D7
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573779; cv=none; b=HT3+mtP7PEZ0YuIEWDEQI9Mn7zUTYvmg+h3NNHJE+yaGn8a0dQqAnWzR7SYVx8DsdCBJnN/w4zRNnt2g5kLb+6sC/bKE+CjBbC8gCBGTkMyiPhZpYTFkdjblgw1zrDHzh/QCmBF0bBa+E/wbz+iAx5iZqyZPpLv25BvcRzbF8Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573779; c=relaxed/simple;
	bh=qQHyoO3C/r0mgT6UM+SLGNsnVfkQUuYr1haCYK6U9Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3vlKsqnQifQ1IsaLBLSROoJI6oR0hgstbzLa8w84Sa3b0FzRdVg9z7Zr8Yi6QIr3Q68r2ZIv2j/o5NUBa2qN/MOMCOPDBJGDUeWpiajkuUxnOYX5/4yr0jThJ3UJoj5Y6ZVz6L4+m81gn7GWiXNOXLPo+UgGiPv55+ez34f254=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HqC2VRE2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HqC2VRE2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0Cz61p8Cz6ClY8w;
	Thu,  5 Sep 2024 22:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725573774; x=1728165775; bh=Z5a4F
	BJpLeDU6zq+CE8fg8nfPMaXdkJ+OqvorL4hgDg=; b=HqC2VRE2zoJP81KfH+ECj
	CfP5zfwz78u/njpDbpgakFBagA+8WjOlVMcF2l0Z7F1a9/HufbYg/BGjHlusiwcO
	F9fvzMj0+MDALjqTsvIiTQ6ip+14i0AuOUIcnvwBsP2CYf/a5RyQ6o33NMNv36Zj
	Gym878luJW68qa6IvBGCgyir8gkOpA/xaYxv5Ubi6CKNF3hnGiT2IppaBGrxm790
	BRV63neTgMSAlCM8Z0bu+QeVsvJzQZpBDh+GDbnpeZKPEl0oD9ptZ5f87efKcWs3
	0qKy3g5yCz/f1aEswZ548SnVu/ezcbZ7RMpVhUSfptfMXkr1oMrT/ZKXSlJhSY2c
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oA5n-pWv5PrZ; Thu,  5 Sep 2024 22:02:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0Cz11NWBz6ClY8x;
	Thu,  5 Sep 2024 22:02:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 07/10] scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
Date: Thu,  5 Sep 2024 15:01:33 -0700
Message-ID: <20240905220214.738506-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905220214.738506-1-bvanassche@acm.org>
References: <20240905220214.738506-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Expand the ufshcd_device_init(hba, true) call and remove all code that
depends on init_dev_params =3D=3D false. This change prepares for combini=
ng
the two scsi_add_host() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 843566720afa..014bc74390af 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10602,7 +10602,48 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
-	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	err =3D ufshcd_activate_link(hba);
+	if (err)
+		goto out_disable;
+
+	/* Verify device initialization by sending NOP OUT UPIU. */
+	err =3D ufshcd_verify_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/* Initiate UFS initialization and waiting for completion. */
+	err =3D ufshcd_complete_dev_init(hba);
+	if (err)
+		goto out_disable;
+
+	/*
+	 * Initialize UFS device parameters used by driver, these
+	 * parameters are associated with UFS descriptors.
+	 */
+	err =3D ufshcd_device_params_init(hba);
+	if (err)
+		goto out_disable;
+	if (is_mcq_supported(hba)) {
+		ufshcd_mcq_enable(hba);
+		err =3D ufshcd_alloc_mcq(hba);
+		if (!err) {
+			ufshcd_config_mcq(hba);
+		} else {
+			/* Continue with SDB mode */
+			ufshcd_mcq_disable(hba);
+			use_mcq_mode =3D false;
+			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
+				err);
+		}
+		err =3D scsi_add_host(host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			goto out_disable;
+		}
+		hba->scsi_host_added =3D true;
+	}
+
+	err =3D ufshcd_post_device_init(hba);
 	if (err)
 		goto out_disable;
=20
