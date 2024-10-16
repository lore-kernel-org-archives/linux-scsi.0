Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCA5216A16
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109640; cv=none; b=BKX6zzBWnZhbp9zVDpRDE7dSYiPhU2Lw2Z/HjTyixSJODEiCx+OqnHZv3d0KI25GjxpX+9LjxSo7U0enGQAFgVrHuz0W96z8hTVLzZHMpZiyR7PAm/DjKePH30XzgjNhx4eeNMg4PDTnEcOP2Iu3PDgMqd1NTF9JMjIPvcc7m+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109640; c=relaxed/simple;
	bh=GnHtxMXpO5LNE9COz51W51s0CivO9ro1jXLWLdslKLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEmN5e3UujwGRzOGcD8A3T3iXoVWjpLjgfJDIXutpf8dLomIr9yySu60DfAymXla+NE0cQttfH6QtnShAlSCEJTkFNJMjqtG9PdD6ysa/VPDsFzxWCSUCgov6LbcMsP+jfB/RcakcF2B//dWAsRhvmZCMDg1dFS0p5e/3uEZr2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iFJ/XUZV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iFJ/XUZV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMcQ3JTbz6ClY9l;
	Wed, 16 Oct 2024 20:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109633; x=1731701634; bh=rWt6p
	6AOTQVgGEYA0Ic2e9BVjQxleGStm+oOW+nXOM8=; b=iFJ/XUZVPA3+VusscNK94
	7QI2KpU3ZQkjptsSMtS+Cmn9jcw3PmxucaLa4FtBN3oyH17lwEBCtWyNU1pQHsUn
	T2CaDtZoDx7Z9uBvw+J0GcpH3L7Ws969sFsLX+31eh5awIMniG62f4ir1Gubjq4K
	2iAHzp9DLJeB48xt9H6exuLqOSjQPV5I8iqcMKuAYoV8ByZGnE4ALlWsO3ms4gIk
	/cEMe3dDHWrX9Sz6bLFzp8NWn+SE7x+QrvtLi3Qg/cxdxFUfJ9tMe1ddmkQAZaRY
	YhhQPrMzxNceRU1RymrXYBH+R84Z89JEmIEYa01IRpbW/CJXfXODna7SgpavvAuw
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QW8aZx47m7lC; Wed, 16 Oct 2024 20:13:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMcJ3dskz6Cnk9T;
	Wed, 16 Oct 2024 20:13:52 +0000 (UTC)
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
Subject: [PATCH v6 10/11] scsi: ufs: core: Move the MCQ scsi_add_host() call
Date: Wed, 16 Oct 2024 13:12:06 -0700
Message-ID: <20241016201249.2256266-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016201249.2256266-1-bvanassche@acm.org>
References: <20241016201249.2256266-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Whether or not MCQ is used, call scsi_add_host from ufshcd_add_scsi_host(=
).
For MCQ this patch swaps the order of the scsi_add_host() and UFS device
initialization. This patch prepares for combining the two scsi_add_host()
calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 41 ++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e3f433f221fc..f34563e3a51d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10388,8 +10388,25 @@ static int ufshcd_add_scsi_host(struct ufs_hba *=
hba)
 {
 	int err;
=20
-	if (!hba->scsi_host_added) {
-		WARN_ON_ONCE(is_mcq_supported(hba));
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
+		err =3D scsi_add_host(hba->host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			return err;
+		}
+		hba->scsi_host_added =3D true;
+	} else {
 		if (!hba->lsdb_sup) {
 			dev_err(hba->dev,
 				"%s: failed to initialize (legacy doorbell mode not supported)\n",
@@ -10650,26 +10667,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
-	if (is_mcq_supported(hba)) {
-		ufshcd_mcq_enable(hba);
-		err =3D ufshcd_alloc_mcq(hba);
-		if (!err) {
-			ufshcd_config_mcq(hba);
-		} else {
-			/* Continue with SDB mode */
-			ufshcd_mcq_disable(hba);
-			use_mcq_mode =3D false;
-			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
-				err);
-		}
-		err =3D scsi_add_host(host, hba->dev);
-		if (err) {
-			dev_err(hba->dev, "scsi_add_host failed\n");
-			goto out_disable;
-		}
-		hba->scsi_host_added =3D true;
-	}
-
 	err =3D ufshcd_post_device_init(hba);
=20
 initialized:
