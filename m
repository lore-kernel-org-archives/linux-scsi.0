Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5EC3AEF3F;
	Fri, 10 Jul 2026 07:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=222.66.158.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783666882; cv=none; b=AtuBzfBgCvaMf0wEBQbwORSphJiYPlN8qFeVzTEEh0bD+S2cZq9xf+e4ZUN6GMikGqLchrQUz5/FzCjD2qoW122WJG52OQlJ8CmGAG0fWgnrJu/mUIds9jCGj1Vlxt8HUmX1jltfx7tvuV2mbQ3KaWQ/e2fv2u3I1qW5SNqg/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783666882; c=relaxed/simple;
	bh=SArPr6mx03dWGqRb4Akn25DnzcEDxPvx81ao2Iuu+9c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rG8db8ORG1pYncmTIMZJQ22IHb1IogKpq7UbBr6tc6MLILkhorHWOr7DAkWl8o2Id0Fz8Ta/rnc0PSpuB0vaVEwvRbOrJXgdHJlp1DvkA5TNFxe+D8wRVhPYwznUMVN0ROW1mw0APnOEraf7Gbm4a0xEN7OpRVBSXsDubRQMsqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com; spf=pass smtp.mailfrom=unisoc.com; dkim=pass (2048-bit key) header.d=unisoc.com header.i=@unisoc.com header.b=XnhH1MRQ; arc=none smtp.client-ip=222.66.158.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unisoc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unisoc.com header.i=@unisoc.com header.b="XnhH1MRQ"
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTPS id 66A6xr4h070359
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 10 Jul 2026 14:59:53 +0800 (+08)
	(envelope-from kui.sun@unisoc.com)
Received: from SHDLP.spreadtrum.com (zeshmbx08.spreadtrum.com [10.29.3.106])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4gxN420KTFz2R2jTj;
	Fri, 10 Jul 2026 14:59:30 +0800 (CST)
Received: from zeshkernups02.spreadtrum.com (10.29.35.184) by
 zeshmbx08.spreadtrum.com (10.29.3.106) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Fri, 10 Jul 2026 14:59:51 +0800
From: Kui Sun <kui.sun@unisoc.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman
	<avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rain.zhang@unisoc.com>, <yuelin.tang@unisoc.com>,
        <wenchao.chen@unisoc.com>, <cixi.geng@linux.dev>
Subject: [PATCH] scsi: ufs: Allows the driver to choose the interrupt handler type
Date: Fri, 10 Jul 2026 14:59:48 +0800
Message-ID: <20260710065948.467514-1-kui.sun@unisoc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 zeshmbx08.spreadtrum.com (10.29.3.106)
X-MAIL:SHSQR01.spreadtrum.com 66A6xr4h070359
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1783666808;
	bh=gaLxqM4To8pwLLDdjvrAU+EpI6nr6WQGXgSpQHI4vrU=;
	h=From:To:CC:Subject:Date;
	b=XnhH1MRQmLdbOzf2h8gD1zs/xhJqiTq0NACGkgTWC4uZaLNKGvNCbpQaJ57VwPu0S
	 nSIIiWcle7cD3osbJqiNJqGg3W/mVByLGk0MhraCzOffGaURw15VexEzOAKz6XQ+0y
	 bg6e+u2na4+B+v0ejr2TPEnAqu58XkRQSuinmIAXx4dF2G944jPx8Ybsm8sYpXSe6r
	 tmgYpO3WnJWHakeYpT7TB0xc4bnI8wNQwF5dzjlzfsVmlBLgejlLrSheR6gKzWlfgQ
	 mjKBDd9QcAwRXRoDqPh1fG3oJtEXG61fNQoBH6jRQiswB/K1LdnuDtCdrTO4+c2aIL
	 Rm5d8jgiEygiw==

This capability allows the host controller driver to choose whether
To register interrupts in a threaded manner or in a
Standard (non-threaded) manner

Signed-off-by: Kui Sun <kui.sun@unisoc.com>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 include/ufs/ufshcd.h      | 7 +++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b5..40fc6a60a4e7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11236,8 +11236,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem =
*mmio_base, unsigned int irq)
        ufshcd_readl(hba, REG_INTERRUPT_ENABLE);

        /* IRQ registration */
-       err =3D devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_thr=
eaded_intr,
+       if (hba->caps & UFSHCD_CAP_INTR_THREAD) {
+               err =3D devm_request_threaded_irq(dev, irq, ufshcd_intr, uf=
shcd_threaded_intr,
                                        IRQF_ONESHOT | IRQF_SHARED, UFSHCD,=
 hba);
+       } else {
+               err =3D devm_request_irq(dev, irq, ufshcd_threaded_intr, IR=
QF_SHARED, UFSHCD, hba);
+       }
+
        if (err) {
                dev_err(hba->dev, "request irq failed\n");
                goto out_disable;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 248d0a5bef40..c1494a459b87 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -897,6 +897,13 @@ enum ufshcd_caps {
         * specific operations and TX Equaliztion Training procedure.
         */
        UFSHCD_CAP_TX_EQUALIZATION                      =3D 1 << 13,
+
+       /*
+        * This capability allows the host controller driver to choose whet=
her
+        * to register interrupts in a threaded manner or in a standard
+        * (non-threaded) manner
+        */
+       UFSHCD_CAP_INTR_THREAD                          =3D 1 << 14,
 };

 struct ufs_hba_variant_params {
--
2.34.1

________________________________
 This email (including its attachments) is intended only for the person or =
entity to which it is addressed and may contain information that is privile=
ged, confidential or otherwise protected from disclosure. Unauthorized use,=
 dissemination, distribution or copying of this email or the information he=
rein or taking any action in reliance on the contents of this email or the =
information herein, by anyone other than the intended recipient, or an empl=
oyee or agent responsible for delivering the message to the intended recipi=
ent, is strictly prohibited. If you are not the intended recipient, please =
do not read, copy, use or disclose any part of this e-mail to others. Pleas=
e notify the sender immediately and permanently delete this e-mail and any =
attachments if you received it in error. Internet communications cannot be =
guaranteed to be timely, secure, error-free or virus-free. The sender does =
not accept liability for any errors or omissions.
=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E5=85=B7=E6=
=9C=89=E4=BF=9D=E5=AF=86=E6=80=A7=E8=B4=A8=EF=BC=8C=E5=8F=97=E6=B3=95=E5=BE=
=8B=E4=BF=9D=E6=8A=A4=E4=B8=8D=E5=BE=97=E6=B3=84=E9=9C=B2=EF=BC=8C=E4=BB=85=
=E5=8F=91=E9=80=81=E7=BB=99=E6=9C=AC=E9=82=AE=E4=BB=B6=E6=89=80=E6=8C=87=E7=
=89=B9=E5=AE=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=E3=80=82=E4=B8=A5=E7=A6=81=E9=9D=
=9E=E7=BB=8F=E6=8E=88=E6=9D=83=E4=BD=BF=E7=94=A8=E3=80=81=E5=AE=A3=E4=BC=A0=
=E3=80=81=E5=8F=91=E5=B8=83=E6=88=96=E5=A4=8D=E5=88=B6=E6=9C=AC=E9=82=AE=E4=
=BB=B6=E6=88=96=E5=85=B6=E5=86=85=E5=AE=B9=E3=80=82=E8=8B=A5=E9=9D=9E=E8=AF=
=A5=E7=89=B9=E5=AE=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=8C=E8=AF=B7=E5=8B=BF=
=E9=98=85=E8=AF=BB=E3=80=81=E5=A4=8D=E5=88=B6=E3=80=81 =E4=BD=BF=E7=94=A8=
=E6=88=96=E6=8A=AB=E9=9C=B2=E6=9C=AC=E9=82=AE=E4=BB=B6=E7=9A=84=E4=BB=BB=E4=
=BD=95=E5=86=85=E5=AE=B9=E3=80=82=E8=8B=A5=E8=AF=AF=E6=94=B6=E6=9C=AC=E9=82=
=AE=E4=BB=B6=EF=BC=8C=E8=AF=B7=E4=BB=8E=E7=B3=BB=E7=BB=9F=E4=B8=AD=E6=B0=B8=
=E4=B9=85=E6=80=A7=E5=88=A0=E9=99=A4=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E6=
=89=80=E6=9C=89=E9=99=84=E4=BB=B6=EF=BC=8C=E5=B9=B6=E4=BB=A5=E5=9B=9E=E5=A4=
=8D=E9=82=AE=E4=BB=B6=E7=9A=84=E6=96=B9=E5=BC=8F=E5=8D=B3=E5=88=BB=E5=91=8A=
=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=BA=E3=80=82=E6=97=A0=E6=B3=95=E4=BF=9D=E8=
=AF=81=E4=BA=92=E8=81=94=E7=BD=91=E9=80=9A=E4=BF=A1=E5=8F=8A=E6=97=B6=E3=80=
=81=E5=AE=89=E5=85=A8=E3=80=81=E6=97=A0=E8=AF=AF=E6=88=96=E9=98=B2=E6=AF=92=
=E3=80=82=E5=8F=91=E4=BB=B6=E4=BA=BA=E5=AF=B9=E4=BB=BB=E4=BD=95=E9=94=99=E6=
=BC=8F=E5=9D=87=E4=B8=8D=E6=89=BF=E6=8B=85=E8=B4=A3=E4=BB=BB=E3=80=82
