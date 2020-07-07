Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5415C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B28C20771
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgGGNgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:36:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39788 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727987AbgGGNga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 09:36:30 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F25052881E8627EDCAFE;
        Tue,  7 Jul 2020 21:36:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 7 Jul 2020 21:36:16 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>,
        <dgilbert@interlog.com>, <ming.lei@redhat.com>,
        <kashyap.desai@broadcom.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 2/2] scsi: scsi_debug: Support hostwide tags
Date:   Tue, 7 Jul 2020 21:32:31 +0800
Message-ID: <1594128751-212234-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1594128751-212234-1-git-send-email-john.garry@huawei.com>
References: <1594128751-212234-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many SCSI HBAs support a hostwide tagset, whereby each command submitted
to the HW from all submission queues must have a unique tag identifier.

Normally this unique tag will be in the range [0, max queue), where "max
queue" is the depth of each of the submission queues.

Add support for this hostwide tag feature, via module parameter
"host_max_queue". A non-zero value means that the feature is enabled. In
this case, the submission queues are not exposed to upper layer, i.e. from
blk-mq perspective, the device has a single hw queue. There are 2 reasons
for this:
a. it is assumed that the host can support nr_hw_queues * can_queue
   commands, but this is not true for hostwide tags
b. for nr_hw_queues != 0, the request tag is not unique over all HW queues,
   and some HBA drivers want to use this tag for the hostwide tag

However, like many SCSI HBA drivers today - megaraid sas being an example -
the full set of HW submission queues are still used in the LLDD driver. So
instead of using a complicated "reply_map" to create a per-CPU submission
queue mapping like megaraid sas (as it depends on a PCI device + MSIs) -
use a simple algorithm:

hwq = cpu % queue count

If the host max queue param is less than the max queue depth param, then
the max queue depth param is clipped.

If and when hostwide shared tags are supported in blk-mq/scsi mid-layer,
then the policy to set nr_hw_queues = 0 for hostwide tags can be revised.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/scsi_debug.c | 73 ++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 68534a23866e..a56d5ee9f4d7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -344,6 +344,7 @@ struct sdebug_defer {
 	struct execute_work ew;
 	int sqa_idx;	/* index of sdebug_queue array */
 	int qc_idx;	/* index of sdebug_queued_cmd array within sqa_idx */
+	int hc_idx;	/* hostwide tag index */
 	int issuing_cpu;
 	bool init_hrt;
 	bool init_wq;
@@ -762,6 +763,7 @@ static unsigned int sdebug_guard = DEF_GUARD;
 static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns = DEF_MAX_LUNS;
 static int sdebug_max_queue = SDEBUG_CANQUEUE;	/* per submit queue */
+static int sdebug_host_max_queue;	/* per host */
 static unsigned int sdebug_medium_error_start = OPT_MEDIUM_ERR_ADDR;
 static int sdebug_medium_error_count = OPT_MEDIUM_ERR_NUM;
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
@@ -4707,15 +4709,28 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
-	u32 tag = blk_mq_unique_tag(cmnd->request);
-	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
+	u16 hwq;
 
-	pr_debug("tag=%#x, hwq=%d\n", tag, hwq);
-	if (WARN_ON_ONCE(hwq >= submit_queues))
-		hwq = 0;
+	if (sdebug_host_max_queue) {
+		/* Provide a simple method to choose the hwq */
+		hwq = smp_processor_id() % submit_queues;
+	} else {
+		u32 tag = blk_mq_unique_tag(cmnd->request);
+
+		hwq = blk_mq_unique_tag_to_hwq(tag);
+
+		pr_debug("tag=%#x, hwq=%d\n", tag, hwq);
+		if (WARN_ON_ONCE(hwq >= submit_queues))
+			hwq = 0;
+	}
 	return sdebug_q_arr + hwq;
 }
 
+static u32 get_tag(struct scsi_cmnd *cmnd)
+{
+	return blk_mq_unique_tag(cmnd->request);
+}
+
 /* Queued (deferred) command completions converge here. */
 static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 {
@@ -4747,8 +4762,8 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 	scp = sqcp->a_cmnd;
 	if (unlikely(scp == NULL)) {
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
-		pr_err("scp is NULL, sqa_idx=%d, qc_idx=%d\n",
-		       sd_dp->sqa_idx, qc_idx);
+		pr_err("scp is NULL, sqa_idx=%d, qc_idx=%d, hc_idx=%d\n",
+		       sd_dp->sqa_idx, qc_idx, sd_dp->hc_idx);
 		return;
 	}
 	devip = (struct sdebug_dev_info *)scp->device->hostdata;
@@ -5451,6 +5466,10 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		new_sd_dp = false;
 	}
 
+	/* Set the hostwide tag */
+	if (sdebug_host_max_queue)
+		sd_dp->hc_idx = get_tag(cmnd);
+
 	if (ndelay > 0 && ndelay < INCLUSIVE_TIMING_MAX_NS)
 		ns_from_boot = ktime_get_boottime_ns();
 
@@ -5585,6 +5604,8 @@ module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
 module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
+module_param_named(host_max_queue, sdebug_host_max_queue, int,
+		   S_IRUGO | S_IWUSR);
 module_param_named(medium_error_count, sdebug_medium_error_count, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(medium_error_start, sdebug_medium_error_start, int,
@@ -5654,6 +5675,7 @@ MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (de
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
+MODULE_PARM_DESC(host_max_queue, "max number of queued commands per host (0 to max(def))");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
 MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
@@ -6141,7 +6163,8 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 	struct sdebug_queue *sqp;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
-	    (n <= SDEBUG_CANQUEUE)) {
+	    (n <= SDEBUG_CANQUEUE) &&
+	    (sdebug_host_max_queue ? sdebug_host_max_queue >= n : 1)) {
 		block_unblock_all_queues(true);
 		k = 0;
 		for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
@@ -6164,6 +6187,17 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(max_queue);
 
+static ssize_t host_max_queue_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_host_max_queue);
+}
+
+/*
+ * Since this is used for .can_queue, and we get the hc_idx tag from the bitmap
+ * in range [0, sdebug_host_max_queue), we can't change it.
+ */
+static DRIVER_ATTR_RO(host_max_queue);
+
 static ssize_t no_uld_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_no_uld);
@@ -6510,6 +6544,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_every_nth.attr,
 	&driver_attr_max_luns.attr,
 	&driver_attr_max_queue.attr,
+	&driver_attr_host_max_queue.attr,
 	&driver_attr_no_uld.attr,
 	&driver_attr_scsi_level.attr,
 	&driver_attr_virtual_gb.attr,
@@ -6619,6 +6654,13 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (sdebug_host_max_queue &&
+	    sdebug_max_queue > sdebug_host_max_queue) {
+		sdebug_max_queue = sdebug_host_max_queue;
+		pr_warn("reducing max submit queue depth to host max queue depth, %d\n",
+			sdebug_max_queue);
+	}
+
 	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue),
 			       GFP_KERNEL);
 	if (sdebug_q_arr == NULL)
@@ -7257,7 +7299,10 @@ static int sdebug_driver_probe(struct device *dev)
 
 	sdbg_host = to_sdebug_host(dev);
 
-	sdebug_driver_template.can_queue = sdebug_max_queue;
+	if (sdebug_host_max_queue)
+		sdebug_driver_template.can_queue = sdebug_host_max_queue;
+	else
+		sdebug_driver_template.can_queue = sdebug_max_queue;
 	if (!sdebug_clustering)
 		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
 
@@ -7272,9 +7317,13 @@ static int sdebug_driver_probe(struct device *dev)
 			my_name, submit_queues, nr_cpu_ids);
 		submit_queues = nr_cpu_ids;
 	}
-	/* Decide whether to tell scsi subsystem that we want mq */
-	/* Following should give the same answer for each host */
-	hpnt->nr_hw_queues = submit_queues;
+	/*
+	 * Decide whether to tell scsi subsystem that we want mq. The
+	 * following should give the same answer for each host. If the host
+	 * has a limit of hostwide max commands, then do not set.
+	 */
+	if (!sdebug_host_max_queue)
+		hpnt->nr_hw_queues = submit_queues;
 
 	sdbg_host->shost = hpnt;
 	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
-- 
2.26.2

