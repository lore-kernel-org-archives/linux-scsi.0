Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE27F16C854
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 06:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728368925; cv=none; b=LKErxiSIYX959+W/nPKo5w2QrPMJKj6vZIfKMbD/Npkb30oDpmIQvm772WNh8bZQrQ5wnH/maswpFHvlA2jqRufsAADnf3r4pdfwFEWhMGb0kDc9M6rgzjN9utMYQUZQlexcmGLkpmrn+uyjoVP+gL5+ci3qd3oLMqvryVJqKRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728368925; c=relaxed/simple;
	bh=CHdVC4C5cEaMJlSA6T9iG1nG+oEj90REJeKbHeAnMuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=HBiun3dC2JZBMqLprn7kEWuQ422etDMYJ/WvHRH/lAfxL4fyAPZkLG1MfwhgxlQ2igm1Em4ZwfBraCwUqaq3VElD9rtuw6NazT9l4V/ddDHIllqyjXfXNAmlQsk/f0gCx9noq2/mJjkxK2ouZGouOscFo+IQoyUk54Wwxfet490=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WryW/63l; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WryW/63l"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241008062838epoutp017d37c58471930497295230b570919d28~8Zl-MGq483265032650epoutp01Z
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 06:28:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241008062838epoutp017d37c58471930497295230b570919d28~8Zl-MGq483265032650epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728368918;
	bh=XX4um9IiHfT9C2s8OHlnqcpiGC9n8GKeXNykCSB8k+U=;
	h=From:To:Cc:Subject:Date:References:From;
	b=WryW/63lxI6hl9+MCBURT87mJPDB5SMyTC0N1S4NCk9t33ctQKblRf1HgJIjzcUF4
	 A2NVvKbToWRMDlhX/DT2NxcwnZPJyPXUPgp6Akct9CZIsU0KcNUcdxIrpraUOj34wy
	 CN1cNo6VuG/VOnL9EpcTLNUwzbrYVNYqCPq3o8R0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20241008062837epcas2p3aab7b739d7cfe678b92481beae25f106~8Zl_e4AGN0253902539epcas2p35;
	Tue,  8 Oct 2024 06:28:37 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.90]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XN5gm69Rdz4x9Q1; Tue,  8 Oct
	2024 06:28:36 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	77.09.09396.411D4076; Tue,  8 Oct 2024 15:28:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20241008062836epcas2p2caa5c41cf8fe4d1bfe5d923633ea2618~8Zl8_SoRT2783327833epcas2p2a;
	Tue,  8 Oct 2024 06:28:36 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241008062836epsmtrp196e887db901f90be4ce9df4625097664~8Zl89i7oJ2130321303epsmtrp1P;
	Tue,  8 Oct 2024 06:28:36 +0000 (GMT)
X-AuditID: b6c32a45-6c5b7700000024b4-81-6704d114ec38
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	39.4A.18937.411D4076; Tue,  8 Oct 2024 15:28:36 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241008062835epsmtip120e8bbbe3a2680a16215e17fd9378415~8Zl8tIfQr2588925889epsmtip1i;
	Tue,  8 Oct 2024 06:28:35 +0000 (GMT)
From: SEO HOYOUNG <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
	quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
	junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [PATCH v2] scsi: ufs: core: check asymmetric connected lanes
Date: Tue,  8 Oct 2024 15:38:42 +0900
Message-Id: <20241008063842.82769-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmma7IRZZ0g+Pv9C0ezNvGZvHy51U2
	i4MPO1kspn34yWzx8pCmxd/bF1ktVi9+wGKx6MY2Jotdf5uZLLbe2MlicXPLURaLy7vmsFl0
	X9/BZrH8+D8mi6kvjrNbLP33lsVi86VvLA6CHpeveHtMWHSA0eP7+g42j49Pb7F4TNxT59G3
	ZRWjx+dNch7tB7qZAjiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNT
	bZVcfAJ03TJzgJ5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYF+gVJ+YWl+al
	6+WlllgZGhgYmQIVJmRnbFzykrngNXfFlOn5DYxnObsYOTgkBEwkDkwu7mLk5BAS2MEoceF3
	ZhcjF5D9iVHi2rK9LBAJIGfTrCoQG6T+89R5zBBFOxklfr5byQLh/GCUeHDzBVgHm4CGxJpj
	h5hAEiICrcwSL1bsZgRJMAuoSXy+uwysSFjAVeLu7knMIDaLgKrE7aWNYDW8ApYSl/rPskGs
	k5dY1PCbCSIuKHFy5hMWiDnyEs1bZ4OdISGwkENi9YRjLBANLhK7762FahaWeHV8CzuELSXx
	sr+NHeLnYolZC6shehsYJQ7NngVVYywx61k7I0gNs4CmxPpd+hDlyhJHbkGt5ZPoOPwXqppX
	omHjb6iJvBIdbUIQYSWJM3NvQ4UlJA7OzoEwPSQOf5KCBGesxOR/bewTGBVmIXlrFpK3ZiFc
	sICReRWjWGpBcW56arFRgSE8bpPzczcxgpOzlusOxslvP+gdYmTiYDzEKMHBrCTCG7GGMV2I
	NyWxsiq1KD++qDQntfgQoykwoCcyS4km5wPzQ15JvKGJpYGJmZmhuZGpgbmSOO+91rkpQgLp
	iSWp2ampBalFMH1MHJxSDUyeTO9nekWZFrn2bb69cvu9pRm7LsQxufkmrdsVfXrXtcZHr/6F
	9tyS+DYt+dhS709KH8OOL/ZUWL+T3VBXPmVd5ETWvQ/ONnoclSj/X6Ewz3/hjpKVL7tDGdIv
	OHjONBORe1M7Zb1Wy/wwU2X3C/d9eF/9Pr5qv1fRux6ZsB3NttoJs/7Nv2V6PCPeYfvWdT/f
	yrE7yB77Elc5a6LslQeHkm0U+nb0Sc+3bdn48slsVsf3ewLffPZLNdIPe53H73Io8OBJgUvn
	wgtUzK7sX2cSrft2isXpXLk3iu11V+ILaq3km6eyJKR/frC3UL56CzOL3xUOxgXLGpoK14tc
	vNDhIHl85c07fedFHHz5pjUpsRRnJBpqMRcVJwIAFYGZ5FcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSnK7IRZZ0g2vX2C0ezNvGZvHy51U2
	i4MPO1kspn34yWzx8pCmxd/bF1ktVi9+wGKx6MY2Jotdf5uZLLbe2MlicXPLURaLy7vmsFl0
	X9/BZrH8+D8mi6kvjrNbLP33lsVi86VvLA6CHpeveHtMWHSA0eP7+g42j49Pb7F4TNxT59G3
	ZRWjx+dNch7tB7qZAjiiuGxSUnMyy1KL9O0SuDI2LnnJXPCau2LK9PwGxrOcXYycHBICJhKf
	p85j7mLk4hAS2M4o8fbTexaIhITE/8VNTBC2sMT9liOsEEXfGCXW313ACJJgE9CQWHPsEBNI
	QkRgJrPE43VbwbqZBdQkPt9dBmYLC7hK3N09iRnEZhFQlbi9tBGsmVfAUuJS/1k2iA3yEosa
	fjNBxAUlTs58AjVHXqJ562zmCYx8s5CkZiFJLWBkWsUomlpQnJuem1xgqFecmFtcmpeul5yf
	u4kRHBtaQTsYl63/q3eIkYmD8RCjBAezkghvxBrGdCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	yjmdKUIC6YklqdmpqQWpRTBZJg5OqQamyu+cDQWfPgUy9H/vaE7+9vXIt4RLOlUHH3Hee/bK
	6J7ervj/V25/lml/271rTq1X++94vXrp3PyATcoVPRO2cswLaNp8Pet0p1/w0V/h5qv/vVLf
	cVjb2/GlyJUk3hMJyzL03+dobBT5tyZn7cKdU4S151ae0qs6/+XXRdt/UqffHss8frPme9Cq
	pLIUm6qrusEnzxa1HZSvvO/kN/d/Uk2Y/22Ll9p3lpr4NFmqnxAM3rX1c+auFT7nymwXP5hQ
	48r/5fmKjxp7HihauJxS0HWQUX73VLRRIKTAsv6Wyz2ZxFtzmcJWP2di8bn4Mpe1Me3fJ/Fd
	Vy/G3Ni2x1ytQqho282XC0Vcn36cOv+VvhJLcUaioRZzUXEiAIVNapz8AgAA
X-CMS-MailID: 20241008062836epcas2p2caa5c41cf8fe4d1bfe5d923633ea2618
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241008062836epcas2p2caa5c41cf8fe4d1bfe5d923633ea2618
References: <CGME20241008062836epcas2p2caa5c41cf8fe4d1bfe5d923633ea2618@epcas2p2.samsung.com>

Performance problems may occur if there is a problem with the
asymmetric connected lane such as h/w failure.
Currently, only check connected lane for rx/tx is checked if it is not 0.
But it should also be checked if it is asymmetrically connected.

v1 -> v2: add error routine.
ufs initialization error occurs in case of asymmetic connected

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 24a32e2fd75e..1381eb7d506a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4540,6 +4540,14 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 		return -EINVAL;
 	}
 
+	if (pwr_info->lane_rx != pwr_info->lane_tx) {
+		dev_err(hba->dev, "%s: asymmetric connected lanes. rx=%d, tx=%d\n",
+			__func__,
+				pwr_info->lane_rx,
+				pwr_info->lane_tx);
+		return -EINVAL;
+	}
+
 	/*
 	 * First, get the maximum gears of HS speed.
 	 * If a zero value, it means there is no HSGEAR capability.
@@ -8579,7 +8587,8 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 		hba->dev_info.f_power_on_wp_en = flag;
 
 	/* Probe maximum power mode co-supported by both UFS host and device */
-	if (ufshcd_get_max_pwr_mode(hba))
+	ret = ufshcd_get_max_pwr_mode(hba);
+	if (ret)
 		dev_err(hba->dev,
 			"%s: Failed getting max supported power mode\n",
 			__func__);
-- 
2.26.0

