Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A693C0623
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775735086; cv=none; b=maQkDog2uk+l5tipOC1J/kMjTfaHSjddkZMyHpjJubIU3GzPW7l7pEfU8CFFjNSQNCE4qEWkzMRQAMU82/enNQQl5KRBDQKtlwUNU+yiNtQ0qcVTtliVOYcyFmkh0jrxrNMQ5D7TEgCFEH3A6j1HLUhZbDnf7TvA7J388+4BaYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775735086; c=relaxed/simple;
	bh=9c0bQpJy2UnS6Rm1PM0Z2cLcR4L8HK2GRFwrcFiZC3o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=SzVpTG0f9+ADPFUh326/5r/YQEDiUOH7qMoT09NTHHQyDakIKU1+0EeKU35UxmarxWOLVb0Bcw1oPuIlCIOmh+Q+CSsuaXsgwhjeoGPskX6tibVWVl/wi8Ff0MCGrPZgSDhLE/5BDZEQclwn4F+2DJpRZdpBN56MgxbixNoJFPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gfQcKfMS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=StqcKCV0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gfQcKfMS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="StqcKCV0"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63981dLq1072656
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2026 11:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=w2R9Fx6xcueG8JsycBSCr/
	+hEJvYdb6sPAdpoJaOjMU=; b=gfQcKfMSO85Kq0x8dz96IzgDgjov7BU11ogvtG
	XvIukYIQqA5NKFIY9sxJL95mB9wKFbXOTt6toI9n81D1qGRIjO9bHvWr6BXNcpnk
	1z24+NAKkklAXEZXshsrESwUCMJRn7bhNtFP0W6S/Ooi5LWfQtI+O/oSBPmxGsDB
	JZWkQG3DmPoUA7juCx0sA01LjVsxZEuOc1K19M2kNNl2coJrMuxp4y8Jbx5hRTzq
	cWfChwaniBzv2Uowud74/m6sbYCV1Ny3VGrpXIaUPklmS4jBlQV07i/P523GS0kp
	C0h6k2zGEqE+jzze/A71QRZmlm8csEfwX+7anP85fkwjKOSw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ddtb3btju-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 11:44:43 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2aad5fec175so13694875ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 04:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775735081; x=1776339881; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w2R9Fx6xcueG8JsycBSCr/+hEJvYdb6sPAdpoJaOjMU=;
        b=StqcKCV0RFrHjnMk8sViwu7CEn/a+rwujgDBApXb+9x03jAVdJNwl8I8UKGYWamUw2
         KFLeXMJ1NIM1wSkmwMphEeHKvsMh4RVW883S5UkYoWGExAMUTNxFRI/heejwNWOnnhKO
         Bhi+u3IaOrdzuxGNe2zHm2GPzcy45G0WKVn8r15JIkwYotpkoF6FhjssDmfzM+OHVCH9
         QLx0A3jQaoaQhOcrSJCBiGb6E0Her74svnbqSINIfrsulyCBHBuoamaupycNv/UguU8x
         tUnZCDufNsGkQZSPdB0h3l0lwuRrsfayRzm2Y8uHYcL5h/98I4q7B00QrxujZKlrNSXQ
         W/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775735081; x=1776339881;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2R9Fx6xcueG8JsycBSCr/+hEJvYdb6sPAdpoJaOjMU=;
        b=aKy8+9F4H5isawxPK2uKM34ApjzOYNQKkMIWwfzUGB7fKYBX4pI15szbGmMjGTv/4I
         saVpJ3LJ+NoBA8vns2hmym6KzL1sLsE6yVd0vgWAZe0A3/hjilzShd6vUB2SYH0fqJPP
         QnRaS1/kffrI6ASY39sPoJU5pWzXU1ay+PrF5Q/+VZsqPnRGm/J89GntHxBZdxNlVQs4
         PAXG+8OmGESPfHHsU2mXZmTOwChDMwr1Qw5Ttxn5znMjYkCFpx1EKcwgBDwGVz3b9hPE
         Xq0SILnVk8mH6W0eCdbr5kxF4VpP/bd7zkCjgtnqjE4Dsk8E4n+72+mwLIsCXJ0dzHHe
         /n0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRlgybuFEQieQpxOkdXt2a31Cd6EyCejNxXddHHeGVXqCdfSiFffW8v8J60nw3oZaHRKmXD9HiWhIv@vger.kernel.org
X-Gm-Message-State: AOJu0YxhhrANrDZP23zPgoyT2kD1pDDqzz/3Bj2DWEiH2tp77/cVNZz7
	YQUFapAeyX9mUSNvYDFsRBLCQPIV36/pQFOHsmYDe16xPWMGACDiq/eMuYOKudH0New/qTCObMj
	JzRKF0K9dhKkyph5m83XtfrMHX2vuLAulGYX8Wsabcxx3OUwP98Hoc3yPddlyFAaP
X-Gm-Gg: AeBDies2saT+vzvGGUA8oLXJgAji0jIi9GOPCPalIZP3coxpEzfH/SS8jjNQtiTJNfD
	kXHkCqIrnx2WTjM1INKc590vFpLd/R+wsfFNiAiCMw5Qq9YouC7HJJ4t3SQFHMraivee0KTHPur
	0xWVSCl2ffoZG7nhFCCv2dgGS4FktQRb/70YXM8j+9CiIGDvLWZEhRvcBlS9CMcD9jjFlIf6NQD
	Su5i/ms7EffRG0kFA2hUzNpSnwicZHzwKKDqcSaWj85ad4nS5xpyeYIEEwTHMMhJIiZsuaI86Wt
	KlDr1lLv6/+nX87kPVZvLszxznYCTm0VW2TNyCNHaTGIFVE8aoDYWTN6mplQgGJOFjZwmNuUuZV
	eDebxIg5L72ksJghL7EjcgSDlQoEbEZ+vMuDwI0lspWPH5DP9ghg91/vao9o=
X-Received: by 2002:a17:902:ccc9:b0:2b0:51f6:d46e with SMTP id d9443c01a7336-2b2816cfd7fmr275961725ad.15.1775735080475;
        Thu, 09 Apr 2026 04:44:40 -0700 (PDT)
X-Received: by 2002:a17:902:ccc9:b0:2b0:51f6:d46e with SMTP id d9443c01a7336-2b2816cfd7fmr275961275ad.15.1775735079946;
        Thu, 09 Apr 2026 04:44:39 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cbd9fsm230957355ad.75.2026.04.09.04.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 04:44:39 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH v8 0/5] Enable ICE clock scaling
Date: Thu, 09 Apr 2026 17:14:07 +0530
Message-Id: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAeR12kC/42RUWvDIBSF/0rxeQaNGmMZY/9jFFFz07omsY1pt
 lH633ebsKd1sBfhXPQ75x6vJMMYIZPt5kpGmGOOaUBRP21IOLhhDzQ2qEnJyopJVlMYnO9wGoC
 GLoUjzcF1cdhTFZyS0FSCa0Pw+WmENn4u6Lcd6kPMUxq/FqdZ36crVLDyB3pp8wPwrCmjVWW8q
 SC4pqlfU87F+eK6kPq+wIPsbqvhCOcLrjCtrsS7jDC8FKftxqigJG+a1rOaK8fA1VJr12pde8+
 F90wrpo27Z+8hZ7fsvt08rylLQc+IspjPntIHjNYNjQ3d0c5pAjpLDAkCO5LeNy2YXyFf/gBzx
 rlQShdC1gq74HQAGN17kdMQ/0uRzNybs9D3wS71WWwqTvibdC4xmmHeh8CUFhV/AN3dbt8qne0
 nCwIAAA==
X-Change-ID: 20260408-enable-ice-clock-scaling-5ca54ed63179
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDEwNSBTYWx0ZWRfXwi4QvqyaPzIZ
 z1iZYxjFMOtjT+njCXfcARpZxP8Czk0AdW3T3ttFQaB9QL7wQgzPtxYpOb3p4FwmRh0IctCDr/q
 igEEFp8cBopXk4uqpSB6QXC8kW7Syv8+aW9kHqFZD3ZKx4x7BVa12Q7vZmmrRetgjUCeYj+MemI
 NkJZw9/vq056tj8uXEPRIgi3BWObu/zmcMsisEPiNHRXsKRo/FAy8gb5J9Jrak7akaegFYEZsiU
 rhLkeeb6yxbtcMbUq8MhLz/AfOkjFVpeHAo3qN8M9m/A38FCA716AruM35XtUAvXe02hxDSdf+h
 DX3QGl6xvXAAZaWD1i8IxyUtjJ3WNwENWbrhJlVRUM2B+gbbupNOjjmlJoSacUgxUdgnaCn6RU5
 S1wDc53AVzJBJyKsLd7hlWZWmDau5GVVjprlruYOgQKHVO2v+8dETXiWCvcIOqg6xKhjBCl7/N3
 ZE8NUkLRzHbT6bgFJtg==
X-Authority-Analysis: v=2.4 cv=eKIjSnp1 c=1 sm=1 tr=0 ts=69d7912b cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=D0JgdhPY6ITr9mA7PGIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 4k20cAhl3PreqW1b0rCLRoRGApCfDh4q
X-Proofpoint-ORIG-GUID: 4k20cAhl3PreqW1b0rCLRoRGApCfDh4q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 spamscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604090105

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

Patch 2 is dependent on patch 1 for the qcom_ice_scale_clk API to be available.
Patch 3 is dependent on patch 1 for the qcom_ice_scale_clk API to be available.

Due to dependency, all patches should go through Qcom SoC tree.

This patchset supersedes earlier ICE clock scaling series (v1–v7) with updated dependencies.
Hence, this patchset also *Depends-On* the following patchseries:

[1] Add explicit clock vote and enable power-domain for QCOM-ICE
    https://lore.kernel.org/linux-arm-msm/20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com

[2] Enable Inline crypto engine for kodiak and monaco
    https://lore.kernel.org/lkml/20260310113557.348502-1-neeraj.soni@oss.qualcomm.com/

[3] Enable iface clock and power domain for kodiak and monaco ice sdhc
    https://lore.kernel.org/linux-arm-msm/20260409-ice_emmc_clock_addition-v2-0-90bbcc057361@oss.qualcomm.com/

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
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
 arch/arm64/boot/dts/qcom/monaco.dtsi | 32 +++++++++++++
 drivers/mmc/host/sdhci-msm.c         | 24 ++++++++++
 drivers/soc/qcom/ice.c               | 92 ++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c          | 22 ++++++++-
 include/soc/qcom/ice.h               |  2 +
 6 files changed, 213 insertions(+), 1 deletion(-)
---
base-commit: 95c541ddfb0815a0ea8477af778bb13bb075079a
change-id: 20260408-enable-ice-clock-scaling-5ca54ed63179
prerequisite-message-id: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
prerequisite-patch-id: 1750aded4cac0105fbf943c5bfd9f844acf4f227
prerequisite-patch-id: 8cf945709b92296c73859515bb67820360d785a2
prerequisite-patch-id: bc8821cbbe222f208c5d86d96f3640c169b972d6
prerequisite-patch-id: a1baf04d3cce803fcb47b1a80591bf7759de8a76
prerequisite-patch-id: b7de0f216e54e264e054f6333b3067abce8d05c5
prerequisite-patch-id: 57f21e8a9505564caebbf89cafa9bd80be1dfe9f
prerequisite-patch-id: 5128586130e3f5847e0417de47ef755b2e2fba93
prerequisite-patch-id: fa46b7d6710907c5eb5ad01e84d28f09a0b26e5a
prerequisite-patch-id: e375d6e54a55c055f5d8673c65d35073df396646
prerequisite-patch-id: ec670d98300863c4b68155a3b0feeace56a4a55a
prerequisite-patch-id: c5ee690afd7f7105963e991dff760de62a403d9b
prerequisite-message-id: <20260310113557.348502-1-neeraj.soni@oss.qualcomm.com>
prerequisite-patch-id: ab9cc8bd28b2e1e27df6e44907e8d758dfeee3df
prerequisite-patch-id: 40f239f7f06573ed45452249f444e54e3565ada7
prerequisite-patch-id: 59129ed0aeba84f6b50f42261d51fe323806a240
prerequisite-message-id: <20260409-ice_emmc_clock_addition-v2-0-90bbcc057361@oss.qualcomm.com>
prerequisite-patch-id: 5b6a436bd949a93e44f912d2565103f6bf0ef55a
prerequisite-patch-id: 7f9ff2b708418a77578e154102f72f0da243eb71

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

