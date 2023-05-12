Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFBFC77B7C
	for <linux-scsi@archiver.kernel.org>; Fri, 12 May 2023 06:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbjELGa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 May 2023 02:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239993AbjELGaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2023 02:30:20 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF855243
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 23:29:49 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C6IYRK017339;
        Fri, 12 May 2023 06:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=uCRJMk5cjKXoVlGaNLJ12kWNQ6zlY5hQ+minlnvh3N4=;
 b=mCZxEP2FpqA8SVRvZZXY94I/DM+cK/q9ljlGvz3r/B/IpcpzG+12fR8psGfDi/3cnL/E
 NLijzXmPY6WUaYpXYwmEeXOodJqg8DMKMA3PVsIYF12BtfgSGoRn9BRBSSRH4hfD6Y4P
 0kUOQ59xDa99NAPQhkJuPR5jAFS58zLDV2RIowFptZkZstDGmMCMPUFpdBYKgqcUoEsr
 PLxt2ZG5c1cukkOsYdVT5D9YYQ8AXjF6nfr0vJ6k1JWHgkbXveblt3YdW1hPQkX2sIdd
 Nq+4Sx5TIG+8JhvnOt674l9uYGlP82r/DCWBARn31hVLrFE1klfnCypwdrpTLeBQsQ99 GQ== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qh27tsr6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 06:29:04 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34C6T3FU006811
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 06:29:03 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 11 May 2023 23:29:03 -0700
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v5 0/7] ufs: core: mcq: Add ufshcd_abort() and error handler support in MCQ mode
Date:   Thu, 11 May 2023 23:28:47 -0700
Message-ID: <cover.1683872601.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 12TwkPwV3FBeDYta5BaYBQ0aTUCCD7mh
X-Proofpoint-GUID: 12TwkPwV3FBeDYta5BaYBQ0aTUCCD7mh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_03,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120055
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

 drivers/ufs/core/ufs-mcq.c     | 233 ++++++++++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  17 ++-
 drivers/ufs/core/ufshcd.c      | 216 ++++++++++++++++++++++++++++++--------
 drivers/ufs/host/ufs-qcom.c    |   2 +-
 include/ufs/ufshcd.h           |   5 +-
 include/ufs/ufshci.h           |  23 +++-
 6 files changed, 440 insertions(+), 56 deletions(-)
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
---
-- 
2.7.4

