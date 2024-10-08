Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FC524B4A
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728356328; cv=none; b=X3J45WuGH+DmwmlnT7f8c4y07oEnnMOfgvEAeHb3McfgtxRX3giTD8lJssl8JWgqiJhySJXma2blI18ch1bv0iieNbrV5Go11gwwtiqDX2HzHp4OH/aEq6zDQlL3wg3BTDLD15WQNbLEa11ti/0J4ZoFIk484Xg5Wa4RUi/q2Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728356328; c=relaxed/simple;
	bh=WTtjtG47vymHfMOTZHiAGXAiV8ozOqMHl1YVg0JFja8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=BsrgRYs6F0bHwQlQKXEZVKDNpCz4Q9kiqIrcTxzlAMEk2xN3kq/tKa4DUmWGqiDSoHmYRPbbIEmptwQxmeUj+jV5sttEPlZ8gYLHbLUCRZjxSUwc209hRh3ibQvhtk+XO/Jc/MWlje3ATf72UcJNrebfaGrKko/iOwffbi0d4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BpD+gNBH; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BpD+gNBH"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241008025842epoutp019584e770ed8ff28499c350d7a6f8ac4a~8WusL7RAB1899918999epoutp01Q
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:58:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241008025842epoutp019584e770ed8ff28499c350d7a6f8ac4a~8WusL7RAB1899918999epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728356322;
	bh=RUnIJ9K+YQ0p0ZcKfT070l16YRpaY6+jaXV37dAh/TY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=BpD+gNBHJNJBh9toqRWlyMYnPk6pSPTjfh5HjE+zSNHClSHuNzQLMYpxP/vbq3SRe
	 d4uPGIdzRIYiickZY6E0ODrZhVTMhOMbPMsrXUvFl8UqjEuR9r52KnN9BktfA4JawR
	 9S9aFHSQQAUGOi6CdlBiKn0/WxjWdzxGIg8KByYA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20241008025841epcas2p1b2c394df55e270124fd5053b542e7c59~8WurgRqCR1455114551epcas2p1N;
	Tue,  8 Oct 2024 02:58:41 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.68]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XN11Y0Sw8z4x9Pw; Tue,  8 Oct
	2024 02:58:41 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	8E.A8.09776.0EF94076; Tue,  8 Oct 2024 11:58:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20241008025840epcas2p4834ac38412a5cd41d32f85d118febc24~8Wup-12ac3266632666epcas2p4I;
	Tue,  8 Oct 2024 02:58:40 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241008025840epsmtrp2dd05d5b875a3222f985201cf7f171ff3~8Wup_-DY10860708607epsmtrp2O;
	Tue,  8 Oct 2024 02:58:40 +0000 (GMT)
X-AuditID: b6c32a47-d53fa70000002630-3c-67049fe089bf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	47.31.08227.0EF94076; Tue,  8 Oct 2024 11:58:40 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241008025839epsmtip1150057a7a3b72671167a1f2dee3d2b13~8WupsaKDp0573505735epsmtip1e;
	Tue,  8 Oct 2024 02:58:39 +0000 (GMT)
From: SEO HOYOUNG <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
	quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [PATCH v1] scsi: ufs: core: check asymmetric connected lanes
Date: Tue,  8 Oct 2024 12:08:45 +0900
Message-Id: <20241008030845.25997-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmme6D+SzpBndvWlk8mLeNzeLlz6ts
	FgcfdrJYTPvwk9ni5SFNi7+3L7JarF78gMVi0Y1tTBZbb+xksbi55SiLxeVdc9gsuq/vYLNY
	fvwfk8XUF8fZLZb+e8viwO9x+Yq3x4RFBxg9vq/vYPP4+PQWi8fEPXUefVtWMXp83iTn0X6g
	mymAIyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfo
	dCWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgXmBXnFibnFpXrpeXmqJlaGBgZEp
	UGFCdsaqOQeZCn6yV/xveMLawLiDrYuRk0NCwETixOY1jCC2kMAORolVR9S7GLmA7E+MEref
	/mCEcL4xSiy/uZMVpuPB9VssEIm9jBKTtixjhXB+MEr86PvIAlLFJqAhsebYISYQW0TgMpPE
	n2VmIDazgJrE57vLwGqEBVwllqy/BLabRUBVYt2eW2AbeAUsJW7M28YCsU1eYlHDbyaIuKDE
	yZlPWCDmyEs0b53NDLJYQmAuh0TXr3tQD7lIdD7dAGULS7w6voUdwpaS+PxuL1CcA8gulpi1
	sBqit4FR4tDsWVA1xhKznrUzgtQwC2hKrN+lD1GuLHHkFtRaPomOw3+hqnklGjb+Zoco4ZXo
	aBOCCCtJnJl7GyosIXFwdg5E2EPi6de5zJCAjpX4fu8N2wRGhVlI/pqF5K9ZCCcsYGRexSiW
	WlCcm55abFRgDI/e5PzcTYzgdKzlvoNxxtsPeocYmTgYDzFKcDArifBGrGFMF+JNSaysSi3K
	jy8qzUktPsRoCgzpicxSosn5wIyQVxJvaGJpYGJmZmhuZGpgriTOe691boqQQHpiSWp2ampB
	ahFMHxMHp1QD06Fpj4utX9w5KuXIYtqVN/lVwbV9luuPyEluEe6ZfHPyxPMLVi3PsDcz+9e6
	PvLbmeezJzY7mjO1G3LNV5Z5c2fx2VL7eapKPeo30jss3m/wV3vDpsT2e78vV+QHoS1zj7/z
	y9/xoMcsTfr9U4HqznK7mmeKfZn+U0yjjwm75/z76yS374tZfa31vd3ioe+7zhnPPt9wb9b3
	S7PvJcwLOevreoalNZp1q8ntReFvLR4veZ5+wP4Bw5l7ry9ZW7R/YT94cnUoz4XLRxn9eR7v
	X/hq8edNWvwKk6svau5aliV0o6eSedfS0k16V+qOLHStE3S0YL/77tjK57Ze0vNWv1JqX8kS
	fEpmfQn3w21MKx8qsRRnJBpqMRcVJwIANpxsr1AEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnO6D+SzpBh9fMFs8mLeNzeLlz6ts
	FgcfdrJYTPvwk9ni5SFNi7+3L7JarF78gMVi0Y1tTBZbb+xksbi55SiLxeVdc9gsuq/vYLNY
	fvwfk8XUF8fZLZb+e8viwO9x+Yq3x4RFBxg9vq/vYPP4+PQWi8fEPXUefVtWMXp83iTn0X6g
	mymAI4rLJiU1J7MstUjfLoErY9Wcg0wFP9kr/jc8YW1g3MHWxcjJISFgIvHg+i2WLkYuDiGB
	3YwSa1Y/YYRISEj8X9zEBGELS9xvOcIKUfSNUeLozRNgRWwCGhJrjh1iAkmICDxlkjhxqIsZ
	JMEsoCbx+e4yFhBbWMBVYsn6S2ANLAKqEuv23GIFsXkFLCVuzNvGArFBXmJRw28miLigxMmZ
	T1gg5shLNG+dzTyBkW8WktQsJKkFjEyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGC
	I0JLawfjnlUf9A4xMnEwHmKU4GBWEuGNWMOYLsSbklhZlVqUH19UmpNafIhRmoNFSZz32+ve
	FCGB9MSS1OzU1ILUIpgsEwenVANTv4HUzy1HmPN7ojgmbXxWtnvmw536+Ztvv679uP7al8zU
	b3NOn4zy+Rnhf2zTqsYwMY5b4TenMx+0faC9dm1tp9r/Wa3z3V9zTbyitvX85+MaRwSvGJ1l
	1lOUuhTU+3p/qmWNs7ffXLOzffEPzIwX1DxQf5v5SVswh13keazKufk75mdfNxM/OIdz57Kz
	P9zqdl52Z9x/WHp1mJWo/5lTHx6VFzroTL8a/bj1GJ+e/q6CwqM3b+4vvzFVmJPrB5+roLJ1
	1nLTp2yxCcEzHDksNpY9nHsmYd9mViX5iS/tivxfh2xmTvHck7jhroRAjfW1dw8+ne+Pimnx
	36kmKKUqUBFoH6sam33aRZ6PtXyOEktxRqKhFnNRcSIA0iao5/cCAAA=
X-CMS-MailID: 20241008025840epcas2p4834ac38412a5cd41d32f85d118febc24
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241008025840epcas2p4834ac38412a5cd41d32f85d118febc24
References: <CGME20241008025840epcas2p4834ac38412a5cd41d32f85d118febc24@epcas2p4.samsung.com>

Performance problems may occur if there is a problem with the
asymmetric connected lane such as h/w failure.
Currently, only check connected lane for rx/tx is checked if it is not 0.
But it should also be checked if it is asymmetrically connected.

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 24a32e2fd75e..387eec6f19ef 100644
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
-- 
2.26.0

