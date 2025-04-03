Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9A61C7009
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715413; cv=none; b=R5QJBfUkRekp4z9MEsE61tGQ9Z0MDXKmLj+VMtwtWzRbfoe4LqycAO1DpUj6pKcZ8F9JyxbU163ODXEGaAot974WcwWCHSkq6eqvic1+ncg5Sv7qBvNNaNmXeAOxBNMcWIl67nD1IliQp59CybKiTYOu2E1quss6OEtFBOibxUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715413; c=relaxed/simple;
	bh=0uggVkirTxOeA7ASZqaFgg2LoAcykcoTXdq/NVfgxYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVJawxZHurD7AxwgptjKHTHSQFznc1OJ7H1p+3n7tHMCwYra0AZ04gzg+cC+v+zYrjXxTTYq6rLH3bXQS2RLrQbPIE+7+UBUXWnrBIGXQ6gsBTu8E34+SZt6xb8GiLHfkBptGJpY/lU8qdwH7BhfdoqSec86kJ1vbQGFDEdzA5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oqJMx3DN; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oqJMx3DN"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF8g0LB2zm0yQC;
	Thu,  3 Apr 2025 21:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715409; x=1746307410; bh=cj7Sr
	/89SQLHOAejVTUaNJSzOmLG1NG+0tX6LWsv2Pw=; b=oqJMx3DN2bp7IIadFys71
	MVYLST258XLmHK+G4BnFMKVgsSgVg9W/2fxrGnqBtvr8mRt5w6CMYpok/zrPbqic
	Gra1L1+hWJ/sJMGBr96NPv0FcMGfLQH3EPvqVaA4BPKsL0dUnXv+Uih0BddlxLN9
	YwPPUigCayaChm8b4HSMMxbJk/gmC1uFZWKkxTHJUQIOEgeVdvnyEeCRjisNsD5h
	RXRffhPPFROWu1IxL8bWbhw9PNaNCRfxaQGb1bvvvJrUI0e+YGbi5d+IDhvd+A9u
	nD9GLYcICYAOyw8yOSw2G7tzFGllcwfLnqurQsChyiTMXRHh88m6jZpD6EPjG4qN
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FuN-CT2aM2u0; Thu,  3 Apr 2025 21:23:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF8W6p1Gzm0yTx;
	Thu,  3 Apr 2025 21:23:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 21/24] scsi: ufs: core: Allocate the reserved slot as a reserved request
Date: Thu,  3 Apr 2025 14:18:05 -0700
Message-ID: <20250403211937.2225615-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Instead of letting the SCSI core allocate hba->nutrs - 1 commands, let
the SCSI core allocate hba->nutrs commands, set the number of reserved
tags to 1 and use the reserved tag for device management commands. This
patch changes the 'reserved slot' from hba->nutrs - 1 into 0 because
the block layer reserves the smallest tags for reserved commands.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index df90163939d0..0adc0f879196 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2417,7 +2417,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
s_hba *hba)
 	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) +=
 1;
 	hba->nutmrs =3D
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
-	hba->reserved_slot =3D hba->nutrs - 1;
+	hba->reserved_slot =3D 0;
=20
 	hba->nortt =3D FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities=
) + 1;
=20
@@ -8762,7 +8762,8 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba, u3=
2 ufs_dev_qd)
 		goto err;
=20
 	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	hba->host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
+	hba->reserved_slot =3D 0;
=20
 	return 0;
 err:
@@ -10593,6 +10594,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
=20
 	host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
 	host->cmd_per_lun =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
 	host->max_id =3D UFSHCD_MAX_ID;
 	host->max_lun =3D UFS_MAX_LUNS;
 	host->max_channel =3D UFSHCD_MAX_CHANNEL;
