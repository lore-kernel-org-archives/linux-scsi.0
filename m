Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F6812E4A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109634; cv=none; b=FS2yZD+Ts1v2QM8bF7lvIDcO1TSZkHeFurXLHVQ/4lIiMNI51iMRakbJDtsKDtT9RoTQCv5zCYPK+1RP+t8K4BzdpaTginZIXuMTm0n0jIQWJx0isSjT58PMbz18ewjqZfRqi5xn4Ky784KPTScaJlW72etE15/iVM4AkmnL0+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109634; c=relaxed/simple;
	bh=FBnVD8X/iO345TcQMbf7TNnc+0luhatqupU9YeQbNbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRx3n3PDnJLlJr+5vcwQSwftnlmY/zmuuowo7nEyOAcDwiuCi889HI3HHckZIFYVsDp2aB9d4KTPLvWpfm36AT1VG3fh4t/ZK+kolZ1sqSXrBGbsMP2o7B9+XxhCRsQ6qa+Yuo29sSF50YYRPfKwxbfFGVl7a1fCkenM1g6qmM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=opgZlC1n; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="opgZlC1n"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMcK0cr3z6ClY9l;
	Wed, 16 Oct 2024 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109628; x=1731701629; bh=U5O40
	t7Sr2iwa3pt+jCk7rQ0o4vd7wBfyNgizOXfjOE=; b=opgZlC1nXU/gHPmOBh1np
	nFYPTxyYOfQnWB/eAPZSUw4xMiWlMGgn/Vls1HloQmrfu/jMVMRJtI8ixo8IydU9
	8336Dk2D3PGheihNVwo0j47NQXiu8NHKb+W3g+LckcSLiL0rp0HfT+i8/VA2AL2v
	YvCFGjrq8lca1jOJC/Amt7hls9HIYNwIrdWljYGPvJkrHWklrjPIFZrNMGzRAXn4
	v4O5FgoOmpPesQPPtKBV7D5U0buvlTpYAdDfdQDcenAaA2P4dZhKI5CsqD86qRBe
	K4qFHR1XaF92PPplBvig/1xMIOLQOPsa4985bNUfQTOlXwHZsiBhsxMOSDpXBfAL
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id e5gN-722lNTp; Wed, 16 Oct 2024 20:13:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMcC2D6qz6ClY9d;
	Wed, 16 Oct 2024 20:13:47 +0000 (UTC)
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
Subject: [PATCH v6 09/11] scsi: ufs: core: Remove code that is no longer needed
Date: Wed, 16 Oct 2024 13:12:05 -0700
Message-ID: <20241016201249.2256266-10-bvanassche@acm.org>
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

Previous changes guarantee that hba->scsi_host_added is true before
ufshcd_device_init() is called. Hence, remove the code from
ufshcd_device_init() that depends on hba->scsi_host_added being false.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d09aa3763f88..e3f433f221fc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8799,7 +8799,8 @@ static int ufshcd_post_device_init(struct ufs_hba *=
hba)
 static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
 {
 	int ret;
-	struct Scsi_Host *host =3D hba->host;
+
+	WARN_ON_ONCE(!hba->scsi_host_added);
=20
 	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
=20
@@ -8840,27 +8841,8 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 		ret =3D ufshcd_device_params_init(hba);
 		if (ret)
 			return ret;
-		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
-			ufshcd_mcq_enable(hba);
-			ret =3D ufshcd_alloc_mcq(hba);
-			if (!ret) {
-				ufshcd_config_mcq(hba);
-			} else {
-				/* Continue with SDB mode */
-				ufshcd_mcq_disable(hba);
-				use_mcq_mode =3D false;
-				dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
-					 ret);
-			}
-			ret =3D scsi_add_host(host, hba->dev);
-			if (ret) {
-				dev_err(hba->dev, "scsi_add_host failed\n");
-				return ret;
-			}
-			hba->scsi_host_added =3D true;
-		} else if (is_mcq_supported(hba) &&
-			   hba->quirks &
-				   UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH) {
+		if (is_mcq_supported(hba) &&
+		    hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH) {
 			ufshcd_config_mcq(hba);
 			ufshcd_mcq_enable(hba);
 		}
