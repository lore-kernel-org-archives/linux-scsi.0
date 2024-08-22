Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F2185934
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 11:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724325181; cv=none; b=JQN5ZRwTqt1zX8x46zUVd2djoqfBFmazoDWWaZ2Jct2F3Fe5ZpI3a79OCKsRtqX0Z1nQC1BcFTvZbAhegleyQnMLzpW2fUqV3GY7UJvxzlvXKTuRJR1k/yEvgoYJLn5ceLKu91i5mPQfKQhEXFfDROamxSPFtk5ftRTbNkdhXBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724325181; c=relaxed/simple;
	bh=2o6SFFiK50nEtSzqm0jnsTg70qgeGslBl21arPBajnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:In-Reply-To:
	 Content-Type:References; b=nIBjk6i9ksmGWAudgveHfTPRWghKaRqV5i5dTpAmYH0RP2a90VckBRgPon+2hxjxeL/NoRPOmI6hZSux0vy16zjRI38D5P22+c/kXXlWFiw6KaUaXDoMuJOTO8QrcBOIqsvHA8GA9wNTH5svEJuUmSdZQ9C9xf+Ea3VamPT28/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PZUtai4N; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PZUtai4N"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240822111250epoutp03e8c2ab2ef5f60086e3d018e8b46e765f~uCJtnCJRk2887028870epoutp03c
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 11:12:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240822111250epoutp03e8c2ab2ef5f60086e3d018e8b46e765f~uCJtnCJRk2887028870epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724325170;
	bh=WhDyByxQC4KKueN7C/L/+10V4NNuprqT3IU+mda/IRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
	b=PZUtai4NlyOpk9nfDUKKLOg8GzAMRMUA6OHfHG3/65luqYCFoqWHJwM23pLV3o0XD
	 cONOfcBcjyx/8NTij++RyErpKPMxN5CfHG+oTkpT6pnoEGaVkcru4MEnHl3tJExwIu
	 /A6qy8u+BZgrSA/nTovaHfy1wy1f6RYnSOQIXLos=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240822111250epcas2p441dfb7d4e7bcacaeac857abf1fa55603~uCJtEeNtf1350613506epcas2p4q;
	Thu, 22 Aug 2024 11:12:50 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.92]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WqLCP3GSMz4x9Pp; Thu, 22 Aug
	2024 11:12:49 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	BC.90.10066.13D17C66; Thu, 22 Aug 2024 20:12:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240822111248epcas2p2739b7db15fd92f9a3f0da9cbffc3d5f9~uCJr3Duvq0251702517epcas2p2L;
	Thu, 22 Aug 2024 11:12:48 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240822111248epsmtrp10729d00c9dfdd32e39b28ad00a8ea7af~uCJr2X2if1127011270epsmtrp1w;
	Thu, 22 Aug 2024 11:12:48 +0000 (GMT)
X-AuditID: b6c32a46-4b7fa70000002752-92-66c71d31230d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.57.19367.03D17C66; Thu, 22 Aug 2024 20:12:48 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240822111248epsmtip141970c9e30c7e57b67ec8f4d0e79d878~uCJrmrfmn0588005880epsmtip1_;
	Thu, 22 Aug 2024 11:12:48 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com, junwoo80.lee@samsung.com,
	wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 1/2] scsi: ufs: core: introduce override_cqe_ocs
Date: Thu, 22 Aug 2024 20:15:34 +0900
Message-Id: <6aaeaa5fd70f76a1ac751ae3c5a3f0e37bc697b1.1724325280.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1724325280.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1724325280.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmua6h7PE0g/lzRSxOPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMC/SKE3OLS/PS9fJS
	S6wMDQyMTIEKE7Izuk7cYSl4IFrxseseewPjbcEuRk4OCQETiRULNrJ2MXJxCAnsYJTY1L2T
	GcL5xCixbsMpFjhnxbprjDAtVy6dZ4NI7GSU+PS/B6r/B6PEj8eP2EGq2AQ0JZ7enMoEkhAR
	+MgksXn+NrAEs4C6xK4JJ5hAbGEBZ4n3L8+zgNgsAqoS5+58ZAaxeQWiJU6974FaJydx81wn
	WJxTwFLi3MEZTKhsLqCamRwSzzcsYYFocJE433iDHcIWlnh1fAuULSXxsr8Nyi6WWLvjKlRz
	A6PE6lenoRLGErOetQNt5gC6VFNi/S59EFNCQFniyC0WiPv5JDoO/2WHCPNKdLQJQTQqS/ya
	NBnqZEmJmTfvQA30kFj5oRMapj2MEpcf72GZwCg/C2HBAkbGVYxiqQXFuempxUYFRvD4S87P
	3cQITq9abjsYp7z9oHeIkYmD8RCjBAezkghv0r2jaUK8KYmVValF+fFFpTmpxYcYTYEBOZFZ
	SjQ5H5jg80riDU0sDUzMzAzNjUwNzJXEee+1zk0REkhPLEnNTk0tSC2C6WPi4JRqYOK2ODdx
	odlpnad/M+JXKSboMuvUry8JSn7wubthf2WgxYq13zX8flcob2E/fd/IcVHugYXb7QTLRH0O
	FhlsW+L/eElVX8/Cb0e3zmtU0bP9XcNyUnyju3zerW/7LN6H7UgOMl2/cYWDjSf3J4NHyb/W
	vI/R+JR14sjEs9OtjOMcclXnMFfE1Zx623jxb71N2tWsrPB70eKVt71+sUreXfOm83HnMokK
	dq8Z2idnFs7WTDl75K/Pr2VR9dvrM3gmvZuk3zEraZ1rTPBZHd6bCssLHs94qjHN/qu/6bzY
	l6pZpQ9dKsQms/la8pwMPit3cY6Y1UdunxX5863FAn7Hixi7zZOtV7E0mbN1R6hHjBJLcUai
	oRZzUXEiANYoG1Q4BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnK6B7PE0g78zjC1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBldJ+6wFDwQrfjYdY+9gfG2YBcjJ4eEgInElUvn
	2boYuTiEBLYzSnybN50JIiEpcWLnc0YIW1jifssRVoiib4wSnxe8ZAFJsAloSjy9ORWsQUSg
	mVmir8kexGYWUJfYNeEEWFxYwFni/cvzYPUsAqoS5+58ZAaxeQWiJU6974FaICdx81wnWJxT
	wFLi3MEZYL1CAhYSU9fcZMMlPoFRYAEjwypG0dSC4tz03OQCQ73ixNzi0rx0veT83E2M4KjQ
	CtrBuGz9X71DjEwcjIcYJTiYlUR4k+4dTRPiTUmsrEotyo8vKs1JLT7EKM3BoiTOq5zTmSIk
	kJ5YkpqdmlqQWgSTZeLglGpgkitgq3T0vuap+cf2qrRm6VO1abxyrXp7Gk1X3rv4ZGrbYuGn
	zJLfk/I4ttZu+OrImu3pdeb5RHvBTzt0D128y203/cODkOkf5t3JObqkvCinW++4sEpZyZHF
	76/9y91+zthJWzK68lud+W/zb3ds/66svfu31v+GcLDC0hKuhac9+483Zmsf/yby96tEXsbH
	mC2Z4kb9k/aZ9QT9j154o9b228Ms/ws+tRdnzC9viZ/MXDDj3U/j6Qc0Kpj3y1i4l8wweu6U
	oO4y39tjTZL+s1PPrPrnr419+afqR+zq9d2qJ3v+nGerOjlp0ZwIbWmmZYcEUwVjWRkcD9x8
	umGnnuTqe4+6JfldRNwKrMV/KLEUZyQaajEXFScCACUwFUv5AgAA
X-CMS-MailID: 20240822111248epcas2p2739b7db15fd92f9a3f0da9cbffc3d5f9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240822111248epcas2p2739b7db15fd92f9a3f0da9cbffc3d5f9
References: <cover.1724325280.git.kwmad.kim@samsung.com>
	<CGME20240822111248epcas2p2739b7db15fd92f9a3f0da9cbffc3d5f9@epcas2p2.samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This patch is to declare override_cqe_ocs callback to
override OCS value.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufshcd-priv.h |  9 +++++++++
 drivers/ufs/core/ufshcd.c      | 11 +++++++----
 include/ufs/ufshcd.h           |  1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ce36154..6ebc830 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -275,6 +275,15 @@ static inline int ufshcd_mcq_vops_config_esi(struct ufs_hba *hba)
 	return -EOPNOTSUPP;
 }
 
+static inline enum utp_ocs ufshcd_vops_override_cqe_ocs(struct ufs_hba *hba,
+							enum utp_ocs ocs)
+{
+	if (hba->vops && hba->vops->override_cqe_ocs)
+		return hba->vops->override_cqe_ocs(ocs);
+
+	return ocs;
+}
+
 extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0dd2605..0615e37 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -821,11 +821,14 @@ static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
  *
  * Return: the OCS field in the UTRD.
  */
-static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp,
+static enum utp_ocs ufshcd_get_tr_ocs(struct ufs_hba *hba,
+				      struct ufshcd_lrb *lrbp,
 				      struct cq_entry *cqe)
 {
 	if (cqe)
-		return le32_to_cpu(cqe->status) & MASK_OCS;
+		return ufshcd_vops_override_cqe_ocs(hba,
+						    le32_to_cpu(cqe->status) &
+						    MASK_OCS);
 
 	return lrbp->utr_descriptor_ptr->header.ocs & MASK_OCS;
 }
@@ -3180,7 +3183,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * not trigger any race conditions.
 		 */
 		hba->dev_cmd.complete = NULL;
-		err = ufshcd_get_tr_ocs(lrbp, NULL);
+		err = ufshcd_get_tr_ocs(hba, lrbp, NULL);
 		if (!err)
 			err = ufshcd_dev_cmd_completion(hba, lrbp);
 	} else {
@@ -5351,7 +5354,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 		scsi_set_resid(lrbp->cmd, resid);
 
 	/* overall command status of utrd */
-	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
+	ocs = ufshcd_get_tr_ocs(hba, lrbp, cqe);
 
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
 		if (lrbp->ucd_rsp_ptr->header.response ||
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a43b142..3dbd3e4 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -382,6 +382,7 @@ struct ufs_hba_variant_ops {
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
+	enum utp_ocs	(*override_cqe_ocs)(enum utp_ocs);
 };
 
 /* clock gating state  */
-- 
2.7.4

