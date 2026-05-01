Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56153B7748;
	Fri,  1 May 2026 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777643089; cv=none; b=uAEoBO2Vu/Xwr96efX3qrwsyoM0RS68Kcju6BMp/Obl43+z+Q5CjGp05hpWJ3avfwrRv4vuQ8oyInWWYpOHKaCQM+Mmb4XV0hL9lUNcU+rJJhO/H3yU+WfMhX4ndwy6dLGeR0k1eaKufDh3A+O/7tp8KA1FD9wCn2YajzExaqJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777643089; c=relaxed/simple;
	bh=XY/gY21GgJKMPzedDLrfkpScYMVY0SZ4RgmY3aBVrS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C7AKgTaMx3v7pHi4pkAQkcFkw0KJaBviGuzeUfSPnVzFcfx5uWLBXqy3KYE3sDTS3U5fBf8xkUmMxUs0rt0mcaDoen46rCk5nQm3jjNrBI1CL3iVVQrmjeDW1+EdzVQECF3f0BBJCM9Xu9DgamAYGyV6R45Mme7v+QSb/Q8KsZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MdwO5ARH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MdwO5ARH"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 641AXl1e4074980;
	Fri, 1 May 2026 13:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=8MbqsOI89MW
	J3nf7zaPzLqXfYgQ8Jdsjrgx8bzH89OA=; b=MdwO5ARH0Xdrx8YKYT9OdA7Tq5n
	FrQyJM6WhkiVWcQ508XBXWdaVt1E6eLqIJunSHmLP7SJoTPHRvGJKkIZHUF/fPu8
	e8RRbesSCs9k8LJwBQSVaqYjDKFF0R1x4B0jGzVA1kfPdvhu8R8iqml+h9Ie6Jnd
	zDbAhDA1GS2eb3cpMwKu5RmkTO9M14jnJTyYVP/JW7zVNn27h69Yw5m2jWC9YowQ
	FvW153GHhHJkducTsGr4LO6rwLLcLHPLn8VCjS6bl2NZwJwgvvpCJcIaGmHsHEUj
	J7UaXX8FddrpVlzBIW3rWVomDv/liXcB4DkbbUcu61Zr471GA0YHJZzx7PA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dvc45asbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:22 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 641DiLI9012128;
	Fri, 1 May 2026 13:44:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4dv9q6heg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:21 +0000 (GMT)
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 641DiLZb012122;
	Fri, 1 May 2026 13:44:21 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 641DiLcn012121
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:21 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 61B67B1B; Fri,  1 May 2026 06:44:21 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo <zhml@posteo.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Fri,  1 May 2026 06:44:17 -0700
Message-Id: <20260501134418.863432-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
References: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEzMyBTYWx0ZWRfX/zVHdBUabysv
 RhoBmneSOxRbEVSKO3+m9qyWGSFt+FUMJUJjnaXBr/IIMlv9UKaA120pePVq0DJtHVq7ZtOJMsG
 NCFZYPRyciAcIzkZh7E+yVWcWXTqS1bqKnUgEPdFCqmpDMOTWHZDpH36l2zMdhosDp9ZNIRxDJv
 mCjXsHs3ru5BtJteWCE6Dx7tbUVT03U/e0dPtKy+TWCZa0mkPS1CB+la7vWc2doT8BmedA8ebUY
 AgjMS8QeuYxxjnXGGkajJ6fiPdjrMuj3JcUgEODYJrJxZmY0xE0BT1wp+Q55kDbhw0jrAsxdn/j
 vvgreuaCE3y+rpPwcYVtOXh7woeStQXtRmkoII10Q9K/cBzqkpYy66gENsiDYh8Xu6tL4DhjhxT
 jucpaUerPCa35vBo3NT5OxJa/6j5lHCyXgU8EBTxTFnrX8TkkmwyrenLkH5mU4lU+3DhJphI8rc
 Sp16MTrkeB95HdGJnCw==
X-Authority-Analysis: v=2.4 cv=DP+/JSNb c=1 sm=1 tr=0 ts=69f4ae37 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8 a=lLwn_pVGIY8_VVq2u94A:9
X-Proofpoint-ORIG-GUID: u8TM5OKd0NvF_Roo3ZrseN-TsWdrDn8Q
X-Proofpoint-GUID: u8TM5OKd0NvF_Roo3ZrseN-TsWdrDn8Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605010133

HW design team usually provides static TX Equalization settings based on
PCB board characteristics. These settings can be passed from the device
tree to configure the TX Equalization parameters (PreShoot, DeEmphasis,
and PreCodeEn) for Host and Device across different HS gears.

Add patternProperties for txeq-settings-g[1-6] to support specifying
static TX Equalization settings.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/ufs-common.yaml | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index ed97f5682509..bc83948fc168 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -105,6 +105,17 @@ properties:
       Restricts the UFS controller to rate-a or rate-b for both TX and
       RX directions.
 
+patternProperties:
+  "^txeq-settings-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 6
+    maxItems: 12
+    description: |
+      Static TX Equalization settings for High Speed (HS) gears.
+      The settings are specified as an array of tuples (PreShoot, DeEmphasis, PrecodeEn).
+      The array must contain these tuples in the following order:
+      Host Lane 0, [Host Lane 1], Device Lane 0, [Device Lane 1].
+
 dependencies:
   freq-table-hz: [ clocks ]
   operating-points-v2: [ clocks, clock-names ]
-- 
2.34.1

