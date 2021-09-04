Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0718C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 06:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A8660FDC
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 06:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350847AbhIDGdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Sep 2021 02:33:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15384 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbhIDGdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2021 02:33:53 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H1l9b5Rbtzbgqx;
        Sat,  4 Sep 2021 14:28:51 +0800 (CST)
Received: from dggpemm500004.china.huawei.com (7.185.36.219) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 4 Sep 2021 14:32:49 +0800
Received: from huawei.com (10.175.124.27) by dggpemm500004.china.huawei.com
 (7.185.36.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 4 Sep 2021
 14:32:48 +0800
From:   Laibin Qiu <qiulaibin@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <hare@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qiulaibin@huawei.com>
Subject: [PATCH -next] [SCSI] Fix NULL pointer dereference in handling for passthrough commands
Date:   Sat, 4 Sep 2021 14:45:34 +0800
Message-ID: <20210904064534.1919476-1-qiulaibin@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500004.china.huawei.com (7.185.36.219)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In passthrough path. If the command size for ioctl request from userspace
is 0. The original process will get cmd_len from cmd->cmnd, but It has
not been assigned at this time. So it will trigger a NULL pointer BUG.

------------[ cut here ]------------
BUG: kernel NULL pointer dereference, address: 0000000000000000
PF: supervisor read access in kernel mode
PF: error_code(0x0000) - not-present page
RIP: 0010:scsi_queue_rq+0xcb2/0x12b0
Call Trace:
blk_mq_dispatch_rq_list+0x541/0xe90
__blk_mq_sched_dispatch_requests+0x1fe/0x2b0
blk_mq_sched_dispatch_requests+0xbf/0x130
__blk_mq_run_hw_queue+0x15b/0x230
__blk_mq_delay_run_hw_queue+0x18f/0x320
blk_mq_run_hw_queue+0x252/0x280
blk_mq_sched_insert_request+0x228/0x260
blk_execute_rq+0x111/0x160
sg_io+0x51a/0x740
scsi_cmd_ioctl+0x533/0x910
scsi_cmd_blk_ioctl+0xa1/0xb0
cdrom_ioctl+0x3f/0x2510
sr_block_ioctl+0x142/0x180
blkdev_ioctl+0x398/0x450
block_ioctl+0x6d/0x80
__se_sys_ioctl+0xd1/0x140
__x64_sys_ioctl+0x3f/0x50
do_syscall_64+0x37/0x50
entry_SYSCALL_64_after_hwframe+0x44/0xa9

We can trigger front BUG by ioctl blow.
------------[ cut here ]------------

sg_io_hdr_t *addr;

addr = malloc(sizeof(sg_io_hdr_t));
memset(addr, 0, sizeof(sg_io_hdr_t));
addr->interface_id = 'S';

fd = open(/dev/sr0, O_RDONLY); // open a CD_ROM dev

ioctl(fd, SG_IO, addr); // all zero sg_io_hdr_t will trigger this bug

Fixes: 2ceda20f0a99a ("scsi: core: Move command size detection out of
the fast path")
Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 572673873ddf..53b47a9103d3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1174,9 +1174,9 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	}
 
 	cmd->cmd_len = scsi_req(req)->cmd_len;
+	cmd->cmnd = scsi_req(req)->cmd;
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
-	cmd->cmnd = scsi_req(req)->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = scsi_req(req)->retries;
 	return BLK_STS_OK;
-- 
2.22.0

