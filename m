Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F471C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 07:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiGSHCE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiGSHCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 03:02:04 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A9E2F39C
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 00:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658214123; x=1689750123;
  h=from:to:subject:date:message-id;
  bh=8JZHasLqkzQAdvFgAI8YQgSqIdOXB+fiImsj/9yLPdk=;
  b=yEWe5CBvjDEq121D4Sk2urvKSY5vhFGFXVk9Ec5Br9/2oW1/BbOgJLJe
   8xekPKYpG1K1lsIahKyyU0MCiGCJ/M5cwlnfM76TbGX0IeQcFhkAl6urc
   /CmPaCO+YUJZE/asIFbv5idsFF4EIP34wZwUlgs0n+xddhcQqvXP00jAs
   I=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 19 Jul 2022 00:02:03 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 19 Jul 2022 00:02:02 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 7CCCF22784; Tue, 19 Jul 2022 00:02:02 -0700 (PDT)
From:   Can Guo <quic_cang@quicinc.com>
To:     bvanassche@acm.org, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, beanhuo@micron.com, quic_asutoshd@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        quic_cang@quicinc.com
Subject: [PATCH 0/2] UFS Multi-Circular Queue (MCQ)
Date:   Tue, 19 Jul 2022 00:01:57 -0700
Message-Id: <1658214120-22772-1-git-send-email-quic_cang@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS Multi-Circular Queue (MCQ) has been added in UFSHCI v4.0 to improve storage performance.
This patch series is a RFC implementation of this.

This is the initial driver implementation and it has been verified by booting on an emulation
platform. During testing, all low power modes were disabled and it was in HS-G1 mode.

Please take a look and let us know your thoughts.

Asutosh Das (1):
  scsi: ufs: Add Multi-Circular Queue support

Can Guo (1):
  scsi: ufs-qcom: Implement three CMQ related vops

 drivers/ufs/core/Makefile   |   2 +-
 drivers/ufs/core/ufs-mcq.c  | 555 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c   | 362 ++++++++++++++++++++---------
 drivers/ufs/host/ufs-qcom.c | 116 +++++++++
 drivers/ufs/host/ufs-qcom.h |   2 +
 include/ufs/ufs.h           |   1 +
 include/ufs/ufshcd.h        | 231 +++++++++++++++++-
 include/ufs/ufshci.h        |  89 +++++++
 8 files changed, 1251 insertions(+), 107 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-mcq.c

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

