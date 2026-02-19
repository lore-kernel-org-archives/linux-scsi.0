Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA99326D5D
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493970; cv=none; b=pne3gom6IsNlvk5JH14nv8dpmueyDA5BwO8XChccPY3A3gv0iqDFx6TYJ0hleBsvPTbwSDU/cUTf3gUsmxsk+CkvdsPTozQv5hjJsQOQGdp1kkSn7LJzkfDJctob/0d3vCrEktHAghk/6N6eJIQD0MSgM94h/VIqYyCLhVbXK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493970; c=relaxed/simple;
	bh=eMDXiPdgV7x5DmQVLUYnmu84UVPCZ9DADftODGHsL6I=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=cBDqDb8qTFf/95jZA4KJFWEVeYRlohPjJV3oODBN8ErDAU1n/uzKcUCAuxKKh0Tk+FsyEnwRsrZQGvQbGyw5x7q9npcmxXd8LKuqdDEZuNGzIdWALkPlW7isNbLBT6nNCGWvDJqcPUAhXiWFoSJjyCyDdg682xz/VPQ+CbuFbFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IlQ30qtM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D9F9/jVb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IlQ30qtM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D9F9/jVb"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IL5dQd2004685
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=8ZPa2FrLj1/+ytyEGdPwV2
	BgJyN/LehL2UmSn5rsXYc=; b=IlQ30qtMhSJKWVSam4IqMJ8zU6Sa4W3eTsVoSz
	9Nx22qQ7ykx/EmVNMik2BEGYdGhHxyItM4gCOnf1y224Kp99wAQJ28ybPNkmGtGz
	5nQYD5jHCoFVawMg/cupjAOuZksWGU/jKvkEBj26IXRbVRF61zqTfOW3IVuvYmK7
	+eF1uCMxUfs4Vx5t9u02HnQZmL2o6fsztTM8xGt/7tnwolmhZh5ZnVr6/dlR18ZV
	iDWsqqj0HQv9vg68vAq9v7vnVIgKFybG5I+pBWBlyAMWPeOvPUcEx73QlR/ZIJ2K
	oCsmKMoPtTnQlY3T7AG9F8Jny4bs7apwvRPs3zzjpbTU9qVw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cdn1qhegn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:28 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c6fd07933aaso519340a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 01:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771493961; x=1772098761; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZPa2FrLj1/+ytyEGdPwV2BgJyN/LehL2UmSn5rsXYc=;
        b=D9F9/jVbtKtr9x1C17bbTIOy1uU3mH/qbROkWuPxPJ9KE0Wvpo/rtE2IkxgYQ2wytH
         TXSKFigerqrAEi7XIBNhllHuw0QnYc5SyKtRQ1xEIR9saLeSb0VKbZ8296krx1a4X1Bw
         +4nCRThqq68IpjAVjkqlZvbo5pC0ui/jVr/32Wm6MOij55OhwM3aOW3A08y6DF7N/+ic
         3I+x2vpbklb9UfoElgii8cnyDbjZfBeG3r27dSviwLwQzXfNqZ112DGYHmRQhB4JhcLg
         FJ86cy2MOWxn/K4hRQMrIghvxki3GmGux77IIrIVvDlRr2EYbSFGHwWb7Re7fVIlrmhR
         bgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493961; x=1772098761;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ZPa2FrLj1/+ytyEGdPwV2BgJyN/LehL2UmSn5rsXYc=;
        b=w4aDqgmDyKx99/q4iQUlHknXojPNC8iSF2m232Jh/JhzDm99BBSH/Es50/5AVLJRWi
         11xEH8a7+wlEETtl61jEGpL/wEzyNkc8cxgjVU32sRRg/oWpiivGtwwN3MizlFAu64sq
         /VuyTDl0w3/9MSHh56amKUivBfvIPLBdROM8p0g8/c1xZpeq1xtCtyMWnlPdORFtepRs
         6IeW2wc4VGqia0huFzABR+c6LuH+5UYBd4AdP/8OBjG3pyqZq3SbEXZ1VcQSmK8K8xVn
         zT1jRjXGO7W/Dq14ELcH5VWgD12CzPUDI0ZPleOdwbKpP3g/sDdBTY+VFazf+XbXIaUi
         oDIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFkUJZabrCaAOJsOboQO1nBizSH6k8WhLHkbwHrSYz/UKINQ3dM1106bY6KnalFjSmbqBINbAojNRY@vger.kernel.org
X-Gm-Message-State: AOJu0YxjHJOY28xIuxiQhzLKYlZbl/asOTDBBMiCxtB8Pr1/wGOnHSm2
	YOsork/IEy/RJ+BzTthC3ublI4Zy99eJOPeU2Ekh09LgbRspCKBVkLrE7fDpeEhZFu3R8vBT3pe
	SEBlwHc4QxytPzG1GXAjxH8Po+RHgMhBtB3gdwN8wVCZ/ru2PNBiY2sAFgQxLuEI5
X-Gm-Gg: AZuq6aJuBXjCf2mYt6ZRhpLV3JzMyHZ/RwboqLCMkJsAhtKaDq9OIb8lFLai1QcefZl
	9Ww12TSe+4tl03/eMA9ydaWxT0hWrEqjuRRBmmXLznheNTFrnseeFJZMx5m2pi2FwEzYR0eSacJ
	eazZnU/bKHbzWeLknQanAlomizAxCqAc03RorcDVCMHxNxh5nj+cAs7EkNfsc0zCFqVlyw2DWws
	PhCHNGgA2NhVhHUyzCzFAjU++t2AFQfGzkGYUpiSHeE+W0z5SnlOTJNLq1nkmO+qqWtqbKesZA4
	BqBMEoOIWWZRttJT3a0ziiFyiiMlRpMEklIv4m4mA88L/QwekOA5cG36D1VtdSYyLR+5qgw4qm7
	enxst9tLhaAgHeeRxUEihUE2lTfmil5wLuWGB9byNHA8NjTpY38Qs/2+nOmY=
X-Received: by 2002:a05:6a00:1d9d:b0:81f:8084:7ea0 with SMTP id d2e1a72fcca58-826b65cd81amr2202153b3a.7.1771493961081;
        Thu, 19 Feb 2026 01:39:21 -0800 (PST)
X-Received: by 2002:a05:6a00:1d9d:b0:81f:8084:7ea0 with SMTP id d2e1a72fcca58-826b65cd81amr2202114b3a.7.1771493960552;
        Thu, 19 Feb 2026 01:39:20 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2ac83sm17710250b3a.12.2026.02.19.01.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:39:20 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH v6 0/4] Enable ICE clock scaling
Date: Thu, 19 Feb 2026 15:09:12 +0530
Message-Id: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAEDalmkC/4XPzU7DMAwH8FeZcsZTvmrSnXgPxCFxnC2ia6FhF
 Wjqu5MWIThQdrH0t6yf7asoPGYu4rC7ipGnXPLQ14B3O0En3x8ZcqxZaKkbpbQE7n3oGC6pQCY
 G6gZ6hkK+y/0RgkRDPhnG1IpKvIyc8vvKPz7VfMrlbRg/1m2TWrpfsJTqf3hSUFdT26BCGbDFh
 6GU/evFdzScz/taxOJP+sdU+papq4lI4V63rZNWbZjm20SptLlhmmpGGV1jtA+xdRum/W26G6a
 t5jJoFbtEvPV7s5qGKbgoHaClADaxgsAhgqoXRWq8Q5/+AOZ5/gRTmVpLDAIAAA==
X-Change-ID: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: qrRojxDC0O2r5ARe-3--eDnRlPrJyuuV
X-Proofpoint-GUID: qrRojxDC0O2r5ARe-3--eDnRlPrJyuuV
X-Authority-Analysis: v=2.4 cv=c7umgB9l c=1 sm=1 tr=0 ts=6996da50 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-lrO7XeYbFCEYaIRUPEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA4NyBTYWx0ZWRfX7udaPj6l+uck
 yEUL6h++waKERK6+9H3mYGn3oXWv1sKotxI3AITqv+v3pE/KkeTOLNhsKta3wTEJVY8veAsYj7B
 7M3/ipAdH8flPvDt7Zi3NptgBLmSGZuZIiGkECo5i+yUpc04j50+17+iSz+3E9xoChhKzRn0uDv
 6Hxaequc+CDonXHGWchDIIp7OrjdKb1UinF9aag+SnT4OiSCW8I6+giRhM8BHCL/LVI1xd4b8fA
 BAV4ysdQMQWqfI7vn2nM5S7kWZieNUac90qMzrXEEK09EvzAVCczMmmV+r0xhil77T3BLq6oHzc
 CDmebhRYHB3jR24VCjYU5eoKbFrsRdIRgJbJ7Vwj2WqLbXKGj8IoY0ekCfHknI0AyocERR/4vjd
 nFlv/LUHLC3x9C+z7rm5NZ8JhC6aPcKra9kIUUcf7+nzrO3Vztqxf8X1Mg7FNQQTUyZzv1Aoxuq
 BVllDFt1s6olYl1whrQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_03,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190087

Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
using the OPP framework. During ICE device probe, the driver now attempts to
parse an optional OPP table from the ICE-specific device tree node for
DVFS-aware operations. API qcom_ice_scale_clk is exposed by ICE driver
and is invoked by UFS host controller driver in response to clock scaling
requests, ensuring coordination between ICE and host controller.

For MMC controllers that do not support clock scaling, the ICE clock frequency
is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
consistent operation.

Dynamic clock scaling based on OPP tables enables better power-performance
trade-offs. By adjusting ICE clock frequencies according to workload and power
constraints, the system can achieve higher throughput when needed and
reduce power consumption during idle or low-load conditions.

The OPP table remains optional, absence of the table will not cause
probe failure. However, in the absence of an OPP table, ICE clocks will
remain at their default rates, which may limit performance under
high-load scenarios or prevent performance optimizations during idle periods.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
Changes in v6:
- Remove scale_up parameter from qcom_ice_scale_clk API.
- Remove having max_freq and min_freq as the checks for overclocking and underclocking is no-longer needed.
- UFS driver passes rounding flags depending on scale_up value.
- Ensure UFS driver does not fail devfreq requests if ICE OPP is not supported.
- Link to v5: https://lore.kernel.org/r/3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com

Changes in v5:
- Update operating-points-v2 property in dtbindings as suggested.
- Fix comment styles.
- Add argument in qcom_ice_create to distinguish between legacy bindings and newer bindings.
- Ensure to drop votes in suspend and enable the last vote in resume.
- Link to v4: https://lore.kernel.org/r/20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com

Changes in v4:
- Enable multiple frequency scaling based OPP-entries as suggested in v3 patchset.
- Include bindings change: https://lore.kernel.org/all/20260123-add-operating-points-v2-property-for-qcom-ice-bindings-v1-1-2155f7aacc28@oss.qualcomm.com/.
- Link to v3: https://lore.kernel.org/r/20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com

Changes in v3:
- Avoid clock scaling in case of legacy bindings as suggested.
- Use of_device_is_compatible to distinguish between legacy and non-legacy bindings.
- Link to v2: https://lore.kernel.org/r/20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com

Changes in v2:
- Use OPP-table instead of freq-table-hz for clock scaling.
- Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
- Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
- Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
- Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com

---
Abhinaba Rakshit (4):
      dt-bindings: crypto: ice: add operating-points-v2 property for QCOM ICE
      soc: qcom: ice: Add OPP-based clock scaling support for ICE
      ufs: host: Add ICE clock scaling during UFS clock changes
      soc: qcom: ice: Set ICE clk to TURBO on probe

 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 26 ++++++
 drivers/soc/qcom/ice.c                             | 95 +++++++++++++++++++++-
 drivers/ufs/host/ufs-qcom.c                        | 21 ++++-
 include/soc/qcom/ice.h                             |  5 ++
 4 files changed, 143 insertions(+), 4 deletions(-)
---
base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

