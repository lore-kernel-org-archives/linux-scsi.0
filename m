Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6334C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A13A619EC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhKQCxJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:09 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14944 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhKQCxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:08 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hv6mL5RnQzZd4J;
        Wed, 17 Nov 2021 10:47:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:09 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 00/15] Add runtime PM support for libsas
Date:   Wed, 17 Nov 2021 10:44:53 +0800
Message-ID: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Right now hisi_sas driver has already supported runtime PM, and it works
well on base functions. But for some exception situations, there are some
issues related to libsas layer:
- Remove a directly attached disk when sas host is suspended, a hang will
occur in the resume process, patch 1~2 solve the issue;
- Insert a new disk (for expander) during suspended, and the disk is not
revalidated when resuming sas host, patch 4~7 solve the issue;
- SMP IOs from libsas may be sending when sas host is suspended, so resume
sas host when sending SMP IOs in patch 9;
- New phyup may occur during the process of resuming controller, then work
of DISCE_DISCOVER_DOMAIN of a new phy and work PORTE_BYTES_DMAED of suspended
phy are blocked by each other, so defer works of new phys during suspend
in patch 10~12;
- Work PORTE_BROADCAST_RCVD and PORTE_BYTES_DMAED are in the same 
workqueue, but it is possible that they are blocked by each other, 
so keep sas host active until finished some work in patch 14.

And patch 3 which is related to scsi/block PM is from Alan Stern 
(https://lore.kernel.org/linux-scsi/20210714161027.GC380727@rowland.harvard.edu/)

Alan Stern (1):
  scsi/block PM: Always set request queue runtime active in
    blk_post_runtime_resume()

John Garry (2):
  libsas: Don't always drain event workqueue for HA resume
  Revert "scsi: hisi_sas: Filter out new PHY up events during suspend"

Xiang Chen (12):
  scsi: libsas: Add spin_lock/unlock() to protect asd_sas_port->phy_list
  scsi: hisi_sas: Fix some issues related to asd_sas_port->phy_list
  scsi: mvsas: Add spin_lock/unlock() to protect asd_sas_port->phy_list
  scsi: libsas: Send event PORTE_BROADCAST_RCVD for valid ports
  scsi: hisi_sas: Add more prink for runtime suspend/resume
  scsi: libsas: Resume sas host before sending SMP IOs
  scsi: libsas: Add a flag SAS_HA_RESUMING of sas_ha
  scsi: libsas: Refactor out sas_queue_deferred_work()
  scsi: libsas: Defer works of new phys during suspend
  scsi: hisi_sas: Keep controller active between ISR of phyup and the
    event being processed
  scsi: libsas: Keep sas host active until finished some work
  scsi: hisi_sas: Use autosuspend for SAS controller

 block/blk-pm.c                         | 22 +++-----
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 39 +++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 25 +++++++--
 drivers/scsi/libsas/sas_event.c        | 77 +++++++++++++++++++++-----
 drivers/scsi/libsas/sas_expander.c     |  3 +
 drivers/scsi/libsas/sas_init.c         | 49 +++++++++++++++-
 drivers/scsi/libsas/sas_internal.h     |  2 +
 drivers/scsi/mvsas/mv_sas.c            |  5 ++
 drivers/scsi/scsi_pm.c                 |  2 +-
 include/linux/blk-pm.h                 |  2 +-
 include/scsi/libsas.h                  |  2 +
 12 files changed, 181 insertions(+), 48 deletions(-)

-- 
2.33.0

