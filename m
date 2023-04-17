Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89A4C77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 21:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjDQVGh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 17:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjDQVGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 17:06:24 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627E910F0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 14:06:23 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33HKRXXX019464;
        Mon, 17 Apr 2023 21:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=JtxR9KLW43XfCyEKb//9RKqGhPMZL8YC776NJ1L1fFM=;
 b=jfu54X0m5Rn5gPoJthlRfBTSN9sPUbfYgVBIkBMqmkGFD6FWnIADHgrZ+bxGzN6YWub3
 hJka0+3Y9cZ3qKeJNFjFmPjcEGtZ0owvBV+za4cK78qwrFn75sUkY6WN5v60n9RrGJ/A
 wqvDDXE/ZpoxQ4JhevNwnz7vRqs0lVwI5ECvseQ7/tD8vFKxYdDzIrwMr+Fqxcy93Uzn
 qEpMV1/TUKpQtD/0NRZlHSbd/XP0txtZqVds4y/fnKNID9vne8CL1NbL3V5qnr6SIBC8
 bNdYdiYwS40EnVgv0frbtBYhPVJAFpHXvJXTV7INsI76xQmSQaMFCZuMfs8Q2b+lkBMf fg== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q12ut9q67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 21:06:02 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33HL61B5018907
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 21:06:01 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 17 Apr 2023 14:06:01 -0700
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>, <Powen.Kao@mediatek.com>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v2 0/5] ufs: core: mcq: Add ufshcd_abort() and error handler support in MCQ mode
Date:   Mon, 17 Apr 2023 14:05:44 -0700
Message-ID: <cover.1681764704.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: OarzJVBE9TcosN87KmKQivt4uhwfVR_H
X-Proofpoint-ORIG-GUID: OarzJVBE9TcosN87KmKQivt4uhwfVR_H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-17_14,2023-04-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxlogscore=818 lowpriorityscore=0 adultscore=0
 phishscore=0 mlxscore=0 clxscore=1015 suspectscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304170186
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series enable support for ufshcd_abort() and error handler in MCQ mode.
The first 3 patches are for supporting ufshcd_abort().
The 4th and 5th patches are for supporting error handler.

Bao D. Nguyen (5):
  ufs: mcq: Add supporting functions for mcq abort
  ufs: mcq: Add support for clean up mcq resources
  ufs: mcq: Added ufshcd_mcq_abort()
  ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
  ufs: core: Add error handling for MCQ mode
---
v1->v2:
patch #1: Addressed Powen's comment. Replaced read_poll_timeout()
with ufshcd_mcq_poll_register(). The function read_poll_timeout()
may sleep while the caller is holding a spin_lock(). Poll the registers
in a tight loop instead.
---

 drivers/ufs/core/ufs-mcq.c     | 258 ++++++++++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  15 ++-
 drivers/ufs/core/ufshcd.c      | 140 ++++++++++++++++++----
 drivers/ufs/host/ufs-qcom.c    |   2 +-
 include/ufs/ufshcd.h           |   2 +-
 include/ufs/ufshci.h           |  17 +++
 6 files changed, 404 insertions(+), 30 deletions(-)

-- 
2.7.4

