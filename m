Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90779201242
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952909; cv=none; b=i5buE7ZJtrtbiBurRg3aziBlFYb5lPn4y3qzb3QnzrJuf4WSMZN9Tlp7enMAz3ThrK0jHeu/Pj92HD4FWOpJStxNma2IZmtwOd3uno+zwgaWJjEq3alAyXT9MIUsqJAi+3Mc0LHN4STiGqwookX2kKlrBfATbV54GyYufdDh1NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952909; c=relaxed/simple;
	bh=bzb6RmtmFRoGr4+TzuAjhKVqbDm5RYu94wfzFJmU7kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boQ0rJsVSaEsvjQZqiENbYT5jSbC68zZy8iWudUnlVmJOTR9jQZq0D3zSxxmUfHgm0bySm4YdruB/PKJgwCnrixFeRld+pifQ/HC51jKAs5kBtsKyVYSOSp8Sk9Wmlv7qiwEpyx6OM/5QnB/lcSS1lAbGJ1yd2wB/4F2z0LBk3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wrFJ+xBO; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wrFJ+xBO"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFFS2GHLz6Cnk98;
	Tue,  2 Jul 2024 20:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719952904; x=1722544905; bh=tkMeu
	8xUg2xvCJQPEOfjRjwoos0kehvNBPpNfTzX74w=; b=wrFJ+xBOWiIqkXdoeSbYa
	cs9Ou/52jEMIU32zdAR3sFuCsp6pxvI2LDKuIcQgCX6QKk6lIesZwYkJ2hzEZwal
	JZGxp0fprGiCn6Jv8CL6OJQSO+gaRHThHB2EyJg48lzUnV41vZ35WG2LdtVrqo5r
	s2h45BRHyuXGjuHgMUmr7AxVv/dItWk8+mkzPPSnL665P/9PMRgLZybrq9GenPqM
	Pyau7VHH8qtpUNejKW56LIpoYebQd9uT7O89C3Da/OdRmpWN/RZHhqj9zOWIP5GD
	xsc1ztX9N73yDNYMHuuwVOCjrqZTMFbCyiNyztxsIw1yNHp6YjcTFlAC6AKoMzUD
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wLbtFZ6USVaU; Tue,  2 Jul 2024 20:41:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFFM1Rc1z6Cnk90;
	Tue,  2 Jul 2024 20:41:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 7/9] scsi: ufs: Move the ufshcd_mcq_enable() call
Date: Tue,  2 Jul 2024 13:39:15 -0700
Message-ID: <20240702204020.2489324-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702204020.2489324-1-bvanassche@acm.org>
References: <20240702204020.2489324-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the ufshcd_mcq_enable() call and also the hba->mcq_enabled =3D true
assignment from inside ufshcd_config_mcq() to the callers of this functio=
n.
No functionality is changed by this patch.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4c138f42a802..b3444f9ce130 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8702,9 +8702,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 	ufshcd_mcq_make_queues_operational(hba);
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
=20
-	ufshcd_mcq_enable(hba);
-	hba->mcq_enabled =3D true;
-
 	dev_info(hba->dev, "MCQ configured, nr_queues=3D%d, io_queues=3D%d, rea=
d_queue=3D%d, poll_queues=3D%d, queue_depth=3D%d\n",
 		 hba->nr_hw_queues, hba->nr_queues[HCTX_TYPE_DEFAULT],
 		 hba->nr_queues[HCTX_TYPE_READ], hba->nr_queues[HCTX_TYPE_POLL],
@@ -8732,8 +8729,10 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
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
@@ -8757,6 +8756,8 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 			ret =3D ufshcd_alloc_mcq(hba);
 			if (!ret) {
 				ufshcd_config_mcq(hba);
+				ufshcd_mcq_enable(hba);
+				hba->mcq_enabled =3D true;
 			} else {
 				/* Continue with SDB mode */
 				use_mcq_mode =3D false;
@@ -8772,6 +8773,8 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 		} else if (is_mcq_supported(hba)) {
 			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
 			ufshcd_config_mcq(hba);
+			ufshcd_mcq_enable(hba);
+			hba->mcq_enabled =3D true;
 		}
 	}
=20
