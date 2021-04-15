Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683C3C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 01:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4415B6120E
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 01:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhDOBvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 21:51:07 -0400
Received: from smtp.infotech.no ([82.134.31.41]:33139 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhDOBvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 21:51:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 69C4920423A;
        Thu, 15 Apr 2021 03:50:43 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ady2RQB76u14; Thu, 15 Apr 2021 03:50:35 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 05007204191;
        Thu, 15 Apr 2021 03:50:33 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com, ming.lei@redhat.com,
        john.garry@huawei.com, axboe@kernel.dk
Subject: [PATCH] scsi_debug: fix cmd_per_lun, set to max_queue
Date:   Wed, 14 Apr 2021 21:50:31 -0400
Message-Id: <20210415015031.607153-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that the cmd_per_lun value placed in the host template
never exceeds the can_queue value. If the max_queue driver
parameter is not specified then both cmd_per_lun and can_queue are
set to CAN_QUEUE. CAN_QUEUE is a compile time constant and is used
to dimension an array to hold queued requests. If the max_queue
driver parameter is given it is must be less than or equal to
CAN_QUEUE and if so, the host template values are adjusted.

Remove undocumented code that allowed queue_depth to exceed
CAN_QUEUE and cause stack full type errors. There is a documented
way to do that with every_nth and
    echo 0x8000 > /sys/bus/pseudo/drivers/scsi_debug/opts
See: https://sg.danny.cz/sg/scsi_debug.html

Tweak some formatting, and add a suggestion to the "trim
poll_queues" warning.

Reported-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 70165be10f00..a5d1633b5bd8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -218,7 +218,7 @@ static const char *sdebug_version_date = "20200710";
  */
 #define SDEBUG_CANQUEUE_WORDS  3	/* a WORD is bits in a long */
 #define SDEBUG_CANQUEUE  (SDEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
-#define DEF_CMD_PER_LUN  255
+#define DEF_CMD_PER_LUN  SDEBUG_CANQUEUE
 
 /* UA - Unit Attention; SA - Service Action; SSU - Start Stop Unit */
 #define F_D_IN			1	/* Data-in command (e.g. READ) */
@@ -5695,8 +5695,8 @@ MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
-MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
+MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
@@ -5710,7 +5710,7 @@ MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
 MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get new store (def=0)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
-MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to max(submit_queues - 1)");
+MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to max(submit_queues - 1))");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(random, "If set, uniformly randomize command duration between 0 and delay_in_ns");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
@@ -7165,12 +7165,15 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 	}
 	num_in_q = atomic_read(&devip->num_in_q);
 
+	if (qdepth > SDEBUG_CANQUEUE) {
+		qdepth = SDEBUG_CANQUEUE;
+		pr_warn("%s: requested qdepth [%d] exceeds canqueue [%d], trim\n", __func__,
+			qdepth, SDEBUG_CANQUEUE);
+	}
 	if (qdepth < 1)
 		qdepth = 1;
-	/* allow to exceed max host qc_arr elements for testing */
-	if (qdepth > SDEBUG_CANQUEUE + 10)
-		qdepth = SDEBUG_CANQUEUE + 10;
-	scsi_change_queue_depth(sdev, qdepth);
+	if (qdepth != sdev->queue_depth)
+		scsi_change_queue_depth(sdev, qdepth);
 
 	if (SDEBUG_OPT_Q_NOISE & sdebug_opts) {
 		sdev_printk(KERN_INFO, sdev, "%s: qdepth=%d, num_in_q=%d\n",
@@ -7558,6 +7561,7 @@ static int sdebug_driver_probe(struct device *dev)
 	sdbg_host = to_sdebug_host(dev);
 
 	sdebug_driver_template.can_queue = sdebug_max_queue;
+	sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
 	if (!sdebug_clustering)
 		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
 
@@ -7593,7 +7597,11 @@ static int sdebug_driver_probe(struct device *dev)
 	 * If condition not met, trim poll_queues to 1 (just for simplicity).
 	 */
 	if (poll_queues >= submit_queues) {
-		pr_warn("%s: trim poll_queues to 1\n", my_name);
+		if (submit_queues < 3)
+			pr_warn("%s: trim poll_queues to 1\n", my_name);
+		else
+			pr_warn("%s: trim poll_queues to 1. Perhaps try poll_queues=%d\n",
+				my_name, submit_queues - 1);
 		poll_queues = 1;
 	}
 	if (poll_queues)
-- 
2.25.1

