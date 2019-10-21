Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9B9CA9EB7
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1540205ED
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfJUQZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:25:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33128 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728305AbfJUQZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:28 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E75D969206CA4E11755C;
        Tue, 22 Oct 2019 00:25:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:16 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 00/18] hisi_sas: Misc patches, mostly debugfs
Date:   Tue, 22 Oct 2019 00:21:57 +0800
Message-ID: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series introduces a couple of minor improvements in the main driver,
and mostly changes in the driver debugfs support.

The main change in the driver debugfs support is the ability to take
multiple memory dumps, which was not available previously. And the bulk
of the changes here is to create new structures for this purpose.

We also add a new debugfs feature to report PHY down events, which seem
to be useful to some people.

Luo Jiaxing (14):
  scsi: hisi_sas: Add timestamp for a debugfs dump
  scsi: hisi_sas: Add debugfs file structure for CQ
  scsi: hisi_sas: Add debugfs file structure for DQ
  scsi: hisi_sas: Add debugfs file structure for registers
  scsi: hisi_sas: Add debugfs file structure for port
  scsi: hisi_sas: Add debugfs file structure for IOST
  scsi: hisi_sas: Add debugfs file structure for ITCT
  scsi: hisi_sas: Add debugfs file structure for IOST cache
  scsi: hisi_sas: Add debugfs file structure for ITCT cache
  scsi: hisi_sas: Allocate memory for multiple dumps of debugfs
  scsi: hisi_sas: Add module parameter for debugfs dump count
  scsi: hisi_sas: Add ability to have multiple debugfs dumps
  scsi: hisi_sas: Delete the debugfs folder of hisi_sas when the probe
    fails
  scsi: hisi_sas: Record the phy down event in debugfs

Xiang Chen (4):
  scsi: hisi_sas: Don't create debugfs dump folder twice
  scsi: hisi_sas: Set the BIST init value before enabling BIST
  scsi: hisi_sas: use wait_for_completion_timeout() when clearing ITCT
  scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()

 drivers/scsi/hisi_sas/hisi_sas.h       |  67 ++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 367 ++++++++++++++++---------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  13 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  26 +-
 5 files changed, 331 insertions(+), 148 deletions(-)

-- 
2.17.1

