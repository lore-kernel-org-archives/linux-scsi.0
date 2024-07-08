Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4BD4503B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473496; cv=none; b=EIbORQO51Jc0PXoukKbUrfzen/cGf7OG9Gu2Z84UmOVSHYKrKRJe+nA8ExHrkAVWFt479n3N+xB5jYdEb9yTz3/LFuILctltoVs7k58bRHr4US73DMuQvPKIhFBmYH6uXDPEKLbb7P76YpalM3tbniwjUFvJRw0S5LD/5jjLYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473496; c=relaxed/simple;
	bh=gtmE3v4LVy2tHbV7shbnCLMD1Mhd/9BW6tDikGCf2nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tenDyE3Nml+p9g9cmzRmAeZq/sdZXe77I8rUfMdC21yliNaCgR2FCdnIqwJcLqxkbzRdr4z3Q+LICY4EcY/MdDWnzo9P9ZxEyeJLdKClHojr77zg3QxDG0yUh1DIlefacSVw+xuRfEyHbdMzoT4vBUUNPEMYgFsqOEDvAPg8jLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QfyucIGl; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QfyucIGl"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxmk68yTz6Cnk9F;
	Mon,  8 Jul 2024 21:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473489; x=1723065490; bh=SSR+E
	nRThIzEVjXzicOgiaGD8AlNTBsrjQKjmKQkk9M=; b=QfyucIGlr/MxLDVaus3L0
	yfvy8cftCwleQx5FjqW5tt5sz8hu/4TZDCgP1wO4wNQtmd3TfdEmHoKhE1snkvc8
	YGTdhIi+1HW0mDWvAoBlf/Hp/o6hWXkjT186M/9pi0rra37swxh30hbmI+VKBCRr
	sGIQLhdng9xLWFQAyHX7zTiNEywqKmSoLc/iZg3k+WVX/3IDJphIbysyGAJTRooS
	+9JMTO58cA1KFWeP4uMyVZZGJYz92+fLzwAHQ4JQ5CTOeZaIKw+iMbjF2loYWm7t
	XNAik8C32rTz7IxRedtNWrz+JqEs0znfHf7ORM+29LdQuSbamMXwqvy4sWRF0Lwh
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NzaXH_lct6nL; Mon,  8 Jul 2024 21:18:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxmZ5FvVz6Cnk9T;
	Mon,  8 Jul 2024 21:18:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 05/10] scsi: ufs: Initialize hba->reserved_slot earlier
Date: Mon,  8 Jul 2024 14:16:00 -0700
Message-ID: <20240708211716.2827751-6-bvanassche@acm.org>
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

Move the hba->reserved_slot and the host->can_queue assignments from
ufshcd_config_mcq() into ufshcd_alloc_mcq(). The advantages of this
change are as follows:
- It becomes easier to verify that these two parameters are updated
  if hba->nutrs is updated.
- It prevents unnecessary assignments to these two parameters. While
  ufshcd_config_mcq() is called during host reset, ufshcd_alloc_mcq()
  is not.

Cc: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a7b049deb943..3d452aa923dc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8679,6 +8679,9 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	if (ret)
 		goto err;
=20
+	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+
 	return 0;
 err:
 	hba->nutrs =3D old_nutrs;
@@ -8700,9 +8703,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 	ufshcd_mcq_make_queues_operational(hba);
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
=20
-	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-
 	ufshcd_mcq_enable(hba);
 	hba->mcq_enabled =3D true;
=20
