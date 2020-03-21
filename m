Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D51EC4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 01:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 107052173E
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 01:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgCUBAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 21:00:00 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:24768 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbgCUBAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Mar 2020 21:00:00 -0400
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 20 Mar 2020 17:59:59 -0700
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg03-sd.qualcomm.com with ESMTP; 20 Mar 2020 17:59:59 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id ACCC61FFE7; Fri, 20 Mar 2020 17:59:59 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     cang@codeaurora.org, Avri.Altman@wdc.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [<RFC RESEND PATCH v2> 0/3] WriteBooster Feature Support 
Date:   Fri, 20 Mar 2020 17:59:17 -0700
Message-Id: <cover.1584752043.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Still a RFC patch, because I'm still expecting some comments
on the design.

v1 -> v2:
- Addressed comments on v1

- Supports shared buffer mode only

- Didn't use exception event as suggested.
  The reason being while testing I saw that the WriteBooster
  available buffer remains at 0x1 for a longer time if flush is
  enabled all the time as compared to an event-based enablement.
  This essentially means that writes go to the WriteBooster buffer
  more. Spec says that the if flush is enabled, the device would
  flush when it sees the command queue empty. So I guess that'd trigger
  flush more than an event based approach.
  Anyway the Vcc would be turned-off during system suspend, so flush
  would stop anyway.
  In this patchset, I never turn-off flush.
  Hence the RFC.

Asutosh Das (3):
  scsi: ufs: add write booster feature support
  ufs-qcom: scsi: configure write booster type
  ufs: sysfs: add sysfs entries for write booster

 drivers/scsi/ufs/ufs-qcom.c  |   7 ++
 drivers/scsi/ufs/ufs-sysfs.c |  39 ++++++-
 drivers/scsi/ufs/ufs.h       |  37 ++++++-
 drivers/scsi/ufs/ufshcd.c    | 238 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h    |   9 ++
 5 files changed, 324 insertions(+), 6 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

