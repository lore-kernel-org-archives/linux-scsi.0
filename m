Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98E114A619
	for <linux-scsi@vger.kernel.org>; Fri,  1 May 2026 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777641424; cv=none; b=Tjq0juGG6anvC4XD77MsFrXzsWSpZIkvE37ZHBIJ8z6rbqsE23Yot/Y2rMbbZSYrxYdFWr9RDNrEyg0Uf//q0zFTIowWxKOCTJ2XjzmNSY/yOBwlwmOK4ZZC9+bWNJ+BIx+YEfJ08CaoM8QUP7kZrcS4iEpox3FZEYgdoH6KIp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777641424; c=relaxed/simple;
	bh=ivtxJn92+/RNWebSkQ39i2d8G3OBLGKDgGtFBfRe1ug=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TgVRng/0CnvP1biU7ADxpgeRRCcWgQr76YjRtiyGwthATNAajyPAPHJlDUw+YhIW/mbSRh+QbL3aBxsGHp9CTUaapTGygOALPNtzNIZBF93LNTNAx1VbdkBdniddtS3AgmYz0dRevgQxdBtnMo4xwMkwxGjJSbOh9s11qvan1I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fOuvu9Eb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fOuvu9Eb"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 641AXDTY3648977;
	Fri, 1 May 2026 13:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=0l0aEk1NRY8IvbWQrvER3GBVFj9Q+/2HkVb
	QOXfwe+I=; b=fOuvu9Ebh2NgXMNm47ys8aCdrVLgdW8UyqpD0iskfnMWOTeonHl
	qwqYenk+y4zdbY+jO+vtAb79OAv7f/LNaoEjUzD22pfSDeq759kH4qhUH/236VGA
	JLxPPdzO1dIkTccfGTy9Vc8kSIz4a5WImgM6O7AmN8qgSJWy//+FTFPAIHxo2L+V
	3JJhu32uW1Jw1w7ZWgmISo0JQoQT1EGlwY17LKTS7dSw5d9UNWhN0cjtWZ1HuAof
	cipBm28B7T1VhaD20XrK+LKDrAzfcpZAbAeNHM6/8Hwr4caY5C62syKl9nnfB1Wi
	RzkweSOQu/PmqfAc6vqfyPwCabAXxMPLYrg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dvj8m1duu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:44 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 641DGhIk010754;
	Fri, 1 May 2026 13:16:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4dv9q6h9kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:43 +0000 (GMT)
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 641DGh7j010749;
	Fri, 1 May 2026 13:16:43 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 641DGhkS010748
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:43 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 772A65FC; Fri,  1 May 2026 06:16:43 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH 0/2] scsi: ufs: Add quirk EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
Date: Fri,  1 May 2026 06:16:39 -0700
Message-Id: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEyOSBTYWx0ZWRfXzgpJwV7mnH1D
 3Gb6q+pkRq56sBc0cp2+z/4WJx2N0518q0nU+6XsgZBaOXFwig06+8Wvyg/TZc6ZQdqNpFgFNiZ
 d6yML++nPz5bQbt1SWtUmd2qzpDLj0ifjTBAgnOTPaZjkAzESkk4HK51KujiczQ9Dy3CEfEYUy9
 ePvs80KoQZvhd2Yf7xYuhPkmpSbP5kvssABJf1hlbUdl0S3m8KVXvmmGKCXWH6HU9NhtPEJ9aiY
 DUVghwmSO+QLEhpD5hC37x17TLRNQBJ3Ljso2LMEE2wAak2MAyxFHwQKRFT6iwf6mHyhBe+NYAV
 XCFLm2v0ITf1mLwaq8imKyBoQs2lU9pPrhrJRbDsKAsnHMDTwuek+l8U/xEOnyJXnTnBjNVEIzl
 /55zudAPDgoP+pl6cEHatHGMi6Vn1dNJbohkPMn/Rd+LwDYjdkXr5LR9pfVYaMJgeNt1DnSU792
 JEvWGyf6zUaAoplzNNw==
X-Proofpoint-GUID: fuKanmotnSoGLa83yDBlY-txKvULs9ez
X-Proofpoint-ORIG-GUID: fuKanmotnSoGLa83yDBlY-txKvULs9ez
X-Authority-Analysis: v=2.4 cv=V4ZNF+ni c=1 sm=1 tr=0 ts=69f4a7bc cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=wGrgBaBf53O1OKP9xaIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605010129

Add a quirk to support TX Equalization Training (EQTR) using Adapt L0L1L2L3
length which is larger than what is allowed by M-PHY spec ver 6.0.


Can Guo (2):
  scsi: ufs: core: Add a quirk for extended TX EQTR Adapt L0L1L2L3
    length
  scsi: ufs: ufs-qcom: Use quirk EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3

 drivers/ufs/core/ufs-txeq.c | 8 ++++++--
 drivers/ufs/host/ufs-qcom.c | 3 +++
 include/ufs/ufshcd.h        | 7 +++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.34.1

