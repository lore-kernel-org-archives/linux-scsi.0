Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C521CAA89
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 02:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744857265; cv=none; b=fxPUbKHllsQGnMbpPurd+rFQ/IUmRiUuziJju7DHH17hJ3b2fKdFtfZcUHwdfrjA0s76eq2sG0qsFG59FNzBZWS4Eu6VeLPUaKz/KqhoUMhLklogHgsV/M+AZ9D6sbnje4yFERlvU4FX/8qHBw9bww+wpbyn6h4cia2QlemA4xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744857265; c=relaxed/simple;
	bh=BZYIN/wc4dm29ISVSErFEEJ3a+s6ZEzUJgEaB3VLrWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=oJuHYU//LkuqXL5owCINn1kJqxt6l4YlpPp+wCs6ijcOkhhEX2hJW0gM5zC32HCzb7UjGgTntr1r96sgu4Nh8H5r2kYDYd82Sn9uw2Xy99Oz0EpaJg2PAkep//LKI3i5I2Ul6GbGxAfVjy8cP08mvAt4p3aR0VW5LXZgwia7DBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rQcDxOlK; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rQcDxOlK"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250417023421epoutp02d5906617970eb3646cd8db8b3f708fdc~2_m8xDhEn1480214802epoutp021
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 02:34:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250417023421epoutp02d5906617970eb3646cd8db8b3f708fdc~2_m8xDhEn1480214802epoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744857261;
	bh=aFlWlI2qNQdbQ8T9Cyy0pL+6w9hLyxVwaXZP/iPl2xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQcDxOlKlsPBuJhYm/DvRh3+nlJABElOS7IpPRf1EZGxBhnmpyYXyxQhOq3/aaE1M
	 TpVF1QfHJJLsZ6MxXW3XT0jMSQFQn8L2Z2JknGiNziOBgkQW+Qr4Hdh7g8U70Vu9z/
	 LgvzIFWg14wuKmgRKxtf5yaU1CbogmrYFQ4GR2KY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20250417023420epcas1p2519893cd385f425967d7eec53e2354e3~2_m8Fh6cL1363113631epcas1p2a;
	Thu, 17 Apr 2025 02:34:20 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.36.224]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZdMRH5Yj4z6B9m7; Thu, 17 Apr
	2025 02:34:19 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	45.41.09912.BA860086; Thu, 17 Apr 2025 11:34:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20250417023419epcas1p343060855c4470f8056116a207a584956~2_m7G3W821513415134epcas1p36;
	Thu, 17 Apr 2025 02:34:19 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250417023419epsmtrp14b8fb0824a85c785f21529ad334a98f0~2_m7EaiUZ2422224222epsmtrp1D;
	Thu, 17 Apr 2025 02:34:19 +0000 (GMT)
X-AuditID: b6c32a36-27feb700000026b8-8c-680068ab467d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.43.07818.BA860086; Thu, 17 Apr 2025 11:34:19 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250417023418epsmtip2f5859b918d60b37c2895346c75ca8b25~2_m6yMtzM2733927339epsmtip28;
	Thu, 17 Apr 2025 02:34:18 +0000 (GMT)
From: DooHyun Hwang <dh0421.hwang@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
	quic_mnaresh@quicinc.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
	jangsub.yi@samsung.com, sh043.lee@samsung.com, cw9316.lee@samsung.com,
	sh8267.baek@samsung.com, wkon.kim@samsung.com, DooHyun Hwang
	<dh0421.hwang@samsung.com>
Subject: [PATCH 2/2] scsi: ufs: core: Add a trace function calling when uic
 command error occurs
Date: Thu, 17 Apr 2025 11:34:04 +0900
Message-ID: <20250417023405.6954-3-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250417023405.6954-1-dh0421.hwang@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmvu7qDIYMg1U7tCwezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONou7
	LZ2sFsuP/2Oy2PrpN6vFt74n7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/STkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRW
	KbUgJafArECvODG3uDQvXS8vtcTK0MDAyBSoMCE7Y8XMRYwFazkqHn/pYm1g/M3WxcjJISFg
	IjGreQlLFyMXh5DADkaJmes+skM4nxgl1n2fywzhfGOUOHu6mQWmZXfHIjaIxF5GicP73oMl
	hAQ+M0oc3wlmswnoSezpXcUKUiQiMI9JovMSxBJmgY+MEgtvvQbbLiyQJLH41G1mEJtFQFXi
	4MuTYN28AjYS0zb+hLpQXuJSVxs7iM0pYCtx9OltqBpBiZMzn4DZzEA1zVtng90qIXCDQ2Lm
	7pmsEM0uEr+ufmOEsIUlXh3fwg5hS0m87G+Dsoslrpw7C7WshVHiUUcGhG0v0dzaDBTnAFqg
	KbF+lz7ELj6Jd197WEHCEgK8Eh1tQhDVahKL/30H2sQOZMtINHJDRD0krk99xQgJqwmMEvt2
	L2OfwCg/C8kDs5A8MAth1wJG5lWMYqkFxbnpqcWGBUbwWE3Oz93ECE7XWmY7GCe9/aB3iJGJ
	g/EQowQHs5II7znzf+lCvCmJlVWpRfnxRaU5qcWHGE2BwTuRWUo0OR+YMfJK4g1NLA1MzIxM
	LIwtjc2UxHn3fHyaLiSQnliSmp2aWpBaBNPHxMEp1cCks+UO/+ONcz+fuaP7auU7NneBV+7X
	Tv/7du2eFkPGiiM5caszf02WZovqNrrlt/+D/+3Z7wr3OkZu8PXj3q9x7M2+JX5fpm4//7qi
	tr5pfq31032red7+Ss7kPLXhd8V/decZ4ks+XH7tpbUp3rC5d/GZdb8W9VgdSPh87KOR07lf
	13f+l1yyXK/OwIDrS9SEqjfv3ss9EVw0129K1dbji62+L+1Zy8a32uqNQTlDxYZvedL+l075
	6y5pVHIodWq4fGeCl3jBWU6fn1suM9+SPrjj+7s1yTY/7d68fhTPufe+mYZ+7bFUTS933sbz
	SRvLF70qNC1QWWMeet7grEOtu/tSH96U7zmH7wktqnn78Y4SS3FGoqEWc1FxIgD/TieBYAQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvO7qDIYMg8Y+bosH87axWbz8eZXN
	YtqHn8wWM061sVrsu3aS3eLX3/XsFhv7OSw6tk5mstjx/Ay7xa6/zUwWl3fNYbPovr6DzeJu
	SyerxfLj/5gstn76zWrxre8Ju0XTn30sFtfOnGC12HzpG4uDsMflK94e0yadYvO4c20Pm0fL
	yf0sHh+f3mLxmLinzqNvyypGj8+b5DzaD3QzBXBGcdmkpOZklqUW6dslcGWsmLmIsWAtR8Xj
	L12sDYy/2boYOTkkBEwkdncsArK5OIQEdjNKnPvUwQ6RkJHovr8XyOYAsoUlDh8uhqj5yChx
	fHsLM0gNm4CexJ7eVawgCRGBFUwS8299ZAdxmAV+M0pM+tEMNklYIEHi5/n1jCA2i4CqxMGX
	J1lAbF4BG4lpG39CnSEvcamrDayeU8BW4ujT22A1QkA107+2skPUC0qcnPkELM4MVN+8dTbz
	BEaBWUhSs5CkFjAyrWKUTC0ozk3PTTYsMMxLLdcrTswtLs1L10vOz93ECI45LY0djO++Nekf
	YmTiYDzEKMHBrCTCe878X7oQb0piZVVqUX58UWlOavEhRmkOFiVx3pWGEelCAumJJanZqakF
	qUUwWSYOTqkGJhuvVCn5ySeNqjhk5XYfCzF5qntWTPbupveMpbevf531yvvAdsb7Ys//uz5h
	b1s150Ni3V+z2qrwOf9EdFuF56vOLohcJRl+95PnnH7NdVu0KizCON+ErCm59ObLIVHdjVvX
	v96X19gpIthVvqS55XjK7L3Md9ncn5zK2/RP8WfsgWDHfz53Jt6vzbgbfl1g0uQnX1s+PyhX
	3yJ59ltOwYWPC55GxP2uYhcxZF39yanW+8DaV/oVO5y/tzdpfityl7271naKaPaXNp9XzXKs
	XNdXbHyu81m40arfSuZb9s/n+4X7ft8LC55z5Lry/Mul06IeRGraVrXMWPxEZnlkiOoVsShb
	JzeWsL7IM06bTJRYijMSDbWYi4oTARIjzrYoAwAA
X-CMS-MailID: 20250417023419epcas1p343060855c4470f8056116a207a584956
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417023419epcas1p343060855c4470f8056116a207a584956
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	<CGME20250417023419epcas1p343060855c4470f8056116a207a584956@epcas1p3.samsung.com>

When a uic command error occurs, there is no trace function calling.
Therefore, trace function calls are added when a uic command error happens.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ab98acd982b5..baac1ae94efc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2534,6 +2534,9 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	hba->active_uic_cmd = NULL;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	if (ret)
+		ufshcd_add_uic_command_trace(hba, uic_cmd, UFS_CMD_ERR);
+
 	return ret;
 }
 
@@ -4306,6 +4309,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	}
 out:
 	if (ret) {
+		ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
+					     UFS_CMD_ERR);
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
 		ufshcd_print_evt_hist(hba);
-- 
2.48.1

