Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795517697;
	b=cJ2ymKhgqiSdXkiDC1GKo7OZfp/8FuYAcsUTi5yMuqXcfjStVGSH5Ef+030R6DX19wfi
	 G7+YV/5EgtVrWkOZVYUpsXbgzKG5rFcKsINJ8aVNzrxzBGq/ipS1wj9RwtVey4FKcUYhj
	 musqahfncKfywguxquIAisH8dCGnfSWinsDmqBOniP9fe1gnmbOgvk/qih+LXMMtV3dj7
	 lJLaLa3cm5afz8FynvkTwD+JtcejnPkInE4Nmblqqi6OSGa1uoOHT2d1bl/ZCyouj/Acm
	 Ea+vO3D5cQEyMKEU31o34DtO3ErSBVn06kgr5Ezzg75VEO1q6hDKvDwxLftxy4y965Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517697;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+dTwZnOHLDKXEvNUsrVBpyCfVL4kbo9yWlVZaxntVfE=;
	b=KoO9sO4guCg+DMtO2PCLVkD9cobsPq7UYH7U4mtpdtfMPc8lJWp3DyZ3IMr52+/QxxZl
	 3OLw58GJd+Hn5dxfBcExLFpLWwoUQJc2QC+hR4mjHkL/L/DlnCpWXVp8SWWmhn0bBWU9R
	 0jcGBXv833JJkp6dkdtjVLIhxakQke9R2GVKWeFlwMjQy1RfAdioHpAbpdrJrcosTxzZc
	 EUaAF0xaS73wnvcXLhti0dpVxKR2s7LyCC7vU14J2XxBzDHzNYRuG8ugfguFZTSP9qIJl
	 ujM3dbDBcJuyNnqdemjXZC9+EBlYTF9vLCphb7aujX0DbMyKxbUeZZTh/phUTAS9KLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=P9SciSyn;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cWfHq3zo;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A74F606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 10:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A74F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=P9SciSyn;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cWfHq3zo
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO8JrAU3225364
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 10:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=+dTwZnOHLDKXEvNUsrVBpyCfVL4kbo9yWlV
	ZaxntVfE=; b=P9SciSynycsGEIVFMS3diJ9WO4pa8LRkuGMtgFBJHgPzynH3I5+
	qTCFBRCgYV3QL7JQaH2EXGhMH/EAbq4P8KRKxDv4MLxn2UvhKg2DFA0/zM5T684v
	ECK+g0s56o2viDWtgTa1zWGb54DXhX6pXDTZc4e6YFbqufxRRpQnxhDSGFuT62pi
	ThfuiXvDL33vawwxEBjSJa9v2p9qhXyyBXVzqFYQKravYzERPlaR0dw3y4pWAxXU
	fy7t9zh1oqJX0Q7AtU1CY7CYrHS6gSl1iBOBul4YMZnj5j+jxoQn5zi61cvEzFDQ
	/KdqMAdBKDor5FG64VvFiZV+IG0RhQt5f4g==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j4x8f2nck-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 10:54:56 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8b852fdd55aso4896789b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 02:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795517696; x=1796122496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+dTwZnOHLDKXEvNUsrVBpyCfVL4kbo9yWlVZaxntVfE=;
        b=cWfHq3zotj/yajFTZFbtj/bus3z/W+mWjslhRqvkiKmv/HhErr3wA2C9zTQovDJfYJ
         nPXe9gYVnvKx0H4fo+ZK7prDOlN3kU+nnTS2Sgublu2WnZ39iSJpjZ6oU47LEKJ1p70R
         ltQa/sfcgh7OSkWlCUUZmdLTPSiKxnvS2J9XVOaJ4vsuqllmWcHOLGIKepnaqhqjn5as
         2l37Du/Nv9LoYJEmFxpVMxPqvOYkb2Y9ndSbKtoETmJ5qFrqD49BCWuLkZ1mTZ8Uloob
         9fhddYhOCx5iQYTMu3x4HfSrJ0r28SxfJRn7whGe2/n4vkkCX+D10klvxDQRiF/+ynO8
         MUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795517696; x=1796122496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+dTwZnOHLDKXEvNUsrVBpyCfVL4kbo9yWlVZaxntVfE=;
        b=weMobVUsHThfrZEf6fMRQERJuovhCSOfT4Ib41xHeFWw8QEDAuY953UVfQspWtZw4b
         SUcw3zELlajbO6/SAfV4a3KjvT71PL2320v8GlfdEYB4BsEdHDmyFM9ApZmFvWWBmeyH
         7lAIMEkF0lRegZox8r4hBaTe5rWCg6stqyfpMU7PxZE5bGgdvD5rSSRkycP6O/ebdUy4
         Zd2r2tybQhfT2Qw0QYykYJyxdlhgjgtsK90nolnelf31g4KA8BLZtkr3ZPoPIsCKBNw7
         PTkdP+yr6KBflF9Rms6lOOpzGyUsXPgbgSZ6lIBSoi4P+XSLM11izhpb9jtCOZ7hCMrz
         7xDQ==
X-Forwarded-Encrypted: i=1; AL+hErHeyhc1Ir0Be1KSUwyDFetrJWyoyQQfpHZdd4M2o0iItfpUVw4IaMEhUD2Tyos34JJ4qbtkLfdJ7V0I@vger.kernel.org
X-Gm-Message-State: APuU4Z8a01aIkG+5ZaHsCxLkdVyKle2oZOEq8EZK4juPaZh2mutPVEx7
	jn5HBm4I7Ma5MeBH3dU3q4dIixbEUqXuD/K6CuAdICKAZPq9/GQJlm8eLUDqlsT7kcha54z//HU
	BvWkpyOGFb+DMxVxepcjOpWmQWBXvAR1v70RXUH9PrsCJBKDT8T7wzvjhzGx4krja
X-Gm-Gg: AZFdTZdhoAf5cPANa1hZfarAVIRMZEVyWPoRwPhdKAA7BWFv5r4M8f9gFYlLAr/zsVD
	g//fL8y9aoqe0NsLKJj9sxv4ocXDy25FJr77hj0E74tLMY9WXlD1W/ukM2yWDhvVrvWNYzNXdXQ
	Ld4fw7qB3toV0a2DkeuMV2QyaHLVpbgWsnCjPpU9KWZ8l8DkBP7TXLM9VfE+fkVoGff1rjhnnIS
	WYow+q+hA+oqY7+avj4VIjvcJ8aPGL0f3lB3vhWOLNWeC2raDCVCJqoCPs6kYv30iZkAnOng3TE
	Vcs/Hx+b3TZKbKrM4igfPXAWrUrwfRIGHJ63ZpbBrY/5K/UKX8grubcyZEfrxRRLBO1ObVyEP5p
	ANjuZouhSrTbZHEhbHXFkpBfLG62Dz02/a4PKX4DIvCJkg3TNDaQig1kKlZTr9+8p2rP5hBHfQm
	oHyYAeFiUv3GvWigGb9jQwziwbhvdjs1yxvwW1EUbaArWdPeUM4YHx5JQ=
X-Received: by 2002:a05:6a00:2ea9:b0:887:17f3:94f7 with SMTP id d2e1a72fcca58-8c8792b60b6mr13838798b3a.1.1795517696023;
        Tue, 24 Nov 2026 02:54:56 -0800 (PST)
X-Received: by 2002:a05:6a00:2ea9:b0:887:17f3:94f7 with SMTP id d2e1a72fcca58-8c8792b60b6mr13838777b3a.1.1795517695517;
        Tue, 24 Nov 2026 02:54:55 -0800 (PST)
Received: from hu-ymg-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f726sm7323476b3a.36.2026.11.24.02.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 02:54:55 -0800 (PST)
From: Yadu M G <yadu.mg@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] scsi: ufs: dt-bindings: Add compatible for Seca UFS Host Controller
Date: Tue, 24 Nov 2026 16:24:47 +0530
Message-ID: <61136dcb5cde2c0cfe1b8f3a488e9edcf36043cf.1795517687.git.yadu.mg@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA0MiBTYWx0ZWRfX+EQcHhbolVr8
 mr18/SnQzd7n4uHahnNWakZslnvr6DDJdXA/19uz6cxsGDOGevvQYC4LcSNp3yzYWDVENqwOgPA
 LD3VD4q980D13yAP6RxKMBpbP8koHSQ=
X-Authority-Analysis: v=2.4 cv=JbgpPkKV c=1 sm=1 tr=0 ts=6b056d00 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=lHObh2IfMKzVuqTG74EA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: kG9XCXQU1vWQWzzZPUFrFhZn51EAttMu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA0MiBTYWx0ZWRfX2HLcxm8LttQl
 pVCHiTtXlLZSnHTStSLZdQDwoHndl+78mcp8N57QjrJvRUmR/OL2/bGMv2YQIJBDztI5yPI3YjM
 D7J7Mm/HsOTLsgcjpRufR4bqNVScWTztVSdONL8stICps/hAr5lIiwU1IiL6FTX4ANP6C5xmuRP
 kz+2eqYfqhhO9wE4vaP/l1RAHEfYUy4B0dATa7zRbz0B9v17yJaf/dIQ9JpQCz2HjFaK2bATDzh
 6GZwtJagBYMZqObuYWEowoAsOR2RIZi4YKgk8hHiBgedodDq1wLcpY9BrjpmcTxL8/C6AI0FDH4
 cS4z4QVKB3c+S8Ur7x45TACS1Wxab6IzDRe8/BErkJtp4udx43VOlzj84g+vrv8j0cRryK3gE7r
 NHn2IQmfKwgrv5QKfoiFLSveL5TgXhQbG1G3ivyCQ8p111+OimPrH+6Kf8nC+aKzalCn2ZesOxG
 a1dvf4GwQhorPbIxkQw==
X-Proofpoint-ORIG-GUID: kG9XCXQU1vWQWzzZPUFrFhZn51EAttMu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240042

Seca's platform firmware implements an SCMI server that manages UFS
resources such as the PHY, clocks, regulators and resets via the SCMI
power protocol, like SA8255P. As a result, the OS-visible DT only
describes the controller's MMIO, interrupt, IOMMU and power-domain
interfaces, making SA8255P the appropriate fallback compatible.

Signed-off-by: Yadu M G <yadu.mg@oss.qualcomm.com>
---
The Seca SoC device tree using this compatible will be posted as a
separate series.

This series was prepared with help from an AI coding assistant
(Claude). It assisted with review on the device tree, bindings and
driver (formatting and alignment fixes), rewording commit messages,
and running the validation steps (checkpatch, dt_binding_check,
dtbs_check and W=1 builds). All changes were reviewed and tested on the
Seca Ride board.
---
 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
index 66d73e9025d6..4a5dbc780b0d 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -16,6 +16,9 @@ properties:
       - items:
           - const: qcom,sa8797p-ufshc
           - const: qcom,sa8255p-ufshc
+      - items:
+          - const: qcom,secaau-ufshc
+          - const: qcom,sa8255p-ufshc
 
   reg:
     minItems: 1

base-commit: 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5
-- 
2.43.0

