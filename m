Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F0A1CB323
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 19:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729625540; cv=none; b=k1whSL+BfaD7TqGxZc1J9er1VNj4ox9G297c3TWFd0fF+z4U6aEVhUtXPGx00az0z9JsBnyMtTAPbO2sb3usmqJ2Wejx5zJBCcqI8cAPJFRvqgBBDdId2MWKsy3svtq0D7mhGqhUzuohj/N+B2DYnFt+21UPaxRIf//Pd+DfCPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729625540; c=relaxed/simple;
	bh=ZPbIqWWWXTkkQYELtxX/pBMFHBJh7yqutjaecej7C6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2tjIrhBIzZ+hrqgdP+g7OBXm0BdfmM87vcwSjJVYP7csBSuB6qusEwat4Z60YUovNKKoHvP3p9tgNM7kuEJP9GpqvCdYsdQQLwbRabU8H7Ht6qPVi0D6pu+ZNhhPON3NF1Jx5SfZ7nbG82lj5dGDEndb2E7CD4FzovK/YCrHV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sszOBfix; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sszOBfix"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY2PZ0T6rzlgMVW;
	Tue, 22 Oct 2024 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729625532; x=1732217533; bh=u7OHb
	TnvNdlnErpRP4CybM/6blOEBfx1D1KPOncBioA=; b=sszOBfixZ+XaeNxkbMxdF
	HITHeLeHDfWDpOo15CBRv4kHyjkT+gx1Tnz0yM4a1MqXi0pUBChum8wOh+EJtahN
	84sLCrwlz7GfRjFJQPCTNtHIS8VpXO7osztjiBrWZAnq2jPrVyQ7WdqHdoFLcODr
	jMl8JNAvRZ2E+Qrb4+WPNWcKJHtzPCRICEswiQvHerfuHT/AFaEXcfP/+WnyNbzD
	mVnXNol8xKj6H8wgkrmSdGNfsoCKbzoTkquXdEXp1jPYqtxb+g/5Wz/4VSMgIc9e
	E6Apx/Cwgk/ZEya6wDNRhfYkeeCtO92rFTerxwh5XxLPfjKJ15e2h1hEVgan6ueB
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zqS_Yy08N-Vs; Tue, 22 Oct 2024 19:32:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY2PL4QF7zlgTWQ;
	Tue, 22 Oct 2024 19:32:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v2 2/6] scsi: ufs: core: Remove goto statements from ufshcd_try_to_abort_task()
Date: Tue, 22 Oct 2024 12:30:58 -0700
Message-ID: <20241022193130.2733293-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022193130.2733293-1-bvanassche@acm.org>
References: <20241022193130.2733293-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The only statement that follows the 'out:' label in
ufshcd_try_to_abort_task() is a return-statement. Simplify this function
by changing 'goto out' statements into return statements.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..57ce1910fda0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7486,7 +7486,7 @@ static void ufshcd_set_req_abort_skip(struct ufs_hb=
a *hba, unsigned long bitmap)
 int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 {
 	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
-	int err =3D 0;
+	int err;
 	int poll_cnt;
 	u8 resp =3D 0xF;
 	u32 reg;
@@ -7516,7 +7516,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 				/* command completed already */
 				dev_err(hba->dev, "%s: cmd at tag=3D%d is cleared.\n",
 					__func__, tag);
-				goto out;
+				return 0;
 			}
=20
 			/* Single Doorbell Mode */
@@ -7529,21 +7529,17 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba,=
 int tag)
 			/* command completed already */
 			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n"=
,
 				__func__, tag);
-			goto out;
+			return 0;
 		} else {
 			dev_err(hba->dev,
 				"%s: no response from device. tag =3D %d, err %d\n",
 				__func__, tag, err);
-			if (!err)
-				err =3D resp; /* service response error */
-			goto out;
+			return err ? : resp;
 		}
 	}
=20
-	if (!poll_cnt) {
-		err =3D -EBUSY;
-		goto out;
-	}
+	if (!poll_cnt)
+		return -EBUSY;
=20
 	err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
 			UFS_ABORT_TASK, &resp);
@@ -7553,7 +7549,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 			dev_err(hba->dev, "%s: issued. tag =3D %d, err %d\n",
 				__func__, tag, err);
 		}
-		goto out;
+		return err;
 	}
=20
 	err =3D ufshcd_clear_cmd(hba, tag);
@@ -7561,7 +7557,6 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
 			__func__, tag, err);
=20
-out:
 	return err;
 }
=20
