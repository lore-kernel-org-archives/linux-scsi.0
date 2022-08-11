Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502F1C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 10:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiHKKdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 06:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiHKKd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 06:33:29 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7968051B
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 03:33:28 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27B4SoNT028069;
        Thu, 11 Aug 2022 10:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : subject
 : date : message-id; s=qcppdkim1;
 bh=R6jyc3BlYz9JlpksDkJ6xCNkLSrLD49kTS6ccODauC4=;
 b=mekTXICaG7dSUsW+FGJ0vgXpOcElK+GtCqaVTUd6PlBgg5djPn8SrLVB6r6OYMvGctPs
 JxkV4KnUqqNiG99CrE8sifH6XOib3tjJ+eeUk8vY5rHpxA5SIKhBc03S82RwOTRs4qZ1
 yxC30KOU2bJ6shxQqL3aQ1GTqpAYi/YLavGTlYKFJDUo2unmab2OKoZ2X0hvLZQv8RUq
 YA04bwRTe6pkXc7vanhD7Wh0v1QJGdAj9NoElud5RoX2F1dqyasn4yHl1HzAlkjmzB8a
 VcIvfgffRoy/ZK2ViD9SgNChNCoYr9eMKgm7BZIGtwFnyZKgFITktd8qscE3KMgoGlsf IQ== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3hvtrnrvuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 10:33:09 +0000
Received: from pps.filterd (NASANPPMTA01.qualcomm.com [127.0.0.1])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 27BAX8hD020938;
        Thu, 11 Aug 2022 10:33:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA01.qualcomm.com (PPS) with ESMTPS id 3hshcksjyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 11 Aug 2022 10:33:08 +0000
Received: from NASANPPMTA01.qualcomm.com (NASANPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27BAVsvd019441;
        Thu, 11 Aug 2022 10:33:08 GMT
Received: from stor-presley.qualcomm.com (wsp769891wss.qualcomm.com [192.168.140.85] (may be forged))
        by NASANPPMTA01.qualcomm.com (PPS) with ESMTP id 27BAX7ms020931;
        Thu, 11 Aug 2022 10:33:08 +0000
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 973A622752; Thu, 11 Aug 2022 03:33:07 -0700 (PDT)
From:   Can Guo <quic_cang@quicinc.com>
To:     quic_asutoshd@quicinc.com, quic_nguyenb@quicinc.com,
        quic_xiaosenh@quicinc.com, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, bvanassche@acm.org, beanhuo@micron.com,
        avri.altman@wdc.com, mani@kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, quic_cang@quicinc.com
Subject: [RFC PATCH v2 0/2] UFS Multi-Circular Queue (MCQ)
Date:   Thu, 11 Aug 2022 03:33:02 -0700
Message-Id: <1660213984-37793-1-git-send-email-quic_cang@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 8Ok7xskO75HyYCEN6n8Fq3lmJh6U9t49
X-Proofpoint-GUID: 8Ok7xskO75HyYCEN6n8Fq3lmJh6U9t49
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_05,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=708 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 clxscore=1011 mlxscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS Multi-Circular Queue (MCQ) has been added in UFSHCI v4.0 to improve storage performance.
This patch series is a RFC implementation of this.

This is the initial driver implementation and it has been verified by booting on an emulation
platform. During testing, all low power modes were disabled and it was in HS-G1 mode.

Please take a look and let us know your thoughts.

v1 -> v2:
- Enabled host_tagset
- Added queue num configuration support
- Added one more vops to allow vendor provide the wanted MAC
- Determine nutrs and can_queue by considering both MAC, bqueuedepth and EXT_IID support
- Postponed MCQ initialization and scsi_add_host() to async probe
- Used (EXT_IID, Task Tag) tuple to support up to 4096 tasks (theoretically)

Asutosh Das (1):
  scsi: ufs: Add Multi-Circular Queue support

Can Guo (1):
  scsi: ufs-qcom: Add MCQ support

 drivers/ufs/core/Makefile   |   2 +-
 drivers/ufs/core/ufs-mcq.c  | 524 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c   | 394 +++++++++++++++++++++++++--------
 drivers/ufs/host/ufs-qcom.c | 125 +++++++++++
 drivers/ufs/host/ufs-qcom.h |   4 +
 include/ufs/ufs.h           |   5 +
 include/ufs/ufshcd.h        | 223 ++++++++++++++++++-
 include/ufs/ufshci.h        |  77 +++++++
 8 files changed, 1264 insertions(+), 90 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-mcq.c

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

