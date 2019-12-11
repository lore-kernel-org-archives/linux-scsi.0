Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3FAC2D0C6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6AEE208C3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576079165;
	bh=/oRw1hHn/HqEoOg2oBQIHsidAuwkS4CZnGiO4urvvmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MXW2uJ/JUy4honLxAO6ar0qw2pgrmJw3Xmf68EWUOqZOAgl0d2Go/GjT6iB4kSHOD
	 BjfAhzbiEDzvSOd1siUNGLirGyciCte4VZK3Q2VvO5dOOC26Q4JV2UK+uYJTmjVOah
	 jbdpAEKsbfphmfFeUBSqEeSi+1hV4JL/Ej2h5XQM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbfLKPp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:45:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733193AbfLKP06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0EFF22527;
        Wed, 11 Dec 2019 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078017;
        bh=/oRw1hHn/HqEoOg2oBQIHsidAuwkS4CZnGiO4urvvmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iby9bL6eqz5gyAsbDk2XNd8tBXrp+yVPLZP5oX3F8YEsNKvWwHNN7zdnBn0SZqTPW
         aW/4w6q9Txqb6TQmtMiw5932o4DAMpsAsB1QI2YwnV+6QdUb3akqOno3GsOmqRHXjo
         52+L+fBPK3BCVi33k/t16JmHmrTUcnxUpug9Exd0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/79] scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()
Date:   Wed, 11 Dec 2019 10:25:36 -0500
Message-Id: <20191211152643.23056-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 550c0d89d52d3bec5c299f69b4ed5d2ee6b8a9a6 ]

For IOs from upper layer, preemption may be disabled as it may be called by
function __blk_mq_delay_run_hw_queue which will call get_cpu() (it disables
preemption). So if flags HISI_SAS_REJECT_CMD_BIT is set in function
hisi_sas_task_exec(), it may disable preempt twice after down() and up()
which will cause following call trace:

BUG: scheduling while atomic: fio/60373/0x00000002
Call trace:
dump_backtrace+0x0/0x150
show_stack+0x24/0x30
dump_stack+0xa0/0xc4
__schedule_bug+0x68/0x88
__schedule+0x4b8/0x548
schedule+0x40/0xd0
schedule_timeout+0x200/0x378
__down+0x78/0xc8
down+0x54/0x70
hisi_sas_task_exec.isra.10+0x598/0x8d8 [hisi_sas_main]
hisi_sas_queue_command+0x28/0x38 [hisi_sas_main]
sas_queuecommand+0x168/0x1b0 [libsas]
scsi_queue_rq+0x2ac/0x980
blk_mq_dispatch_rq_list+0xb0/0x550
blk_mq_do_dispatch_sched+0x6c/0x110
blk_mq_sched_dispatch_requests+0x114/0x1d8
__blk_mq_run_hw_queue+0xb8/0x130
__blk_mq_delay_run_hw_queue+0x1c0/0x220
blk_mq_run_hw_queue+0xb0/0x128
blk_mq_sched_insert_requests+0xdc/0x208
blk_mq_flush_plug_list+0x1b4/0x3a0
blk_flush_plug_list+0xdc/0x110
blk_finish_plug+0x3c/0x50
blkdev_direct_IO+0x404/0x550
generic_file_read_iter+0x9c/0x848
blkdev_read_iter+0x50/0x78
aio_read+0xc8/0x170
io_submit_one+0x1fc/0x8d8
__arm64_sys_io_submit+0xdc/0x280
el0_svc_common.constprop.0+0xe0/0x1e0
el0_svc_handler+0x34/0x90
el0_svc+0x10/0x14
...

To solve the issue, check preemptible() to avoid disabling preempt multiple
when flag HISI_SAS_REJECT_CMD_BIT is set.

Link: https://lore.kernel.org/r/1571926105-74636-5-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f478d1f50dfc0..ea4882f12c50e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -485,7 +485,13 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	struct hisi_sas_dq *dq = NULL;
 
 	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags))) {
-		if (in_softirq())
+		/*
+		 * For IOs from upper layer, it may already disable preempt
+		 * in the IO path, if disable preempt again in down(),
+		 * function schedule() will report schedule_bug(), so check
+		 * preemptible() before goto down().
+		 */
+		if (!preemptible())
 			return -EINVAL;
 
 		down(&hisi_hba->sem);
-- 
2.20.1

