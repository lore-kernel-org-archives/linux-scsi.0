Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB9F2D8DD0;
	Tue, 16 Jun 2026 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781609652; cv=none; b=jgMRA86uIiI1enKUXCH7N+tbMcNYrgCfNn3AAUoHiHbe7IEgZ4MZrgeD33WXpriKquANF2xyu+S/l0KFpakeCuA3WwX8P7rt9Nt91paYGbFGdTLuUlo42DHq/CbBbiWaU73dahz+rRMDVEr6X1xnF/ITxYhuz1sS9aHEfkHDg24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781609652; c=relaxed/simple;
	bh=CL9iSNo6Gwr0ZBggrG8RUS9/Kutk/ZqrjLdbhxbCzXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HyXZacZQJekpMUdBE46u0DOjK3jIlBbtO3KF0IoKxH0rskcdmhzTvzrQAkJQToKStSVy80CVT7pAcPB+U0gtevLBbgZJQG2O1PaOVfEjpouXNHhalmdAaRzv6TYz5Ci4P1VjvJWHnVu8rA/HQxGFmgXbUDgsJUtDnlBxpbzaMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iynEmIoT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iynEmIoT"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GA9Ckj2893402;
	Tue, 16 Jun 2026 11:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Lt3LqJwPP0c
	V17oxSnsW76l/WW5Mel1VGCC3Vf/WdSA=; b=iynEmIoTAo5AufBw83CgKRzR7Xo
	Zct7DLuk+zHJII8rbe02xsbUya7BXFmxnPU4wJOvVnv5elUXCfbjNr/qPsdrq4Ya
	DAHayhuWgVvqnKrPi8u3SXR6ZKfZTamIqeNv3kzdhQvGvHE8zSBLmD355kJPaXjI
	zlcm/uYKBA/Vio6AhMjmHViqddyfqdbFYAaf7LI2Sdb1E94WTcIje/umy1YnchCj
	k9dNxzRz49CFbMSMEADBxIZq9FPwhm2fj9wCp3sGe4mcXKqimS1Ge+usnkOJELGT
	7sWYaFfGVRvFxWjkA/cxs3equwu7y64S/4KoB1wOlfILHKmKCvIdg2ZNRLQ==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eu253h0ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 11:33:54 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65GBXrWR015212;
	Tue, 16 Jun 2026 11:33:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4etk1at1ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 11:33:53 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65GBXrmp015206;
	Tue, 16 Jun 2026 11:33:53 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 65GBXqnP015205
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 11:33:53 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id EA8A1654; Tue, 16 Jun 2026 04:33:52 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo <zhml@posteo.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: [PATCH v10 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Tue, 16 Jun 2026 04:33:47 -0700
Message-Id: <20260616113348.1168248-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260616113348.1168248-1-can.guo@oss.qualcomm.com>
References: <20260616113348.1168248-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: wOytt8lAaXQ1_vZuW7vrt1lxUzU_RXYu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDExOCBTYWx0ZWRfXxAjkYJemLrO5
 rS8BVLG1VDjFFrVn5pK4GGsekYWv2Vo5+E0+0eiZP64ZqzHecHIQYdE9F8UsXfE/LB2RdVidMgV
 abhw0MD3TuTRXJc0IYSiDPIjNBjtrtk=
X-Authority-Analysis: v=2.4 cv=WNdPmHsR c=1 sm=1 tr=0 ts=6a3134a2 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=mpaa-ttXAAAA:8
 a=O1bjOzfcQfNXtJdNm1oA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDExOCBTYWx0ZWRfXzVR853ZNXVWs
 sBuYWyMyYemi/UXgfAWlqBnS0RM6KPCSP0XZmsqAUirpmtlnVjUgD9mNvYWo48TRtLHtc50IkOy
 /UZ8/95L48fcahhrBuvqDc6GBZ1mAVtNtjzo7PqZACUeFjylXDYulvv3Re2lC0EBinj+McYRVCC
 uA4AcInoZOqqpxBECdh7NBLMAuetlafl7HXQA0I0QFGSgHLFq+uJD/E95hXIobojudPke6dPt6V
 31u5GsL1vl+DalWoB1OeZ8IYBRO2+ou8NiQSneIUjDxFiZa1/FbFhqiGWhweSyBA7sVanmIOpMn
 xOwKpspTD/25N/QKwbnWR2C3vAnRM9b78MifwU87C+pnQ7rp3RDGpYXW3OnasZSAYVUHM9YbZhW
 kI3Gf53vjaAHAlNTnYf0hcCPUH8Ap5awwygq85iim8Om9S1ievvWVfz94FQ/7AFzH0rWtrtVFBw
 pt7xNg5BZTAJ9QqLOaA==
X-Proofpoint-ORIG-GUID: wOytt8lAaXQ1_vZuW7vrt1lxUzU_RXYu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_03,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0 clxscore=1011
 suspectscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160118

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

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index ed97f5682509..cc32e1189d50 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -105,6 +105,64 @@ properties:
       Restricts the UFS controller to rate-a or rate-b for both TX and
       RX directions.
 
+  tx-precode-enable-g6:
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    minItems: 1
+    items:
+      - items:
+          - description: Host_Lane0 precode
+            enum: [0, 1]
+          - description: Device_Lane0 precode
+            enum: [0, 1]
+      - items:
+          - description: Host_Lane1 precode
+            enum: [0, 1]
+          - description: Device_Lane1 precode
+            enum: [0, 1]
+    description:
+      Static TX Precode enable values for HS-G6 only.
+
+patternProperties:
+  "^txeq-preshoot-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    minItems: 1
+    items:
+      - items:
+          - description: Host_Lane0 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane0 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+      - items:
+          - description: Host_Lane1 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane1 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+    description: |
+      Static TX Equalization PreShoot settings for High Speed Gears. These
+      values are programmed to the corresponding UniPro PA layer attribute
+      PA_TxEQG[1-6]Setting. Each value selects a Pre-Shoot level as defined
+      by the MIPI M-PHY specification (TX_HS_PreShoot_Setting).
+
+  "^txeq-deemphasis-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    minItems: 1
+    items:
+      - items:
+          - description: Host_Lane0 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane0 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+      - items:
+          - description: Host_Lane1 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane1 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
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

