Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D15EC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 03:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiLODGt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 22:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLODGs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 22:06:48 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B050D7E
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 19:06:47 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF1oXbu021267;
        Thu, 15 Dec 2022 03:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=PTmDq5RpJbKwd81cyFY1pnIdQZRj5/gZlP7wGzX194U=;
 b=Txww7zPIXSb26gkHnFu+9NF1YsSZoFvaHAomVPTR7PXFj0PCRBCpwMadKumH9cbTdoRH
 IUEEurKclpdOfiw1e2HCIhV1hVWkW3tsGT8lkJ3xgZPOzV8VPcs7ujXgXFQLt9LRaIsF
 sG1uI2nWv/N8EPUQgrm0+qNgaHjBCuQmS8FBX/c1FpFJb/7ZGcxj/jtDN7w3tVyxeSqX
 O5O1Lzu8AJ4xcmIgNMwxfg5ciY5ZmCz+/EW8aRw0VN7JOiKZmFXEfbZs/CmNARANT2fs
 l7DvchzhGaxfA7gaNbOHNJTS8REq1DXubkB18N0nIDGd7VkBsH5B6ATQ/jMQuc7txB+Q jQ== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mf6rfaym8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 03:06:25 +0000
Received: from pps.filterd (NASANPPMTA01.qualcomm.com [127.0.0.1])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 2BF36Pj5019103;
        Thu, 15 Dec 2022 03:06:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA01.qualcomm.com (PPS) with ESMTP id 3mf11ahwr8-1;
        Thu, 15 Dec 2022 03:06:25 +0000
Received: from NASANPPMTA01.qualcomm.com (NASANPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BF36Odh019097;
        Thu, 15 Dec 2022 03:06:24 GMT
Received: from stor-presley.qualcomm.com (corens_vlan604_snip.qualcomm.com [10.53.140.1])
        by NASANPPMTA01.qualcomm.com (PPS) with ESMTP id 2BF36OjW019096;
        Thu, 15 Dec 2022 03:06:24 +0000
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 9716A20DB9; Wed, 14 Dec 2022 19:06:24 -0800 (PST)
From:   Can Guo <quic_cang@quicinc.com>
To:     quic_asutoshd@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Can Guo <quic_cang@quicinc.com>
Subject: [PATCH v3 0/3] Add support for UFS Event Specific Interrupt
Date:   Wed, 14 Dec 2022 19:06:19 -0800
Message-Id: <1671073583-10065-1-git-send-email-quic_cang@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: m53wGSJmTjbO85gtpFB48s0xFjKZKZ1G
X-Proofpoint-ORIG-GUID: m53wGSJmTjbO85gtpFB48s0xFjKZKZ1G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_12,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 mlxscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 mlxlogscore=783 malwarescore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series is
to enable Event Specific Interrupt (ESI), which can used in MCQ mode.

Please note that this series is developed and tested based on the latest MCQ
driver (v11) pushed by Asutosh Das.

v2 -> v3:
- Improved commit msg of patch #2 by incorporating Bart's comment

v1 -> v2:
- Improved QCOM specific ESI configuration flow

Can Guo (3):
  ufs: core: Add Event Specific Interrupt configuration vendor specific
    ops
  ufs: core: mcq: Add Event Specific Interrupt enable and config
    functions
  ufs-host: qcom: Add MCQ ESI config vendor specific ops

 drivers/ufs/core/ufs-mcq.c     | 16 +++++++
 drivers/ufs/core/ufshcd-priv.h |  8 ++++
 drivers/ufs/core/ufshcd.c      |  5 +++
 drivers/ufs/host/ufs-qcom.c    | 97 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.h    |  5 +++
 include/ufs/ufshcd.h           |  8 ++++
 include/ufs/ufshci.h           |  2 +
 7 files changed, 141 insertions(+)

-- 
2.7.4

