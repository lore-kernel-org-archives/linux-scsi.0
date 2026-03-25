Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6403537D4;
	Wed, 25 Mar 2026 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452146; cv=none; b=IgZRGZH8AGY/byPIPLJ83VoNvgEko4ULW/i8WJrctQ5BAdGww7EwH6fI5b5cqUJ8RyWyjkzc9HFAWEBdUjUUU0/pbOts16weaN1cnOUt1wXeLh4o5VikhtEIha+4EzaRyWgihjDKNjGR+4Q8viA60p4/ktRJjT98yw6eE7c28kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452146; c=relaxed/simple;
	bh=FoXH869VdS6K0usegNQZ0bZ9pVTuiTR4P6T86L2zcBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=THqXc0XvpZVEXBxwlVtEIaTMt9rKhztLhOWZVYt/y1MyK6QSZGmdjd+2y8FxxgCtZW/a7E4U8c4oTcFAAYPw7nwf0V+npk2dzjA8xRxhnUdjkKdTms7NwL/DHVJSMqJ+zt+n6MIshFkuxKoWnrueDJPASEVHZEZZr83HyPYdaDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=depVfBoT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="depVfBoT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PFH7AR3532232;
	Wed, 25 Mar 2026 15:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=JhKn+8nxRJgE5KLPHpQQU/yuq+dO00WCcEf
	ZDnvrjxU=; b=depVfBoTZK0kQxX9TxJf+XIde+7Zw0ldgvHZRv5uxMZXt/9KDHo
	1A8tQm/eUIr5KdRK0bz7GTkhhPteAAjTIsusCyJ+4xywV476nQL2xfPdXSRIR/+u
	HAOdq6Q4vDivwdP2ob59atwo5gFMO186gY1oGvKdiaIavGCac9WIyhu64jNbqTq1
	Ebcyu75/BqBcLUyT+PPtF664ndz7KjZktyNvPYnLk1i5dpIUGw9madsjXmO9V57M
	pD09yXOPHFn93bnuDm4AoE7VFrXf1QWc+U4Z3t5H+EozL/qvsnkbFP3amFfSAVOu
	QKX43MPvVGxCN5ctvpB0lVkO2iB5khB7g7w==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d4dy4h3er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:21:57 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PFLumT017654;
	Wed, 25 Mar 2026 15:21:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4d475qfgun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:21:56 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62PFLuwT017648;
	Wed, 25 Mar 2026 15:21:56 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 62PFLuhj017645
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:21:56 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id EC1065AE; Wed, 25 Mar 2026 08:21:55 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: [PATCH v5 00/12] scsi: ufs: Add TX Equalization support for UFS 5.0
Date: Wed, 25 Mar 2026 08:21:42 -0700
Message-Id: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDExMCBTYWx0ZWRfXzvWdyjqxjamr
 aRyjjATZ3eAHK8mVWWEtSp90VIBNLt1Z8/HoftGLnbtVFyZo1vf9A3ruWl27r9UvKdAFy5bYPOX
 RUV3GmDRpuvM8JNHyy0mnSFMm0TRl+ivUxxuTl48SPov9+Ff7N4T/IQGcYRx3eU88j/Buqd+1wk
 poqtkF67DaEsdawV/KqsRzr9am4g1m+zDvyPGdMPa/i0L4qqilxnKsuhG/rPlOMYvfUQRedb3Eg
 MmmMEHSGgEf/rcFHzn6khgemHQ6n6Blu7KB8sjzt0VhJ0Pf3w4VCPbMHSVMj9s5Wjk0wiVFmUHP
 N/vqN0u34ZG5dSZTaFPjgb3VIAsTU75KuuM91xAIyYLqtuliMyJI5yW55u3Jt5TO6iPVuSEBvTy
 HQ4rgSbwTc4MJwxSug8+s3rMvKF3vlOMEXv/lgK0jKWvmWvTnvh1ZCQgCDdy1VRdd7yj2O3n6Vk
 0ybUleC0bU3uCr8l1uw==
X-Proofpoint-ORIG-GUID: ap838VB1rT8tasmd4B_0a4s6wNxIebAy
X-Proofpoint-GUID: ap838VB1rT8tasmd4B_0a4s6wNxIebAy
X-Authority-Analysis: v=2.4 cv=eeUwvrEH c=1 sm=1 tr=0 ts=69c3fd95 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=ZyePWOR3t2h397M-7AgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_04,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250110

Hi,

The UFS v5.0 and UFSHCI v5.0 standards have published, introducing support
for HS-G6 (46.6 Gbps per lane) through the new UniPro V3.0 interconnect
layer and M-PHY V6.0 physical layer specifications. To achieve reliable
operation at these higher speeds, UniPro V3.0 introduces TX Equalization
and Pre-Coding mechanisms that are essential for signal integrity.

This patch series implements TX Equalization support in the UFS core
driver as specified in UFSHCI v5.0, along with the necessary vendor
operations and a reference implementation for Qualcomm UFS host
controllers.

Background
==========

TX Equalization is a signal conditioning technique that compensates for
channel impairments at high data rates (HS-G4 through HS-G6). It works
by adjusting two key parameters:

- PreShoot: Pre-emphasis applied before the main signal transition
- DeEmphasis: De-emphasis applied after the main signal transition

UniPro V3.0 defines TX Equalization Training (EQTR) procedure to
automatically discover optimal TX Equalization settings. The EQTR
procedure:

1. Starts from the most reliable link state (HS-G1)
2. Iterates through all possible PreShoot and DeEmphasis combinations
3. Evaluates signal quality using Figure of Merit (FOM) measurements
4. Selects the best settings for both host and device TX lanes

For HS-G6, Pre-Coding is also introduced to further improve signal
quality. Pre-Coding must be enabled on both transmitter and receiver
when the RX_FOM indicates it is required.

Implementation Overview
=======================

The implementation follows the UFSHCI v5.0 specification and consists of:

Core Infrastructure (Patches 1-6):
- New vops callback negotiate_pwr_mode() to allow vendors to negotiate
  power mode parameters before applying TX Equalization settings
- Support for HS-G6 gear enumeration
- Complete TX EQTR procedure implementation in ufs-txeq.c
- Debugfs interface for TX Equalization parameter inspection and manual
  retraining
- Module parameters for adaptive TX Equalization control

Qualcomm Implementation (Patches 7-11):
- PHY-specific configurations for TX EQTR procedure
- Vendor-specific FOM measurement support
- TX Equalization settings application
- Enable TX Equalization for HW version 0x7 and onwards

The implementation is designed to be vendor-agnostic, with platform-
specific details handled through the vops callbacks. Other vendors can
add support by implementing the three new vops:

- tx_eqtr_notify(): Called before/after TX EQTR for vendor setup
- apply_tx_eqtr_settings(): Apply vendor-specific PHY configurations
- get_rx_fom(): Retrieve vendor-specific FOM measurements if needed

Module Parameters
=================

The implementation provides several module parameters for flexibility:

- use_adaptive_txeq: Enable/disable adaptive TX Equalization (default: false)
- adaptive_txeq_gear: Minimum gear for adaptive TX EQ (default: HS-G6)
- use_txeq_presets: Use only the 8 standaird presets (default: false)
- txeq_presets_selected[]: Select specific presets for EQTR

Testing
=======

This patch series has been tested on Qualcomm platforms with UFS 5.0
devices, validating:

- Successful TX EQTR completion for HS-G6
- Proper FOM evaluation and optimal settings selection
- Pre-Coding enablement for HS-G6
- Power mode changes with TX Equalization settings applied
- Report of TX Equalization settings via debugfs entries
- Report of TX EQTR histories via debug entries (see next section)
- Re-training TX Equalization via debugfs entry

Example of TX EQTR history
==========================

# cat /sys/kernel/debug/ufshcd/*ufshcd*/tx_eq_hs_gear6/device_tx_eqtr_record
Device TX EQTR record summary -
Target Power Mode: HS-G6, Rate-B
Most recent record index: 2
Most recent record timestamp: 219573378 us

TX Lane 0 FOM - PreShoot\DeEmphasis
\       0        1        2        3        4        5        6        7
0      50       70       65        -        -        -        -        x
1       x        x        x        x        x        x        x        x
2     100       90       70        -        -        -        -        x
3       x        x        x        x        x        x        x        x
4      95       90        -        -        -        -        -        x
5       -        -        -        -        -        -        -        x
6       x        x        x        x        x        x        x        x
7       x        x        x        x        x        x        x        x

TX Lane 1 FOM - PreShoot\DeEmphasis
\       0        1        2        3        4        5        6        7
0      50       70       60        -        -        -        -        x
1       x        x        x        x        x        x        x        x
2     100       80       65        -        -        -        -        x
3       x        x        x        x        x        x        x        x
4      95       85        -        -        -        -        -        x
5       -        -        -        -        -        -        -        x
6       x        x        x        x        x        x        x        x
7       x        x        x        x        x        x        x        x

Patch Structure
===============

Patches 1-3: Preparatory changes for power mode negotiation and HS-G6
Patch 4: Core TX Equalization and EQTR implementation
Patches 5-7: Debugfs support for TX Equalization
Patches 8-12: Qualcomm vendor implementation

Next
====

One more series has been developed to enhance TX Equalization support,
which will be submitted for review after this series is accepted:

- Provide board specific (static) TX Equalization settings from DTS
- Parse static TX Equalization settings from DTS if provided
- Apply static TX Equalization settings if use_adaptive_txeq is disabled
- Add support for UFS v5.0 attributes qTxEQGnSettings & wTxEQGnSettingsExt
- Enable persistent storage and retrieval of optimal TX Equalization settings

v4 -> v5:
1. Addressed comments from Bean in patch 7, returned -EINVAL when
   negotiated gear != requested gear in function ufshcd_retrain_tx_eq().
2. Addressed comments from Peter in patch 4, moved usage of
   &hba->tx_eq_params[gear - 1] after checks on gear and improved the
   checks on gear in function ufshcd_config_tx_eq_settings().

v3 -> v4:
1. Incorporated comments from Bart and Peter.
2. In patch 1, removed redundant checks on dev_req_params
3. In patch 1, moved error prints out of vops negotiate_pwr_mode()
4. In patch 1, removed vops implemenation ufs_versal2_negotiate_pwr_mode(),
   sprd_ufs_negotiate_pwr_mode() and ufs_intel_lkf_negotiate_pwr_mode() as
   they are simply doing memcpy().
5. In patch 3, initialize UFS_HS_GEAR_MAX as UFS_HS_G6. 
6. In patch 4, adjusted places where UFS_HS_GEAR_MAX is used.
7. In patch 4, defined inline func ufs_hs_rate_to_str() instead of macro.
8. In patch 4, changed default value of use_txeq_presets to 'false'.
8. In patch 4, optimized ufshcd_tx_eq_params and ufshcd_tx_eq_settings.
9. In patch 4, optimized memory usage of ufshcd_tx_eq_params.
10. In patch 5, updated places which use fields in ufshcd_tx_eq_params.
11. In patch 7, used 'retrain' instead of 'refresh'.
12. In patch 10, introduced a few macros.

v2 -> v3:
1. Incorporated comments from Bart, Bean and Mani.
2. In patch 4, made ufshcd_config_pwr_mode() ignore TX EQTR error.
3. Added patch 6 to introduce helpers to pause/resume command processing.
4. In patch 7, changed debugfs entry to 'tx_eq_ctrl' and used 'refresh'
   as input to trigger TX Equalization refreshing.
5. In patch 7, renamed ufshcd_retrain_tx_eq() to ufshcd_refresh_tx_eq().
6. Fixed typos and coding style issues.

v1 -> v2:
1. Incorporated Bart's comments.
2. Fixed typos and coding style issues.
3. Added enum ufshcd_pmc_policy and use enum instead of boolen parameter.
4. Updated TX Equalization debugfs entries structure.
5. Extracted ufshcd_pause/resume_command_processing() in ufshcd.c.
6. Updated sequence in Qualcomm's vops get_rx_fom() implementation.

Can Guo (12):
  scsi: ufs: core: Introduce a new ufshcd vops negotiate_pwr_mode()
  scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a
    parameter
  scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum
    ufs_hs_gear_tag
  scsi: ufs: core: Add support for TX Equalization
  scsi: ufs: core: Add debugfs entries for TX Equalization params
  scsi: ufs: core: Add helpers to pause and resume command processing
  scsi: ufs: core: Add support to retrain TX Equalization via debugfs
  scsi: ufs: ufs-qcom: Fixup PAM-4 TX L0_L1_L2_L3 adaptation pattern
    length
  scsi: ufs: ufs-qcom: Implement vops tx_eqtr_notify()
  scsi: ufs: ufs-qcom: Implement vops get_rx_fom()
  scsi: ufs: ufs-qcom: Implement vops apply_tx_eqtr_settings()
  scsi: ufs: ufs-qcom: Enable TX Equalization

 drivers/ufs/core/Makefile          |    2 +-
 drivers/ufs/core/ufs-debugfs.c     |  290 +++++++
 drivers/ufs/core/ufs-txeq.c        | 1293 ++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h     |   59 +-
 drivers/ufs/core/ufshcd.c          |  192 ++++-
 drivers/ufs/host/ufs-amd-versal2.c |    3 -
 drivers/ufs/host/ufs-exynos.c      |   34 +-
 drivers/ufs/host/ufs-hisi.c        |   23 +-
 drivers/ufs/host/ufs-mediatek.c    |   40 +-
 drivers/ufs/host/ufs-qcom.c        |  591 ++++++++++++-
 drivers/ufs/host/ufs-qcom.h        |   42 +
 drivers/ufs/host/ufs-sprd.c        |    3 -
 drivers/ufs/host/ufshcd-pci.c      |    7 +-
 include/ufs/ufshcd.h               |  174 +++-
 include/ufs/unipro.h               |  141 ++-
 15 files changed, 2779 insertions(+), 115 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-txeq.c

-- 
2.34.1

