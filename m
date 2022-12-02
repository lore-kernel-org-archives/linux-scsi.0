Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BBBC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 08:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiLBISN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 03:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiLBIRw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 03:17:52 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20570C6E61
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2022 00:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1669968944; x=1701504944;
  h=from:to:cc:subject:date:message-id;
  bh=UH8Uc0PGJKBtGWy7R00SAf5gZanEI63NVIKX1vALbkY=;
  b=xMuXBFByIiIMyQU5LFcGkl7ixSgG+VwOPC0f+tBtZzq48V4CO6Uj18Z2
   ZVWOU2cDiWapDKFO6kh8i9emVEgsSAfTIu1oNusiM+NhCQPMohOO8HTk0
   68eX2BgFZziHd7i8W14Y7d+y5D7DyP5utWxQvs92tLs7ij9v1V7gJatVY
   w=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 02 Dec 2022 00:15:42 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 02 Dec 2022 00:15:42 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id B7FD620DAF; Fri,  2 Dec 2022 00:15:42 -0800 (PST)
From:   Can Guo <quic_cang@quicinc.com>
To:     quic_asutoshd@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Can Guo <quic_cang@quicinc.com>
Subject: [PATCH 0/3] Add support for UFS Event Specific Interrupt
Date:   Fri,  2 Dec 2022 00:15:04 -0800
Message-Id: <1669968909-33021-1-git-send-email-quic_cang@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series is
to enable Event Specific Interrupt (ESI), which can used in MCQ mode.

Please note that this series is developed and tested based on the latest MCQ
driver (v9) pushed by Asutosh Das.

Can Guo (3):
  ufs: core: Add Event Specific Interrupt configuration vendor specific
    ops
  ufs: core: mcq: Add Event Specific Interrupt enable and config APIs
  ufs-host: qcom: Add MCQ ESI config vendor specific ops

 drivers/ufs/core/ufs-mcq.c     | 16 +++++++
 drivers/ufs/core/ufshcd-priv.h |  8 ++++
 drivers/ufs/core/ufshcd.c      |  5 +++
 drivers/ufs/host/ufs-qcom.c    | 99 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.h    |  5 +++
 include/ufs/ufshcd.h           |  8 ++++
 include/ufs/ufshci.h           |  2 +
 7 files changed, 143 insertions(+)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

