Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428B39A805;
	Thu, 28 May 2026 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962815; cv=none; b=ND+6hF1pFJuDVm1KRmfjpTDADTcUlQiF8KpdeP5Tw91d+8M1T2FVaMntrFArsZvLln1QhIBZXCU/nmweMljZBh1k5c+YrmsenIupHZHMt1Vrljay0ZrXRiW+Eh2yPUgvdSDIOSE0YSEgQFKJwkXZeMxWyttTC4R0m2xWljQ0ViQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962815; c=relaxed/simple;
	bh=cEGUrQn5zfSHcZel1YP2AsXMaFm37TEl1+M+p4EizJo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gWQTHNgtbnshQRXGbvD+jITC3BftxXkbyZLcP0cjNjuYjLZWUoNtBT40hWqBBzCT4I28Kn9+zzjeSV2cXhRl1H5EUcTnBAyLxNmCYjsaCmfbjDgemVoXuPLbuNXf/580rna/wU/cynxgAlv2Sd6BBq3SqS8ROUEA3gOQaYa3O3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h5lYngtS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h5lYngtS"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S8vaPH4016473;
	Thu, 28 May 2026 10:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Z9fHghHvoMM
	TbEf/iS8uDXDn4ErwJXgkPHYYxFOsCkc=; b=h5lYngtSqXBZAaDsMIraNju4YAm
	qrIld6lWYawjVTNK2WShVdRENyGgewiQ7+CA7cOQplMsjW7UhtBr9A5MKCLR0aFb
	uJ0hCk3QWd/QFLccIlN2Ga1TyJByRn5urQD29cWLSaSVHZK6rNi/+1xO0YRpncUJ
	hjPHUkrDdM9+IkOjBVikAN7sxbOtasxXsd68gspxKjd3TdNCDh6nmFr1YhLEEEv0
	nxGsTR8nZRYRB1S2qrTikrehMqd+w1yR+B9XGfNtFF4Iv1zV7cy5unUPnt9ma6tq
	r52rF67uLrv6xTZkTTpxJ4XzNO7lz6V9/e7MFinQ5Ds8bmCljqE8swpotEw==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7y5aagt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:21 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64SA4iUN013336;
	Thu, 28 May 2026 10:06:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4ee8c5cx5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:20 +0000 (GMT)
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64SA6JcW015375;
	Thu, 28 May 2026 10:06:20 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 64SA6JH8015374
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:19 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id B142F62C; Thu, 28 May 2026 03:06:19 -0700 (PDT)
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
Subject: [PATCH v4 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Thu, 28 May 2026 03:06:13 -0700
Message-Id: <20260528100614.3386423-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
References: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=OM4XGyaB c=1 sm=1 tr=0 ts=6a18139d cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=aytFPfgCXfsv55HZsIkA:9
X-Proofpoint-ORIG-GUID: sXGDQFHB6RyLDwWOjjA3dF4vxS7hh2JD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDEwMiBTYWx0ZWRfX/KxYpt9YL62h
 XI8qFqtiE/Qv6K6KkL3Ka7BkjEgeXJLAZ1rgv2LioQICPMlEBFG4qeSPONEY6r930O9xO69CN7S
 1HVjOzuM2BBbXYHTAXjDwmf8pKgRzrtgXr1cRZ4ksZfdrH6G1DzuAYa3RPZLo+yKRK/KrCj/7gi
 II+2iVCq9Dt0D71dU/3JIL2wRA0sN2ujhpaaAGrhhmMb4yr1cgXI8MWA8Ju88+J5JUwFCIPk/Ou
 210hTwdgyFtxUZ6EfnsE4VzsYKSCnW8jXoYMk/7Rld7EisBfuhsjl8ZK2CxdFt46Zzunw3sBuaZ
 ZfNrbvSnKXCc4p31b/n1vI+jVmWfq1fIkaN3fQ5OsgGUhDf3nlofEbb7b2+OqC00dKCVksVva6q
 /Cl/BLMhGJUtXQBEgZP3T5Tr9sF+saYw4fhjaIZa/+uAJmQN2ELsXvh/WoMcWSk5MwMt07vQV7e
 Ll4rQMlnyPjvFQGuqrA==
X-Proofpoint-GUID: sXGDQFHB6RyLDwWOjjA3dF4vxS7hh2JD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_03,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280102

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

