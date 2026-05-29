Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882161A0712;
	Fri, 29 May 2026 01:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780017290; cv=none; b=R1jAIjVqKEhtz4AUOoyJlxnvQCTp4JmYlUAFN6GiBVVwJqcmTdZpTCx0ZwKVLWF0XKICk9RWPOMhATfwrdx5joPKsHKc/sTlwTqxeTeOx/MRT3uFor4yDgdIfmWh2ndB0RpZ13uJjQL3cAexsuEdZ93Fa06EI9lLSBkqyuHm0Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780017290; c=relaxed/simple;
	bh=A5eVm2EomAXESPEiIozIbCihaI9GvyGNZU4/Pp3SvOs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T0oaGX6OzvmpQ4Tsl7ZlWfDbKlR51tSVw/Z7po/FweFViPobr6NByrJd1L4oYInQCh30h6Jp5lFme0mck6dXJEbKfjrOnmJvZJWYn7bNbi4D3ad2XVeR/WevWneyUMs0dzI0l3DPyUL1sjkfgY8MKr9BxcE97+sTmVQJQjbqGWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=amnBQN2y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="amnBQN2y"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64SKkS9f1540317;
	Fri, 29 May 2026 01:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=K7q7nnq8/4z
	atjMsZ7NJ/bqTAUM0L9LxlJKB6MIO7As=; b=amnBQN2yzBmLQ/VU8zBOnIsMpnz
	u3bx0/FIiyk9Bw78J1gIMVKbfuL2JDErKUaQjC2Tu7L+LirakZgXdD7ornsPnVxT
	Wdore9dkz7gODdYP2Rp21MEm3I21CaUD6v0rNXiKbSmBCMWicU2EfL7xKu+uDdUG
	s8KAMsg3UGJQ2CAFth2TEymQbuzr4qhZ0GX/Do6yRPPizild8G41d0cuqQYh3FI1
	1QdoXHhJfdidQ/XEVNcx6NYkBmiJ4CyI5H7i4VPOtxfzo5vCCsIES2IYT0tgf+ld
	ouB7yZcCcS2yTaAOzKx7FBNhyun/MW/fNzfkbEO9V1KxBATqnLvkpxF3XgQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eety4skkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:28 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64T1ER7f021355;
	Fri, 29 May 2026 01:14:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4eeb0bhfsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:27 +0000 (GMT)
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64T1ERCu021348;
	Fri, 29 May 2026 01:14:27 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 64T1ERFu021343
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:27 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 00D9362E; Thu, 28 May 2026 18:14:26 -0700 (PDT)
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
Subject: [PATCH v5 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Thu, 28 May 2026 18:14:19 -0700
Message-Id: <20260529011421.462046-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-ORIG-GUID: d_t8S2vtPMHeVSfcSa6HKpVFmWIjKZkT
X-Proofpoint-GUID: d_t8S2vtPMHeVSfcSa6HKpVFmWIjKZkT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDAwOSBTYWx0ZWRfX98G9HtCP8V5H
 WvAhbNtdNXPZkyizb/Cn3BzQs3jHG3pNpKUwRYY4QGzRkSu9z38HP0qhEE81D3CLZVNchPtJuyu
 BifX8QSYu0YxpQDJUrygtSXYw7raSaLanebIsvCl0f6ykPcKfqgHWg57EFPEl5227dgRgX0FEXC
 eMlgPf0bWk8D7KPYXY1UNMiXSsiRiq8yVskkbp/qYoVl8seNnWiQsL0pmqsZUuYC2iXt3FSPO8C
 K7+wzT6RuFfNYMrR70jfztZe+H2fUcSDE6MKYxjz1eBUxxcoJTWv3eT1JJ4qxVsROATwO3JAMjS
 K9iK8qxaH6h8weD3wsETYajgIGNYG5H76OSBobSXGywt2XPSaKql5JoHbqFvplgpyr6xDSr691V
 gHH9U8PcG3XXP9LwvS3vjAz9bMw36JoD1YkV2DGo402ID6XrbU9yPhONmsSh2cOZb7GFGXMn/+G
 C1atCBQuxD8A30qfHcw==
X-Authority-Analysis: v=2.4 cv=S+TpBosP c=1 sm=1 tr=0 ts=6a18e874 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8 a=PY6Zn8H8AAAA:8 a=EUspDBNiAAAA:8
 a=aytFPfgCXfsv55HZsIkA:9 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290009

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

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
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

