Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939A63F5BF0;
	Wed, 27 May 2026 14:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892878; cv=none; b=qlUUeiDBbh3AARef1dNk6hoKGHxpyuzmzMJHXzhCmed9DKP/pXcHluMQ71EsYL9Ffi8OajDzsBoK+NLsqS4MRF3e3Q3XAUWeSCjYHNu65UY/40PwG5zZUegNpknHXnZsyzmK9yxPmOm0cFW5sNx5AY3gzQFPoF7ADikS3NSIw9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892878; c=relaxed/simple;
	bh=dN/RLtT+6/9gmHXR6owgk5iD48ePezSvPfSRRAbC83I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TKo5mTSS2fFy3J6PS4s4n19TyF4GQ79TL+pvaT4dRNTAW+gmlND7pg+1QAp4S4Rn35uiHaR9Lh+uRxmcl6Z6komJ6O/sYV1y9nbour2Dn6rBaRQ/ymx8v1RYCxlubnCyPt8e+m8o12uXnJ/kmGze0WK65KJyng7SRONW7QpJRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IAmJ+IRZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IAmJ+IRZ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RA6X7B1149323;
	Wed, 27 May 2026 14:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Dc42CakmYY9
	U1haqvQWozl4b3JvrF5IPYu0JQwZLVcg=; b=IAmJ+IRZlNBpVTA8mKyURkPu9v8
	PanpaV6kk3F87Wx1uF1x/UOr4AqETidTsGfZc677gSwK5JhagR8x5nMMNSvyZBO3
	0Mxg1W7F6q3JxuOnmdUGjLWdJxlBUKo/8+e04hK8q2ncofHl/jBZxLUXRR/HDyHt
	fRmpZXZb7guNT8/5xN3Gq5uSqpQdeN1U0OPuCGpde7qr8tN8gh9aJs2OQQHyt4i2
	ONp6lfqKr4TSim44qywcXbA5RC8zPkcyhFpKArbMdT6Hd2xHKF900j2+o2xY/Auz
	kapQkIQQemCtPgl8Sy1Pimpa+qQPlz98pOqir+vGqiPZCtWw5XjsXj6qTYg==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4edxjsgxaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:41:03 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64REf2fl009637;
	Wed, 27 May 2026 14:41:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4ecnabf4ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:41:02 +0000 (GMT)
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64REf2w0009607;
	Wed, 27 May 2026 14:41:02 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 64REf2dr009573
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:41:02 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 2CEDA631; Wed, 27 May 2026 07:41:02 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Zhaoming Luo <zhml@posteo.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Wed, 27 May 2026 07:40:54 -0700
Message-Id: <20260527144055.2758170-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=C4PZDwP+ c=1 sm=1 tr=0 ts=6a17027f cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8 a=aytFPfgCXfsv55HZsIkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0MyBTYWx0ZWRfX8Y5lLJpm1Otk
 SFa07t82VyxBe/+o+3uoDQ2RfRp//PrDYsVogDatBC+8nU3Y44Mb6JnaDYpxTsQLN+rIQ4TcB5U
 dmendgSV3ObnRxrCvlfrkzcCoMYNr9/Xl2FkoUJmx7f4x0Cv72Fyy/v5KkpPgP0m8DlowR50gGN
 5rQWSN4OdE7cPg6JZQ81MaOzF1u/qkkLguPlXvYXDbcfJ1Q81hiyVeOGskQytx7/qXbyaMFm+j9
 ucm1wgmCmdO7bHox3HJzNpXhr4dzPXPFglyPri9uiy+cZaj658E9ytuyrMKrsLhljomYqHSZG+T
 QfdynwFvtBw2UrXjAmc3o8Dt6lJdeQa96vmQK2+bjDjWqL0mr10MM+qaBH8j6+3m6OqXEDFBhxx
 eTs2QxE9DeuSPitfGFN3peQN4ayv+BgN/lsAkp+3DdJH12gmR4b81XnTBOgU9ljLSrfTfShveeG
 DcfPSYF5ybbCV9c9urQ==
X-Proofpoint-ORIG-GUID: tYsse3Bb_fQUGNN8BENsW4vHZmdTurwi
X-Proofpoint-GUID: tYsse3Bb_fQUGNN8BENsW4vHZmdTurwi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605270143

UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
and M-PHY v6.0. In these specs, TX Equalization is defined for all High
Speed Gears (not only HS-G6) to compensate channel loss and improve signal
integrity at high speed operation.

For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
required depending on channel characteristics.

Add vendor-neutral DT properties:

- patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
- fixed property tx-precode-enable-g6

Each property is a uint32 array of per-lane tuples:
<Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]

Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index ed97f5682509..d90cf25adfa5 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -105,6 +105,51 @@ properties:
       Restricts the UFS controller to rate-a or rate-b for both TX and
       RX directions.
 
+  tx-precode-enable-g6:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    oneOf:
+      - minItems: 2
+        maxItems: 2
+      - minItems: 4
+        maxItems: 4
+    items:
+      enum: [0, 1]
+    description: |
+      Static TX Precode enable values for HS-G6 only.
+      Values are specified as per-lane tuples:
+      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
+
+patternProperties:
+  "^txeq-preshoot-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    oneOf:
+      - minItems: 2
+        maxItems: 2
+      - minItems: 4
+        maxItems: 4
+    items:
+      minimum: 0
+      maximum: 7
+    description: |
+      Static TX Equalization PreShoot values for High Speed Gears.
+      Values are specified as per-lane tuples:
+      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
+
+  "^txeq-deemphasis-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    oneOf:
+      - minItems: 2
+        maxItems: 2
+      - minItems: 4
+        maxItems: 4
+    items:
+      minimum: 0
+      maximum: 7
+    description: |
+      Static TX Equalization DeEmphasis values for High Speed Gears.
+      Values are specified as per-lane tuples:
+      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
+
 dependencies:
   freq-table-hz: [ clocks ]
   operating-points-v2: [ clocks, clock-names ]
-- 
2.34.1
