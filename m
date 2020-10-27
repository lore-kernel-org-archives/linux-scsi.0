Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63660C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 12:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18582218AC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 12:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750763AbgJ0MOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 08:14:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:6405 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbgJ0MOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 08:14:15 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CL9c970g5z6w93;
        Tue, 27 Oct 2020 20:14:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 27 Oct 2020 20:14:04 +0800
From:   John Garry <john.garry@huawei.com>
To:     <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <tglx@linutronix.de>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <maz@kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] Support managed interrupts for platform devices
Date:   Tue, 27 Oct 2020 20:10:21 +0800
Message-ID: <1603800624-180488-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So far, managed interrupts are only used for PCI MSIs. This series add
platform device support for managed interrupts. Initially this topic was
discussed at [0].

The method to enable managed interrupts is to allocate all the IRQs for
the device, and then switch the interrupts to managed - this is done
through new function irq_update_affinity_desc().

API platform_get_irqs_affinity() is added as a helper to manage this work,
such that we don't need to export irq_update_affinity_desc() or
irq_create_affinity_masks().

For now, the HiSilicon SAS v2 hw driver is switched over. This is used
in the D05 dev board.

Performance gain observed for 6x SAS SSDs is ~357K -> 420K IOPs for fio read.

I hope - all going well - this series can go through the SCSI tree, since
the non-SCSI changes are additive, thanks!

[0] https://lore.kernel.org/lkml/84a9411b-4ae3-1928-3d35-1666f2687ec8@huawei.com/

John Garry (2):
  Driver core: platform: Add platform_get_irqs_affinity()
  scsi: hisi_sas: Expose HW queues for v2 hw

Thomas Gleixner (1):
  genirq/affinity: Add irq_update_affinity_desc()

 drivers/base/platform.c                | 58 +++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 ++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 71 ++++++++++++++++++++++----
 include/linux/interrupt.h              |  8 +++
 include/linux/platform_device.h        |  5 ++
 kernel/irq/manage.c                    | 19 +++++++
 7 files changed, 165 insertions(+), 11 deletions(-)

-- 
2.26.2

