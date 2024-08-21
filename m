Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53D116F0D0
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 06:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724222527; cv=none; b=R2cI0FgT+pmpjS4sPn0V0TS6iCAATCXY0YegzzOkjunx9LZjUxTDCTybuGshc3EKvEXGkloqHgHzKBcmliIPn2EpPm79rUogBlUUXrDeKO9yyUMMpndRhczn0BqPAUO/1gLx5KA0TY1qHXUZMA92+9BpPekyJ8DfQUdfttU+OvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724222527; c=relaxed/simple;
	bh=eOQ5l4XgFlW7U7G++R9DHPzSWWgUGvcxjK1dOQAskrE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:In-Reply-To:
	 Content-Type:References; b=GzaFon9fKFP7LcG3X7izpCOfd8yTspwGY/6hOl3DsCiByJZBtm3E3iWEQXmvA1HNqPqJQy/Hbgd5ekmR3XQhDJ33bDVrPjUx1eByry6ULn0cjNcfvU9uYmULCF8rXxpM2Jr+NykcbGE4P0GPmA0DsAEJfwrdqoWo664r9M0FIew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lquXMm87; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lquXMm87"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240821064156epoutp04950c01898a27c3a9d44a660132a649ae~tqz5a19k72388823888epoutp04M
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 06:41:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240821064156epoutp04950c01898a27c3a9d44a660132a649ae~tqz5a19k72388823888epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724222516;
	bh=sMj9BuUHnr0qLRImQKl4GsIZNC6zCltaKXufVWbcMtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
	b=lquXMm87TFwch3UOJe7O4BSnhmsV79kZ4QtxJK1J6XNIZnjJ1U79ODE5lkVO8h79F
	 aM3sRzWBR5RiRnuf2CGHDejQBjpExbcu4C2pZ7MCp/iz7xWhieIdQ0MFAOvfhkc8kf
	 KCpjWU2PLg2NpK/ePnAJw13uRK0Gzj5XEnww9i3k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240821064156epcas2p3bbddece0e8868e7de34bd82f3f31bfd9~tqz44O3cw3037830378epcas2p33;
	Wed, 21 Aug 2024 06:41:56 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.91]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WpcFH0zs4z4x9Pw; Wed, 21 Aug
	2024 06:41:55 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.FD.08901.23C85C66; Wed, 21 Aug 2024 15:41:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240821064154epcas2p1535229865081d0c07c8e1b19364deefa~tqz3UFYSZ0227502275epcas2p1S;
	Wed, 21 Aug 2024 06:41:54 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240821064154epsmtrp166344e3c153ec229298432b9f27e2f26~tqz3TBYfs1068210682epsmtrp1a;
	Wed, 21 Aug 2024 06:41:54 +0000 (GMT)
X-AuditID: b6c32a43-a0fff700000022c5-32-66c58c325de2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	24.20.07567.23C85C66; Wed, 21 Aug 2024 15:41:54 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240821064154epsmtip296d7dab2371915e0dcd6bcbebd5f4319~tqz3Fmjx-1962519625epsmtip27;
	Wed, 21 Aug 2024 06:41:54 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com, junwoo80.lee@samsung.com,
	wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 1/2] scsi: ufs: core: introduce override_cqe_ocs
Date: Wed, 21 Aug 2024 15:44:35 +0900
Message-Id: <895b69ac1e938490cd1d17b5f82b6f730bcd82c2.1724222619.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1724222619.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1724222619.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA1WSe0xTVxzHc26vlwux7qbqPDaG4QVxuhVaHu2tkc0EtpXgEhb3cHZJ6dpL
	afpMX7olJJghVArIuqETFRygLIVBhqWyboynMreUTCvSFiRlEUyJ6HAZDhhsra1b9t/n9/j+
	XufgDFYLxsaVWhNt0ErVJJaAuob38DkZ1deKuQshIXXjXgdGBRtdGBVaHseowZmTKHX6t2UG
	tTZ5cwPV3hJEqWafC6Hca58gVI/vW5TyO6+hlNd9HqNsE70Y1Ta6jlCX1hdQ6sqtJfQAIfLe
	LhC1fB9CRHXNA0D0pMuKiRZnA6io1ukAot+7E0WVAzakED+i2l9CS+W0IYnWynRypVaRQxYc
	kuRKsvlcHocnpARkklaqoXPIvIOFnNeV6vAGZJJFqjaHXYVSo5FMf2W/QWc20UklOqMph6T1
	crVeoE8zSjVGs1aRpqVN+3hcbkZ2OLFIVWJdPY7qpzYd63R9UAaqN1aBeBwSWbDnYm1cFUjA
	WUQvgJ4Hp0HUeAyg84+RmLEEYE/jw7hnkvMTM2g00Afg2s0nWNT4E0B/xywaycKIPXDWX49E
	AluIRQReaXI9lTOI3dBd9yMS4c1ELnzovQ4ijBK7oMvnCVfCcSYhhl/VENFuidA/dpIR4XhC
	CCfLrcj/OSGc8yUO6wc+R6KCPBhwDsdG3QznR50xZsPQqYoYG+HXveMxcRmA7fM/xwKZsGGu
	EkSGYIQ36HKnRxASyXAkgEbH3wStw2txUTcTWitYUWEyXLF/BqK8HZ71T8UKimDb/FzsitUA
	2lpWsDrwQsN/DS4C4ADP03qjRkHLMvS8f19PptN0g6e/dW9uL7jdtJ42BBAcDAGIM8gtTFto
	sJjFlEs/+pg26CQGs5o2DoHs8B0/ZbC3ynTh7641SXhZQm4Wn88TZGRzBeQ25vSJC3IWoZCa
	aBVN62nDMx2Cx7PLkDsfKuxkx+yjlLI57+pzG8StPZ7rBwOVnrxkPvay76XO48rW2qP94k5V
	sOLtN97zNLW2CeSkrXxedkNRtOJoeHe8DV0o5wrXvekVk+dUE97gmb/PNB5Lsyzzynf9ejgx
	1RFyT4m1zprRU2+ldt2aLt26Mf7NIwMpOzyu/Adu+06aw7x3dbbYUZhlmbgP7kKf6a+Uu0Xv
	Pz68r2/xTqD6u5rgkiAV1yy8yN0uPirp+4Ih30m3ZyIXOP2MS3RpM/P+2PQ5hX21ILkjaOke
	yf9lm/2Hb147e8BBDyvHZvrzA+afWu3suZx36jPtyrodtqrL43qn+9XdtRa++8RgKfPRVRI1
	lkh5exkGo/QfHP2IKjYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvK5Rz9E0g28HBS1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWqxe/IDFYtGNbUwWu/42M1lsvbGTxeLmlqMsFpd3zWGz
	6L6+g81i+fF/TBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
	4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBkdvxtZCu7wVazbFtPA2MPTxcjJISFgIjHn+kOW
	LkYuDiGB3YwSP2Z9ZIdISEqc2PmcEcIWlrjfcoQVougbo0Tf0zNsIAk2AU2JpzenMoHYIgLN
	zBJ9TfYgNrOAusSuCSfA4sICzhLvLh8DG8QioCqx7cZZoF4ODl6BaIkVvQIQ8+Ukbp7rZAax
	OQUsJW63dIC1CglYSDTMO8qKS3wCo8ACRoZVjJKpBcW56bnJhgWGeanlesWJucWleel6yfm5
	mxjBkaGlsYPx3vx/eocYmTgYDzFKcDArifB2vzyYJsSbklhZlVqUH19UmpNafIhRmoNFSZzX
	cMbsFCGB9MSS1OzU1ILUIpgsEwenVAPTpd36WxON7zw+9v2O+3OhqXL7y/uX5X+UZtlbrP5X
	efa1p0evLE8vnvTf8clFWVuedeVzjT6pBIVf4KrvfXZrrdObU0t/VH2d5j/3ikkDhzdX2OUL
	V2TbxXkU8zW5NNh8MlglSyxs1wTplCc+Nw/ziF5wNnXjtN8KCZtOpyUd8wnT2yimPWW27LVI
	PZE+y9288WdP+p1h5o79lGN0s85Z5FX/zkqXhbb3LgSI3Un23OMWJvcg1FjIf/OdYy/lJNe2
	lUytC+2MyZXK+75w4/b/d53X/rL6svrWJKPSeXu88vZG7et33+z2SPVyVCXLFpd0nkXmAtkt
	E19vqanZnZi8+8y/tOD3HV0H212XNGgpsRRnJBpqMRcVJwIAzeNmFvsCAAA=
X-CMS-MailID: 20240821064154epcas2p1535229865081d0c07c8e1b19364deefa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240821064154epcas2p1535229865081d0c07c8e1b19364deefa
References: <cover.1724222619.git.kwmad.kim@samsung.com>
	<CGME20240821064154epcas2p1535229865081d0c07c8e1b19364deefa@epcas2p1.samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This patch is to declare override_cqe_ocs callback to
override OCS value.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufshcd-priv.h | 9 +++++++++
 drivers/ufs/core/ufshcd.c      | 4 +++-
 include/ufs/ufshcd.h           | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ce36154..be593d1 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -275,6 +275,15 @@ static inline int ufshcd_mcq_vops_config_esi(struct ufs_hba *hba)
 	return -EOPNOTSUPP;
 }
 
+static inline enum utp_ocs ufshcd_vops_override_cqe_ocs(struct ufs_hba *hba,
+		enum utp_ocs ocs)
+{
+	if (hba->vops && hba->vops->override_cqe_ocs)
+		return hba->vops->override_cqe_ocs(hba, ocs);
+
+	return ocs;
+}
+
 extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0dd2605..83a1870 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -825,7 +825,9 @@ static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp,
 				      struct cq_entry *cqe)
 {
 	if (cqe)
-		return le32_to_cpu(cqe->status) & MASK_OCS;
+		return ufshcd_vops_override_cqe_ocs(hba,
+						    le32_to_cpu(cqe->status) &
+						    MASK_OCS);
 
 	return lrbp->utr_descriptor_ptr->header.ocs & MASK_OCS;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a43b142..64444fb 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -382,6 +382,7 @@ struct ufs_hba_variant_ops {
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
+	enum utp_ocs	(*override_cqe_ocs)(struct ufs_hba *hba, enum utp_ocs);
 };
 
 /* clock gating state  */
-- 
2.7.4

