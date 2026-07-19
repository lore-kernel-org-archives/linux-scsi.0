Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4429229C33F;
	Sun, 19 Jul 2026 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784491140; cv=none; b=X9skxSpJ1LZfLoqKtXUPhjFw8DxlE4p+OwF7Vqg3Mq1P2V/ZIC/KjzTH11BVc87cBB+tN6qBGorVAfHfShlLtlT9E/GALJpjWeZPI4yAJXaz7So87aKWnE+9m8AsO3R4qwlO9imcHxglYG0qzWkXTYx3ShyV0/200+iMwJDKYWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784491140; c=relaxed/simple;
	bh=MdGf/q8cH48YhOxGOU9vZCobhS12SJhHSg09QFu6zFo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e1oFPAfuZLmKKF0Zam2V8j81Rhgf618Nf5JCjJfslrze+S1HH0GmWHZy0UdH/uxejkV9jdGQ+Hs2q97eXWlQWLyD9ZfgaJay5mXZFraFGwudcp/7vJ8qy+4CwECq8pwRQesuDIv12W18gy7h/NXb19QY6HFBjqDAhgR3asWU1Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aAAXNh5g; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aAAXNh5g"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JHIITM090900;
	Sun, 19 Jul 2026 19:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=tEzDJvW5UDDMSbpE5FQiM9F8jUc4zEDNPh3
	tDkslJfI=; b=aAAXNh5gwQh0mZfFM8o1ssxD3tL+qktnUwQ9wFsgrvwU9VmhpEB
	WiSyGIOy5ogqrLiYJr7yYH2/OwLpudTcPUjVyhd/UQbj7YavJZIXQibRgRs2tBk7
	gvQdx0tPYnH/viZsvkGCsgoBH5H4ZhesvkdwZJTY985G2XTIaTKkD5wkwz8Qi5oJ
	A2Vh/EudwcbW1rpETnUyHPEbYhUK8U+EQk9zLsN4KbAA9Q5/bNByVjifNfgANpFp
	FwU6R7CbGCyAIU5wnBJvj0zkCt8JmeUQCZcmZRYX2gKhZ57Gf9464LI5rUfTufOs
	+aSv9vLH0Mu2vwxgaCv1MGU1V7CxTB5/OUQ==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2bnkdfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Jul 2026 19:58:40 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 66JJwa1x003189;
	Sun, 19 Jul 2026 19:58:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 4fgj3v6h06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Jul 2026 19:58:36 +0000 (GMT)
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66JJwa8j003184;
	Sun, 19 Jul 2026 19:58:36 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 66JJwaRv003182
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Jul 2026 19:58:36 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id 52B5D647; Mon, 20 Jul 2026 01:28:35 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: krzk+dt@kernel.org, robh@kernel.org, andersson@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, avri.altman@wdc.com,
        conor+dt@kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V2] scsi: ufs: dt-bindings: Document the Maili UFS Controller
Date: Mon, 20 Jul 2026 01:28:33 +0530
Message-Id: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDIyMyBTYWx0ZWRfX3KiFHkWARBdf
 06kVuASVwPMXpr30/kHhZ9LBJsT40+kgUmLvoOLWhm+zp4ubyAsFtyi3Y9OljBFGtULDwjaVhJ9
 TPJ8CouYYtk5IEOKWhOjcCus0Qh/QBKEw4zZwrrn1CaLcptxQ0UarYk5C9Hd5dOEOPosD3/ZVhT
 I4GhLCXgXeH75KJg9Ywse547DKiSU31e/CIrP3I+RInGWgLoFfFq+hwH8v1mBa97hkTgtiZFiy3
 zAhiYPjjxnkf6RgiZGqB9qXSQ1Lb0oKk+OndEH8wO0mYLEtJGB0AgFAWP2OCeGzP4uhr4pXdCgT
 K1Ez2NfGCvv+jucR22CAWxg2wtT2754R8q5IlFC9Let25d3W6SCP8RHTU4IAPZXL4zQWhH4vsMD
 wxnRl8yzTDzcriyRVzPF55uHw/69zd2QT+KWZVW9a7r3nH3SlnBugs0vBg1b5HzW7HKmBLDPhX4
 263lLkgy0AWWTI3bBzg==
X-Proofpoint-ORIG-GUID: HXdRCbFW1qHbusG2gpMYE73xQEZtFZiu
X-Proofpoint-GUID: HXdRCbFW1qHbusG2gpMYE73xQEZtFZiu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDIyMyBTYWx0ZWRfX3Gu0SI8/+dEj
 iwkP+2eRNMWc/L37hUkgfrxLxGamzzAspP9DFJFk3bt9TTXYTq4ETRwSVlQyXy0duxk40+G7mss
 2Ser6vq7GEc0Fr5GDbKfu0+YqwHSfaE=
X-Authority-Analysis: v=2.4 cv=deOwG3Xe c=1 sm=1 tr=0 ts=6a5d2c70 cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=3pRFFtUwbMGDAvonun0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_06,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607190223

Document the UFS Controller on Maili SoC.

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
Change from v1:
1. Addressed Krzysztof's comment to update 'qcom,maili-ufshc'
   to the allOf condition required for MCQ targets.
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index b441f0d26081..d03295806657 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -18,6 +18,7 @@ select:
           - qcom,eliza-ufshc
           - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
+          - qcom,maili-ufshc
           - qcom,nord-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
@@ -31,6 +32,7 @@ properties:
           - qcom,eliza-ufshc
           - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
+          - qcom,maili-ufshc
           - qcom,nord-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
@@ -78,6 +80,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-ufshc
+              - qcom,maili-ufshc
               - qcom,nord-ufshc
     then:
       properties:
--
2.34.1

