Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00ECCC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 07:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbjEWH3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 03:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbjEWH25 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 03:28:57 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F3E8F
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 00:28:35 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6CUOk017185;
        Tue, 23 May 2023 07:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=1O9wrLLd9wk08Ls9b+nE/UnjRzP4jgb/nPH4+gt7tBk=;
 b=c8WbvKbZ03piRT1mMilmUKPChEHjFasjDyz4MziuMcymARM4S7qaSIFG1PNopBBCvEwf
 SvYSemy4CAHwrsTxu5LptIlwYwCJo27GKKqgPRsgEjHW2sQcF++YvIyDxjxdkcWnv6wD
 oVSpy4Pbvl8E+j/9pCLFP6FA1iND5e7jzonhdH0bz3CuJOzgxoR8ZPTkeoDheXrigoLl
 h6Ys0+OgPpxQGmTbfNwoM/IJWidzNA7VUVZBYHZ4ipBdWpcPKLWlcGNewjby3IPiECRV
 A7xpcGnztBs2EqbH4gGipKyJqJQImTDrHdz59cyDJwQqp5q1c4ukDeduSFaFazqwMojR rg== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qr6h0t6v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 07:28:26 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34N7SP4D022810
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 07:28:25 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 23 May 2023 00:28:24 -0700
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v6 0/7] ufs: core: mcq: Add ufshcd_abort() and error handler support in MCQ mode
Date:   Tue, 23 May 2023 00:28:08 -0700
Message-ID: <cover.1684825500.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 5vc2MisprUEEKPxy52nIHc-C71Audm6E
X-Proofpoint-ORIG-GUID: 5vc2MisprUEEKPxy52nIHc-C71Audm6E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_04,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230060
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series enable support for ufshcd_abort() and error handler in MCQ mode.

Bao D. Nguyen (7):
  ufs: core: Combine 32-bit command_desc_base_addr_lo/hi
  ufs: core: Update the ufshcd_clear_cmds() functionality
  ufs: mcq: Add supporting functions for mcq abort
  ufs: mcq: Add support for clean up mcq resources
  ufs: mcq: Added ufshcd_mcq_abort()
  ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
  ufs: core: Add error handling for MCQ mode

 drivers/ufs/core/ufs-mcq.c     | 233 +++++++++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  17 ++-
 drivers/ufs/core/ufshcd.c      | 234 +++++++++++++++++++++++++++++++++--------
 drivers/ufs/host/ufs-qcom.c    |   2 +-
 include/ufs/ufshcd.h           |   5 +-
 include/ufs/ufshci.h           |  23 +++-
 6 files changed, 457 insertions(+), 57 deletions(-)
---
v5->v6: Addressed Stanley's comments
patch #1,2,3,4,6: unchanged.
patch #5: fixed extra erroneous if() statement introduced in version v5
patch #7: Change ufshcd_complete_requests() to call a new mcq function
          ufshcd_mcq_compl_pending_transfer(), leaving ufshcd_transfer_req_compl()
          to be used in SDB mode only.

          Reset the hwq's head and tail slot variables to default values
          when the ufs host controller hw has been reset.
---
v4->v5:
patch #4: fixed uninitialized variable access introduced in patch v3.
---
v3->v4: Mainly addressed Bart's comments
patch #1: updated the commit message
patch #2: renamed ufshcd_clear_cmds() into ufshcd_clear_cmd()
patch #3: removed result arg in ufshcd_mcq_sq_cleanup()
patch #4: removed check for "!rq" in ufshcd_cmd_inflight()
          avoided access to door bell register in mcq mode 
patch #5, 6: unchanged
patch #7: ufshcd_clear_cmds() to ufshcd_clear_cmd()
--- 
v2->v3:
patch #1:
  New patch per Bart's comment. Helps process utp cmd
  descriptor addr easier.
patch #2:
  New patch to address Bart's comment regarding potentialoverflow 
  when mcq queue depth becomes greater than 64.
patch #3:
  Address Bart's comments
  . Replaced ufshcd_mcq_poll_register() with read_poll_timeout()
  . Replace spin_lock(sq_lock) with mutex(sq_mutex)
  . Updated ufshcd_mcq_nullify_cmd() and renamed to ufshcd_mcq_nullify_sqe()
  . Minor cosmetic changes
patch #4:
  Adress Bart's comments. Added new function ufshcd_cmd_inflight()
  to replace the usage of lrbp->cmd
patch #5:
  Continue replacing lrbp->cmd with ufshcd_cmd_inflight()
patch #6:
  No change
patch #7:
  Address Stanley Chu's comment about clearing hba->dev_cmd.complete
  in clear ufshcd_wait_for_dev_cmd()
  Address Bart's comment.
---
v1->v2:
patch #1: Addressed Powen's comment. Replaced read_poll_timeout()
with ufshcd_mcq_poll_register(). The function read_poll_timeout()
may sleep while the caller is holding a spin_lock(). Poll the registers
in a tight loop instead. 
-- 
2.7.4

