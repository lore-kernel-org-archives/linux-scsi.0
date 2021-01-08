Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF892C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 07:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90760233EE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 07:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbhAHH3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 02:29:19 -0500
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:5877 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726241AbhAHH3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2021 02:29:19 -0500
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 08 Jan 2021 15:28:37 +0800
X-QCInternal: smtphost
Received: from cbsp-sh-gv.ap.qualcomm.com (HELO cbsp-sh-gv.qualcomm.com) ([10.231.249.68])
  by ironmsg01-tai.qualcomm.com with ESMTP; 08 Jan 2021 15:28:21 +0800
Received: by cbsp-sh-gv.qualcomm.com (Postfix, from userid 393357)
        id 4FC9E26B7; Fri,  8 Jan 2021 15:28:20 +0800 (CST)
From:   Ziqi Chen <ziqichen@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        cang@codeaurora.org, hongwus@codeaurora.org, rnayak@codeaurora.org,
        vinholikatti@gmail.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        ziqichen@codeaurora.org, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com
Subject: [PATCH v5 0/2] Two changes to fix ufs power down/on specs violation
Date:   Fri,  8 Jan 2021 15:28:02 +0800
Message-Id: <1610090885-50099-1-git-send-email-ziqichen@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series is made based on 5.11-scsi-staging branch.

As per specs, e.g, JESD220E chapter 7.2, while powering off/on the ufs device, RST_N signal and REF_CLK signal
should be between VSS(Ground) and VCCQ/VCCQ2. The sequence after fixing as below:

Power down:
1. Assert RST_N low
2. Turn-off REF_CLK
3. Turn-off VCC
4. Turn-off VCCQ/VCCQ2.
power on:
1. Turn-on VCC
2. Turn-on VCCQ/VCCQ2
3. Turn-On REF_CLK
4. Deassert RST_N high.

The 1st change let ref-clk to be disabled before VCC & VCCQ turning off while to be enabled after VCC & VCCQ turning on.
The 2nd change is used to pull down RST_n during UFS power off.

Change since v4:
- Split the original change "scsi: ufs: Fix ufs power down/on specs violation" into two changes, one fixs clk specs violation and the other one fixs RST_n specs violation.
- The 2nd change is just only for QCOM platform.

Change since v3:
- Rename vops callback func toggle_device_reset(sturct ufs_hba *hba, bool down) to device_reset(sturct ufs_hba *hba, bool assert).
- Move the dealy after pulling donw RST_n back into vops. 

Change since v2:
- Correct commit message.

Change since v1:
- Rename vops callback func device_reset(sturct ufs_hba *hba) to toggle_device_reset(sturct ufs_hba *hba, bool down) to fix this specs violation for all SoC vendors platform. 

Ziqi Chen (2):
  scsi: ufs: Fix ufs clk specs violation
  scsi: ufs-qcom: Fix ufs RST_n specs violation

 drivers/scsi/ufs/ufs-qcom.c |  4 ++++
 drivers/scsi/ufs/ufshcd.c   | 20 ++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

