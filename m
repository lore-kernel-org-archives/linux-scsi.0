Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BFE3DA5D2;
	Mon, 15 Jun 2026 08:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781513533; cv=none; b=mlD+2CCHvpOoXU6GMX2G/bRE7tqiTufITpfpEbK1903+I3WTq3rEWm04hdmDcD026Jna/UWZ/5nXO2td5fomQED96xWdXJCMD0sj6hXTr/DQglkqYHHqwJzXZnw96o/sYzhb1wCnVxk0waAr4CAzf3vyGQOHMBqEOGJ4rMnRsHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781513533; c=relaxed/simple;
	bh=ES8E1keNUT+86AMpxa4LLuR68Moh2dpgjFWv8raOY+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mqSMXsNl+HqWUm1BUurOUdcWNjIEnXiqLh4YBPpjfK+SvdSvYPxukz5ggGbrWfXjvPm6lzmz5UndPhMFvePjTlHQp0ZPJ9Z3xqI2VipYXIcyJnRgrqHTDz4VFy2tUBdLZgrn1/UQVQ9QXOO1dAegexeINbLuReqBP06QNqGj+p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XVH3MP3+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XVH3MP3+"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F6J1Qp3327542;
	Mon, 15 Jun 2026 08:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=5rSjjDqRnPW
	x6cmTwlJGIy+3qWnBfrPKYuPAiYC747A=; b=XVH3MP3+pGy5m0OKNiZv18WWmd7
	8unxx/sTI89S3E1QGnwdbZ8G3dOLTobDFn2BBmOlfcqO+K15ZvcJGtwxwlW+k5bq
	9ORGiJRqKZ3N7abm7MoMbf7Lq3PJrACFd/3MyAzhi7IC3fHT1Ooi0TJORLx21apc
	QK3nKSpYkcQxme0+sOvz9chR5QVsja9xO0Z51swtMd0fZwhBsENvelSAZtNymTbO
	dUqkR6m0orANfxDqkM9LC489nddqFbSgVE15gSGRG53r9/M5CGDsxXKmnXRsHg5K
	ZCvzAiCf7sqE6bnzWTWuyGWjDYBk0mUN1VTbuLzqQuAWSw9bVLGsphjJObQ==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4es0cgpc8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 08:50:36 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65F8oZli004039;
	Mon, 15 Jun 2026 08:50:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4et5v6v9ye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 08:50:35 +0000 (GMT)
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65F8oZrU004031;
	Mon, 15 Jun 2026 08:50:35 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 65F8oYmk004030
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 08:50:35 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id B577D656; Mon, 15 Jun 2026 01:50:34 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo <zhml@posteo.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Mon, 15 Jun 2026 01:50:25 -0700
Message-Id: <20260615085027.2102882-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260615085027.2102882-1-can.guo@oss.qualcomm.com>
References: <20260615085027.2102882-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-ORIG-GUID: L51jgdlJxZwFFybeI4FydguDGUjjrirz
X-Authority-Analysis: v=2.4 cv=NPLlPU6g c=1 sm=1 tr=0 ts=6a2fbcdc cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8 a=O1bjOzfcQfNXtJdNm1oA:9
X-Proofpoint-GUID: L51jgdlJxZwFFybeI4FydguDGUjjrirz
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA5MiBTYWx0ZWRfX6DJYvVO9t6y6
 re3cJKxtaT3fyBqEEcUpaPpqQ3+t+qUM74Z/wTHD91bObLBjdVglyBtXDbMt0IaKtdbWCXGrS/r
 eWEbylqTNIE4meU3e1+fCKG6LTZiC4U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA5MiBTYWx0ZWRfXyeeAHsmYlBru
 p4Jww6Is/J97JlHlSFgX1nbP5mD3alcmvIN9Qh3WNfXzOFTJWJKhS6/s8KuE0wypdRImyz1AU4l
 tWQzbML87Gr7n4trE7zsfcbViJrIFNP1LAM6Mfnm+uVk8tN2M5lWjN3uBeQuVZo1zaZ934CHbAH
 D7JEGXIW5ezKxd56ac06zSBi9tHDSvCMUCKYKXSauILCTJGRuWSIzu6yedPCnv6oz0bCuhZV01z
 Ne70Wlnz3tU4atyjzh4m/ScwZ1Bw/vp+IHwLHAcnC0WO6uMswKQOj6v3rjvpAhcll6A+MppI0ML
 tD4JIgP+h1Bhe2SLGXHGFvCyGfEtXHt9D8gyTPDkn9t2CbqyuQwEnKlcGmp14B8cHLwEbnyIAsw
 TU6xBwuL7dQGYMoLhLfQzizwDhSPfE2O+B5/6Ns3xBIEWAyCyxZxABMStfiwtKpqovn371X6S3D
 FvVPwTXq7KNJ64bL1qA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150092

UFS v5.0/UFSHCI v5.0 adds HS-G6 support (46.6 Gbps/lane) via UniPro
v3.0 and M-PHY v6.0. These specs define TX Equalization for all
High-Speed Gears (not only HS-G6) to compensate channel loss and
improve signal integrity at high speed.

For HS-G6, M-PHY uses PAM4 1b1b line coding. Pre-Coding may also be
required depending on channel characteristics.

Document vendor-neutral properties in ufs-common.yaml:
- txeq-preshoot-g[1-6]
- txeq-deemphasis-g[1-6]
- tx-precode-enable-g6

Values are per-lane Host/Device tuples (2 values for x1, 4 values for
x2). PreShoot/DeEmphasis range from 0..7, and Precode is 0/1.

These are board-specific signal-integrity tuning values. They depend on
channel SI/PHY characterization and validation (host PHY, device PHY,
package, and board routing), and are determined by HW/PHY designers.

Although UFSHCI v5.0 supports TX Equalization Training via UniPro v3.0,
which allows host software to determine optimal TX Equalization at
runtime, static board-specific TX Equalization settings in the Device
Tree are still necessary because:
- TX Equalization Training is not supported for HS-G3 and below
- TX Equalization Training is disabled on some platforms

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index ed97f5682509..145a6416e1df 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -105,6 +105,61 @@ properties:
       Restricts the UFS controller to rate-a or rate-b for both TX and
       RX directions.
 
+  tx-precode-enable-g6:
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    oneOf:
+      - items:
+          - description: Host_Lane0 precode
+          - description: Device_Lane0 precode
+      - items:
+          - description: Host_Lane0 precode
+          - description: Device_Lane0 precode
+          - description: Host_Lane1 precode
+          - description: Device_Lane1 precode
+    items:
+      enum: [0, 1]
+    description:
+      Static TX Precode enable values for HS-G6 only.
+
+patternProperties:
+  "^txeq-preshoot-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    oneOf:
+      - items:
+          - description: Host_Lane0 Preshoot value
+          - description: Device_Lane0 Preshoot value
+      - items:
+          - description: Host_Lane0 Preshoot value
+          - description: Device_Lane0 Preshoot value
+          - description: Host_Lane1 Preshoot value
+          - description: Device_Lane1 Preshoot value
+    items:
+      enum: [0, 1, 2, 3, 4, 5, 6, 7]
+    description: |
+      Static TX Equalization PreShoot settings for High Speed Gears. These
+      values are programmed to the corresponding UniPro PA layer attribute
+      PA_TxEQG[1-6]Setting. Each value selects a Pre-Shoot level as defined
+      by the MIPI M-PHY specification (TX_HS_PreShoot_Setting).
+
+  "^txeq-deemphasis-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    oneOf:
+      - items:
+          - description: Host_Lane0 DeEmphasis value
+          - description: Device_Lane0 DeEmphasis value
+      - items:
+          - description: Host_Lane0 DeEmphasis value
+          - description: Device_Lane0 DeEmphasis value
+          - description: Host_Lane1 DeEmphasis value
+          - description: Device_Lane1 DeEmphasis value
+    items:
+      enum: [0, 1, 2, 3, 4, 5, 6, 7]
+    description: |
+      Static TX Equalization DeEmphasis settings for High Speed Gears. These
+      values are programmed to the corresponding UniPro PA layer attribute
+      PA_TxEQG[1-6]Setting. Each value selects a De-Emphasis level as defined
+      by the MIPI M-PHY specification (TX_HS_DeEmphasis_Setting).
+
 dependencies:
   freq-table-hz: [ clocks ]
   operating-points-v2: [ clocks, clock-names ]
-- 
2.34.1

