Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E1527E05A
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 13:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767706836; cv=none; b=dSCGWcV0h7qnHZNwgVsleQX8g/QHaid7oQLctL5ntTdUJ/Vto5njxOOnIKcexVx/OGgft4RgTUvvwr0zV8BjMRogZqNE8qZd0SrtfdevXsq0hw/8WH7WS3EKj1PCyQmzV4TIuhiDWJ2CFUIJgnDBKwxrKYRugbJs6dpAY3OiGfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767706836; c=relaxed/simple;
	bh=5uw6gWRydAXjW+ZAsJv4BZ7YGg1H6uOcEj2DTq7IL9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HnQd96btDZw28aR+62P9BPYKOzFMig1v3eaEcktu7RstyhCApSC3KzbgSpzUJuAOO8gWwBtaX99gdm785agsjZxMZBrZDKfiNCsvLDlCwv7EFJBlnHjVse3TJ3/nW8Qjb+uAKcOHD3EJhK+fvHw3+dudpjbNrUh1/Ejc8wA0oOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bPVWS15s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=io3NBKX8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bPVWS15s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="io3NBKX8"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606B80Lr3214040
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 13:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YT1+WRBEePyTEwhJQOOMgnw0dcH2eAv+88f4K6Zdi1E=; b=bPVWS15s9aAQmmvS
	2bLyP2pgPDaXY4ZMJx7U5hvvGOEnY1OLm2lQZPRdIp76boCooe30LyqZys7tXqd/
	PalEdR13dVPMqG3SeSPNOXNblBNpsihkvnFNmMklEOjVt411iVh7jCUp4wfeReaT
	tG2YxH7JHQR1o3u+OiAZ3JGgXbn9azX+Wfv6r3JkOKKfey1TX4hKhGcsKLaNXwF+
	zVOQAdJDuER7ZRaCV8I4ctJMwvx6XyEi2F7oM1sf58Y5kTjSSI4GKq8LR6BSrXrb
	dT+s2UqFn/UITtGCOaqAXThXoZUblFEioDVlq9yx3SU4gLixAeKKxLQ8i8RNtvLe
	an3fTg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgpnda7h3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 13:40:31 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b630753cc38so1618973a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 05:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767706830; x=1768311630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YT1+WRBEePyTEwhJQOOMgnw0dcH2eAv+88f4K6Zdi1E=;
        b=io3NBKX8jrpDcljLXlJteREOwsLnNKjvs6AgMPzr4nlLYoJ+tIEAo0frzAN9t1IdWN
         fdK1ikhBY9aAALNuoyEptE5f13Hu7i3ZfbxxTB1A4deJfzqPtPmx2koLTusft5Kc+K9C
         F5JhiSxvWzenIUDwL7gXSjutjzvEFVXAsw5LCy0MSYAOYxn1AKBKfGxYBxeicEg/sDEc
         Iv6xVIZHT9XHNkRUaxMEfUoSMq/RwzhOfjq8uB5EUE1isyxXJI80CGCZzC+yUbP6D9hM
         LCIlLI6Z8nJroOkyrnlIjeO8OtyLIgcvJEnDWQjTK4luz/O4KmeahNd4reI0auMuT3wi
         yaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767706830; x=1768311630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YT1+WRBEePyTEwhJQOOMgnw0dcH2eAv+88f4K6Zdi1E=;
        b=CTep+tNjV2CsPoFnyvW92IJymIznPWdl3p86DG3oWFf1joI6a3lE7Jc2pwcAQ3YKha
         ccRkcN6cBkCFeEgE1I2e+EFQwdI3VWDMkvGZ4GUycGwOhnv3FDAL6YB8HWVMgrDggZrx
         AwOx3LaXVdpIz//tBPljYdwKCxImBHJ29G0Hz/1mBc8UNG395gzIGQP8wBEMXPhK7bQW
         DCpFiOdNcwhpe8PPY2SjvGKk0gIVqbZLL7dU2z71Vgv3t3DjeDc98JOI6NZcwcEzrxbq
         QsMz6DemEqqIZEF3Lqpw7IpoKTEVvZgspRffThmfC5HrOevEcsCaOgGWcHNQDu1F1Dos
         EJ3g==
X-Forwarded-Encrypted: i=1; AJvYcCXMcs9ndCKIRYiCncSh2N8RX5cHtNPcNsj10NXXvC6tcgZBwJsonz0Q/u66fC8CgZPx7SzGoHXHwX5h@vger.kernel.org
X-Gm-Message-State: AOJu0YzN+itJ5rM26D/71/B/QIrlZhT8Ee3f/HFQGVHLOr+iUAp2pbWZ
	F+l1ufP935ejaIZ3uZ5KEdMR5PyHIf0Plxw9fFTHijnlG7tM3Dlsh+2C8191YnlHnpAMTFsoMnH
	Lo5sA5YGJ8gnFZ0eIyO7xMIafyHbFZGnv6aVda/+9Tlw43guZYXPd87WG/1o0BZza
X-Gm-Gg: AY/fxX5xTR359MHIts8WQ5UyrcoGM0DDAlhBLbKxPbSfCzkpOhUgjdIimUPn4MXk5Vi
	K+mHi5+5Cjj/DfasZLKPJ4Q4Cmrfs7W0LMvSQe8kSFpj8/AMstkJa0fAEi3laLzBAbXWo4HdHQM
	BjFkVkEVIkWVaG0dN75+Tfwy6EOQTlk2l1q8UYpIinBwp6NhIfc7TRorSwnWD6i9iZRvjpVpD05
	aEev58PTA/elKIgfSR0UcQbo5jitZRWcDtBPMbqgZkt3puT4Flp+gVOLjtKD2ZNZcM5CE6xXWVR
	ozeBVSdx0FSj/scK3RvbeHEXPkQobA9YY+TRnGNU3UkacKjB4gzUWAoOfcqcaesXJN35mjOh925
	HIcNKRaL6vTetN22saG9TKls5H7F+tcW3DAiMMrHw
X-Received: by 2002:a05:6a21:33a0:b0:366:584c:62fa with SMTP id adf61e73a8af0-389822d7804mr3034097637.21.1767706830031;
        Tue, 06 Jan 2026 05:40:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3qC8z4lbOJuLoKb4xvZmoxJozhpdKAHzzoCTTcC1R2/MyomtFOJUnUIzLP+epfD7hFVvbsQ==
X-Received: by 2002:a05:6a21:33a0:b0:366:584c:62fa with SMTP id adf61e73a8af0-389822d7804mr3034062637.21.1767706829549;
        Tue, 06 Jan 2026 05:40:29 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc7856sm24112515ad.68.2026.01.06.05.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 05:40:29 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anjana Hari <anjana.hari@oss.qualcomm.com>
Subject: [PATCH V4 2/4] dt-bindings: ufs: Document bindings for SA8255P UFS Host Controller
Date: Tue,  6 Jan 2026 19:10:06 +0530
Message-Id: <20260106134008.1969090-3-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260106134008.1969090-1-ram.dwivedi@oss.qualcomm.com>
References: <20260106134008.1969090-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wLrNV-xhpJ2vBH3hY4tMsKDhUjB0VEfy
X-Proofpoint-GUID: wLrNV-xhpJ2vBH3hY4tMsKDhUjB0VEfy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExOSBTYWx0ZWRfXyzQtOcd5PuvF
 JOokVwsLnZnORxyhaaBCBaB+aH9pJLRWLEn6X0b6Zm+iWhyk8CcTpKpUXirKolUMYmbST1o+KDl
 PQd122wUkje7IzU42akTkrtVoCHsoG/R3XkbV9U7oWjrPdippfl7+B5laE+ebxYewaxuadAnAkf
 1kirh9bctOzuSyRzLdLKIKkQyaJzUArrQR0Fk9oVIj4oMUan/WmSyI3KuiMQevBvSTnfRmbEfU8
 sxvfBg6OIyq6kJe6l+vFCiWZ2g50vIS1hhKcsPKV9pGzjL74adEOJlR9bXaHuJ4Jbs5Sy8q/erz
 rFzsY02VmkdmsvtJneqPp/IYdVDZsNXHUqDPlMas4hhj+vz8AxPbAV6uJaGqE83FnVRK5mKBShN
 eOSdSWyuqfQEj/Y58Pf/xcnlW9DIJC3oNoZJyFr9y83h/6bmHh4rQBVry5iDX5AKUXSFTovAR84
 /X1m2JOlvT3QapiuxbQ==
X-Authority-Analysis: v=2.4 cv=Jpz8bc4C c=1 sm=1 tr=0 ts=695d10cf cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gEfo2CItAAAA:8 a=EUspDBNiAAAA:8
 a=VcM-S10TGioI4za7RKgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 phishscore=0 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060119

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
 .../bindings/ufs/qcom,sa8255p-ufshc.yaml      | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
new file mode 100644
index 000000000000..ea2f746117e5
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -0,0 +1,56 @@
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
+        ufshc@1d84000 {
+            compatible = "qcom,sa8255p-ufshc";
+            reg = <0x01d84000 0x3000>;
+            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
+            lanes-per-direction = <2>;
+
+            iommus = <&apps_smmu 0x100 0x0>;
+            power-domains = <&scmi3_pd 0>;
+            dma-coherent;
+        };
-- 
2.34.1

