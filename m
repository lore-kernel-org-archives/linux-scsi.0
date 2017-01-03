From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] hisi_sas: some CQ processing fixes
Date: Tue, 3 Jan 2017 20:24:47 +0800
Message-ID: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:57420 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758138AbdACLzo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 06:55:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org, John Garry <john.garry@huawei.com>

This patchset fixes some issues related to servicing of the
completion queue interrupt.
The major fix is that sensitive hisi_hba structures need to be
locked when free'ing a slot.
Another modification is that the v2 hw completion queue irq is
now serviced with a tasklet, as too much work was being done in
the ISR.

John Garry (3):
  scsi: hisi_sas: service v2 hw CQ ISR with tasklet
  scsi: hisi_sas: lock sensitive regions when servicing CQ interrupt
  scsi: hisi_sas: lock sensitive region in hisi_sas_slot_abort()

 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 26 ++++++++++++++++++++------
 4 files changed, 26 insertions(+), 6 deletions(-)

-- 
1.9.1

