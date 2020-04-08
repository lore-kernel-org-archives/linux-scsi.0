Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D62CC2BA2B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 21:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C902082D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 21:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDHVtM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 17:49:12 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:44405 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgDHVtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 17:49:12 -0400
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 08 Apr 2020 14:49:11 -0700
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg04-sd.qualcomm.com with ESMTP; 08 Apr 2020 14:49:10 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id 976CD209D0; Wed,  8 Apr 2020 14:49:10 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     cang@codeaurora.org, martin.petersen@oracle.com,
        Avri.Altman@wdc.com, linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v1 0/3] WriteBooster Feature Support 
Date:   Wed,  8 Apr 2020 14:48:38 -0700
Message-Id: <cover.1586374414.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RFC -> v1:
- Added platform capability for WriteBooster 

RFC-:
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

 drivers/scsi/ufs/ufs-qcom.c  |   8 ++
 drivers/scsi/ufs/ufs-sysfs.c |  39 ++++++-
 drivers/scsi/ufs/ufs.h       |  37 ++++++-
 drivers/scsi/ufs/ufshcd.c    | 241 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h    |  43 ++++++++
 5 files changed, 362 insertions(+), 6 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

