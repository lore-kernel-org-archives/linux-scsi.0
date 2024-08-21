Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2316F265
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 06:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724222528; cv=none; b=qVweoM1qKBsr9gWoLgk7ngkpeuelnIgISWqpexqDZhM7Noq4x0klScg6NHeX6SrkHV2AJHx4wCgNAL5rQ/e/s/7Ugue5eRX8oMPtqrrP6+oymkv1y2uRVMSUA3Scu8JVXy+0bE56hrpvv2fOka800aPWT1WpWX2A+itkYOC7CF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724222528; c=relaxed/simple;
	bh=2YMk0tU/ZuY6pC6YfFTXPztae5lb6hoSXuLup1em3HU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:In-Reply-To:
	 Content-Type:References; b=LfRI15L3C3e/rxNawcNCJZWxA3vanP8FB4rc16GLSrQBccuUuBxnZLFgRmvXye5aWFBtTQZHS3bgFGJzWtbLVzFQxFPbw6iEc7Fudpt867oqSF7owfM/rz2Ojzawcyn/9JMsO5lEJESRsQzh7Zag8bEZT6IOiUhMex0wogobYRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WaU9S0rf; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WaU9S0rf"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240821064157epoutp04c4753bdd70b38771252cfe77a9a64201~tqz6a-WFb2388823888epoutp04N
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 06:41:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240821064157epoutp04c4753bdd70b38771252cfe77a9a64201~tqz6a-WFb2388823888epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724222517;
	bh=5EqnHaZ504P6UH5gWXZF2XLXr3/zz7CZ6fpkZoARR/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
	b=WaU9S0rfSEMWp+ZyLv+CxOXlTZvjs+ubbIS41I20FsrxPp8ZxYyMojAb+V8SFTvW5
	 4Uydae4XEfUQ0wTKRKOcP+Ok3UnVOhkFP9Uf0Ih+uRBXRFdl9VYTUB9v53Gj4VlOtk
	 QuAkSeLrk7/wY+BZR7KB+tzvKFQk0j/Es3vjsnTM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240821064157epcas2p456a8d00ba18b2ea4b2a539f4a1d2766f~tqz5zSaRf3154231542epcas2p42;
	Wed, 21 Aug 2024 06:41:57 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.89]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WpcFJ21Pjz4x9QC; Wed, 21 Aug
	2024 06:41:56 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	E1.9A.10016.43C85C66; Wed, 21 Aug 2024 15:41:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240821064155epcas2p1ff32f6cc352363a831a08c4cb09f446b~tqz4nPvDM0676306763epcas2p1d;
	Wed, 21 Aug 2024 06:41:55 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240821064155epsmtrp11e27fd3cf5157a20a47087794b386de1~tqz4hL8mg1068210682epsmtrp1k;
	Wed, 21 Aug 2024 06:41:55 +0000 (GMT)
X-AuditID: b6c32a48-4b5ff70000002720-b9-66c58c34d6df
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	E7.C0.19367.33C85C66; Wed, 21 Aug 2024 15:41:55 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240821064155epsmtip23006339411a5d3766cd3df77aefa52a3~tqz4RJmua2089620896epsmtip2E;
	Wed, 21 Aug 2024 06:41:55 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com, junwoo80.lee@samsung.com,
	wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 2/2] scsi: ufs: ufs-exynos: implement override_cqe_ocs
Date: Wed, 21 Aug 2024 15:44:36 +0900
Message-Id: <7842191d46ebfc11a3fdf4caac81d31b36d3252c.1724222619.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1724222619.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1724222619.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmha5Jz9E0g6O3uCxOPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMC/SKE3OLS/PS9fJS
	S6wMDQyMTIEKE7Iztp0+wFTwiKvi4sdGxgbGHxxdjJwcEgImEr8u/2PuYuTiEBLYwSix/d4V
	NgjnE6PEtBkrGUGqwJwtL8NgOlqP/WGEKNrJKLF++QYo5wejxNsjF9lBqtgENCWe3pzKBJIQ
	EfjIJLF5/jawBLOAusSuCSeYQGxhAU+JEwtPMoPYLAKqEtNvXAVbxysQLfFr9VMmiHVyEjfP
	dYLVcApYStxu6WBCZXMB1czkkPjf+RPIYQdyXCR2O0K0Cku8Or6FHcKWknjZ3wZlF0us3XEV
	qrWBUWL1q9NQCWOJWc/agW7gALpTU2L9Ln0QU0JAWeLILRaI6/kkOg7/ZYcI80p0tAlBNCpL
	/Jo0mRHClpSYefMO1EAPidl3XzFBgqeHUeL4gY/sExjlZyEsWMDIuIpRLLWgODc9tdiowAQe
	ecn5uZsYwYlVy2MH4+y3H/QOMTJxMB5ilOBgVhLh7X55ME2INyWxsiq1KD++qDQntfgQoykw
	GCcyS4km5wNTe15JvKGJpYGJmZmhuZGpgbmSOO+91rkpQgLpiSWp2ampBalFMH1MHJxSDUwe
	MSry9aw+yzdeF/zHduv5Bd43l50Fsn9rpdy9eJ9R/L/Lw1nbBQ6tUXsrM+fy0d3NfGp9uRoK
	znGvLkewpxV+eHBgaWKLVWPohIwdU317Q00DF/2YYf3ixxkbY63iOYyz5qmfi7C/UsXZ/J3p
	eNkFv8sxJiu6T5zYVXb2/qZt7/cvXn+dV9V/8wfXLzPcd6v+CDaPOdn/8+DjqLoijQlXWKI8
	Gks2/+YN5Wcz8/1irC3uWCzXqn6TLWjR3hvxhWJ8BdfrpR6mGc6Y8nmLjcjH2QVmnzR+7lvw
	bZZT5fZ5yo6/HDSUOlNP3lH8N3tNzRxvqYLlh+6227w5zxh9We1cwqXSR0ZX76zTnvbjEfN9
	JZbijERDLeai4kQAnXKnnDUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvK5xz9E0g8UPFC1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBnbTh9gKnjEVXHxYyNjA+MPji5GTg4JAROJ1mN/
	GLsYuTiEBLYzStw/+Z0ZIiEpcWLnc0YIW1jifssRVoiib4wSXWens4Ak2AQ0JZ7enMoEYosI
	NDNL9DXZg9jMAuoSuyacAIsLC3hKnFh4Emwoi4CqxPQbV8GG8gpES/xa/ZQJYoGcxM1znWA1
	nAKWErdbOsDiQgIWEg3zjrLiEp/AKLCAkWEVo2hqQXFuem5ygaFecWJucWleul5yfu4mRnBU
	aAXtYFy2/q/eIUYmDsZDjBIczEoivN0vD6YJ8aYkVlalFuXHF5XmpBYfYpTmYFES51XO6UwR
	EkhPLEnNTk0tSC2CyTJxcEo1MHlcbIpxXLng0/96jqPn16X/YLKsCW/iNEhnOtVTvdqMleHM
	6nmfNwgqB1dudZX+M71jjSLHvy5N06ozupUz/KXqr88/IuvDKtnP2sP1eO4kuT07fH2OSXO9
	ddsV+1lvff6XsjPmH397JqZIbnVSlZliJTL1wpLy5sXS79pkma6vMfhw0MLoWKml+IZyQ2nr
	3tL3knpZ73kLVq9iLjvFqKb2Ia0iNG931vKaK0bZdSbVOs7vRO4++81b5c98bNGV/dqua2a9
	Pcht9fpxpFLUpi/TqyxWPuNcHLF7x89DWsGzu77vqGcR2+VpwbF57i1t/hnCDNyrVD3sXqQF
	ZVTFb1Zp2X6Jwbo2NvKlgmCrEktxRqKhFnNRcSIA7jCobfkCAAA=
X-CMS-MailID: 20240821064155epcas2p1ff32f6cc352363a831a08c4cb09f446b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240821064155epcas2p1ff32f6cc352363a831a08c4cb09f446b
References: <cover.1724222619.git.kwmad.kim@samsung.com>
	<CGME20240821064155epcas2p1ff32f6cc352363a831a08c4cb09f446b@epcas2p1.samsung.com>
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
 drivers/ufs/host/ufs-exynos.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 16ad352..4ed06fa 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1376,6 +1376,14 @@ static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
 
 #endif /* !CONFIG_SCSI_UFS_CRYPTO */
 
+static enum utp_ocs exynos_ufs_override_cqe_ocs(struct ufs_hba *hba,
+						enum utp_ocs ocs)
+{
+	if (ocs == OCS_ABORTED)
+		ocs = OCS_INVALID_COMMAND_STATUS;
+	return ocs;
+}
+
 static int exynos_ufs_init(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
@@ -1926,6 +1934,7 @@ static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
 	.fill_crypto_prdt		= exynos_ufs_fmp_fill_prdt,
+	.override_cqe_ocs		= exynos_ufs_override_cqe_ocs,
 };
 
 static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
-- 
2.7.4

