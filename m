Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4566F5478E
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113146; cv=none; b=Y5hOZIFZ7zcpcWC0NoToLFpnD+++U2SV/FMZwH4Z/DeCisobsWR3V0LwE1g8+J/YcQ1H3nE8c4Y/qsbqEPSFXdkcUcWVcxIRN9qDBW0cXMS1Ls/jQWuRQqFGMVLqJvsFeDIqr0H0gsiB7BC39uttHEro9xAe8E/96URl41UGahI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113146; c=relaxed/simple;
	bh=Xn+tuGz2iZ3UwjQBmBHrEKPeiEv0Ywldl1LysgdhgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl/aZF3bUGLaT+HxsJ//O6XzsFCg/1mK8NtZKRHBPSyqODomWWirMqm9F0PkEVUCWvn8mEgqh0ENeoebg8LtkkBZLU2QKXHssIDF1ob9bUg2ePu2pyhcHQzef+rGGkrUEaMssQROdMOYSVmtJ2SCHhIibwg969zGjutlvUsnM8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DGT6u0WN; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DGT6u0WN"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTNvs0C1wzlgTWP;
	Wed, 16 Oct 2024 21:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729113141; x=1731705142; bh=dhpm9
	EmWWkpfxSCUFvc7iAu3vYdrTITzUUPean/3+es=; b=DGT6u0WN9QLNpwbFrJTQa
	bkqIRpL1bqFYNm2q8qASIRM+Jms4yeZ+lOvwar8sB70YjfpCZ1EuqXE0bsIFAZ38
	WVKLF8xhiwHFnlJ3bjfCOLxhsXg/XZg6Un8Ll1BpzikjeocfDySq4wKp7Xv1X+IW
	de+/cxrrA5ziy505PzQ7HomlIcH2xLRHT9/M6otWXzPgnUNKorlqwmHNVWQlTRxj
	bQjDKZGmbyuRJb536YXEcU1svgIOmHsSFs53+L3zgtXDL5rwsRqRDlSWTQ1elJDv
	WM6CTL2qTfamA+NMx7dOLfs4gOOZPZDzzn58hzFDl9QT1PaB7wjV33Ca4rJPh3MJ
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s2S-XaIcUsOo; Wed, 16 Oct 2024 21:12:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTNvk4Q8zzlgMVr;
	Wed, 16 Oct 2024 21:12:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH 2/7] scsi: ufs: core: Remove goto statements from ufshcd_try_to_abort_task()
Date: Wed, 16 Oct 2024 14:11:13 -0700
Message-ID: <20241016211154.2425403-3-bvanassche@acm.org>
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

The only statement that follows the 'out:' label in
ufshcd_try_to_abort_task() is a return-statement. Simplify this function
by changing 'goto out' statements into return statements.

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
