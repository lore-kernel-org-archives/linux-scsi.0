Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953DF1E6DD5
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 07:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546149; cv=none; b=BAEn1qBkiA4kUTkcSN3zlJeqjvCFPeC1U34wnLTj3RpKIjYN4OpHKo6HJPmop6sPqLbyyLCb0ToifhBaKsnLkkIaUCM/gtWWJp+pNFgKBZT+lvYKxpjG+rbHd7foFaYgBobQYn7uN8RlRjF5XMjPG7dlyxaWBeMLLuxXV0lPCyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546149; c=relaxed/simple;
	bh=RdxmHpxnSn7oqtNjjGy9uCnO3Bby+9XJuR2xLOCuk4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=KDMfxlQ36aSFxTPQLSHG2lK7m578XlpZn+QqzsNmJyk9ryOkFM1SzzKzAA5XNaROzNZQ130Ikbv234aaXp3bMtWXK3A0jFrV+HKnz6Jlr0qjZ/2PbG0Af/oVJCb7V/8ETVppoKoNLH8vNSBmCailgG/wqbBWuuP7DMWVocBCSjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gSFvJhWu; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gSFvJhWu"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241010074224epoutp024c04d2018bbdda0dbff7c711a956ce65~9B49nJKFM0624106241epoutp02P
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 07:42:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241010074224epoutp024c04d2018bbdda0dbff7c711a956ce65~9B49nJKFM0624106241epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728546144;
	bh=hLKKRo9l9bBKVvZDdlt7XO9Hx/F9gdHBcsh8ZjTZT/4=;
	h=From:To:Cc:Subject:Date:References:From;
	b=gSFvJhWu8kN6WA0MK/SbE8K1oPd7YCo2AdlOjqVuh9dwRorXSZKHh7eZmAceNkRqc
	 5XnMHzO1Q3bGRz41NS55fBZChQu9244L/CTIcjMXEqqalRrf/6exTyyGYOEACgaVWn
	 8fXj3y4sRs4RyaD74/LGZvVRBthP0PJbDLMg1410=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20241010074223epcas2p14479ee39b4b19447fa68c72a63bda5a8~9B49H_jLy1630416304epcas2p1P;
	Thu, 10 Oct 2024 07:42:23 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.100]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XPMCz2sSRz4x9Q3; Thu, 10 Oct
	2024 07:42:23 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.F7.09396.F5587076; Thu, 10 Oct 2024 16:42:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20241010074222epcas2p4278413120c00584d83f654dbde6c0f49~9B47gplOw1810718107epcas2p4u;
	Thu, 10 Oct 2024 07:42:22 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241010074222epsmtrp1961bef3ac3db715e3fe5d4b44cfb5f0d~9B47funOT0182601826epsmtrp1A;
	Thu, 10 Oct 2024 07:42:22 +0000 (GMT)
X-AuditID: b6c32a45-671ff700000024b4-41-6707855fb93b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	22.87.07371.E5587076; Thu, 10 Oct 2024 16:42:22 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241010074221epsmtip2fac01ba56df8629645cdfa907d5349bc~9B47ObJE81882418824epsmtip21;
	Thu, 10 Oct 2024 07:42:21 +0000 (GMT)
From: SEO HOYOUNG <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
	quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
	grant.jung@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [PATCH v3 0/2] processing of asymmetric connected lanes
Date: Thu, 10 Oct 2024 16:52:27 +0900
Message-Id: <cover.1728544727.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHc+69vVxcul0LjpOGSHfdnOBa2q6FqwVnosxu7MFCNjMSxiq9
	KaxPe8sUX+lGUIZGQRCkwAbFyjM2q4V0DKXUdYxolg1dQAnG11SMOJUIFgOu9dbN/z7ne77f
	8zu/8yBQwVlcSBSbbIzVpDFQ+BKs70yyUlxQHqOTLnbF01e+78PpqdBfOD109TuMrrsfQump
	QDI9v+COoRcm/uTR3W1XMNo53ofQ/QtlCN07/hNGX/QGMfp8fxNO7x/z4XT78CJCH7k9HEO7
	Fqcx+uToLLZeoD5/IVtd5fQD9Zy7Alc/+PsSpq4e2KM+6O0C6hnPcvU+/34kh8jTZxQxGi1j
	FTGmQrO22KTLpLJzCzYUKNOkMrFsDZ1OiUwaI5NJbfwgR/xusSHcCSX6WmMoCUs5GpalUtdl
	WM0lNkZUZGZtmRRj0Ros6RYJqzGyJSadxMTY1sqkUrkybPxSXzRTfQ+3eHjbx38fxu3AhVWC
	WAKSCtjuO4ZEWED6AGxyCCvBkjA/BHDSO4Jxg1kAndePIs8T1S0XeNzEKQA7OjswLv4YwBsz
	b0YYJ1fBnl8DSMQUTzaj0PnDZRCZQMmVcGby+LNAHLkeHj3XiUcYI9+AZweH0QjzyXQ4e7c2
	ur8k6LQ/QTh9KRxpuIFx6yTBst5GNFIAkl4Clrmu4VxgIwxNu1CO4+CdYW8Mx0I4dWhvmIkw
	s9DRupPL2gEMNDqinreh4+Y+EPGgZDJ096dy9hXwl0vRsi/DijMLUTcf2n98El2RDyv2CjiZ
	gueaJ6IyhEONBk5Ww28bDmARWUDmw5651CogcrzQluOFthz/76AFoF3gVcbCGnUMK7fI/rvd
	QrPRA5696pQsH6iZvi8JAIQAAQAJlIrni1t5OgFfqyndwVjNBdYSA8MGgDJ80NWocFmhOfwt
	TLYCmWKNVJGWJkuXK6XpVAL/cnmzVkDqNDZGzzAWxvo8hxCxQjuyFVZJ+h6rvpjJ+6Ze0uav
	qfeM5vlXvtXzSfbHdYrbA9tKdZ6U/BMtO2o/xNmm3IbEuEF94tXBjPmnBzsIxyuto8eJw7st
	g3rt/J3lvz2dLAx9XuPbMvUo6dbuZZU/r3swe4vPD92r9G8zujennvIbH31ap7rW3Cj5KMQz
	lRlfWzoxcjGrImHriqCzXV+++rSYNeStPaF6mIVtXj30HrLdlW8UZO8cet10MjiiFW7KCCZt
	eefwqtIN3bsGui1H+LWqXd06ZYlOeHckwZlI1PbOfaZq6/+n+rrBmJyryg+erheH3ld8daAu
	UNwgH/3DdSwUu6fH/lK9e5N8jNV3GoM3VWMUxhZpZCmoldX8C+WhMvFeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWy7bCSvG5cK3u6wduJbBYP5m1js3j58yqb
	xcGHnSwW0z78ZLZ4eUjT4tff9ewWf29fZLVYvfgBi8WiG9uYLHb9bWay2HpjJ4vFzS1HWSwu
	75rDZtF9fQebxfLj/5gspr44zm6x9N9bFovNl76xOAh5XL7i7TFh0QFGj+/rO9g8Pj69xeIx
	cU+dR9+WVYwenzfJebQf6GYK4IjisklJzcksSy3St0vgyvg88R1bwSbWihvnjrM1MC5l6WLk
	5JAQMJGYuOAKaxcjF4eQwG5GiW3zpzNDJCQk/i9uYoKwhSXutxyBKvrGKLFxUzNYgk1AQ2LN
	sUNMIAkRgc3MEv839bGCJJgF1CQ+310GtkJYwEFixpmVbCA2i4CqxOn9x8E28AqYS3x7MwXq
	DHmJRQ2/mSDighInZz5hgZgjL9G8dTbzBEa+WUhSs5CkFjAyrWKUTC0ozk3PTTYsMMxLLdcr
	TswtLs1L10vOz93ECI4XLY0djPfm/9M7xMjEwXiIUYKDWUmEV3cha7oQb0piZVVqUX58UWlO
	avEhRmkOFiVxXsMZs1OEBNITS1KzU1MLUotgskwcnFINTPxMEd+M9662qL93+wcz24J1AfIz
	dhYdnfh+zoKXix6kJy6Xjn3VYxbKlfi/mWk2N5PdKrkuy52Gr5nj/rSc6euLvP3O5Fvkj5BA
	PlG5j70v6xedDjWYZzmlrP3E8+XaV87s1X20WWyP7pf82W/bDqSu2JLk+ffRb/sF32RFLAz7
	XszWe5Mu+/Xgqu4rjw3ebzt1q+HoUwb7yl/X+0Q3KxVqLFh35UGy2v3PxiytgfuUXnGzsN9m
	/D1reZzXZ5+Cb3cnv2F3+skx715VVqPDy9BpHoGVF3UFn1u5V61fW9i03CaHeWFcfe2Hf+cb
	dn+Z/PtT9eXDZT+38Zix8m+e/sNlV2VK4b4Fl5lf2Ckv1qlSYinOSDTUYi4qTgQAKAMEgwYD
	AAA=
X-CMS-MailID: 20241010074222epcas2p4278413120c00584d83f654dbde6c0f49
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241010074222epcas2p4278413120c00584d83f654dbde6c0f49
References: <CGME20241010074222epcas2p4278413120c00584d83f654dbde6c0f49@epcas2p4.samsung.com>

Performance problems may occur if there is a problem with the
asymmetric connected lane such as h/w failure.
Currently, only check connected lane for rx/tx is checked if it is not 0.
But it should also be checked if it is asymmetrically connected.
So if it is an asymmetric connected lane, an error occurs.

v1 -> v2: add error routine.
ufs initialization error occurs in case of asymmetic connected

v2 -> v3: split two patches

SEO HOYOUNG (2):
  scsi: ufs: core: check asymmetric connected lanes
  scsi: ufs: core: reflect function execution result in return

 drivers/ufs/core/ufshcd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

-- 
2.26.0

