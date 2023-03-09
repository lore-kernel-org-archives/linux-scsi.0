Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12A9C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 05:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCIF3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 00:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCIF3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 00:29:32 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AA91B30F
        for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2023 21:29:31 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32955InW009218;
        Thu, 9 Mar 2023 05:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=Gmpum9S5M04NKQNDDRL5hphDqunvTtJNNn7FwwgJWxo=;
 b=OuZSHQtQ78kYwEBLWSCfiuRXSUaR1CN3Rc8pAs6RiyjRiVTijdRsRQFoP7y+56KtgHRE
 6AH1z9OezRJa/4JgFgCzOaZLSQI2NzhjwLvnrujnNVPYSHBfqOs8Uni3l1Z5O3P9lmok
 2aW4+basN8/6LTh72kG0dI84v66yqPLFE7v/9JSN+Jz7MnTdmvdw8mjWBL00AqYlHD5U
 1AOLfCublGVQZQF7JgcyAxkBGTRFB9U7RpKBZ1NpSrqr0a43Bpr7PDb36drw+mGpkF41
 wkglfDBSSaZyPGvV4RCjDv3/0emh7+Zv0z8UwCH/vmkdnvI1HdU5NXFO2Lkp32n6x23n Lw== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3p758crgtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 05:29:11 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3295TA1F024164
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 9 Mar 2023 05:29:10 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 8 Mar 2023 21:29:09 -0800
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [RFC PATCH v2 0/3] ufs: core: mcq: Add ufshcd_abort() support in MCQ mode
Date:   Wed, 8 Mar 2023 21:28:54 -0800
Message-ID: <cover.1678338926.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: TVIBxpJTDFBWP9dil6K8vZ18Xp5Ijbos
X-Proofpoint-GUID: TVIBxpJTDFBWP9dil6K8vZ18Xp5Ijbos
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_02,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=605 phishscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090042
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series enable support for ufshcd_abort() in MCQ mode.
The first patch is to prepare synchronization for ufshcd_abort() and interrupt contexts.
The second patch contains the supporting functions for ufshcd_abort().
The third and fourth patches add support for MCQ abort as discussed in the UFS
host controller spec.

Bao D. Nguyen (3):
  ufs: mcq: Add supporting functions for mcq abort
  ufs: mcq: Add support for clean up mcq resources
  ufs: mcq: Added ufshcd_mcq_abort()
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

 drivers/ufs/core/ufs-mcq.c     | 243 +++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  17 +++
 drivers/ufs/core/ufshcd.c      |  55 ++++++++--
 include/ufs/ufshcd.h           |   1 +
 include/ufs/ufshci.h           |  16 +++
 5 files changed, 324 insertions(+), 8 deletions(-)

-- 
2.7.4

