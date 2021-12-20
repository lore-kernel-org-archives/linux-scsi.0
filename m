Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F003FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhLTL0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:26:51 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16833 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhLTL0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:50 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JHcj35jzhz91f3;
        Mon, 20 Dec 2021 19:25:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:48 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 00/15] Add runtime PM support for libsas
Date:   Mon, 20 Dec 2021 19:21:23 +0800
Message-ID: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently the Hisilicon SAS controller v3 hw driver supports runtime PM.
However a number of corner-case bugs have been reported for this feature.
These includes:
a. If a directly-attached disk is removed when the host is suspended, a
system hang may occur during resuming. Libsas drains events after resuming
the host. Draining the events causes a deadlock as we need to ensure that
the host is resumed for some libsas events processing, however the resume
process will not complete until all events are processed;
b. If a disk is attached to an expander when the host is suspended then 
this new disk will not be detected when active again;
c. The host controller may not be resumed from suspension when sending 
SMP IOs;
d. If a phy comes up when resuming the host controller then we may get a
deadlock from processing of events DISCE_DISCOVER_DOMAIN and 
PORTE_BYTES_DMAED;
e. Similar to d., the work of PORTE_BROADCAST_RCVD and PORTE_BYTES_DMAED
may deadlock.

This series addresses those issues, briefly described as follows:
a. As far as we can see, this drain is unneeded, so conditionally remove it
in patch 1~2;
b. Just insert broadcast events to revalidate the topology in patch 4~7;
c. and e. When processing any events from the LLD, make libsas keep the
host active until finished processing all works related to the original
events in patch 9 and 14;
d. Defer phyup event processing in case described in patch 10~12;


Change Log:
v1 -> v2:
- Rewrite those commit messages according to John Garry's suggestions;
- Add my SOB for patch 2 and change SOB of John Garry's to Acked-by 
in patch 8 and 15; 

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
  scsi: libsas: Insert PORTE_BROADCAST_RCVD events for resuming host
  scsi: hisi_sas: Add more logs for runtime suspend/resume
  scsi: libsas: Resume host while sending SMP IOs
  scsi: libsas: Add flag SAS_HA_RESUMING
  scsi: libsas: Refactor sas_queue_deferred_work()
  scsi: libsas: Defer works of new phys during suspend
  scsi: hisi_sas: Keep controller active between ISR of phyup and the
    event being processed
  scsi: libsas: Keep host active while processing events
  scsi: hisi_sas: Use autosuspend for the host controller

 block/blk-pm.c                         | 22 +++-----
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 39 +++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 24 ++++++--
 drivers/scsi/libsas/sas_event.c        | 77 +++++++++++++++++++++-----
 drivers/scsi/libsas/sas_expander.c     |  3 +
 drivers/scsi/libsas/sas_init.c         | 49 +++++++++++++++-
 drivers/scsi/libsas/sas_internal.h     |  2 +
 drivers/scsi/mvsas/mv_sas.c            |  5 ++
 drivers/scsi/scsi_pm.c                 |  2 +-
 include/linux/blk-pm.h                 |  2 +-
 include/scsi/libsas.h                  |  2 +
 12 files changed, 180 insertions(+), 48 deletions(-)

-- 
2.33.0

