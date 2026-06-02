Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11913BB103
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 22:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439071; cv=none; b=tmjmw+tVFIf7uTAlbD3gxYFtJu5C8XT/0v0JHdo60hz0tgL8FTIv1wz9Q3cP7WGxc428By37ja5c9Ak4ZjPpRtD7+7qqKRLU9NI8D+y5akI7Ac5qhF0p071bMQ8riEFTcPKzggUEm7SA3vLIF0y8CM91LGrWOVyTCUrZ8rS4gCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439071; c=relaxed/simple;
	bh=eBHbIhPU5QhnRv3FTo+WfXhuaTc1Pd3l5QTgoqveuh8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=LQL8AZQK9fz+xWu9/VX3Fdj32MLqxiWWoPjo3zX6g866VbOzMz5O8nDTMjBoW+WLSrRm3aAjoTm5vUdgfu6he3wCezjAKqxpksNsOW4nExATGz/bETPgr96p/h7U4kRLMw2fhU02OczsFwXYjHzdlqkjcS48GdFsEi4dxrktMCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kS2R2o/T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fThiJ2Ax; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kS2R2o/T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fThiJ2Ax"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652IrG0a4012749
	for <linux-scsi@vger.kernel.org>; Tue, 2 Jun 2026 22:24:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=8dwmrSe4/4mK9fiPmzsrjd
	Vxh4fmXrMI9gE+cNaNCEA=; b=kS2R2o/T7zXL/PYnRZP0YhvZzwdvOCdtLlCUqM
	+gB8ATyFHNvenro/QVkIfNxuOlWX6RpZUqVv7UgFU0ebpPES92XuIlng5GbEd7bg
	biJxcyIMAccAWUoguSdMc4LXsCR/H9iP5sYg7b5/KYtuiV5mLpDF0IcYt0lVBlgB
	M7H9m3poXZ/mILHpOX7Xpn0odFoeyoKLEAOZjLPSu7HJDr8fxLaEhMkbFb3kDupS
	xC981++cvHVTWzONTYNM3+u+cs8MqyvbTgXpGzFwStv6V8dTtEHnqzdeG2W/o/aR
	8AYJ6SaP4h9JYhDlUaU6y5xEwo9BP1YenCsJ5e0FRC5mX5uw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ehsf4m332-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 22:24:27 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2bf281d523eso27439125ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 15:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780439067; x=1781043867; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8dwmrSe4/4mK9fiPmzsrjdVxh4fmXrMI9gE+cNaNCEA=;
        b=fThiJ2AxtmFu22Q3pTYfQcmCcbyajTPLp/tFWjuRf0sLSVQlrjs8eCUdI52E4pndmz
         3pR0W9Q/FD42rsIvCh6UH8pzLFyfhO4PPAX67CiRh5maW4cth0WxVClxovfVPfnbWqCU
         y2+koiaAWXyIkOZs36SvpHscQHPIv70Iul28QXlFcGD4eXEIdUvBOgIpq2Y/zKsUAPjU
         C5pl7Gp0M48PCW57kwvxI0CKq4L98I/6sQaF+zUAd/D8V6xN3vLpaZHhW4dmB+RQaZsm
         ezwJnBRFJ/VB6eqVcdwoF/YoWkYwJz0y56PqW1fuRifwwti7Sy2s79zHpfKGMdeclFjK
         ajeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780439067; x=1781043867;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8dwmrSe4/4mK9fiPmzsrjdVxh4fmXrMI9gE+cNaNCEA=;
        b=UA0BxsThHw7vrWWxi5VO/QbX0MisaaxqTqmZxAtXGIrc0N71ondWacmf2q8CC1Ym3/
         2DU10S559YL7ooaa+yautJYnZt3ngBwvU3kcIG4ngUmpNk88jLkJ3FXs8gvKLCEs3NTz
         R1LrcUwb5bzXFCxTRLMULN7BkjqoGI9dkz2n6eWYagucCbkEa437CFDVIeZc6XvPODRB
         rFcrMJe3TGlaG1NDz9yNq8XwEXYXBfVmgN2BFE28ZwnMCN39Rh8s2xN5qUuKP5bwDP3B
         m1CPDyfjWuaw8d69WDW5uiNVIEWBxHM5AcdiTD8SO2Jq1Ar8SvNIx5D0/lA0w+6sSec2
         DOsw==
X-Forwarded-Encrypted: i=1; AFNElJ+qtG2lJ8jEuLbwPO/MgdhV4A5p62OoYcV3ibZxyp8zETVHI2aCADjB/QMTxU+ZaJnAyiKmwDy+JY3Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyqUSw/1yS1MCdkJAB0kDFqY8k60HdAvsMTMiBw9n5KENWKgnz1
	sET3iNyKxVusoWMevOebaiEu0NdhwnlCSzi7QRIvc0EfDoyOMFG3rXVfvpdsclbK6Lx3rv6hwVp
	wSa09wm+2t2qz43mLlfYc63naZnQt9OwWxJNVRzsnX4WGTlkB1UbKmv/JpFGxAfK2
X-Gm-Gg: Acq92OFHMVkDT3s/kNgsaAbX7666NYU+ScPEqWoqDzRWigYxkT/eiz+rQRKS1V/pX4z
	4rGVvKqMCbAgzOZVp+uJei8igYtjxQgtmDnGtPTGzMa/IWEctJHGOPq1/zLQGXYMDUjTF9Bg4Uu
	Yz48acw9HIbUX1vpLOKqaZqGDDty5T9hmfFX7SAv450orVyoZ2brKHft2CwwlPoHLdUAU1Jku7C
	A5SSTvgSznZNiCXsjKAV3xeoEoBkYzjRVUsz/6BN3UdARx+yy5XWC976iOPDy80deR03KBphC9i
	MUgRJCl3Vmh4NaQ9ODQO2eaIUpdtLwLyeBfZfs3qGLhk6xnBA2odDQbSL3DUJwjkUghhHgJqjpG
	oumN/tkA0y5kTlUsMHfLW7nwARabDbsQCM8DlCqitoyKUUkExE000rxLfMDGr2tv6SE2lFQ==
X-Received: by 2002:a17:902:f645:b0:2bd:63dc:b7ad with SMTP id d9443c01a7336-2c1639ee43cmr5681675ad.2.1780439067057;
        Tue, 02 Jun 2026 15:24:27 -0700 (PDT)
X-Received: by 2002:a17:902:f645:b0:2bd:63dc:b7ad with SMTP id d9443c01a7336-2c1639ee43cmr5681405ad.2.1780439066521;
        Tue, 02 Jun 2026 15:24:26 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e0ecsm2698035ad.45.2026.06.02.15.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 15:24:26 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH v10 0/5] Enable ICE clock scaling
Date: Wed, 03 Jun 2026 03:53:52 +0530
Message-Id: <20260603-enable-ice-clock-scaling-v10-0-b0b728435356@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAPhXH2oC/3WQ3WqEMBCFX0Vy3Uh+jBoppe9RFhnHyW5af7rGl
 ZZl370x3hRKbwJzmHznnLmzQIunwJrszhbafPDzFAcpnjKGF5jOxH0fBaaEKkUpJKcJuiGqSBy
 HGT94QBj8dOZQW9fbQhdCaRa/fy7k/Fdiv53ifPFhnZfvZLXZXT2gRpn/oZvlgmNdlFKTRSqq1
 zmE/HqDAedxzOPDTo/DbKHrLeZfD0fWQYiwuOTXJnMVOCuhR6UFgLWktNaC0NWmQ9tB39uqFtD
 vuUcKAVLvJntOCbUUUmpjqlwXtRGKSz4RLfCeh3nyfxK9sN/Ha7LEKES512tpHLFNHdvo6td4b
 07SOl2idAim2VRs9PgBKdRuRJkBAAA=
X-Change-ID: 20260601-enable-ice-clock-scaling-a89fd9434023
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDIxNyBTYWx0ZWRfXy+1OGkvM63NF
 cIpdAx7bCtPv0KmnmL6rLBk0aurK2T2ACWhHXfWMlIXs+PCfBv8KKv3wDKkiCSd+Ey7G92Yqv0D
 kCgNUaTdIPBwlNFHd9xiM5hRdi4eBmnKHWRpmrfWe8vCKnYTWlmBuR9Y5OqnQEx+9Att23qVZl8
 NdUT4b2M0lB/CBSghjet8FYaZPXmlUtojAGmUHle/mfhFDiwvOVjgNUwoVsMM03aK3S1IRR4nZD
 1Fkox7W/Ovr2ti+9MHcu5suVCeJlRenDMi2Bm8OjqqMSxkHWObwHEbvvXRRenBpO0RkbkLC5PIg
 JNXG7Y4k3c8X3J4/clpnGPELjk9BCzzPG6RUupRX1o/hJXwMc6MS8oJJMRsqsNwH3CrMQGKK6iE
 ZI978IYtoeK58vVnZbDFRyL5FTKaouStjbyX+CbxVI2GRP8yxckPiF1TbRSAwqzMm1MAHKukV3R
 rg1h+sn7mXT8Gct8yiQ==
X-Proofpoint-GUID: eXftiLyHBDZH_3f9k4wOFIl2ITdBi4ra
X-Authority-Analysis: v=2.4 cv=AJZ7LEvz c=1 sm=1 tr=0 ts=6a1f581b cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=D0JgdhPY6ITr9mA7PGIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: eXftiLyHBDZH_3f9k4wOFIl2ITdBi4ra
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606020217

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

Testing:
* dtbs_check
* Validated on Rb3Gen2 and qcs8300-ride-sx

Merge Order and Dependencies
============================

Patch 2 is dependent on patch 1 for the qcom_ice_scale_clk() API to be available.
Patch 3 is dependent on patch 1 for the qcom_ice_scale_clk() API to be available.

Due to dependency, all patches should go through Qcom SoC tree.

This patchset supersedes earlier ICE clock scaling series (v1–v9) with updated dependencies.
Hence, this patchset also *Depends-On* the following patchseries:

[1] Add explicit clock vote and enable power-domain for QCOM-ICE
    https://lore.kernel.org/all/20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com/

    NOTE: This patch is already picked and part of linux-next.
          v10 is rebased on top of this change onto linux-next.

[2] Enable Inline crypto engine for kodiak and monaco
    https://lore.kernel.org/all/20260310113557.348502-1-neeraj.soni@oss.qualcomm.com/

[3] Enable iface clock and power domain for kodiak and monaco ice sdhc
    https://lore.kernel.org/linux-arm-msm/20260409-ice_emmc_clock_addition-v2-0-90bbcc057361@oss.qualcomm.com/

Patch v10 is rebased on top of latest changes picked onto linux-next for the ICE driver
which had merge conflicts with v9. Conflicting changes includes:
1. https://lore.kernel.org/linux-arm-msm/20260518-qcom-ice-fix-v7-0-2a595382185b@oss.qualcomm.com/
2. https://lore.kernel.org/linux-arm-msm/20260520155704.130803-1-manivannan.sadhasivam@oss.qualcomm.com/

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
Changes in v10:
- Rebase on top of latest changes for ICE driver conflicting with previous patchseries.
- Link to v9: https://lore.kernel.org/r/20260525-enable-ice-clock-scaling-v9-0-c84613e9ce47@oss.qualcomm.com

Changes in v9: 
- Kodiak ICE eMMC OPP-table entry corresponding to 300MHz is updated with SVS_L1.
- Add 75MHz for Monaco ICE eMMC OPP-table.
- Fix error handling and initialization of has_opp variable.
- Pass ULONG_MAX as target freq instead of INT_MAX from sdhci_ice_init as it better adjusts the data-type of
  the function qcom_ice_scale_clk.
- Link to v8: https://lore.kernel.org/r/20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com

Changes in v8: 
- Instead of scaling to TURBO in ICE probe, sdhci_msm_ice_init calls qcom_ice_scale_clk for setting freq to max.
- Fix error handling in qcom_ice_scale_clk.
- Fix error handling in ufs_qcom_clk_scale_notify for the call to qcom_ice_scale_clk.
- Move the registering of OPP-table to qcom_ice_probe and remove passing legacy_bindings argument to qcom_ice_create.
- Add OPP-table for kodiak and monaco ICE eMMC and UFS device nodes.
- Link to v7: https://lore.kernel.org/r/20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com

Changes in v7: 
- Replace the custom rounding flags with 'bool round_ceil' as suggested.
- Update the dev_info log-line.
- Dropped dt-bindings patch (already applied by in previous patchseries).
- Add merge order and dependencies as suggested.
- Link to v6: https://lore.kernel.org/r/20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com

Changes in v6: 
- Remove scale_up parameter from qcom_ice_scale_clk API.
- Remove having max_freq and min_freq as the checks for overclocking and underclocking is no-longer needed.
- UFS driver passes rounding flags depending on scale_up value.
- Ensure UFS driver does not fail devfreq requests if ICE OPP is not supported.
- Link to v5: https://lore.kernel.org/all/20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com/

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
Abhinaba Rakshit (5):
      soc: qcom: ice: Add OPP-based clock scaling support for ICE
      ufs: host: Add ICE clock scaling during UFS clock changes
      mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE init
      arm64: dts: qcom: kodiak: Add OPP-table for ICE UFS and ICE eMMC nodes
      arm64: dts: qcom: monaco: Add OPP-table for ICE UFS and ICE eMMC nodes

 arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++
 arch/arm64/boot/dts/qcom/monaco.dtsi | 37 ++++++++++++++
 drivers/mmc/host/sdhci-msm.c         | 24 ++++++++++
 drivers/soc/qcom/ice.c               | 93 ++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c          | 21 ++++++++
 include/soc/qcom/ice.h               |  2 +
 6 files changed, 219 insertions(+)
---
base-commit: f7af91adc230aa99e23330ecf85bc9badd9780ad
change-id: 20260601-enable-ice-clock-scaling-a89fd9434023
prerequisite-message-id: <20260310113557.348502-1-neeraj.soni@oss.qualcomm.com>
prerequisite-patch-id: ab9cc8bd28b2e1e27df6e44907e8d758dfeee3df
prerequisite-patch-id: 40f239f7f06573ed45452249f444e54e3565ada7
prerequisite-patch-id: 59129ed0aeba84f6b50f42261d51fe323806a240
prerequisite-change-id: 20260406-ice_emmc_clock_addition-e19f36c1fca5:v2
prerequisite-patch-id: 5b6a436bd949a93e44f912d2565103f6bf0ef55a
prerequisite-patch-id: 7f9ff2b708418a77578e154102f72f0da243eb71

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

