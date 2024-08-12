Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25E614A4E0
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 06:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723445974; cv=none; b=lpyYmJpIZcxrecb29UEauAGm5r9fqzsi/IVlQCMhGOr9EDWSXKzmZAiTHyciBz1rHRE3y8vGjQ/hAkJIEiHuw15BaF5TQCtxqiGZ5pcbJU3ZgiHBrOGZfcEJexYjWF7ZhB9FwG/Vj48VIM7vOAOZip9NG96WxE1XWNNtAca24Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723445974; c=relaxed/simple;
	bh=fMAI++h32t//AHmfL0D2mFSDVyXgFqjlo5mDlA1l0a4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:References; b=RIlNXx6jLf/cuQuyOByG740Yki0tl8be/ui8zJYMRMOnjFb1Zqo7GdiA7dVF7UkNhAOsWwZL0gWvpF57ataoXQm1xuUVMtwsYCWEAtRQ06zUMi+CY91pkep9hnu2WyHQs2MdHLb8aBf2DwIgnmF/2BQi9qB7ki5QxBr9qpfEu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=M2oPp0+s; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M2oPp0+s"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240812065929epoutp04365476e111e5b3ceed5e0e2cb3a3ea8f~q6PpjZyTl2691126911epoutp04k
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 06:59:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240812065929epoutp04365476e111e5b3ceed5e0e2cb3a3ea8f~q6PpjZyTl2691126911epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1723445969;
	bh=13jWM+ktnj23ePQEANAQnniiN1iteNNHMSBYRkHFQIs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=M2oPp0+sriV1B8Y+eaFjTnLK3gzMEk7KFoR4bWX3o2bz1zhC7rPCS9fc/kD7N0RvF
	 1z5yASNZF8BDQfje77jDHuaNUODTP8FVBGFt9m5qGmOVqRQoO/c+TmAKXWEeZTdgSb
	 J5D7jERTYkz+HJmlM9JMmhmYN9X0F/j+dwwVgSpY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240812065928epcas2p1a575f8f10a5e2d350e7c3fee3baf5381~q6PpCyKu62045720457epcas2p1i;
	Mon, 12 Aug 2024 06:59:28 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.99]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Wj53h18K9z4x9QK; Mon, 12 Aug
	2024 06:59:28 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	63.64.10431.FC2B9B66; Mon, 12 Aug 2024 15:59:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20240812065927epcas2p4ace98e8757a76e62efa3165de719408a~q6PnY3gSf1343513435epcas2p4y;
	Mon, 12 Aug 2024 06:59:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240812065927epsmtrp29378d4b286448f662bb202b94e16e000~q6PnX9HwX0739007390epsmtrp2L;
	Mon, 12 Aug 2024 06:59:27 +0000 (GMT)
X-AuditID: b6c32a45-ffffa700000028bf-af-66b9b2cfb133
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8E.B4.08964.FC2B9B66; Mon, 12 Aug 2024 15:59:27 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240812065926epsmtip1eae8822f53896c39f200df8f5b082ab4~q6PnJ6ZDM0410504105epsmtip1a;
	Mon, 12 Aug 2024 06:59:26 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com, junwoo80.lee@samsung.com,
	wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] scsi: ufs: core: introduce override_cqe_ocs
Date: Mon, 12 Aug 2024 16:01:54 +0900
Message-Id: <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdljTVPf8pp1pBg+fW1ucfLKGzeLBvG1s
	Fi9/XmWzOPiwk8Vi2oefzBZ/b19ktVi9+AGLxaIb25gsdv1tZrLYemMni8XNLUdZLC7vmsNm
	0X19B5vF8uP/mCyW/nvLYrH50jcWBwGPy1e8PRbvecnkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWj
	x+dNch7tB7qZAjiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgD5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYF+gVJ+YWl+al6+Wl
	llgZGhgYmQIVJmRnLF2+mL1gnWBF28M3rA2MM/i6GDk5JARMJPYdOcUCYgsJ7GCUmL6Jq4uR
	C8j+xCjxduY6ZojEN0aJe1tCuhg5wBqOXfaHqNnLKLHl9UZWCOcHo8Sl3S+YQBrYBDQlnt6c
	ygSSEBH4yCSxef42dpAEs4C6xK4JJ5hAJgkL2Essm2oJEmYRUJW4f3whI4jNK+Am8XT3HGaI
	6+Qkbp7rZAaZIyHQySHRvGYTC0TCReLMyq9QRcISr45vYYewpSQ+v9vLBmEXS6zdcZUJormB
	UWL1q9NQRcYSs561M4IcwQx06fpd+hCfKUscucUCcSafRMfhv+wQYV6JjjYhiEZliV+TJjNC
	2JISM2/egRroIbFrySJWSFjFSuw8sIFxAqPsLIT5CxgZVzGKpRYU56anFhsVGMKjKDk/dxMj
	OElque5gnPz2g94hRiYOxkOMEhzMSiK8zeGb0oR4UxIrq1KL8uOLSnNSiw8xmgLDayKzlGhy
	PjBN55XEG5pYGpiYmRmaG5kamCuJ895rnZsiJJCeWJKanZpakFoE08fEwSnVwLQvaW/3/3yV
	23P3rZ7YlxqbN/3YwVXfpESPleqxp8379i9005HkX093aPquuj21Z9s53ZMJ1mov3rYsmH/i
	Srr/rf5EwaKSY99uOK7bP2VdSciERUyRJ+pyfKIqzBk6Js41feFTZ35wv0nrtYd+6SuL3Eom
	Ljn5bL/Fzv0S2x6y3dj0bbNWwFVncSe9Z29896w7OLHAN7/p0/MgkWKWR84iSydrvOJa73qv
	xPv5lCzfx1tE77aWdHjVr+qx0Pos85w7rGzFx+iLszqrMrMSL81OVNideGRfBodadO3z2wrW
	3ceYf73uvVWkEC/6VHuy7PKzMTyPN0z8N2HZd4OVwdwaZx4oLONIu71Idu6XAnN7JZbijERD
	Leai4kQAVvdgvBsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSnO75TTvTDDZcZbU4+WQNm8WDedvY
	LF7+vMpmcfBhJ4vFtA8/mS3+3r7IarF68QMWi0U3tjFZ7PrbzGSx9cZOFoubW46yWFzeNYfN
	ovv6DjaL5cf/MVks/feWxWLzpW8sDgIel694eyze85LJY8KiA4we39d3sHl8fHqLxaNvyypG
	j8+b5DzaD3QzBXBEcdmkpOZklqUW6dslcGUsXb6YvWCdYEXbwzesDYwz+LoYOTgkBEwkjl32
	72Lk4hAS2M0o8efxLNYuRk6guKTEiZ3PGSFsYYn7LUdYIYq+MUocWroLrIhNQFPi6c2pTCC2
	iEAzs0Rfkz2IzSygLrFrwgkmkAXCAvYSy6ZagoRZBFQl7h9fCDaTV8BN4unuOcwQ8+Ukbp7r
	ZJ7AyLOAkWEVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZw4Gpp7mDcvuqD3iFGJg7G
	Q4wSHMxKIrzN4ZvShHhTEiurUovy44tKc1KLDzFKc7AoifOKv+hNERJITyxJzU5NLUgtgsky
	cXBKNTB57m3eE8a37F8w/++E+fan8tYy8XXPnT3vwr+Mfx9ls1sXPI/a/sLCuGuy/MmNHAZh
	/gvSm588Wt66JnPyQVfuj7dufovbVR5qOcHd9PGkXxp5SzuDJnRfvXfKM5Ojnrk71sE1mM+j
	5R7Te4d5+7q/b/JSW8aT9rN71rUN+y4/vsm6sfX+FdYJGvYPzzpo+IR9yhBbtq7C/6ZaWfqh
	O1O/W2ivZWfN6Zq+YfqLzee8KkRUnkgI3hJMOnKiS/Fj77LIn0rXPQW0ck1fcXpFLG/KDPKw
	C/S88CYr3mHOjKWzvjns8O3qls2pyLo6L1eDS+vaiq2X9op02C5Q/t7w0vbNZcazVQw8eb/8
	2NavU69RYinOSDTUYi4qTgQARQY9UcsCAAA=
X-CMS-MailID: 20240812065927epcas2p4ace98e8757a76e62efa3165de719408a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240812065927epcas2p4ace98e8757a76e62efa3165de719408a
References: <CGME20240812065927epcas2p4ace98e8757a76e62efa3165de719408a@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

UFSHCI defines OCS values but doesn't specify what exact
conditions raise them. E.g. when some commands are nullified
or cleaned up, Exynos host reposts OCS_ABORT. Even if
an OEM wants to issue them again, not fail, current UFS driver
fails them because it set command result to DID_ABORT.

So I think it needs another callback to replace the original OCS
value with the value that works the way you want.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufshcd-priv.h | 9 +++++++++
 drivers/ufs/core/ufshcd.c      | 4 +++-
 include/ufs/ufshcd.h           | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ce36154..4dec6eb 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -275,6 +275,15 @@ static inline int ufshcd_mcq_vops_config_esi(struct ufs_hba *hba)
 	return -EOPNOTSUPP;
 }
 
+static inline enum utp_ocs ufshcd_vops_override_cqe_ocs(struct ufs_hba *hba,
+							enum utp_ocs ocs)
+{
+	if (hba->vops && hba->vops->override_cqe_ocs)
+		return hba->vops->override_cqe_ocs(hba);
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

