Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7C1248893
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381859; cv=none; b=ODkMHjkctJI19uO9PLbVxfW9BmRfdqt6IjFpPtovpR0JwrrrayE8F9bD7WFFBQ6x7HyK+urvfxWo3fLyhKMN7kFU6rGZeT6E6IMPtsj6W+G1ecOrIXMoUcWd1WGnHvyaX7JqoXZ9AEEsXGmVPqXK/+WDTshocnET8bbIFxUojYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381859; c=relaxed/simple;
	bh=qjGkXyff0JOzXHAVjFAg4DNaOzEfBoQYUyu5QmS1S7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hb4cW5fHhiXoyIY3FbyFH1f8+AkKWu02YMuHEmtvwBfWM3wITJ61MlmuVs7URgv1NsAKhOVEfIaBsGcnbKKxaycQGxx2f4C7/H0mFy6wxXRAbm9w6QTdOY817Em06F4vv2DGawbm8GeYDD0dDYN54BmmThPD4Jjqb2TjBqJyhJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YJcxgI8c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NvwvFq/s; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YJcxgI8c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NvwvFq/s"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BAB6FsG2419757
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+rUCr121SZ+QerPYflBRYtTCStaRS4LPAaBzx1rPUmQ=; b=YJcxgI8c/0JePLcl
	Gw2od2t9DwnaVf4yvQGjLt2Jexl5QtiVQqAZREIQjZ7fMDcjkcMTuNkUXLeWivbz
	02sxMeDB63aiLUX9W2v91LVBTkQQVdAhxQ1FEK5pMAuW+m07TTPjXIy1cG8395+A
	4y6HSi84gitgPorsuzRiRGtGHr6q+0vtY3sKt7TWu/WgYOVc3BZpCmkA08LtyjN5
	wr+s4dd6HvgZPsvLBIBMLavU2k/90SUrw1qcfTIPAyy/c1O4Lz8sjWpeVBpAmhwi
	aZ+zxdtWgoBGKatyAToQ6GyhNLbE6cZWaDk0IDNrIewQ6E7AGDWwS0BNrQyshKj9
	u0HDOQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ay7pp0v1u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:55 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-297f8a2ba9eso143638115ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 07:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765381855; x=1765986655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rUCr121SZ+QerPYflBRYtTCStaRS4LPAaBzx1rPUmQ=;
        b=NvwvFq/scNTyASHWb1QN+iqrtTs8s6p3dUtqUi9bV5eev8kna+n+FJ6p+n5kiW6Mc+
         Cu0c/VlmmywBpSfcMu4no1TfJZxjMDSPbvvh2Fv3b1PXnmCQYo5fetsQS1rSc8Mu0yP9
         Eq2iu85GLFopwnPURRZPWdVLn9asVTnm7ALy392I37tL3vAtUkkHOojgPFac8iCd7CZ4
         Tp+GrRMmNzgqeFTYtylC1u2VzvveNiwYCGIjWnJvsrt4vpUEUS0D6ucoDhWDY7haHzrs
         QN1i1az8UvwcvW245EILGNf/U86zn9VvmGzMOvEamTN7zBJ3nQAUr4ZGir1qCZAOMW4i
         dIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765381855; x=1765986655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+rUCr121SZ+QerPYflBRYtTCStaRS4LPAaBzx1rPUmQ=;
        b=O2L79Irx4r4J4e9LtombYz3287l8PVik0+/ubClPGCjpt+33BeSsobtPef7I591kdU
         5jLqgqQvKWUEFJFOhFbwgGCivGHH0+baX0FZoXfMRauidszgAYZiSMV92U90Zg31wgKq
         oQCXoiCfxUuxRyAqiKnHBNEDYst9fEVz8RaXA39WH6etO6qYENgjgNjbAgan0inQrHL5
         vDkuaz0cnzRFx/9VBNzsIKz1+VmM2ib16DWIuYy+MRALvbHaHUXj6NOxE5Z9VDwHquSZ
         YP3t6bqqdZCp+e6kB2Xb52CgQ/ryzZ4kQrYsUobA/1r8da6UFCpmCBOAJRcEclltLbUu
         jqyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfsPIkaFE4uq58oRHtBiddDn4qsSWK38HoY4j9AiOjcOECSdLA0k1ySQ7mT+r8ENbZyJLO9QSe7HnS@vger.kernel.org
X-Gm-Message-State: AOJu0YyEKpIQv62X7xEk0fgvViC79+3YS4aaD9TEW4Zq78eJ9bt/gInw
	BsbDdUpUP3xtkNnFPUdebpgNbn5wf3s+T2IFSUjc2MRV2yu6KGuOE1vjwSwzR/QIWCtO3HshDaX
	evQs+pDZZeJFyoFhdnak2RelSOOnTuJlYlr75ZSFL/ovHrrsjzZKp1g5EXIfHO2As
X-Gm-Gg: AY/fxX5SPdII2PO+TiaqK/YfgRwMRPBvD/tavIHja1ee0RAcTg+8VHnGmADDvVmlxTS
	riMz8+Qr6chIRHHXX+dtptcTwpPUoBnMrhuCN+84ZkD17DdCjQyencFKKJ/xBQdJFNxAtQjLVyO
	1In7jd5j+EQzAjCcJJcqEcIB9KQaLr4mFHaUUQaUDjm2YOyosfw8xpFQay2Iu/tWcwgwOX6tvtf
	8FgWB2nrmamDNglvI/2eXs7QNQv/IoAUg6OI3jA8GNMK8edhv7/zwKIEbwE6En8gCAgsRF7pRQA
	mJnjqSVFGoE+cfeZagEcxFOeIaBOl/0Llso+PS+jqbQ1zeijrdRzgkLy2Mw349EKTzN3QsXCwR3
	38VdkfImIF/dXWOofSpMwX5J7hXZlh9uYpToZP1AZ
X-Received: by 2002:a17:903:178e:b0:295:596f:84ef with SMTP id d9443c01a7336-29ec2d3516cmr30281095ad.31.1765381855063;
        Wed, 10 Dec 2025 07:50:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBZg3CDmb5QXrh/vHnqknn5K8usGXHeluV8lbexssAYjUj5YTX6hrPcmb2zIpMYU2GXSoGfg==
X-Received: by 2002:a17:903:178e:b0:295:596f:84ef with SMTP id d9443c01a7336-29ec2d3516cmr30280815ad.31.1765381854620;
        Wed, 10 Dec 2025 07:50:54 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ed93e470fsm7780175ad.41.2025.12.10.07.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 07:50:54 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/3] dt-bindings: ufs: Document bindings for SA8255P UFS Host Controller
Date: Wed, 10 Dec 2025 21:20:32 +0530
Message-Id: <20251210155033.229051-3-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251210155033.229051-1-ram.dwivedi@oss.qualcomm.com>
References: <20251210155033.229051-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: USyiPRNTBaDCXT-JPSSjU6rUgMBFnd6t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDEyOSBTYWx0ZWRfX6HmH0OUt/Nft
 PlY1jmItafeD7wCSy3pHPRxYhH6glqFHJrL0yu2I+SH10gM5uunCnuJ+/X6oM0vjy09/XPm4HQu
 IjC9tt+5nmt6eNR+hZhtVIrWTWpgn84Oeh+EU9sGsxQTvFNs2q4Eg+iHU0eHtkwLvjvbVBpMYnr
 f1xgNL69tD5CVNuz8T3Dv2c3G6j6yfsesU6grfjtVlCu9g3dnCkMpCPGOqtWJ7KRfmPXqs4xQRz
 wEF4zFOL44cowffHemHLNW2p+E6PURf8bbzcE+k3yVw+77zyBW8cQezXvocDxd+wTfzG7NkqLYJ
 74vPTi+ScsU/Bt5lQ5G7GglLMZEmYbNZKXGjWdplKpI2a+vRjl+zuRe6VmCoJyI/KUjlyHZE4tU
 L5JsIpvZHqqWUTJ1rwlSHN8kjdI9yQ==
X-Proofpoint-ORIG-GUID: USyiPRNTBaDCXT-JPSSjU6rUgMBFnd6t
X-Authority-Analysis: v=2.4 cv=WaMBqkhX c=1 sm=1 tr=0 ts=693996df cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gEfo2CItAAAA:8 a=EUspDBNiAAAA:8
 a=VcM-S10TGioI4za7RKgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_01,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512100129

Document the device tree bindings for UFS host controller on
Qualcomm SA8255P platform which integrates firmware-managed
resources.

The platform firmware implements the SCMI server and manages
resources such as the PHY, clocks, regulators and resets via the
SCMI power protocol. As a result, the OS-visible DT only describes
the controller’s MMIO, interrupt, IOMMU and power-domain interfaces.

The generic "qcom,ufshc" and "jedec,ufs-2.0" compatible strings are
removed from the binding, since this firmware managed design won't
be compatible with the drivers doing full resource management.

Co-developed-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
Signed-off-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
Signed-off-by: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
---
 .../bindings/ufs/qcom,sa8255p-ufshc.yaml      | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
new file mode 100644
index 000000000000..ec006f7de752
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/qcom,sa8255p-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm SA8255P UFS Host Controller
+
+maintainers:
+  - Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
+  - Anjana Hari <anjana.hari@oss.qualcomm.com>
+
+properties:
+  compatible:
+    const: qcom,sa8255p-ufshc
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  iommus:
+    maxItems: 1
+
+  dma-coherent: true
+
+  power-domains:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - power-domains
+  - iommus
+  - dma-coherent
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        ufshc@1d84000 {
+            compatible = "qcom,sa8255p-ufshc";
+            reg = <0x0 0x01d84000 0x0 0x3000>;
+            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
+            lanes-per-direction = <2>;
+
+            iommus = <&apps_smmu 0x100 0x0>;
+            power-domains = <&scmi3_pd 0>;
+            dma-coherent;
+        };
+    };
-- 
2.34.1

