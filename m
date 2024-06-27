Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E46D60EC4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518454; cv=none; b=EX4U2193VUSaA4yU1r+HBNTNeTq9PRLKJBTJnQteRFDwIY673Z0yf0Lw94In6SdQasv7YsDnXy380/cCt8qyNV4Q1UhGZEN5T5I1G1xZp7pSVNGE9IFlFBpYFRyktjoKQObOosgm5VreV7SpyqV5bEj6Or1nncnFw0x6mxmaiLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518454; c=relaxed/simple;
	bh=Vy7TJC31+qAvPmUc0HXFjDv3q9dqkheHZXkN+LoWMnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXws/WNlkDG2XKWj5UK5zZUqzdNhfi32DMQQbTeDU0Pav3dnyWZ3jpVXnmKozYhQwGybZfSW9dpDBN4Olr0cF3n/bHj6CofQLqWwvl/Lym2goC4gw4+lzaxiefhCHlccRDnN94y7Z+MyhSjtE6vXjjYBpkJCmJ6Tlvz9YJbMVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bVx2Bwe8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bVx2Bwe8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W98ZX5kfDzll9by;
	Thu, 27 Jun 2024 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719518449; x=1722110450; bh=OEU2i
	A1vTWVGJCG8cceZo/ban5Jrc6fevDW7B5J5uh4=; b=bVx2Bwe85n57ikGgEc+WV
	RoIy1spuIuHvPEIPHM1Jqv8yDiqLDsLPVNoC7hhqBeFrZ1WXjV2aOxegOu5I6/WH
	tQvgu+4urYMTRqXVPjQS97nYCnXgw4AlUBVaGngJ8c7rL2Ybduzs3tWfFcGxRd74
	+/vJXbl0B43CIqPiUDMWfHsZUR9FBm8+/VvyM+iH+VLbOkPjXHEFfZKzG5NmH0hT
	84OXKsVSxwI+zeEEbn0VQ03ckUIKRq2z5FJyLBK0hU5djO1JVA2p2RhZQIFMqDxi
	2MMuRINEyyABXSU2Z8wgPSDFbWLTRTVHcg2l1Ut+iuO8+M6mnRB+ZlbZRICUl6+p
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6HV3x3S-Dwkb; Thu, 27 Jun 2024 20:00:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W98ZR4GC5zll9bp;
	Thu, 27 Jun 2024 20:00:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 5/7] scsi: ufs: Initialize hba->reserved_slot earlier
Date: Thu, 27 Jun 2024 12:58:31 -0700
Message-ID: <20240627195918.2709502-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240627195918.2709502-1-bvanassche@acm.org>
References: <20240627195918.2709502-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2cbd0f91953b..178b0abaeb30 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8678,6 +8678,9 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	if (ret)
 		goto err;
=20
+	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+
 	return 0;
 err:
 	hba->nutrs =3D old_nutrs;
@@ -8699,9 +8702,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 	ufshcd_mcq_make_queues_operational(hba);
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
=20
-	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-
 	ufshcd_mcq_enable(hba);
 	hba->mcq_enabled =3D true;
=20
