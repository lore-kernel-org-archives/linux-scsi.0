Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBEC1E50B
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 04:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725250681; cv=none; b=kiRnUcDwhMkx0HBWzsrNnvafTFsrCcrZCmvchix1tRWzAWVt4rkM7bRnzoXLGjQ908JqDrl8lIfEIJ+Fqkt5/hxN6N0K0olzb+0mSVKyQaOfyNCJkRrwaeBTIcK+0QXafO781gnFyuIUjJtcH0CWlJQx97qC2MoYjZD24udV/pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725250681; c=relaxed/simple;
	bh=rDcTxesVpUAKbdchB2UcayjYfjAZqcA53h9zG3W88Ic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=onJavpF15q7xIONKdIO/ls68wSztSjE6mLtMQzwyoeyxs3idyHkaPXKEyCXnjOCng4V2rp2ZAtr7z/njcgFNaZ6+cVe0+qH+gbI9BIFUzkBCou2JEJCtZjmvAhSFVDlXCEBMTfOddbDAgaeMmRTz06FMs4XNJ8cI0HXi/uAOwNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SeslD/0U; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SeslD/0U"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240902041755epoutp04aa3f92f420f3546e8fc9d7d160f61e2a~xUllFa9Ja1816518165epoutp04S
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 04:17:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240902041755epoutp04aa3f92f420f3546e8fc9d7d160f61e2a~xUllFa9Ja1816518165epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725250675;
	bh=Gm6bfVYo8q3tjpjBLXQfHM59etQejq246QIVY2XCsr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeslD/0UCa3ZXSuVESgUammiUJWrLiXIP9zNeZzj4yOAJB+gHiTzLlf4yURE4hGK0
	 nEHmFxWAQmDHO+HypkpnfzYsOKo50UmKq3hyWlKgRzX9G4jsOycWi6xq/PKDG+uH6v
	 AJiM3N7xcMN0tXDonXQWIumb/5Poov5h8t+fIeU8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240902041755epcas2p32790dd6a8adcbb4b0997d1d36674a524~xUlkm5Qla2389523895epcas2p3E;
	Mon,  2 Sep 2024 04:17:55 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.90]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WxwTZ27w6z4x9Pp; Mon,  2 Sep
	2024 04:17:54 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	17.F3.10012.27C35D66; Mon,  2 Sep 2024 13:17:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240902041753epcas2p26511cc4d2badf0e866cec2f855380c67~xUljPIODt1585715857epcas2p2q;
	Mon,  2 Sep 2024 04:17:53 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240902041753epsmtrp1cbe18b74a4ac6a6c646dfbb6936236dd~xUljOQsf43038530385epsmtrp1I;
	Mon,  2 Sep 2024 04:17:53 +0000 (GMT)
X-AuditID: b6c32a47-ea1fa7000000271c-e5-66d53c72617e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E6.1A.08456.17C35D66; Mon,  2 Sep 2024 13:17:53 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240902041753epsmtip2e650b1ba05ef0eb92c378c523e2d1b34~xUli8b9Kp0320303203epsmtip2N;
	Mon,  2 Sep 2024 04:17:53 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
	bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
	beanhuo@micron.com, adrian.hunter@intel.com, h10.kim@samsung.com,
	hy50.seo@samsung.com, sh425.lee@samsung.com, kwangwon.min@samsung.com,
	junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v2 1/2] scsi: ufs: core: introduce override_cqe_ocs
Date: Mon,  2 Sep 2024 13:26:45 +0900
Message-Id: <90ea4709cf07d951aaad16e1e63f13842bb4608f.1725251103.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1725251103.git.kwmad.kim@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEJsWRmVeSWpSXmKPExsWy7bCmmW6RzdU0g7OP2SxOPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWsw528BksXrxAxaLRTe2MVns+tvMZLH1xk4Wi5tbjrJY
	XN41h82i+/oONovlx/8xWSz995bFYvOlbywOgh6Xr3h77Jx1l91j8Z6XTB4TFh1g9Pi+voPN
	4+PTWywefVtWMXp83iTn0X6gmymAMyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DS
	wlxJIS8xN9VWycUnQNctMwfoFyWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgXmB
	XnFibnFpXrpeXmqJlaGBgZEpUGFCdsaHg9fZCv6LVpw5u4a9gfGXYBcjJ4eEgInEkUmPWbsY
	uTiEBHYwSqzuW8IC4XxilHiwrIkJwvnGKDF1ciMzTMvX/5uZIRJ7GSUmvP0NVfWDUeLrxU+s
	IFVsApoST29OBUuICLQwS1zY9IsNJMEsoC6xa8IJJhBbWMBL4sjhPWA2i4CqxO8tT8CaeQWi
	Jeae6WOEWCcvsajhN1gNp4ClxN5rX6FqBCVOznzCAjFTXqJ562ywkyQEznBIfN55gAmi2UXi
	4q3lbBC2sMSr41vYIWwpiZf9bVB2scTaHVeZIJobgEHw6jRUwlhi1rN2oCs4gDZoSqzfpQ9i
	SggoSxy5BbWXT6Lj8F92iDCvREebEESjssSvSZOhzpeUmHnzDlSJh0THTWjw9jBK7Fs7mWUC
	o8IsJN/MQvLNLIS9CxiZVzGKpRYU56anFhsVGMOjODk/dxMjOHFrue9gnPH2g94hRiYOxkOM
	EhzMSiK8S/dcTBPiTUmsrEotyo8vKs1JLT7EaAoM64nMUqLJ+cDckVcSb2hiaWBiZmZobmRq
	YK4kznuvdW6KkEB6YklqdmpqQWoRTB8TB6dUA9PKUpnj716uVL2yfcvDFMWCmhn8uxbZ3Zw3
	x3Ky0O9tvKFJHyalZX3dMeXiuR1T+IRK/h4Mf9/wKcly47S9MzV0jNkv/N6VE7y7IvvtSueL
	P5MiFT6k2t9V2GnDe2p5Mp/g+2UOx667RR5QfrtRZ7NZrpmbIWvaQ1nFFac/ylTfbhC81Poi
	6lrKFpF/HwRn6eecqY9+MJPj7pfv/otzr/3juL3g06GiXv11x2O+/hN/J3gtXC0+MHMqz8Yt
	pWemqN/++0JrW+1czflet+fH2wvdeLlC6tPBmpzX1hzPfKaYty2LXJlsvPzM96bEn8s8/Lg/
	/2forOk4YxqrvSrqwK+SM+z+v/onOyR9Lo/VSc1/qsRSnJFoqMVcVJwIABHk1X9lBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJXrfQ5mqawcOpMhYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLeacbWCyWL34AYvFohvbmCx2/W1msth6YyeLxc0tR1ks
	Lu+aw2bRfX0Hm8Xy4/+YLJb+e8tisfnSNxYHQY/LV7w9ds66y+6xeM9LJo8Jiw4wenxf38Hm
	8fHpLRaPvi2rGD0+b5LzaD/QzRTAGcVlk5Kak1mWWqRvl8CV8eHgdbaC/6IVZ86uYW9g/CXY
	xcjJISFgIvH1/2bmLkYuDiGB3YwSD+Z/YYVISEqc2PmcEcIWlrjfcgQsLiTwjVGi61giiM0m
	oCnx9OZUJpBmEYEZzBINnVuZQRLMAuoSuyacYAKxhQW8JI4c3gNmswioSvze8gRsEK9AtMTc
	M31QC+QlFjX8BqvhFLCU2HvtK9QyC4kTnd/ZIeoFJU7OfMICMV9eonnrbOYJjAKzkKRmIUkt
	YGRaxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHGFaWjsY96z6oHeIkYmD8RCjBAez
	kgjv0j0X04R4UxIrq1KL8uOLSnNSiw8xSnOwKInzfnvdmyIkkJ5YkpqdmlqQWgSTZeLglGpg
	Sr437fiKwNemvoYpOvpnc1gzozXVLT5w93NueuOWpVV6/OxuvZl5Dv28W5aeVVomKrnGtM0t
	e8H9N/N8DF1mSVtzxcb/trHpLS5Vu8FXeeC120nHrV/mTXDP/vb5vF3amazzWxnDzP8tfzV7
	2SJXib011aIn7+41n8t1nbH22QT3E2sW7L4rqLql+Kr8yg1PEsu/PJif73OE7eyalrM/M+71
	7Q/e4u8UUXOx1fr3xD/55V8tp0lxtn9773Ay6O6TBtHMskm9paLCukd/frn/zbn8Qe8rBp7M
	x9s38W4tULeMeLZ7sqBT8tZ2X5spgZVlu4plDbP5H81+KRKavO3x20cv3JpKf3CvP/pn+Q8b
	WSWW4oxEQy3mouJEADVZJlofAwAA
X-CMS-MailID: 20240902041753epcas2p26511cc4d2badf0e866cec2f855380c67
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240902041753epcas2p26511cc4d2badf0e866cec2f855380c67
References: <cover.1725251103.git.kwmad.kim@samsung.com>
	<CGME20240902041753epcas2p26511cc4d2badf0e866cec2f855380c67@epcas2p2.samsung.com>

This patch is to declare override_cqe_ocs callback to
override OCS value.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufshcd-priv.h |  9 +++++++++
 drivers/ufs/core/ufshcd.c      | 11 +++++++----
 include/ufs/ufshcd.h           |  1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ce36154ce963..6ebc83029e09 100644
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
index 0dd26059f5d7..0615e372fe44 100644
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
index a43b14276bc3..3dbd3e41b022 100644
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
2.26.0

