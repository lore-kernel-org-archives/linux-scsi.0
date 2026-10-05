Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E7230B517;
	Mon,  5 Oct 2026 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791219742; cv=none; b=E7fOHVlXiSs+ye57WeNS2isXQbcLnQPIapMrD+stgX2+ATR+qyPC8EdzU7fwH1YOcaS5Q62EraroNOulRNTyZzcERM8jRcLZ62gZMH1TYmf92iDrvG+aqA8duHP9CW4GxKhYUdOybXP1VyPCARiX3Q/NetsxtL40HoQa1XJsz1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791219742; c=relaxed/simple;
	bh=t/yEb69NqJwxXnY2yzDPMyvnZIr+lmNinV/kM6eADoc=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=jSxJNvKpImW+toR7N0bRNN0uymfF0wfXQw4odlBLiHzBt6TiljhqEi9mC7CwGHxYrmqhLXkWWL4/K3MYaAdHEnx9w3JgUugHL0fDf4mgHXURO125XYT6Jzc1xyj4HmmAZUA6ADOaFYJVWm+ZrO1z9uK97COZZvcQQrWZas/1HR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=iHpcz3Jd; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="iHpcz3Jd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1791219731; x=1791478931;
	bh=t/yEb69NqJwxXnY2yzDPMyvnZIr+lmNinV/kM6eADoc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=iHpcz3Jd7cuaTlXtlgEFIdxXp75oLf09jOLK+Z5B9oJEcnkip6yFmjCqzU3spAh+s
	 isNGiJKpK7FMEkqV9L6lxvJyEarjcB3Qwpx9TDU/L6gSO4yWwSn5TdJD43LNL24Xhj
	 ELFRiT+i7Oh/AYhwMUwd/79XPqXIhZkxI/geG7Oz3+FX5xnotAMqtfuyIgnnyMlE9q
	 COPg5vlL43jE6hmU0FBIgx3J5Sr6iWLXszcgdxv7yGxWtoWgDFTJ+c1B8ezvvMFjVN
	 MKqzs5C6wuWPsu2JNkxYrPkdcpvVNkgJ6gxeB6CAOH5hxSPn2paNbu1dU3yNB2XQGn
	 55smCSXyd70lg==
Date: Mon, 05 Oct 2026 17:02:06 +0000
To: Manivannan Sadhasivam <mani@kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, Abel Vesa <abel.vesa@oss.qualcomm.com>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Luca Weiss <luca.weiss@fairphone.com>, Bjorn Andersson <andersson@kernel.org>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH] scsi: ufs: qcom: Power down UFS during system suspend on Milos
Message-ID: <20261005-milos-ufs-suspend-v1-1-a6f8b89d5b63@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: ce9a58eb4e9744b4aff0606b7f060f3d44db0ca5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Milos the UFS PHY GDSC is turned off on every system suspend and the
PHY loses its register state, so exiting hibern8 on resume fails:

ufshcd-qcom 1d84000.ufshc: pwr ctrl cmd 0x18 with (MIBattribute 0x0, mode 0=
x0) failed, host upmcrs:0x5
ufshcd-qcom 1d84000.ufshc: ufshcd_uic_hibern8_exit: hibern8 exit failed. re=
t =3D 5
ufshcd-qcom 1d84000.ufshc: __ufshcd_wl_resume: hibern8 exit failed 5

Set no_phy_retention so the controller and device are powered down
during system suspend and the link is brought up again on resume.

Fixes: 04bb37433330 ("arm64: dts: qcom: milos: Add UFS nodes")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
 drivers/ufs/host/ufs-qcom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 7e6cb6dc42d1..e979850c05cb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -3033,6 +3033,10 @@ static void ufs_qcom_remove(struct platform_device *=
pdev)
 =09=09platform_device_msi_free_irqs_all(hba->dev);
 }
=20
+static const struct ufs_qcom_drvdata ufs_qcom_milos_drvdata =3D {
+=09.no_phy_retention =3D true,
+};
+
 static const struct ufs_qcom_drvdata ufs_qcom_sm8550_drvdata =3D {
 =09.quirks =3D UFSHCD_QUIRK_BROKEN_LSDBS_CAP,
 =09.no_phy_retention =3D true,
@@ -3044,6 +3048,7 @@ static const struct ufs_qcom_drvdata ufs_qcom_sa8255p=
_drvdata =3D {
=20
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused =3D {
 =09{ .compatible =3D "qcom,ufshc" },
+=09{ .compatible =3D "qcom,milos-ufshc", .data =3D &ufs_qcom_milos_drvdata=
 },
 =09{ .compatible =3D "qcom,sm8550-ufshc", .data =3D &ufs_qcom_sm8550_drvda=
ta },
 =09{ .compatible =3D "qcom,sm8650-ufshc", .data =3D &ufs_qcom_sm8550_drvda=
ta },
 =09{ .compatible =3D "qcom,sa8255p-ufshc", .data =3D &ufs_qcom_sa8255p_drv=
data },

---
base-commit: bf1ee2bd5c2da8992f33c8950ef194aaff74ed6c
change-id: 20261005-milos-ufs-suspend-7dd7439543a6

Best regards,
-- =20
Alexander Koskovich <akoskovich@pm.me>


