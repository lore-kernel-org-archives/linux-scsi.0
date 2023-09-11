Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFB7EE57DF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjIKGAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjIKGAo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:00:44 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8C0CD3
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 23:00:37 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38B5DXw1016008;
        Mon, 11 Sep 2023 06:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=3ghS7pHbQC0x2lKxYXkIHPeQ6OJydKfdzMZZLKtgsnU=;
 b=daXtWbfm67UB4hCr1SG4If/x2R6zC3/idCM88O1g2qseA803cChF5KVxBaWIztT6fFjY
 +8JqmqHGoh46Yw6l9hKPhPtd1lQ50f54h+67GnDZrDLN0OYfFyCedD+yzFCctqC+qVHw
 jqZXN//atNj87powA7GeqaSYdXHg4TvKY1HPiq2JNgejSsmm4vWDenINztp6Jb82tRRW
 Q9TXrlMfcKPW8RgUJVeYoluLVbYBeTZovlpccjt5cuG2puzXxDOb5kbkOJ5d3vFUVDN/
 SqNx8W4xoxWY1iafqpqpQODsH2em6WGrG07eMYKd6i+U+vXaM3ixHoI01VLQ5DIKWLfm rA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3t0e2ujtnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Sep 2023 06:00:33 +0000
Received: from pps.filterd (NASANPPMTA03.qualcomm.com [127.0.0.1])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 38B5wubi029744;
        Mon, 11 Sep 2023 06:00:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA03.qualcomm.com (PPS) with ESMTP id 3t0hskq0mr-1;
        Mon, 11 Sep 2023 06:00:32 +0000
Received: from NASANPPMTA03.qualcomm.com (NASANPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38B5vOGR027252;
        Mon, 11 Sep 2023 06:00:32 GMT
Received: from stor-dylan.qualcomm.com (stor-dylan.qualcomm.com [192.168.140.207])
        by NASANPPMTA03.qualcomm.com (PPS) with ESMTP id 38B60Wrm032338;
        Mon, 11 Sep 2023 06:00:32 +0000
Received: by stor-dylan.qualcomm.com (Postfix, from userid 359480)
        id D1A6A20DEF; Sun, 10 Sep 2023 23:00:31 -0700 (PDT)
From:   Can Guo <quic_cang@quicinc.com>
To:     quic_cang@quicinc.com, mani@kernel.org, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 0/6] Enable HS-G5 support on SM8550
Date:   Sun, 10 Sep 2023 22:59:21 -0700
Message-Id: <1694411968-14413-1-git-send-email-quic_cang@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: YJbmN4mFpjkOlujxq1g7v1IOUGAnLOA9
X-Proofpoint-ORIG-GUID: YJbmN4mFpjkOlujxq1g7v1IOUGAnLOA9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_03,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=796 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309110054
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series enables HS-G5 support on SM8550.

This series is rebased on below changes from Mani -
https://patchwork.kernel.org/project/linux-scsi/patch/20230908145329.154024-1-manivannan.sadhasivam@linaro.org/
https://patchwork.kernel.org/project/linux-scsi/patch/20230908145329.154024-2-manivannan.sadhasivam@linaro.org/

This series is tested on below HW combinations -
SM8550 MTP + UFS4.0
SM8550 QRD + UFS3.1
SM8450 MTP + UFS3.1 (for regression test) 


Bao D. Nguyen (1):
  scsi: ufs: ufs-qcom: Add support for UFS device version detection

Can Guo (5):
  scsi: ufs: ufs-qcom: Setup host power mode during init
  phy: qualcomm: phy-qcom-qmp-ufs: Add High Speed Gear 5 support for
    SM8550
  phy: qualcomm: phy-qcom-qmp-ufs: Move data structs and setting tables
    to header
  scsi: ufs: ufs-sysfs: Expose UFS power info
  scsi: ufs: ufs-sysfs: Introduce UFS power info sysfs nodes

 Documentation/ABI/testing/sysfs-driver-ufs         |  48 +-
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v6.h     |   2 +
 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v6.h |   2 +
 .../qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v6.h    |  12 +
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            | 782 +-------------------
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.h            | 805 +++++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c                       |  71 ++
 drivers/ufs/host/ufs-qcom.c                        |  57 +-
 drivers/ufs/host/ufs-qcom.h                        |   3 +
 9 files changed, 1013 insertions(+), 769 deletions(-)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-ufs.h

-- 
2.7.4

