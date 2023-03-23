Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF97FC6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 09:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjCWJ4M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 05:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCWJzg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 05:55:36 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA75B1422E
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 02:54:09 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N5gPhm028489;
        Thu, 23 Mar 2023 09:53:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=QSfjN4Pp3jtIwVIbVF6UnamxrKcTxpZn9xLHXZ4KqaY=;
 b=Cn59fIq5hLE4d5zK36sccspShuhkKJUeDtDhSVH+T7Knbby3E2ERcZwIvlHnu2NqlVwM
 JRT6CaH/dILmVbejIhiTBC10kY2RF83uNANGb0gGCPqO90/vkeYEg045ExgP1sul7Z2v
 ZYfTeZhUNmeSF8/9QKpOw6dr1NDTiNlO6PkoWnBOo65Pcs9n3zSTazi9I6AxLHXd0MJK
 QZnXmbbJf/nCUa6oJVSCyX8bNAD0LwiA6mfAeHB0ig1U9e/73SXeHN2+rd/kdIobRvOB
 xD/ld0eTIoNKn3xUo9PicSjuFMahulal2qVuv/aEFBi12zd2Nqnj3kYghLsWgwdluWjU kQ== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pg64k1xbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 09:53:54 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32N9rqrO022392
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 09:53:52 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Thu, 23 Mar 2023 02:53:52 -0700
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [RFC PATCH v3 0/5] ufs: core: mcq: Add ufshcd_abort() support in MCQ mode
Date:   Thu, 23 Mar 2023 02:53:30 -0700
Message-ID: <cover.1679564391.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 0vI2ndIU38uekM9Dfb6290FOT_5FAjhI
X-Proofpoint-ORIG-GUID: 0vI2ndIU38uekM9Dfb6290FOT_5FAjhI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=604 phishscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230074
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
v2->v3:
patch #1:
  - In ufshcd_mcq_sq_cleanup(), identify dev_command and correctly use the hwq dedicated for dev command.
  - Addressed Bart's comments:
    a. ufshcd_mcq_sqe_search(), renaming "i" into "slot"
    b. modify ufshcd_mcq_update_sq_head_slot() to return the head slot value. Removed the sq_head_slot member variable.
  - Addressed Seo's coment. Stop the SQ before the ufshcd_mcq_sqe_search() and restart the SQ after the search is done.

patch #4 and #5: new patches for error handling.
Error handling support will go together with ufshcd_abort() support.
---
v1->v2:
patch #1
  - Removed ufshcd_mcq_cqe_search()
  - Removed mcq_poll_ms from the hba. Replaced with MCQ_POLL_MS
patch #2
  - Changed the type of mask argument from u32 to unsigned long in function ufshcd_clear_cmds()
patch #3
  - Removed the ufshcd_mcq_cqe_search error case
---

 drivers/ufs/core/ufs-mcq.c     | 257 ++++++++++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  15 ++-
 drivers/ufs/core/ufshcd.c      | 139 ++++++++++++++++++----
 drivers/ufs/host/ufs-qcom.c    |   2 +-
 include/ufs/ufshcd.h           |   2 +-
 include/ufs/ufshci.h           |  17 +++
 6 files changed, 404 insertions(+), 28 deletions(-)

-- 
2.7.4

