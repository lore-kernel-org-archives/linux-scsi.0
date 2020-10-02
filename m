Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BTC_ID,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923A4C4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B4DF206B2
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388029AbgJBOeh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14795 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387974AbgJBOeh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:37 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A4B32672524BC8C1AE67;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:25 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/7] hisi_sas: Add runtime PM support for v3 hw
Date:   Fri, 2 Oct 2020 22:30:31 +0800
Message-ID: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series adds runtime PM support for v3 hw. Consists of:
- Switch to new PM suspend and resume framework
- Add links to devices to ensure host cannot be suspended while devices
  are not
- Filter out phy events during suspend to avoid deadlock
- Add controller RPM support
- And some more minor misc related changes

I also included a random small fix, only visible when #CPUs < #queues and
MSI affinity module param set.

Note that this series does not conflict with patch "scsi: hisi_sas:
Switch v3 hw to MQ", which is supposed to go through the block tree:

https://lore.kernel.org/linux-scsi/32574da3d8de863ff38347ef6ead9b35@mail.gmail.com/T/#m39c82fc8a3e3a6b20247d0bd0122d2916e620a28

Luo Jiaxing (1):
  scsi: hisi_sas: Use hisi_hba->cq_nvecs for calling calling
    synchronize_irq()

Xiang Chen (6):
  scsi: hisi_sas: Switch to new framework to support suspend and resume
  scsi: hisi_sas: Add controller runtime PM support for v3 hw
  scsi: hisi_sas: Add the check of the definition of method _PS0 and
    _PR0
  scsi: hisi_sas: Add device link between SCSI devices and hisi_hba
  scsi: hisi_sas: Filter out new PHYs up events during suspended
  scsi: hisi_sas: Recover phys state according to the status before
    reset

 drivers/scsi/hisi_sas/Kconfig          |   1 +
 drivers/scsi/hisi_sas/hisi_sas.h       |   2 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  10 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 105 +++++++++++++++++++++++--
 4 files changed, 107 insertions(+), 11 deletions(-)

-- 
2.26.2

