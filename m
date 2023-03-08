Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AE5C64EC4
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 04:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCHECj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 23:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCHECh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 23:02:37 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6B09FBCD
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 20:02:33 -0800 (PST)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3283OBqm006032;
        Wed, 8 Mar 2023 04:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=8iBUr68UPf1P/vtSTg/P/4wZhOFI6eQoZdzVncu+0NQ=;
 b=FOYjFmBgwl8KDtYdJx0fmfnTHE0hgGwL2tabWXeanKsjCQPG4l3WtsZuoKgU+W3kDEqq
 yEz7DUwG2+/K5qqBGd+JySQzmQGvr9XUzzGLPPJoW8vioXXadSedZYZjZfv8ht3YcKgj
 66BmRJDrxPw/4or138AbE14OdLvLEC0Ev16R/xDfoBGUKFGfub/M9oMkfzFz7tmpQhNp
 6fc61B3vThrxBHsoxKKwC3b8tFEWWbYx4NXhPBXDBYjNAELuIxhn1amT9cFCtP/ZaNOH
 VrFm3pNAOQRuv4/ZPfU075sCH2rM4f6FZhw99mgpw6Etiiz+P8Tl9zQTuRfZHqmLvlOK MA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3p6femgenk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 04:02:17 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32842GYr022632
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 8 Mar 2023 04:02:16 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 7 Mar 2023 20:02:16 -0800
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [RFC PATCH v1 0/4] ufs: core: mcq: Add ufshcd_abort() support in MCQ mode
Date:   Tue, 7 Mar 2023 20:01:40 -0800
Message-ID: <cover.1678247309.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: _ts4LAHBf_A4CCAw2WS3i9KZMuqDnbwe
X-Proofpoint-ORIG-GUID: _ts4LAHBf_A4CCAw2WS3i9KZMuqDnbwe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_18,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1011 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=603 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series enable support for ufshcd_abort() in MCQ mode.
The first patch is to prepare synchronization for ufshcd_abort() and interrupt contexts.
The second patch contains the supporting functions for ufshcd_abort().
The third and fourth patches add support for MCQ abort as discussed in the UFS
host controller spec.

Bao D. Nguyen (4):
  ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
  ufs: mcq: Add supporting functions for mcq abort
  ufs: mcq: Add support for clean up mcq resources
  ufs: mcq: Added ufshcd_mcq_abort()

 drivers/ufs/core/ufs-mcq.c     | 299 ++++++++++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  19 ++-
 drivers/ufs/core/ufshcd.c      |  57 ++++++--
 drivers/ufs/host/ufs-qcom.c    |   2 +-
 include/ufs/ufshcd.h           |   5 +-
 include/ufs/ufshci.h           |  16 +++
 6 files changed, 383 insertions(+), 15 deletions(-)

-- 
2.7.4

