Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BA8ECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 01:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiIWBG6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 21:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiIWBG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 21:06:56 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB251166CC
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 18:06:55 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28N08YpK018680;
        Fri, 23 Sep 2022 01:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=vF4XAR3mk2ZrFMINvDP0YS9WPLfwYHYB4feFT3aL1iE=;
 b=e/0VpLoAoiXU2lseUlhrc/GBn5zui4UKqjDpcK7uFZ/do0lfBgOsB0ZLPMvqoiuzlwj5
 ApVq3qvZqy3wIzpPbTMCfuh2gbcFf3yagPleW63PoMWd9727MTcIwxYF3SSt3eMGfkJA
 XPCBy96C/pv8Yq1pQ1fBVQXHjYq5d2qY9T/pXcEBBdZmvKMhu7cULf7cSxS2NkFGFxIK
 VhJaK1uGmqBhmgk4Z5BHcfbiIB6HFc9z0yPWSPXX0SevhuOUjW52PEiOcBQdJBrVUeH1
 CzjCR8JXhnurOQvYZ0OE5OquNn2ZVqGhfDpRfarIMTESoIvfomtAD+/YJnIRVbA1DxUC 4A== 
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jrpqnskhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 01:06:13 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28N16BQe015496
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 01:06:11 GMT
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 22 Sep 2022 18:06:11 -0700
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     <mani@kernel.org>, <quic_nguyenb@quicinc.com>,
        <quic_xiaosenh@quicinc.com>, <quic_cang@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <quic_rampraka@quicinc.com>,
        <quic_richardp@quicinc.com>, <stanley.chu@mediatek.com>,
        <adrian.hunter@intel.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH v1 00/16] Add Multi Circular Queue Support 
Date:   Thu, 22 Sep 2022 18:05:07 -0700
Message-ID: <cover.1663894792.git.quic_asutoshd@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: _eHWTivX9oA1CgYXow0M2wjUbC4tC0RX
X-Proofpoint-GUID: _eHWTivX9oA1CgYXow0M2wjUbC4tC0RX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_16,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


UFS Multi-Circular Queue (MCQ) has been added in UFSHCI v4.0 to improve storage performance.
This patch series is a RFC implementation of this.

This is the initial driver implementation and it has been verified by booting on an emulation
platform. During testing, all low power modes were disabled and it was in HS-G1 mode.

Please take a look and let us know your thoughts.

v1:
- Split the changes
- Addressed Bart's comments
- Addressed Bean's comments

* RFC versions:
v2 -> v3:
- Split the changes based on functionality
- Addressed queue configuration issues
- Faster SQE tail pointer increments
- Addressed comments from Bart and Manivannan

v1 -> v2:
- Enabled host_tagset
- Added queue num configuration support
- Added one more vops to allow vendor provide the wanted MAC
- Determine nutrs and can_queue by considering both MAC, bqueuedepth and EXT_IID support
- Postponed MCQ initialization and scsi_add_host() to async probe
- Used (EXT_IID, Task Tag) tuple to support up to 4096 tasks (theoretically)

Asutosh Das (16):
  ufs: core: Probe for ext_iid support
  ufs: core: Introduce Multi-circular queue capability
  ufs: core: Defer adding host to scsi if mcq is supported
  ufs: core: mcq: Introduce Multi Circular Queue
  ufs: core: mcq: Configure resource regions
  ufs: core: mcq: Calculate queue depth
  ufs: core: mcq: Allocate memory for mcq mode
  ufs: core: mcq: Configure operation and runtime interface
  ufs: core: mcq: Use shared tags for MCQ mode
  ufs: core: Prepare ufshcd_send_command for mcq
  ufs: core: mcq: Find hardware queue to queue request
  ufs: core: Prepare for completion in mcq
  ufs: mcq: Add completion support of a cqe
  ufs: core: mcq: Add completion support in poll
  ufs: core: mcq: Enable Multi Circular Queue
  ufs: qcom-host: Enable multi circular queue capability

 drivers/ufs/core/Makefile      |   2 +-
 drivers/ufs/core/ufs-mcq.c     | 511 +++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  84 ++++++-
 drivers/ufs/core/ufshcd.c      | 322 +++++++++++++++++++++-----
 drivers/ufs/host/ufs-qcom.c    |  49 ++++
 drivers/ufs/host/ufs-qcom.h    |   4 +
 include/ufs/ufs.h              |   6 +
 include/ufs/ufshcd.h           | 136 +++++++++++
 include/ufs/ufshci.h           |  63 +++++
 9 files changed, 1117 insertions(+), 60 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-mcq.c

-- 
2.7.4

