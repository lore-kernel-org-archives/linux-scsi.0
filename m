Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA657C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 22:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjE2WND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 18:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjE2WNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 18:13:01 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED9CCD
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 15:13:00 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34TMCb3F008310;
        Mon, 29 May 2023 22:12:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=7XsRUszmKtdDjqYeDUgXHOEJ+t0fXmbX6y2C83u0YK0=;
 b=OpGUuI0EbR1mFF2wAn4gqVF2wuX2IN69BCZ4VvdAOqvNyRCBomywhJCG0w9mEpqQJIVQ
 SAWkSDYwrgHiiCptmZLDdv5dqFFQOksbfO6/66fUdQ4TvmxJAdR1sp99CtEolFtNMTwx
 HxAyWDjDkbQQDwrdIrJqPVTgYppDvidebbnpAOMWgVDLUbUZTH236X4kwuJR9lahNBZg
 nWYrnxDpD1/MXReM/pKkSw4BHC42s96ADEkg7JwYwgAGpfWpH2Rw/COhobJ2PhvTTK+x
 ngIcQsJTk6Ae9UQ/wLnFmLQjhnnl2e1rIjXMIFIhkVu8Z+xkF694Z9Hy2HFD4Vag9G04 1w== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qub5r49r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 May 2023 22:12:36 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34TMCZWo014600
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 May 2023 22:12:35 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 29 May 2023 15:12:35 -0700
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v7 0/7] ufs: core: mcq: Add ufshcd_abort() and error handler support in MCQ mode
Date:   Mon, 29 May 2023 15:12:19 -0700
Message-ID: <cover.1685396241.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: PmqBtaS9g7ZfoH3dJIHigv5PGN1CUhEH
X-Proofpoint-GUID: PmqBtaS9g7ZfoH3dJIHigv5PGN1CUhEH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-29_12,2023-05-29_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305290187
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

 drivers/ufs/core/ufs-mcq.c     | 259 ++++++++++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  18 ++-
 drivers/ufs/core/ufshcd.c      | 256 ++++++++++++++++++++++++++++++++--------
 drivers/ufs/host/ufs-qcom.c    |   2 +-
 include/ufs/ufshcd.h           |   5 +-
 include/ufs/ufshci.h           |  23 +++-
 6 files changed, 501 insertions(+), 62 deletions(-)
---
Changes compared to v6:
patch #7: Added a new argument force_compl to function ufshcd_mcq_compl_pending_transfer().
          Added a new function ufshcd_mcq_compl_all_cqes_lock().
	  This change is to handle the case where the ufs host controller has been reset by
	  the ufshcd_hba_stop() in ufshcd_host_reset_and_restore() prior to calling
	  ufshcd_complete_requests(). The new logic is added to correctly complete all the
	  commands that have been completed in the Completion Queue, or inform the scsi layer
	  about those commands that are still stuck/pending in the hardware.
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

