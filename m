Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708A4C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5892B60E76
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhHJEkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:40:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14900 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234710AbhHJEka (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:40:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aQag008600
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:40:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=4auV6LHa1HoIFbl4hgC0GwLsTt37L2WxZvNxjYFPBJ0=;
 b=Q8y+0uOuBZpQ9fs8jqI8oZqkgex4FpioWXqkq855YM4oDSMjqWKKp8GoePiAAkc+6qAp
 wX3SGKv32vqS1KjXDnH9uzknIrUb+iiyf6ysntED1Y4IMzG45VL+6QHoDgVlQ663xUkj
 rSyvN+FpN+2TCknGsMyhg0PKmI9oU35qqKMOPa6q/xCdaLBmhRuXC1r9o5gZxJlUmfcA
 6Zggrof6kv/jGA9VFInlWcG7lnUwE3NYVBG6lf3+hmpBc6bK+fPbBI/g08YmzkukKfYN
 m5+x1ll9sjw1fSu33ALA7wWjGWXj+If5I49GjvIZbgfjyB6Q1A5oQhnve8DVgle6vtL+ pw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gfb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:40:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:40:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:40:07 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1C6925C6902;
        Mon,  9 Aug 2021 21:40:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4e5Ws001308;
        Mon, 9 Aug 2021 21:40:05 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4e5ZK001249;
        Mon, 9 Aug 2021 21:40:05 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 13/14] qla2xxx: Sync queue idx with queue_pair_map idx
Date:   Mon, 9 Aug 2021 21:37:19 -0700
Message-ID: <20210810043720.1137-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: OP1w2qIZ30b7Qs8W19YuM6ih_y6iFSmb
X-Proofpoint-GUID: OP1w2qIZ30b7Qs8W19YuM6ih_y6iFSmb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

The first invocation of function find_first_zero_bit will return 0 and
queue_id gets set to 0.
An index of queue_pair_map also get sets to 0.

	qpair_id = find_first_zero_bit(ha->qpair_qid_map, ha->max_qpairs);

        set_bit(qpair_id, ha->qpair_qid_map);
        ha->queue_pair_map[qpair_id] = qpair;

In the alloc_queue callback driver checks the map, if queue is already
allocated.
	ha->queue_pair_map[qidx]

This works fine as long as max_qpairs is greater than nvme_max_hw_queues(8).
Since the size of the queue_pair_map is equal to max_qpair. In case, nr_cpus
is less than 8, max_qpairs values goes less than 8, this creates wrong value
returns as qpair.

[ 1572.353669] qla2xxx [0000:24:00.3]-2121:6: Returning existing qpair of 4e00000000000000 for idx=2
[ 1572.354458] general protection fault: 0000 [#1] SMP PTI
[ 1572.354461] CPU: 1 PID: 44 Comm: kworker/1:1H Kdump: loaded Tainted: G          IOE    --------- -  - 4.18.0-304.el8.x86_64 #1
[ 1572.354462] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 03/01/2013
[ 1572.354467] Workqueue: kblockd blk_mq_run_work_fn
[ 1572.354485] RIP: 0010:qla_nvme_post_cmd+0x92/0x760 [qla2xxx]
[ 1572.354486] Code: 84 24 5c 01 00 00 00 00 b8 0a 74 1e 66 83 79 48 00 0f 85 a8 03 00 00 48 8b 44 24 08 48 89 ee 4c 89 e7 8b 50 24 e8 5e 8e 00 00 <f0> 41 ff 47 04 0f ae f0 41 f6 47 24 04 74 19 f0 41 ff 4f 04 b8 f0
[ 1572.354487] RSP: 0018:ffff9c81c645fc90 EFLAGS: 00010246
[ 1572.354489] RAX: 0000000000000001 RBX: ffff8ea3e5070138 RCX: 0000000000000001
[ 1572.354490] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8ea4c866b800
[ 1572.354491] RBP: ffff8ea4c866b800 R08: 0000000000005010 R09: ffff8ea4c866b800
[ 1572.354492] R10: 0000000000000001 R11: 000000069d1ca3ff R12: ffff8ea4bc460000
[ 1572.354493] R13: ffff8ea3e50702b0 R14: ffff8ea4c4c16a58 R15: 4e00000000000000
[ 1572.354494] FS:  0000000000000000(0000) GS:ffff8ea4dfd00000(0000) knlGS:0000000000000000
[ 1572.354495] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1572.354496] CR2: 000055884504fa58 CR3: 00000005a1410001 CR4: 00000000000606e0
[ 1572.354497] Call Trace:
[ 1572.354503]  ? check_preempt_curr+0x62/0x90
[ 1572.354506]  ? dma_direct_map_sg+0x72/0x1f0
[ 1572.354509]  ? nvme_fc_start_fcp_op.part.32+0x175/0x460 [nvme_fc]
[ 1572.354511]  ? blk_mq_dispatch_rq_list+0x11c/0x730
[ 1572.354515]  ? __switch_to_asm+0x35/0x70
[ 1572.354516]  ? __switch_to_asm+0x41/0x70
[ 1572.354518]  ? __switch_to_asm+0x35/0x70
[ 1572.354519]  ? __switch_to_asm+0x41/0x70
[ 1572.354521]  ? __switch_to_asm+0x35/0x70
[ 1572.354522]  ? __switch_to_asm+0x41/0x70
[ 1572.354523]  ? __switch_to_asm+0x35/0x70
[ 1572.354525]  ? entry_SYSCALL_64_after_hwframe+0xb9/0xca
[ 1572.354527]  ? __switch_to_asm+0x41/0x70
[ 1572.354529]  ? __blk_mq_sched_dispatch_requests+0xc6/0x170
[ 1572.354531]  ? blk_mq_sched_dispatch_requests+0x30/0x60
[ 1572.354532]  ? __blk_mq_run_hw_queue+0x51/0xd0
[ 1572.354535]  ? process_one_work+0x1a7/0x360
[ 1572.354537]  ? create_worker+0x1a0/0x1a0
[ 1572.354538]  ? worker_thread+0x30/0x390
[ 1572.354540]  ? create_worker+0x1a0/0x1a0
[ 1572.354541]  ? kthread+0x116/0x130
[ 1572.354543]  ? kthread_flush_work_fn+0x10/0x10
[ 1572.354545]  ? ret_from_fork+0x35/0x40

Fix is to use index 0 for admin and first IO queue.

Fixes: e84067d743010 (“scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration”)
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 94e350ef3028..04b766b8a471 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -91,8 +91,9 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
 
-	if (!qidx)
-		qidx++;
+	/* Map admin queue and 1st IO queue to index 0 */
+	if (qidx)
+		qidx--;
 
 	vha = (struct scsi_qla_host *)lport->private;
 	ha = vha->hw;
-- 
2.19.0.rc0

