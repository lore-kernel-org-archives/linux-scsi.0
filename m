Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8BF1D6DA9;
	Fri,  1 May 2026 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777641424; cv=none; b=JLbCEFKXGuuVO2V8Rv8cajqvTfgvYeJLIWPQTgh+htH1eOMUPtdOLlwulPZOcRyM+6OZaaPp8G4KgzJiPpEQRZ3RRDpTmQb+d8xl9v2HvaNDTKIpxI7Rd/CMooco06zo8Eo8FNxfoNPfWVbEx3b2F20PXhtNJyUlf/pzWd6/hkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777641424; c=relaxed/simple;
	bh=PGpejte6GlcGdP8WRBgpjie1sSjhv9wCACl6UpN4lEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fn0LwZCY+UNDS/aocn2DkB3P3pMwhBvFr2tpoeBdESJkU4RC1dx/bOA2ghYV6uL4Dj6scJjJ4aEA2Lst6rZJ1UeZmm/xoeDR/R/lPpNh4XfrZQ3zRVJISLZ9Y7CQIPXOaVF3pf+9GVBC5pygwC7XA4VuEcto5SpQWuIeGqYTd4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bWts9E12; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bWts9E12"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 641AXM542580096;
	Fri, 1 May 2026 13:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Hffon1I/+q1
	iD7OTTRowUnNxGvRMCT8yiaQI1DgApfU=; b=bWts9E12ByCd0yARBUm/8GCRnWr
	ZagR3VGUaNqFKX6cOQRg+KzQjklFycbwl9M8RrBkkRGcdaFF4Jlg9a1Xz1eCGr0U
	rMshMkTAviQPefLw34LdQ3Uqh3E5ZRic+Qwr+EPHJCnrEuT3VHWwPhz+xOAwwOj8
	j4aGsbEwbCQ4fFKgvJfd9JZ5H9vYZjvpiF9Yn0bNwF6MWcq0Sat9ox6h30+6q0CE
	u0Q6aY6Lvn+iLeqtJiA759E8Jf3h2X1uofeF8/EjWdGd1qoy6W0A5oK3LzKoc4Fl
	6wyfMfqOJpsaXqHdprQiWaygyqo9sSF5hyvy1AWnny0YNae2UrZc71QYYFg==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dvbpwaxq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:54 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 641DGrm0023562;
	Fri, 1 May 2026 13:16:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4dvgkwmwnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:53 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 641DGrw9023555;
	Fri, 1 May 2026 13:16:53 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 641DGrL9023554
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:53 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 00DC5B46; Fri,  1 May 2026 06:16:52 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-arm-msm@vger.kernel.org (open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] scsi: ufs: ufs-qcom: Use quirk EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
Date: Fri,  1 May 2026 06:16:41 -0700
Message-Id: <20260501131641.826258-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=dozrzVg4 c=1 sm=1 tr=0 ts=69f4a7c6 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8 a=c503dEwmYKfehBB8bAQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEyOSBTYWx0ZWRfX3WlhOzRWwDCi
 MdRrHessaH4KT5x6WA6skY/jlMlT97hv/4hsJFolUDEobs6WcAOKT0fKHMyIE36DKZLGUIfoJti
 VOAetGypn47araPzDc3IzHBhk6Qd0CylbffBvWw5JGO21jCLnIGdDyM7mdCeDC5ssOnpU5fDCiz
 xrKGz6IqFTu4S6tMv/LjMsaJobpgafs9tXmHG1CF1glxklS8YO2OVUGNENE1nEHByn94+lrFDZ1
 tCgUTrBtpRgzDGJcYk7xNm3NKda+s8Z/+/wWGA1V7g9R8e+PHgYLLF2MGmUKF20zpaOUBzVrXDv
 oDJLElQIXxmjfjqxcMWa/SWSL6CDgKnwqsk+e0+Fz2+3MGKI51KXcFr8TQyzbERrxsuzLcO896r
 teI4R3e0uT+IDfa4HvRnZZiBR4q9tqW/tI/01FaHeedTxccOCwTjuLymB0JABpnWf6ONts7wBLQ
 fFt/G+SovfOshJShJGA==
X-Proofpoint-ORIG-GUID: qxv76GvRekCOpVagmzDm3SlG9QWKL9C_
X-Proofpoint-GUID: qxv76GvRekCOpVagmzDm3SlG9QWKL9C_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 impostorscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605010129

Use UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3 for UFS Hosts
HW major version 0x7 & minor version 0x1.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index bc037db46624..7b6957ef164b 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1305,6 +1305,9 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 	if (host->hw_ver.major > 0x3)
 		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
 
+	if (host->hw_ver.major == 0x7 && host->hw_ver.minor == 0x1)
+		hba->quirks |= UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3;
+
 	if (drvdata && drvdata->quirks)
 		hba->quirks |= drvdata->quirks;
 }
-- 
2.34.1

