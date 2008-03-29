From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/5] scsi_debug: remove unnecessary function declarations
Date: Sun, 30 Mar 2008 00:59:58 +0900
Message-ID: <1206806398-22205-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35462 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYC2QAz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 12:00:55 -0400
In-Reply-To: <1206806398-22205-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

This patch removes function declarations with moving some
functions. This cleans up them a bit to silence checkpatch.pl. There
is no functional change.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |  277 ++++++++++++++++++++++-----------------------
 1 files changed, 133 insertions(+), 144 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1b6a6d8..07103c3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -218,8 +218,6 @@ static DEFINE_RWLOCK(atomic_rw);
 
 static char sdebug_proc_name[] = "scsi_debug";
 
-static int sdebug_driver_probe(struct device *);
-static int sdebug_driver_remove(struct device *);
 static struct bus_type pseudo_lld_bus;
 
 static struct device_driver sdebug_driverfs_driver = {
@@ -235,18 +233,42 @@ static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
 			           0, 0, 0x0, 0x0};
 
-static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev);
-static void mk_sense_buffer(struct sdebug_dev_info * devip, int key,
-			    int asc, int asq);
-static void stop_all_queued(void);
-static int stop_queued_cmnd(struct scsi_cmnd * cmnd);
-
 static int sdebug_add_adapter(void);
 static void sdebug_remove_adapter(void);
-static void sdebug_max_tgts_luns(void);
 
-static struct device pseudo_primary;
-static struct bus_type pseudo_lld_bus;
+static void sdebug_max_tgts_luns(void)
+{
+	struct sdebug_host_info *sdbg_host;
+	struct Scsi_Host *hpnt;
+
+	spin_lock(&sdebug_host_list_lock);
+	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+		hpnt = sdbg_host->shost;
+		if ((hpnt->this_id >= 0) &&
+		    (scsi_debug_num_tgts > hpnt->this_id))
+			hpnt->max_id = scsi_debug_num_tgts + 1;
+		else
+			hpnt->max_id = scsi_debug_num_tgts;
+		/* scsi_debug_max_luns; */
+		hpnt->max_lun = SAM2_WLUN_REPORT_LUNS;
+	}
+	spin_unlock(&sdebug_host_list_lock);
+}
+
+static void mk_sense_buffer(struct sdebug_dev_info *devip, int key,
+			    int asc, int asq)
+{
+	unsigned char *sbuff;
+
+	sbuff = devip->sense_buff;
+	memset(sbuff, 0, SDEBUG_SENSE_LEN);
+
+	scsi_build_sense_buffer(scsi_debug_dsense, sbuff, key, asc, asq);
+
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "scsi_debug:    [sense_key,asc,ascq]: "
+		      "[0x%x,0x%x,0x%x]\n", key, asc, asq);
+}
 
 static void get_data_transfer_info(unsigned char *cmd,
 				   unsigned long long *lba, unsigned int *num)
@@ -1680,52 +1702,9 @@ static void timer_intr_handler(unsigned long indx)
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
-static int scsi_debug_slave_alloc(struct scsi_device * sdp)
-{
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
-	set_bit(QUEUE_FLAG_BIDI, &sdp->request_queue->queue_flags);
-	return 0;
-}
-
-static int scsi_debug_slave_configure(struct scsi_device * sdp)
-{
-	struct sdebug_dev_info * devip;
-
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
-	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
-		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
-	devip = devInfoReg(sdp);
-	if (NULL == devip)
-		return 1;	/* no resources, will be marked offline */
-	sdp->hostdata = devip;
-	if (sdp->host->cmd_per_lun)
-		scsi_adjust_queue_depth(sdp, SDEBUG_TAGGED_QUEUING,
-					sdp->host->cmd_per_lun);
-	blk_queue_max_segment_size(sdp->request_queue, 256 * 1024);
-	return 0;
-}
-
-static void scsi_debug_slave_destroy(struct scsi_device * sdp)
-{
-	struct sdebug_dev_info * devip =
-				(struct sdebug_dev_info *)sdp->hostdata;
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
-	if (devip) {
-		/* make this slot avaliable for re-use */
-		devip->used = 0;
-		sdp->hostdata = NULL;
-	}
-}
-
-struct sdebug_dev_info *sdebug_device_create(struct sdebug_host_info *sdbg_host,
-					     gfp_t flags)
+static struct sdebug_dev_info *
+sdebug_device_create(struct sdebug_host_info *sdbg_host, gfp_t flags)
 {
 	struct sdebug_dev_info *devip;
 
@@ -1789,19 +1768,88 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 	return open_devip;
 }
 
-static void mk_sense_buffer(struct sdebug_dev_info * devip, int key,
-			    int asc, int asq)
+static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 {
-	unsigned char *sbuff;
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
+		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+	set_bit(QUEUE_FLAG_BIDI, &sdp->request_queue->queue_flags);
+	return 0;
+}
 
-	sbuff = devip->sense_buff;
-	memset(sbuff, 0, SDEBUG_SENSE_LEN);
+static int scsi_debug_slave_configure(struct scsi_device *sdp)
+{
+	struct sdebug_dev_info *devip;
 
-	scsi_build_sense_buffer(scsi_debug_dsense, sbuff, key, asc, asq);
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %u>\n",
+		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
+		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
+	devip = devInfoReg(sdp);
+	if (NULL == devip)
+		return 1;	/* no resources, will be marked offline */
+	sdp->hostdata = devip;
+	if (sdp->host->cmd_per_lun)
+		scsi_adjust_queue_depth(sdp, SDEBUG_TAGGED_QUEUING,
+					sdp->host->cmd_per_lun);
+	blk_queue_max_segment_size(sdp->request_queue, 256 * 1024);
+	return 0;
+}
+
+static void scsi_debug_slave_destroy(struct scsi_device *sdp)
+{
+	struct sdebug_dev_info *devip =
+		(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug:    [sense_key,asc,ascq]: "
-		      "[0x%x,0x%x,0x%x]\n", key, asc, asq);
+		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %u>\n",
+		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+	if (devip) {
+		/* make this slot avaliable for re-use */
+		devip->used = 0;
+		sdp->hostdata = NULL;
+	}
+}
+
+/* Returns 1 if found 'cmnd' and deleted its timer. else returns 0 */
+static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
+{
+	unsigned long iflags;
+	int k;
+	struct sdebug_queued_cmd *sqcp;
+
+	spin_lock_irqsave(&queued_arr_lock, iflags);
+	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+		sqcp = &queued_arr[k];
+		if (sqcp->in_use && (cmnd == sqcp->a_cmnd)) {
+			del_timer_sync(&sqcp->cmnd_timer);
+			sqcp->in_use = 0;
+			sqcp->a_cmnd = NULL;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	return (k < SCSI_DEBUG_CANQUEUE) ? 1 : 0;
+}
+
+/* Deletes (stops) timers of all queued commands */
+static void stop_all_queued(void)
+{
+	unsigned long iflags;
+	int k;
+	struct sdebug_queued_cmd *sqcp;
+
+	spin_lock_irqsave(&queued_arr_lock, iflags);
+	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+		sqcp = &queued_arr[k];
+		if (sqcp->in_use && sqcp->a_cmnd) {
+			del_timer_sync(&sqcp->cmnd_timer);
+			sqcp->in_use = 0;
+			sqcp->a_cmnd = NULL;
+		}
+	}
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
 static int scsi_debug_abort(struct scsi_cmnd * SCpnt)
@@ -1891,46 +1939,6 @@ static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
 	return SUCCESS;
 }
 
-/* Returns 1 if found 'cmnd' and deleted its timer. else returns 0 */
-static int stop_queued_cmnd(struct scsi_cmnd * cmnd)
-{
-	unsigned long iflags;
-	int k;
-	struct sdebug_queued_cmd * sqcp;
-
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
-		sqcp = &queued_arr[k];
-		if (sqcp->in_use && (cmnd == sqcp->a_cmnd)) {
-			del_timer_sync(&sqcp->cmnd_timer);
-			sqcp->in_use = 0;
-			sqcp->a_cmnd = NULL;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	return (k < SCSI_DEBUG_CANQUEUE) ? 1 : 0;
-}
-
-/* Deletes (stops) timers of all queued commands */
-static void stop_all_queued(void)
-{
-	unsigned long iflags;
-	int k;
-	struct sdebug_queued_cmd * sqcp;
-
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
-		sqcp = &queued_arr[k];
-		if (sqcp->in_use && sqcp->a_cmnd) {
-			del_timer_sync(&sqcp->cmnd_timer);
-			sqcp->in_use = 0;
-			sqcp->a_cmnd = NULL;
-		}
-	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-}
-
 /* Initializes timers in queued array */
 static void __init init_all_queued(void)
 {
@@ -2055,7 +2063,6 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
 		return 0;
 	}
 }
-
 /* Note: The following macros create attribute files in the
    /sys/module/scsi_debug/parameters directory. Unfortunately this
    driver is unaware of a change and cannot trigger auxiliary actions
@@ -2474,6 +2481,17 @@ static void do_remove_driverfs_files(void)
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_add_host);
 }
 
+static void pseudo_0_release(struct device *dev)
+{
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
+}
+
+static struct device pseudo_primary = {
+	.bus_id		= "pseudo_0",
+	.release	= pseudo_0_release,
+};
+
 static int __init scsi_debug_init(void)
 {
 	unsigned long sz;
@@ -2588,30 +2606,6 @@ static void __exit scsi_debug_exit(void)
 device_initcall(scsi_debug_init);
 module_exit(scsi_debug_exit);
 
-static void pseudo_0_release(struct device * dev)
-{
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
-}
-
-static struct device pseudo_primary = {
-	.bus_id		= "pseudo_0",
-	.release	= pseudo_0_release,
-};
-
-static int pseudo_lld_bus_match(struct device *dev,
-                          struct device_driver *dev_driver)
-{
-        return 1;
-}
-
-static struct bus_type pseudo_lld_bus = {
-        .name = "pseudo",
-        .match = pseudo_lld_bus_match,
-	.probe = sdebug_driver_probe,
-	.remove = sdebug_driver_remove,
-};
-
 static void sdebug_release_adapter(struct device * dev)
 {
         struct sdebug_host_info *sdbg_host;
@@ -3011,20 +3005,15 @@ static int sdebug_driver_remove(struct device * dev)
         return 0;
 }
 
-static void sdebug_max_tgts_luns(void)
+static int pseudo_lld_bus_match(struct device *dev,
+				struct device_driver *dev_driver)
 {
-	struct sdebug_host_info * sdbg_host;
-	struct Scsi_Host *hpnt;
-
-	spin_lock(&sdebug_host_list_lock);
-	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
-		hpnt = sdbg_host->shost;
-		if ((hpnt->this_id >= 0) &&
-		    (scsi_debug_num_tgts > hpnt->this_id))
-			hpnt->max_id = scsi_debug_num_tgts + 1;
-		else
-			hpnt->max_id = scsi_debug_num_tgts;
-		hpnt->max_lun = SAM2_WLUN_REPORT_LUNS; /* scsi_debug_max_luns; */
-	}
-	spin_unlock(&sdebug_host_list_lock);
+	return 1;
 }
+
+static struct bus_type pseudo_lld_bus = {
+	.name = "pseudo",
+	.match = pseudo_lld_bus_match,
+	.probe = sdebug_driver_probe,
+	.remove = sdebug_driver_remove,
+};
-- 
1.5.3.7

