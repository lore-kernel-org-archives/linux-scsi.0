Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA280C33CAA
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC29221D7D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgATM04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:26:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9213 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbgATM04 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 07:26:56 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B5353EF6A50EE0610B56;
        Mon, 20 Jan 2020 20:26:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:26:43 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/7] hisi_sas: Misc patches
Date:   Mon, 20 Jan 2020 20:22:30 +0800
Message-ID: <1579522957-4393-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series introduces some misc patches for the driver for the v5.6
cycle.

Nothing especially interesting, but maybe the change to switch the v2
driver to use reply map also, which improves performance.

There is also a change to switch the driver to use threaded interrupt
handling over tasklets.

John Garry (2):
  scsi: hisi_sas: Rename hisi_sas_cq.pci_irq_mask
  scsi: hisi_sas: Use reply map for v2 hw

Luo Jiaxing (3):
  scsi: hisi_sas: Replace magic number when handle channel interrupt
  scsi: hisi_sas: Modify the file permissions of trigger_dump to write
    only
  scsi: hisi_sas: Add prints for v3 hw interrupt converge and automatic
    affinity

Xiang Chen (2):
  scsi: hisi_sas: use threaded irq to process CQ interrupts
  scsi: hisi_sas: replace spin_lock_irqsave/spin_unlock_restore with
    spin_lock/spin_unlock

 drivers/scsi/hisi_sas/hisi_sas.h       |  9 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 74 ++++++++++-----------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 90 +++++++++++++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 54 +++++++++-------
 4 files changed, 139 insertions(+), 88 deletions(-)

-- 
2.17.1

