From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: [PATCH] scsi: Set sg_tablesize to 1, for LLDDs that set SG_NONE
Date: Wed, 28 Oct 2015 14:36:39 -0500
Message-ID: <1446060999-49260-1-git-send-email-manoj@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35006 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbJ1ThF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2015 15:37:05 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Wed, 28 Oct 2015 13:37:05 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id A5CD719D8026
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2015 13:25:12 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9SJZe2N12910868
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2015 12:35:40 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9SJb25i017160
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2015 13:37:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Manoj Kumar <manoj@linux.vnet.ibm.com>, Youngjae Lee <leeyo@linux.vnet.ibm.com>

Oops while testing blk_mq over the new cxlflash driver.

[ 2960.817172] Oops: Kernel access of bad area, sig: 11 [#5]
[ 2960.817309] NIP  __blk_mq_run_hw_queue+0x278/0x4c0
[ 2960.817313] LR __blk_mq_run_hw_queue+0x2bc/0x4c0
[ 2960.817314] Call Trace:
[ 2960.817320] __blk_mq_run_hw_queue+0x2bc/0x4c0 (unreliable)
[ 2960.817324] blk_mq_run_hw_queue+0xd8/0x100
[ 2960.817329] blk_mq_insert_requests+0x14c/0x1f0
[ 2960.817333] blk_mq_flush_plug_list+0x150/0x190
[ 2960.817338] blk_flush_plug_list+0x11c/0x2b0
[ 2960.817344] blk_finish_plug+0x58/0x80
[ 2960.817348] __do_page_cache_readahead+0x1c0/0x2e0
[ 2960.817352] force_page_cache_readahead+0x68/0xd0
[ 2960.817356] generic_file_read_iter+0x43c/0x6a0
[ 2960.817359] blkdev_read_iter+0x68/0xa0
[ 2960.817361] __vfs_read+0x11c/0x180
[ 2960.817364] vfs_read+0xa4/0x1c0
[ 2960.817366] SyS_read+0x6c/0x110
[ 2960.817369] system_call+0x38/0xb4

The root cause of the problem was this low level device driver(LLDD),
in this case cxlflash, does not support scatter-gather and hence had
set it's sg_tablesize to SG_NONE (value of 0). In reality the tablesize
is of length 1. This value of SG_NONE does not cause any problems with
the standard block driver stack but causes issues for blk_mq, as shown
above. Since quite a few of the legacy LLDDs are setting sg_tablesize
to SG_NONE, it was preferable to override the LLDD provided value in
scsi_host_alloc().

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Signed-off-by: Youngjae Lee <leeyo@linux.vnet.ibm.com>
---
 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..bd13c9d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -413,7 +413,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->hostt = sht;
 	shost->this_id = sht->this_id;
 	shost->can_queue = sht->can_queue;
-	shost->sg_tablesize = sht->sg_tablesize;
+	shost->sg_tablesize = (sht->sg_tablesize ? sht->sg_tablesize : 1);
 	shost->sg_prot_tablesize = sht->sg_prot_tablesize;
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
-- 
2.1.0

