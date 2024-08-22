Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF85181BA8
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 11:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724325176; cv=none; b=jsupYaequ58qB/bcXUdQD2SEWonbyPATjQ/MVuKZockclduQn3ZX8o87YfwqU8HGVPSx8iPxQN5RBkJYYfM5t162UBmNE7ciaT2+0MLVTsKpAeSBzehQEH5SiPzc6bzCshaHVez119QyVPzdM0CP1euo21CI+57CbbM4X3Sp/EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724325176; c=relaxed/simple;
	bh=AGnKr1NzUWLrk4XMShjBVsJMRG/N+ThYgYQttEhm4Bs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:In-Reply-To:
	 Content-Type:References; b=hmSC3/dp488mbLgJLm9sBjsf0MhldmJ8ZGcBM0fk+zGsYxao6bV7XIdRlc9LDpCZW+OFohoWcsmA9xJfgZ++fhhzct8VSo+bxCezFurDhftnaWbA5cHVShBWMghX4M8gLpmbWckp7K5CZS3O5H2eeY/5k8ZQ/m6J4wPJJwmNyK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kjzfj2GP; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kjzfj2GP"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240822111251epoutp041fbf8c471f3dbe8462002a2f3f6d5558~uCJueH6S70688506885epoutp04O
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 11:12:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240822111251epoutp041fbf8c471f3dbe8462002a2f3f6d5558~uCJueH6S70688506885epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724325171;
	bh=pUkKEpqsWn1vgiB80YuD9+I/Uj7IWzHftlh2WMqtSFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
	b=kjzfj2GPztH32PICh+mARc2G5zXLFz8t9tIUXyLwuXKnxaGCoMl/a1kDvqsqnpTj2
	 cXlPgG+vQTfCggfDD+L+ii2yYXMgTRtZzhPzk5B4pRUNFmou2QoFw7EO6tCRTSM0n3
	 2Zd8hqvHFCdZhm2fyjeQe1qjMo37KOFS58kv3G0c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240822111251epcas2p4cd1e01de78cf14f0eb3f60dad7251215~uCJt4FUVC1130211302epcas2p46;
	Thu, 22 Aug 2024 11:12:51 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.91]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WqLCQ2tK4z4x9Pw; Thu, 22 Aug
	2024 11:12:50 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	74.57.10012.23D17C66; Thu, 22 Aug 2024 20:12:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240822111249epcas2p1201417c48df67afbc734ff38ea841cda~uCJss-6Cw0076400764epcas2p1J;
	Thu, 22 Aug 2024 11:12:49 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240822111249epsmtrp107cd3bab302666b3d2702e57d8f8dddb~uCJssR2l_1127011270epsmtrp1y;
	Thu, 22 Aug 2024 11:12:49 +0000 (GMT)
X-AuditID: b6c32a47-ea1fa7000000271c-f1-66c71d32813f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	9C.57.19367.13D17C66; Thu, 22 Aug 2024 20:12:49 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240822111249epsmtip1e151548a962775c253deaaa15228b496~uCJsdOwDH0982509825epsmtip1V;
	Thu, 22 Aug 2024 11:12:49 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com, junwoo80.lee@samsung.com,
	wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 2/2] scsi: ufs: ufs-exynos: implement override_cqe_ocs
Date: Thu, 22 Aug 2024 20:15:35 +0900
Message-Id: <763ab716ba0207ecdad6f55ce38edf2d1bc7d04b.1724325280.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1724325280.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1724325280.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmma6R7PE0gx1/BC1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMC/SKE3OLS/PS9fJS
	S6wMDQyMTIEKE7Izdu1dwlpwhKti9+Gt7A2MTzi6GDk5JARMJDbNecHexcjFISSwg1Hi/NxW
	VgjnE6PE6/k/2OGcqa/escO0dN68zwyR2MkocaN/JStIQkjgB6PEqQkiIDabgKbE05tTmUCK
	RAQ+Mklsnr8NrJtZQF1i14QTQAkODmEBT4mD0zNBwiwCqhIrfi9kAbF5BaIltl7sZ4FYJidx
	81wnM4jNKWApce7gDCZUNhdQzVwOiR87vrNBNLhIbJv1EOpSYYlXx7dA2VISL/vboOxiibU7
	rkI1NzBKrH51GiphLDHrWTsjyHHMQB+s36UPYkoIKEscucUCcT6fRMfhv+wQYV6JjjYhiEZl
	iV+TJjNC2JISM2/egRroIXF04hEWSFj1MErs/N/PNoFRfhbCggWMjKsYxVILinPTU4uNCozh
	sZecn7uJEZxatdx3MM54+0HvECMTB+MhRgkOZiUR3qR7R9OEeFMSK6tSi/Lji0pzUosPMZoC
	A3Iis5Rocj4wueeVxBuaWBqYmJkZmhuZGpgrifPea52bIiSQnliSmp2aWpBaBNPHxMEp1cCU
	Z5zP/Sp7z2+e2dx2mldYxLpnv5i1rM8wpuvk5PaAOYtjH8ibTm9JEo74yTY1ffnxLuel9urz
	Zp/Lm6M2K2/OD8WShOYpV27k73qyYetRP8t4kYeJk76pO+sy/9VXWya0WVzu49JiEa/L2uol
	xwLOf3PbZrbpT/yiK+US90tfCk5X0+e8rWQXrnpj/QJPpcv3f+30ZeH2+zXf7ffT1ITvHz1U
	W9b5L5ZU6/D9X3Bs8v2rkYpecyta3Tt13jp6zJb/s+y19Zqs/WHyx+Yv/Z3puSxCvtPn/tX5
	Dn/89iyZ2qWS+s/xU5aE483+5MjbvjdeL7+14+YdzdJHnWYewh5nEx5Lf6qTK4zYp3vnzHtJ
	JZbijERDLeai4kQA++2u9jYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnK6h7PE0g7/PdC1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBm79i5hLTjCVbH78Fb2BsYnHF2MnBwSAiYSnTfv
	M3cxcnEICWxnlHg4o40dIiEpcWLnc0YIW1jifssRVoiib4wSlzZNAkuwCWhKPL05lQnEFhFo
	Zpboa7IHsZkF1CV2TTgBFOfgEBbwlDg4PRMkzCKgKrHi90IWEJtXIFpi68V+Foj5chI3z3Uy
	g9icApYS5w7OABspJGAhMXXNTTZc4hMYBRYwMqxiFE0tKM5Nz00uMNQrTswtLs1L10vOz93E
	CI4JraAdjMvW/9U7xMjEwXiIUYKDWUmEN+ne0TQh3pTEyqrUovz4otKc1OJDjNIcLErivMo5
	nSlCAumJJanZqakFqUUwWSYOTqkGprWV0pGLk85lV55rti1g//6+9WFFturC/rtLGTVdg51v
	z3glFKy2tkONT3Njz+lM1YpPux54HHQ15lnkILNw7WSRmd883CRXvjG4aSXj8E4jdyHD8gTV
	34159tybp21yXbnj3srWJVVRW96sK9z2uCis7Pyeo4+vHX3h7b/zQ7WI35vefUkVaWFb/qV0
	vF1V177P5L5kkYzQRVnrgqiieRaLxZrtcoJ5YiVCCvRumXsseKl/q+3R99kyuY9KbnMvqb5S
	rcJd/Up12vdV5/gkH/ek+5nOaW3K2f5di5N5pwBTzad9SZ/P/+z1qvm7tuL6RIaLZ9+XhgrG
	tR5S2HrMOmBB1OFspak1d3/uv9XXr8RSnJFoqMVcVJwIAJA5Ojn4AgAA
X-CMS-MailID: 20240822111249epcas2p1201417c48df67afbc734ff38ea841cda
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240822111249epcas2p1201417c48df67afbc734ff38ea841cda
References: <cover.1724325280.git.kwmad.kim@samsung.com>
	<CGME20240822111249epcas2p1201417c48df67afbc734ff38ea841cda@epcas2p1.samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Exynos host reports OCS_ABORT when a command is nullifed
or cleaned up with MCQ enabled. I think the command in those
situations should be issued again, rather than fail, because
when some conditions that caused the nullification or cleaning up
disppears after recovery, the command could be processed.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/host/ufs-exynos.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 16ad352..7ff0e84 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1376,6 +1376,13 @@ static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
 
 #endif /* !CONFIG_SCSI_UFS_CRYPTO */
 
+static enum utp_ocs exynos_ufs_override_cqe_ocs(enum utp_ocs ocs)
+{
+	if (ocs == OCS_ABORTED)
+		ocs = OCS_INVALID_COMMAND_STATUS;
+	return ocs;
+}
+
 static int exynos_ufs_init(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
@@ -1926,6 +1933,7 @@ static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
 	.fill_crypto_prdt		= exynos_ufs_fmp_fill_prdt,
+	.override_cqe_ocs		= exynos_ufs_override_cqe_ocs,
 };
 
 static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
-- 
2.7.4

