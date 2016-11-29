From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 01/14] cxlflash: Set sg_tablesize to 1 instead of SG_NONE
Date: Mon, 28 Nov 2016 18:41:06 -0600
Message-ID: <1480380067-60200-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752872AbcK2AlU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 19:41:20 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT0e8eO088518
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:41:19 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 270tdafr7f-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:41:19 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Mon, 28 Nov 2016 17:41:18 -0700
In-Reply-To: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

The following Oops is encountered when blk_mq is enabled with the
cxlflash driver:

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

The SCSI blk_mq stack assumes that sg_tablesize is always a non-zero
value with scsi_mq_setup_tags() allocating tags using sg_tablesize.
The cxlflash driver currently uses SG_NONE (0) for the sg_tablesize
as the devices it supports are not capable of scatter gather. This
mismatch of values results in the Oops above.

To resolve this issue, sg_tablesize for cxlflash can simply be set
to 1, a value which satisfies the constraints in cxlflash and the
lack of support of SG_NONE in SCSI blk_mq.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b301655..6004860 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2377,7 +2377,7 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun = CXLFLASH_MAX_CMDS_PER_LUN,
 	.can_queue = CXLFLASH_MAX_CMDS,
 	.this_id = -1,
-	.sg_tablesize = SG_NONE,	/* No scatter gather support */
+	.sg_tablesize = 1,	/* No scatter gather support */
 	.max_sectors = CXLFLASH_MAX_SECTORS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = cxlflash_host_attrs,
-- 
2.1.0

