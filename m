Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B103D8104;
	Fri, 29 May 2026 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780054451; cv=none; b=dkl6Ljfxub01LC5LGRFtlinmzTfJv3JTeD1B9b15+tZqOAJrANGjZvSoOqXZrpVTo0GMIyIqrriBXWUcHZTmBlr+usC0EpG/NFGOqev6AXOBdmEciSGXMFeSCLY6vVQBIEKu8DfsCo1sfxRx+xZvjBOg+6m3n56lpD60Tf5Hh9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780054451; c=relaxed/simple;
	bh=u5iCouWbN8CRcqvx9n1/Cr9P+BiSqvcV37Fnh8q0wRA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HDbw1dQ+RXohgJLjS/g9+WcUVGgGF6MLooi+xOCAJ7Xdcm5kcwk4jMcNiJBlUeKv4bcPWsort9lM8Xw0gqVAm+mm0F3eZOm52dNTdioJDNhYrOx0RhVeMkCBmyiHaU2xuvXZbXOoJ366x4PtNHGmiN5RqXWCtmieMfrFT8UyaCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DrBErj4/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DrBErj4/"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64T6hTcI1386301;
	Fri, 29 May 2026 11:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=EAfM7s+mpYN
	DbAPjmSVR9D6/MML1U3SzvdduUy3krA4=; b=DrBErj4//LD2cXgDYWByMnk+Q8w
	xjOnfhsDPCv49O/djJVDFBz41ELL3Rx6Dso2v9/xWrACHcdG+UItZ+vxv89aADFw
	uSQcqO/2ssvkUElt0Xu6BY3THZJBnXGcS7SZBpzWdqdHxqqCM538kDQmQXn9NNcf
	HhOnN5zbgOJ57zjV5sp8L25AhT+vNOWOy2xov8Qcp8MLfI2AslM44lhmy/4AWLC/
	s4/Ldw5LmL2IhWMl/C45ieGObJQqwxKNDfC7rGNbYgOIUIqFBHUiSKzxdXel4IWk
	Lxh1gKDIfbGDkf4SMz7IUvWvIbn4cYAmobi9f163SBf56C77p0gvxq8jBkA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eevumu9db-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 11:33:45 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64TBUZFw017010;
	Fri, 29 May 2026 11:33:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4eej1su6fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 11:33:44 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64TBXg63022056;
	Fri, 29 May 2026 11:33:43 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 64TBXfWS022045
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 11:33:42 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 7058A62E; Fri, 29 May 2026 04:33:41 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Zhaoming Luo <zhml@posteo.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: [PATCH v6 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Fri, 29 May 2026 04:33:37 -0700
Message-Id: <20260529113338.984301-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
References: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: lPRjIg8uOo1OveVchCIwUfKqixZbYdU_
X-Proofpoint-ORIG-GUID: lPRjIg8uOo1OveVchCIwUfKqixZbYdU_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDExNSBTYWx0ZWRfX9F0R6ZrrYsIq
 4ONnf4Jdd5eP01z4c+6wp/lF15a4V7EaDmMZKRz+R//oC/AwQD49r/4DUYNszrncoXaIw2AAQcV
 px6tcthNDSp4Wu+aTMjGZmUrGAl0dVC93afMrIp2UOcmXhTxuJfq0jvMqkuTQAJTqtU3z31xbDU
 pqWA4pfMTb62IQCZmYf29AL2GA/gUvG9A/QFDzthNjL5StTFXFOF6iZRP94Fb/4cG56zpUK5L1N
 uyxa5enpGTANRLbm3v69ckkbWzi5fQABs9GzRmQrDB2jDUnqyzTmsxhkYvZrDwvGUbl6izv6tiR
 frjzVggvaWf/4cpZtvVks7UcN6UUGhktgq1Rp/mRAel+0n0UIgAsejMSWqQiHP7Met9WJvXzVw3
 JdMBPeGjwsAdqnvwo5rG9ant0sbQpX2ThMGQ3ZyAzjyaZ1aUQxuwafE1Kq+pIK5GykiSDqYlNlJ
 F2w/2dlbEHEa9Lr5lXA==
X-Authority-Analysis: v=2.4 cv=cObQdFeN c=1 sm=1 tr=0 ts=6a197999 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8 a=PY6Zn8H8AAAA:8 a=mpaa-ttXAAAA:8
 a=EUspDBNiAAAA:8 a=aytFPfgCXfsv55HZsIkA:9 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0
 phishscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290115

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
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
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

