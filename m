Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F62366821
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803281; cv=none; b=Fx6M3fTda1wywBBZw0w3tsEB5yMJ5jiNohzp+rblsUxz/OCnzMB4BHsgCqNH21FAEXmCgVmlAGrPG+FcLodgPKRgHyp8rcUantRgPP3tVvCre6vHKOF8Kaj8xcDaccMXhvzHXB+WTGOiAmwojpigXIlr7aw5BkKU4OR2mESEQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803281; c=relaxed/simple;
	bh=6ARsp9atQmUNw6Xa7IgxkJuoDS+d7gKJ9ZK7Tf/3pt0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=dGwBME/bKqNa40k9bcC9E8X+3tGjXW9VKxgNOMmf3oTNwK9Qg0TChn+CTwTudplpcTGS++gU6qocTU+J8FgluDj3jH5pD3E5l6Klyqn1wZoiZoqvLyZ9rgrgVJDJpimyOo9yxZm1lsP1yzzluii8+a6M7bUyWBA11GQ4PVueuds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W61R0L6k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FXf9HXBd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W61R0L6k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FXf9HXBd"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B4fmWc4013626
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=UsW5mcXGCmvKB7BggdY6RH
	n50BgOLMf7MW1eLSPUZMQ=; b=W61R0L6kZoToLklZBXzXsP1CG1cRQ5eA+/dRqm
	8j2ICFQ2uXbR//Q+t6krjkdGNlCeI6USkaowIaOQhLTEkVPLJigAeHI1SjFA0+8Y
	KW0wXsfG6xDGBkQA0w4gz+EhndeMFPB58X2QLjlKiMrEEACoK92A3qXDxzu47xnD
	UvrA/eHEP/gxo8znWtwI6aSopUHUq8z/gw+tqiBbtLHwTS0zicOHHVYYY2+vk6tt
	mlSxjFeytpWQO3KrZ6GGj0gPqhZeP943DK+bXtHrtG/r9dXsk18FhJpUisEA3Pzo
	30Am0MdOXWuzZbQex/ycLwl+6EhdYfCJmnUQTkGMFv1ty9ww==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c8aadagwm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:47:59 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3562370038dso1315878a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 01:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770803278; x=1771408078; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UsW5mcXGCmvKB7BggdY6RHn50BgOLMf7MW1eLSPUZMQ=;
        b=FXf9HXBd+R5txdUg3c2dt++QI5KCrIKfYeJ3+ZPDy5PbLtZUtx4Lb1vSr2cXSV9o9Z
         YA7DMioMuwyp1a/aqkRfNpieO7lApoFHpyn0c+NgXg5fIFnjvxSPx5MeoKMNOjS4den/
         coLor1YzFwnUOS1oFRR7LybXWzx5TyuZ07Ey4gY8B1ymK1ELeYKCMV0Y3OZbB6jTvcX2
         pLlAOYWKKhBEgVWxKKrJZZe0q/MZyuOvWcPMdrAytKhtc6AWVown60QWaQWYm40wDCcl
         RqS1s0DVtDnSmw5u8O23p2DXKYARCo+7qGj/AjPGsilNSmvuQuW9cloqhMAFz7mgKwEA
         cNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770803278; x=1771408078;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsW5mcXGCmvKB7BggdY6RHn50BgOLMf7MW1eLSPUZMQ=;
        b=ZyBriVmnJPgk9HMkbeCQsiP/dc3FdqIxrKatvvUvXgM9AD4CkkDxt0L/F5u5/TcJS7
         WcyXT+cZ+FZLyWZ+iSWVWplxdtB0nZ49plHPOc9mD2P2K00QTQtnvJqOYpOQywajgSBx
         Cn8SgaewxuwZpUX47iDKmnOYGIJHNvM0k0XYIrZ4x2P9wyslV/V+QE67uwXUdBaU9efx
         Qrlkae5SrzGRziOu4PAKBLuPiFvDV+wsEixhBPePceYGrMY/AVlescXvxrvUs5HWX6Gx
         4SDnvAJPgv++Sdg1LPjvW2glxIKAFotuHt1xIecB88cyjEodUbVpwYjs8G29IRlXbQ7I
         EA8A==
X-Forwarded-Encrypted: i=1; AJvYcCXD24pi2XbBM/LC3bGDvNt1EGJ6WMpAaqFx22rf5WEl9fI+C9MXiFuM4+w2pYAXYPsxNpixQFtQTBMI@vger.kernel.org
X-Gm-Message-State: AOJu0YyAcPSmdnSraCLtXt0ZnOEoe0pmbDl+C4kxzeFoKd+4pyFuggmZ
	Q6SHHVL6TsA3uc/2rMEgoWedgF6ySM9OvzyPcSb5Mj4IlTiq0ECJyOA3aRop44ZOylIqWUqJ2sk
	eEpERUyr/xZNJ2kQNDUnULUKFoQZMCQjIY1inOJjGxVroxwIazVEQRnrGISSk1eip31nH9omX
X-Gm-Gg: AZuq6aILL5tKIR2AySznByXreVrIV9xpERY+umQzdwHal3RtqLeFD8ako4Ekn0F6Vrf
	tCQ1SCcIxw1qIqGF2Tr32yHyFkd+CEWPNke23f6MvA61gWQhLrmbLmuKSi2j80+iRw4r8tVhJUK
	DCJZVCqd8iliA7T8E26bgqlAF9S0N+qOOw040UyH958R2oovtcfRP69+FUT1CTpnWl+qnZbASQQ
	I5chMLipHOpcQokBEJvbq0TW96RKvuQaS+Zp63m9UUCdvDT3+5ClMxBDltk+CHykk9JJGJC3kWT
	Il9Am3GCaf3mVt1Rh5s+QbL2xoAUn+v+CrxWfv7fQvOeZW7k66Ga52Qk6+B/y1ph7K/xepMRh9B
	KnNPV3TFJZdElCpVVXtnH+c4IMzM69bWZ7G4JyHci4eI9+vQeCt64VOTUrRs=
X-Received: by 2002:a17:90a:7f85:b0:340:c60b:f362 with SMTP id 98e67ed59e1d1-354b3c53063mr11896880a91.6.1770803277825;
        Wed, 11 Feb 2026 01:47:57 -0800 (PST)
X-Received: by 2002:a17:90a:7f85:b0:340:c60b:f362 with SMTP id 98e67ed59e1d1-354b3c53063mr11896875a91.6.1770803277308;
        Wed, 11 Feb 2026 01:47:57 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6b84dsm7526640a91.10.2026.02.11.01.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:47:56 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH v5 0/4] Enable ICE clock scaling
Date: Wed, 11 Feb 2026 15:17:43 +0530
Message-Id: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAD9QjGkC/4XPwU7DMAwG4FeZciZTnLQm2Yn3QDskrrNFdA00W
 wWa+u6kQwgOjF4s/Zb1/fJVFB4TF7HbXMXIUyopDzW0DxtBRz8cWKauZqGVbgG0kjz40LO8xCI
 TsaQ+04ss5Ps0HGRQaMhHwxidqMTryDG93/jnfc3HVM55/Li1TbBsv2Cl4H94AlmrybUIqAI6f
 MqlbN8uvqd8Om3rEIs/6R8T9Jqpq4lI4VE7Z1UDd0zzbaICbVZMU81OdbY12ofO2Ttm89u0K2Z
 TzeWwAbaR+K/f53n+BM0ZukLLAQAA
X-Change-ID: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: ZTC-wB3Ypn-_tyyddhJeeRyglCaioz3A
X-Proofpoint-GUID: ZTC-wB3Ypn-_tyyddhJeeRyglCaioz3A
X-Authority-Analysis: v=2.4 cv=OoVCCi/t c=1 sm=1 tr=0 ts=698c504f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Lsz1E_LYmYg3FmW8_BQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA3OSBTYWx0ZWRfX9OqcE/Ezfnko
 nR28dl3AU1FwsAU9fWY1UlAIjqoRvb3NwlJGL0YEfDaNw2I+gGvVIF+ANsT/fdPnwM0cHeQKYpE
 nyTmJhyXCBHzwESBJq3+p9ddkYSUZWVKnDzLni8I4rlvw7Y3I6srJzKF6sDvplGgiUCMgBoTzoZ
 3RX5wtfKDOxm/jykEFhwHXLYCVexeLXDj2t0plJLNrH/ahnp8wmhS7eTRwmYgiuCqCVx16f+o9n
 KalZuM52uZE7DvxPX+QvluaBxlLaY3eS07EbloZZ/Ut/1A46rl78GypTYLeb+gfMWzcqV/5foqc
 MVLqYBANusaH0cuz2sKoBX9C96AMhKgmBo3Q/99Po90v/4mM8HpVFdCC1R/hFxsLnBH0L5Guej7
 62q+9uUTu2orSlOB8dVPkVi59LcFPP55e78y3a7nZJ4D+q/Pp7s1gZY5BGOUTUXV2HSanUoZ9Bm
 o64cL831aldVYe6Y5qg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110079

Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
using the OPP framework. During ICE device probe, the driver now attempts to
parse an optional OPP table from the ICE-specific device tree node to
determine minimum and maximum supported frequencies for DVFS-aware operations.
API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
controller driver in response to clock scaling requests, ensuring coordination
between ICE and host controller.

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

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  26 ++++
 drivers/soc/qcom/ice.c                             | 137 ++++++++++++++++++++-
 drivers/ufs/host/ufs-qcom.c                        |  17 +++
 include/soc/qcom/ice.h                             |   5 +
 4 files changed, 182 insertions(+), 3 deletions(-)
---
base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

