Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C75C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E29B214E0
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405034AbfIFM7F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:59:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6695 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404861AbfIFM6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:14 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C1D5743A757ADCF7B11C;
        Fri,  6 Sep 2019 20:58:10 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:00 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 00/13] hisi_sas: Some misc patches
Date:   Fri, 6 Sep 2019 20:55:24 +0800
Message-ID: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset includes support for some more minor features, a bit of
tidying, and a few patches to make the driver a bit more robust.

Notables:
- BIST phy loopback support
- Fix for NCQ tags
- Correctly config registers after controller reset

Luo Jiaxing (7):
  scsi: hisi_sas: add debugfs auto-trigger for internal abort time out
  scsi: hisi_sas: Use true/false as input parameter of sas_phy_reset()
  scsi: hisi_sas: Directly return when running I_T_nexus reset if phy
    disabled
  scsi: hisi_sas: Remove sleep after issue phy reset if
    sas_smp_phy_control() fails
  scsi: hisi_sas: Remove hisi_sas_hw.slot_complete
  scsi: hisi_sas: Remove some unused function arguments
  scsi: hisi_sas: Add hisi_sas_debugfs_alloc() to centralise allocation

Xiang Chen (6):
  scsi: hisi_sas: Retry 3 times TMF IO for SAS disks when init device
  scsi: hisi_sas: Update all the registers after suspend and resume
  scsi: hisi_sas: Assign NCQ tag for all NCQ commands
  scsi: hisi_sas: Remove redundant work declaration
  scsi: hisi_sas: Add BIST support for phy loopback
  scsi: hisi_sas: Fix the conflict between device gone and host reset

 drivers/scsi/hisi_sas/hisi_sas.h       |  18 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 569 +++++++++++++++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  17 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 159 ++++++-
 5 files changed, 661 insertions(+), 103 deletions(-)

-- 
2.17.1

