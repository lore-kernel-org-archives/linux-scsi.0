Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A263F1ACE
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791297857; cv=none; b=cM3M+wpeLixKKUlJ2259vTd3kup2Oc3hYPoXUWFC/mPPVU099eqIPKg9QkBefHr9vz6z6OMBErH46uZzvJQFcAQapMYpD9dMO3bMXQGUj1qdMoT/zZ0hU+GrU1cDLgresm530nWY6ZG9R7JOQGCEs/rqtGkvUxmesHdkIJsdcw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791297857; c=relaxed/simple;
	bh=eSFdXc07YalpKFd82fSJBxmFyhmc9R45sAeTNr4yvs4=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=urNVGFWmdzpC52z7sa3iwpXIiVgz6h2di/an8ksY/8ycHGYlG4nTMjjEKAkclfqMpseNwDbDei+y5/tn40XNDQkJGYhrkUeLNfUtpg153Lij+5saRJg5ZcR6AYTRzXPKrw6jHPkfOMjY+uTcsN96t5rLFyQmwj4aEj/fFRtT640=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=o1FP8MTU; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="o1FP8MTU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1791297853; x=1791557053;
	bh=eSFdXc07YalpKFd82fSJBxmFyhmc9R45sAeTNr4yvs4=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=o1FP8MTUJhV0BvBdwixEMNFVYTzmI71gcypWNHvE0uQQAVCbJFkGzh8TsOt7Ez3h7
	 3pi9H7g6rLy3IL0VahutVWCEyLZ0MifiQ3jF9bO0xYS4lCvBn6UwJY1BfV3+Pfl56s
	 btoUKayTBOPEcKezCMfm8PHray7EJCTgg5Y2aWm7uoWic9ndigN3zdoUVMy85dL28w
	 d6RyK8WP0+ANPL672NuS5F6shYvDP2sYC+2OYLgAQ6NRg25P1FDin6Wq0g8VWLS1bC
	 SW6yI4IosHde7ao1P+L7addw5b74TyNKuGp1uPeqor+lA+aEhO49/lEaj8BJJ5aFac
	 0nZM/7wQgcxNA==
Date: Tue, 06 Oct 2026 14:44:07 +0000
To: Manivannan Sadhasivam <mani@kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, Nitin Rawat <nitin.rawat@oss.qualcomm.com>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: Manish Pandey <manish.pandey@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH RFC] scsi: ufs: ufs-qcom: Fix ICC bandwidth votes for DDR path
Message-ID: <20261006-ufs-icc-bw-v1-1-9fbc6fcc6514@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: 3bc06ccafd31d1b0d67a178de3c4d3318d74d6e8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Manish Pandey <manish.pandey@oss.qualcomm.com>

The DDR ICC vote was using icc_set_bw(0, mem_bw), which sets only the
peak bandwidth. On Qualcomm NoC, peak votes alone do not guarantee the
required aggregate bandwidth. As a result, when other clients (such as
USB) are removed, the total NoC bandwidth drops and UFS performance
KPIs degrade.

Use mem_bw as the average bandwidth and 0 as the peak value so the DDR
path gets an effective and sustained bandwidth vote.

Signed-off-by: Manish Pandey <manish.pandey@oss.qualcomm.com>
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
On a downstream 6.6 kernel on Palima, one UFS part (Samsung KLUFG8RHGB-B0E1=
)
fails hibern8 exit with auto hibernate enabled unless this change is applie=
d,
the other Sandisk UFS part is fine without it. The downstream 5.10 kernel
for the same board voted this path as average bandwidth through DT and did
not have the problem.

I could not reproduce the performance regression from the commit desc on
mainline though on the Nothing Phone (3a) (Milos, SK hynix H9QT1GGCN6X147),
tested without this change applied, dropped USB vote and compared UFS perf,
could just be something wrong with my test though.

Wanted some opinions if this change was correct for mainline regardless.
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 7e6cb6dc42d1..4b23037d571b 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -950,7 +950,7 @@ static int ufs_qcom_icc_set_bw(struct ufs_qcom_host *ho=
st, u32 mem_bw, u32 cfg_b
 =09struct device *dev =3D host->hba->dev;
 =09int ret;
=20
-=09ret =3D icc_set_bw(host->icc_ddr, 0, mem_bw);
+=09ret =3D icc_set_bw(host->icc_ddr, mem_bw, 0);
 =09if (ret < 0) {
 =09=09dev_err(dev, "failed to set bandwidth request: %d\n", ret);
 =09=09return ret;

---
base-commit: bf1ee2bd5c2da8992f33c8950ef194aaff74ed6c
change-id: 20261006-ufs-icc-bw-e2a8bf90118e

Best regards,
-- =20
Alexander Koskovich <akoskovich@pm.me>


