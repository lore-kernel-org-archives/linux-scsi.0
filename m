Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1E2C001B2
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbiLNEGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237320AbiLNEGL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:06:11 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D02527B02
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1670990767; x=1702526767;
  h=from:to:cc:subject:date:message-id;
  bh=f0NrloGx4sYI8QnunbFIYxQ8S+X2eigK1ncPp/vBLX0=;
  b=K/6XmXRFopjiuHPUmKYeWsBYBFpb04p5xvVuk7Lj6REvc4X9cddH7BVr
   aQtXbFWvfWATtU2N1/IkVEyP6cvmX5osUNIKGHtHmBmuHegd96eh+aN4e
   Ce4Ivo8TYq7e1B+Wm4heGS0+RKXPa8aShOiw/KX0VgoteNy2tFZfWDb8D
   k=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 13 Dec 2022 20:06:05 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 13 Dec 2022 20:06:05 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id BDD9220DF0; Tue, 13 Dec 2022 20:06:05 -0800 (PST)
From:   Can Guo <quic_cang@quicinc.com>
To:     quic_asutoshd@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Can Guo <quic_cang@quicinc.com>
Subject: [PATCH v2 0/3] Add support for UFS Event Specific Interrupt
Date:   Tue, 13 Dec 2022 20:05:59 -0800
Message-Id: <1670990763-30806-1-git-send-email-quic_cang@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series is
to enable Event Specific Interrupt (ESI), which can used in MCQ mode.

Please note that this series is developed and tested based on the latest MCQ
driver (v11) pushed by Asutosh Das.

v1 -> v2:
- Improved QCOM specific ESI configuration flow
	
Can Guo (3):
  ufs: core: Add Event Specific Interrupt configuration vendor specific
    ops
  ufs: core: mcq: Add Event Specific Interrupt enable and config APIs
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

