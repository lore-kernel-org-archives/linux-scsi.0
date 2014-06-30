From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: support scsi-mq, queues and locks
Date: Mon, 30 Jun 2014 01:08:16 -0400
Message-ID: <53B0F0C0.40907@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010008090000080500070005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34079 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaF3FIX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2014 01:08:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>, Christoph Hellwig <hch@lst.de>

This is a multi-part message in MIME format.
--------------010008090000080500070005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch ** is against Christoph's core-for-3.17 branch
which includes scsi-mq V2.

The purpose of releasing it now is to facilitate testing of
scsi-mq . The fio user space program seems to be the tool
of choice for such tests. With fio and four (pseudo) devices
I have observed 1.2 M IOPS on my equipment. Rob Elliott has
better results than that.


ChangeLog:
   - add host_lock option whose default value is 0 which
     removes the host_lock around all queued commands
   - accept delay=-1 (_hi_) or -2 which use a tasklet to invoke
     the scsi_done callback into the mid-layer. The default
     is still delay=1 which uses a timer to delay 1 jiffy
   - wire .change_queue_depth and .change_queue_type
     functions to better simulate queueing in a modern LLD
   - add SCSI_DEBUG_OPT_Q_NOISE (0x200) mask to only produce
     debug output associated with queue full, plus from
     .change_queue_depth and .change_queue_type functions
   - add SCSI_DEBUG_OPT_ALL_TSF (0x400) mask which reports
     all queued_arr fulls at TASK_SET_FULL, otherwise
     SCSI_MLQUEUE_HOST_BUSY is returned
   - add SCSI_DEBUG_OPT_RARE_TSF (0x800) mask which works
     together with the every_nth option (> 0) to count
     occurrences of num_in_q==queue_depth. When every_nth
     is reached the victim (a command) yields TASK SET FULL
   - clean up many debug messages.


IMO the scsi-mq queue_depth handling doesn't break but does
not converge promptly (and in some cases seems to be steady
state unstable) in the face of TASK_SET_FULL statuses.
This can be seen with this sequence:
   # cd /sys/bus/pseudo/drivers/scsi_debug
   # echo 0x600 > opts
< then in another window 'tail -f /var/log/syslog'>
< then in yet another window run a fio test against scsi_debug>
   # echo 200 > max_queue
< if the tail shows nothing, try writing a lower value into max_queue>

max_queue starts at 576. Depending on the fio test, the new
value written into max_queue needed to prompt the TSF trip
point will vary. You will now it when you see it :-)


The PI and provisioning parts of scsi_debug have been written
by Martin Petersen and some of its bitmaps may be racy without
the host_lock. I'm hoping that when Martin has time, he will
re-visit that code.

** scsi_debug in the core-for-3.17 branch already has Hannes'
    64 bit LUN changes and Akinobu Mita's "allow huge transfer
    length for read/write commands". So expect some noise if
    this patch is applied to other trees (such as vanilla lk
    3.15.2). There is no real conflict but the patch command
    gets upset.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Robert Elliott <elliott@hp.com>

--------------010008090000080500070005
Content-Type: text/x-patch;
 name="sdebug_cf317dg7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug_cf317dg7.patch"

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6ed43fd..0da86c9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -42,6 +42,9 @@
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/atomic.h>
 
 #include <net/checksum.h>
 
@@ -53,13 +56,14 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
 
 #include "sd.h"
 #include "scsi_logging.h"
 
-#define SCSI_DEBUG_VERSION "1.82"
-static const char * scsi_debug_version_date = "20100324";
+#define SCSI_DEBUG_VERSION "1.84"
+static const char *scsi_debug_version_date = "20140629";
 
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
@@ -81,7 +85,6 @@ static const char * scsi_debug_version_date = "20100324";
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
 
-#define SDEBUG_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 
 /* Default values for driver parameters */
 #define DEF_NUM_HOST   1
@@ -99,6 +102,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_EVERY_NTH   0
 #define DEF_FAKE_RW	0
 #define DEF_GUARD 0
+#define DEF_HOST_LOCK 0
 #define DEF_LBPU 0
 #define DEF_LBPWS 0
 #define DEF_LBPWS10 0
@@ -113,6 +117,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_REMOVABLE false
 #define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
 #define DEF_SECTOR_SIZE 512
+#define DEF_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 #define DEF_UNMAP_ALIGNMENT 0
 #define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
@@ -130,7 +135,10 @@ static const char * scsi_debug_version_date = "20100324";
 #define SCSI_DEBUG_OPT_DIF_ERR   32
 #define SCSI_DEBUG_OPT_DIX_ERR   64
 #define SCSI_DEBUG_OPT_MAC_TIMEOUT  128
-#define SCSI_DEBUG_OPT_SHORT_TRANSFER	256
+#define SCSI_DEBUG_OPT_SHORT_TRANSFER	0x100
+#define SCSI_DEBUG_OPT_Q_NOISE	0x200
+#define SCSI_DEBUG_OPT_ALL_TSF	0x400
+#define SCSI_DEBUG_OPT_RARE_TSF	0x800
 /* When "every_nth" > 0 then modulo "every_nth" commands:
  *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
@@ -158,9 +166,18 @@ static const char * scsi_debug_version_date = "20100324";
 #define SAM2_LUN_ADDRESS_METHOD 0
 #define SAM2_WLUN_REPORT_LUNS 0xc101
 
-/* Can queue up to this number of commands. Typically commands that
- * that have a non-zero delay are queued. */
-#define SCSI_DEBUG_CANQUEUE  255
+/* SCSI_DEBUG_CANQUEUE is the maximum number of commands that can be queued
+ * (for response) at one time. Can be reduced by max_queue option. Command
+ * responses are not queued when delay=0. The per-device DEF_CMD_PER_LUN can
+ * be changed via sysfs /sys/class/scsi_device/<h:c:t:l>/device/queue_depth
+ * but cannot exceed SCSI_DEBUG_CANQUEUE. */
+#define SCSI_DEBUG_CANQUEUE_WORDS  9	/* a WORD is bits in a long */
+#define SCSI_DEBUG_CANQUEUE  (SCSI_DEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
+#define DEF_CMD_PER_LUN  255
+
+#if DEF_CMD_PER_LUN > SCSI_DEBUG_CANQUEUE
+#warning "Expect DEF_CMD_PER_LUN <= SCSI_DEBUG_CANQUEUE"
+#endif
 
 static int scsi_debug_add_host = DEF_NUM_HOST;
 static int scsi_debug_ato = DEF_ATO;
@@ -175,6 +192,7 @@ static unsigned int scsi_debug_guard = DEF_GUARD;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_max_luns = DEF_MAX_LUNS;
 static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
+static int retired_max_queue;
 static int scsi_debug_no_lun_0 = DEF_NO_LUN_0;
 static int scsi_debug_no_uld = 0;
 static int scsi_debug_num_parts = DEF_NUM_PARTS;
@@ -198,8 +216,11 @@ static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
 static bool scsi_debug_clustering;
+static bool scsi_debug_host_lock = DEF_HOST_LOCK;
 
-static int scsi_debug_cmnd_count = 0;
+static atomic_t sdebug_cmnd_count;
+static atomic_t sdebug_completions;
+static atomic_t sdebug_a_tsf;
 
 #define DEV_READONLY(TGT)      (0)
 
@@ -231,6 +252,7 @@ struct sdebug_dev_info {
 	u64 lun;
 	struct sdebug_host_info *sdbg_host;
 	u64 wlun;
+	int num_in_q;
 	char reset;
 	char stopped;
 	char used;
@@ -249,16 +271,16 @@ struct sdebug_host_info {
 static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
-typedef void (* done_funct_t) (struct scsi_cmnd *);
 
 struct sdebug_queued_cmd {
-	int in_use;
-	struct timer_list cmnd_timer;
-	done_funct_t done_funct;
+	/* in_use flagged by a bit in queued_in_use_bm[] */
+	struct timer_list *cmnd_timerp;
+	struct tasklet_struct *tletp;
 	struct scsi_cmnd * a_cmnd;
 	int scsi_result;
 };
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
+static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
 
 static unsigned char * fake_storep;	/* ramdisk storage */
 static struct sd_dif_tuple *dif_storep;	/* protection info */
@@ -291,6 +313,9 @@ static const int check_condition_result =
 static const int illegal_condition_result =
 	(DRIVER_SENSE << 24) | (DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 
+static const int device_qfull_result =
+	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
+
 static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 				    0, 0, 0x2, 0x4b};
 static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
@@ -2366,32 +2391,52 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	return 0;
 }
 
-/* When timer goes off this function is called. */
-static void timer_intr_handler(unsigned long indx)
+/* When timer or tasket goes off this function is called. */
+static void sdebug_q_cmd_complete(unsigned long indx)
 {
-	struct sdebug_queued_cmd * sqcp;
+	int retiring = 0;
 	unsigned long iflags;
+	struct sdebug_queued_cmd *sqcp;
+	struct scsi_cmnd *scp;
+	struct sdebug_dev_info *devip;
 
+	atomic_inc(&sdebug_completions);
+	spin_lock_irqsave(&queued_arr_lock, iflags);
 	if (indx >= scsi_debug_max_queue) {
-		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "
-		       "large\n");
-		return;
+		if (indx >= retired_max_queue) {
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			pr_err("%s: index %lu too large\n", __func__, indx);
+			return;
+		}
+		retiring = 1;
 	}
-	spin_lock_irqsave(&queued_arr_lock, iflags);
 	sqcp = &queued_arr[(int)indx];
-	if (! sqcp->in_use) {
-		printk(KERN_ERR "scsi_debug:timer_intr_handler: Unexpected "
-		       "interrupt\n");
+	if (!test_bit((int)indx, queued_in_use_bm)) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		pr_err("%s: Unexpected completion\n", __func__);
 		return;
 	}
-	sqcp->in_use = 0;
-	if (sqcp->done_funct) {
-		sqcp->a_cmnd->result = sqcp->scsi_result;
-		sqcp->done_funct(sqcp->a_cmnd); /* callback to mid level */
+	scp = sqcp->a_cmnd;
+	if (scp) {
+		scp->result = sqcp->scsi_result;
+		devip = (struct sdebug_dev_info *)scp->device->hostdata;
+		if (devip)
+			--devip->num_in_q;
+	}
+	__clear_bit((int)indx, queued_in_use_bm);
+	if (retiring) {
+		int k;
+
+		k = find_last_bit(queued_in_use_bm, retired_max_queue);
+		if ((k < scsi_debug_max_queue) || (k == retired_max_queue))
+			retired_max_queue = 0;
+		else
+			retired_max_queue = k + 1;
 	}
-	sqcp->done_funct = NULL;
+	sqcp->a_cmnd = NULL;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	if (scp)
+		scp->scsi_done(scp); /* callback to mid level */
 }
 
 
@@ -2419,7 +2464,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 		return devip;
 	sdbg_host = *(struct sdebug_host_info **)shost_priv(sdev->host);
 	if (!sdbg_host) {
-                printk(KERN_ERR "Host info NULL\n");
+		pr_err("%s: Host info NULL\n", __func__);
 		return NULL;
         }
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
@@ -2482,9 +2527,10 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	if (NULL == devip)
 		return 1;	/* no resources, will be marked offline */
 	sdp->hostdata = devip;
+	sdp->tagged_supported = 1;
 	if (sdp->host->cmd_per_lun)
-		scsi_adjust_queue_depth(sdp, SDEBUG_TAGGED_QUEUING,
-					sdp->host->cmd_per_lun);
+		scsi_adjust_queue_depth(sdp, DEF_TAGGED_QUEUING,
+					DEF_CMD_PER_LUN);
 	blk_queue_max_segment_size(sdp->request_queue, -1U);
 	if (scsi_debug_no_uld)
 		sdp->no_uld_attach = 1;
@@ -2510,21 +2556,34 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 {
 	unsigned long iflags;
-	int k;
+	int k, qmax;
 	struct sdebug_queued_cmd *sqcp;
+	struct sdebug_dev_info *devip;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < scsi_debug_max_queue; ++k) {
-		sqcp = &queued_arr[k];
-		if (sqcp->in_use && (cmnd == sqcp->a_cmnd)) {
-			del_timer_sync(&sqcp->cmnd_timer);
-			sqcp->in_use = 0;
-			sqcp->a_cmnd = NULL;
-			break;
+	qmax = scsi_debug_max_queue;
+	if (retired_max_queue > qmax)
+		qmax = retired_max_queue;
+	for (k = 0; k < qmax; ++k) {
+		if (test_bit(k, queued_in_use_bm)) {
+			sqcp = &queued_arr[k];
+			if (cmnd == sqcp->a_cmnd) {
+				if (scsi_debug_delay > 0)
+					del_timer_sync(sqcp->cmnd_timerp);
+				else if (scsi_debug_delay < 0)
+					tasklet_kill(sqcp->tletp);
+				__clear_bit(k, queued_in_use_bm);
+				devip = (struct sdebug_dev_info *)
+					cmnd->device->hostdata;
+				if (devip)
+					--devip->num_in_q;
+				sqcp->a_cmnd = NULL;
+				break;
+			}
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	return (k < scsi_debug_max_queue) ? 1 : 0;
+	return (k < qmax) ? 1 : 0;
 }
 
 /* Deletes (stops) timers of all queued commands */
@@ -2533,19 +2592,47 @@ static void stop_all_queued(void)
 	unsigned long iflags;
 	int k;
 	struct sdebug_queued_cmd *sqcp;
+	struct sdebug_dev_info *devip;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < scsi_debug_max_queue; ++k) {
-		sqcp = &queued_arr[k];
-		if (sqcp->in_use && sqcp->a_cmnd) {
-			del_timer_sync(&sqcp->cmnd_timer);
-			sqcp->in_use = 0;
-			sqcp->a_cmnd = NULL;
+	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+		if (test_bit(k, queued_in_use_bm)) {
+			sqcp = &queued_arr[k];
+			if (sqcp->a_cmnd) {
+				if (scsi_debug_delay > 0)
+					del_timer_sync(sqcp->cmnd_timerp);
+				else if (scsi_debug_delay < 0)
+					tasklet_kill(sqcp->tletp);
+				__clear_bit(k, queued_in_use_bm);
+				devip = (struct sdebug_dev_info *)
+					sqcp->a_cmnd->device->hostdata;
+				if (devip)
+					--devip->num_in_q;
+				sqcp->a_cmnd = NULL;
+			}
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
+/* Free queued command memory on heap */
+static void free_all_queued(void)
+{
+	unsigned long iflags;
+	int k;
+	struct sdebug_queued_cmd *sqcp;
+
+	spin_lock_irqsave(&queued_arr_lock, iflags);
+	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+		sqcp = &queued_arr[k];
+		kfree(sqcp->cmnd_timerp);
+		sqcp->cmnd_timerp = NULL;
+		kfree(sqcp->tletp);
+		sqcp->tletp = NULL;
+	}
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+}
+
 static int scsi_debug_abort(struct scsi_cmnd * SCpnt)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
@@ -2641,10 +2728,10 @@ static void __init init_all_queued(void)
 	struct sdebug_queued_cmd * sqcp;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < scsi_debug_max_queue; ++k) {
+	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
 		sqcp = &queued_arr[k];
-		init_timer(&sqcp->cmnd_timer);
-		sqcp->in_use = 0;
+		sqcp->tletp = NULL;
+		sqcp->cmnd_timerp = NULL;
 		sqcp->a_cmnd = NULL;
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
@@ -2663,8 +2750,8 @@ static void __init sdebug_build_parts(unsigned char *ramp,
 		return;
 	if (scsi_debug_num_parts > SDEBUG_MAX_PARTS) {
 		scsi_debug_num_parts = SDEBUG_MAX_PARTS;
-		printk(KERN_WARNING "scsi_debug:build_parts: reducing "
-				    "partitions to %d\n", SDEBUG_MAX_PARTS);
+		pr_warn("%s: reducing partitions to %d\n", __func__,
+			SDEBUG_MAX_PARTS);
 	}
 	num_sectors = (int)sdebug_store_sectors;
 	sectors_per_part = (num_sectors - sdebug_sectors_per)
@@ -2701,62 +2788,108 @@ static void __init sdebug_build_parts(unsigned char *ramp,
 	}
 }
 
-static int schedule_resp(struct scsi_cmnd * cmnd,
-			 struct sdebug_dev_info * devip,
-			 done_funct_t done, int scsi_result, int delta_jiff)
+static int
+schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
+	      int scsi_result, int delta_jiff)
 {
-	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmnd) {
-		if (scsi_result) {
-			struct scsi_device * sdp = cmnd->device;
-
-			printk(KERN_INFO "scsi_debug:    <%u %u %u %llu> "
-			       "non-zero result=0x%x\n", sdp->host->host_no,
-			       sdp->channel, sdp->id, sdp->lun, scsi_result);
-		}
+	unsigned long iflags;
+	int k, num_in_q, tsf, qdepth;
+	struct sdebug_queued_cmd *sqcp = NULL;
+	struct scsi_device *sdp = cmnd->device;
+
+	if (NULL == cmnd || NULL == devip) {
+		pr_warn("%s: called with NULL cmnd or devip pointer\n",
+			__func__);
+		/* no particularly good error to report back */
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
-	if (cmnd && devip) {
-		/* simulate autosense by this driver */
+	if (scsi_result) {
+		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+			sdev_printk(KERN_INFO, sdp,
+				    "%s: non-zero result=0x%x\n", __func__,
+				    scsi_result);
+		/* N.B. this per device sense buffer looks dangerous */
 		if (SAM_STAT_CHECK_CONDITION == (scsi_result & 0xff))
 			memcpy(cmnd->sense_buffer, devip->sense_buff,
 			       (SCSI_SENSE_BUFFERSIZE > SDEBUG_SENSE_LEN) ?
 			       SDEBUG_SENSE_LEN : SCSI_SENSE_BUFFERSIZE);
 	}
-	if (delta_jiff <= 0) {
-		if (cmnd)
-			cmnd->result = scsi_result;
-		if (done)
-			done(cmnd);
+	if (delta_jiff == 0) {
+		/* using same thread to call back mid-layer */
+		cmnd->result = scsi_result;
+		cmnd->scsi_done(cmnd);
 		return 0;
-	} else {
-		unsigned long iflags;
-		int k;
-		struct sdebug_queued_cmd * sqcp = NULL;
+	}
 
-		spin_lock_irqsave(&queued_arr_lock, iflags);
-		for (k = 0; k < scsi_debug_max_queue; ++k) {
-			sqcp = &queued_arr[k];
-			if (! sqcp->in_use)
-				break;
+	/* deferred response cases */
+	spin_lock_irqsave(&queued_arr_lock, iflags);
+	num_in_q = devip->num_in_q;
+	qdepth = cmnd->device->queue_depth;
+	k = find_first_zero_bit(queued_in_use_bm, scsi_debug_max_queue);
+	tsf = 0;
+	if ((scsi_debug_every_nth != 0) &&
+	    (SCSI_DEBUG_OPT_RARE_TSF & scsi_debug_opts) &&
+	    (num_in_q == (qdepth - 1)) &&
+	    (atomic_inc_return(&sdebug_a_tsf) >= abs(scsi_debug_every_nth))) {
+		atomic_set(&sdebug_a_tsf, 0);
+		tsf = 1;
+	} else if ((qdepth > 0) && (num_in_q >= qdepth))
+		tsf = 1;
+	/* if (tsf) simulate device reporting SCSI status of TASK SET FULL.
+	 * Might override existing CHECK CONDITION. */
+	if (tsf)
+		scsi_result = device_qfull_result;
+	if (k >= scsi_debug_max_queue) {
+		if (SCSI_DEBUG_OPT_ALL_TSF & scsi_debug_opts)
+			tsf = 1;
+		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts)
+			sdev_printk(KERN_INFO, sdp,
+				    "%s: num_in_q=%d, reporting %s\n",
+				    __func__, num_in_q, (tsf ?
+				    "TASK SET FULL" : "host full"));
+		if (tsf) {
+			/* queued_arr full so respond in same thread */
+			cmnd->result = scsi_result;
+			cmnd->scsi_done(cmnd);
+			/* N.B. not returning SCSI_MLQUEUE_DEVICE_BUSY */
+			return 0;
+		} else
+			return SCSI_MLQUEUE_HOST_BUSY;
+	}
+	__set_bit(k, queued_in_use_bm);
+	++devip->num_in_q;
+	sqcp = &queued_arr[k];
+	sqcp->a_cmnd = cmnd;
+	sqcp->scsi_result = scsi_result;
+	if (delta_jiff > 0) {
+		if (NULL == sqcp->cmnd_timerp) {
+			sqcp->cmnd_timerp = kmalloc(sizeof(struct timer_list),
+						    GFP_ATOMIC);
+			init_timer(sqcp->cmnd_timerp);
 		}
-		if (k >= scsi_debug_max_queue) {
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
-			printk(KERN_WARNING "scsi_debug: can_queue exceeded\n");
-			return 1;	/* report busy to mid level */
+		sqcp->cmnd_timerp->function = sdebug_q_cmd_complete;
+		sqcp->cmnd_timerp->data = k;
+		sqcp->cmnd_timerp->expires = get_jiffies_64() + delta_jiff;
+		add_timer(sqcp->cmnd_timerp);
+	} else {
+		if (NULL == sqcp->tletp) {
+			sqcp->tletp = kmalloc(sizeof(struct tasklet_struct),
+					      GFP_ATOMIC);
+			tasklet_init(sqcp->tletp, sdebug_q_cmd_complete, k);
 		}
-		sqcp->in_use = 1;
-		sqcp->a_cmnd = cmnd;
-		sqcp->scsi_result = scsi_result;
-		sqcp->done_funct = done;
-		sqcp->cmnd_timer.function = timer_intr_handler;
-		sqcp->cmnd_timer.data = k;
-		sqcp->cmnd_timer.expires = jiffies + delta_jiff;
-		add_timer(&sqcp->cmnd_timer);
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		if (cmnd)
-			cmnd->result = 0;
-		return 0;
+		if (-1 == delta_jiff)
+			tasklet_hi_schedule(sqcp->tletp);
+		else
+			tasklet_schedule(sqcp->tletp);
 	}
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	if (tsf && (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts))
+		sdev_printk(KERN_INFO, sdp, "%s: num_in_q=%d, status: %s\n",
+			    __func__, num_in_q, "TASK SET FULL");
+	return 0;
 }
+
 /* Note: The following macros create attribute files in the
    /sys/module/scsi_debug/parameters directory. Unfortunately this
    driver is unaware of a change and cannot trigger auxiliary actions
@@ -2774,6 +2907,7 @@ module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
 module_param_named(guard, scsi_debug_guard, uint, S_IRUGO);
+module_param_named(host_lock, scsi_debug_host_lock, bool, S_IRUGO | S_IWUSR);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
@@ -2810,7 +2944,7 @@ MODULE_VERSION(SCSI_DEBUG_VERSION);
 MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
-MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
+MODULE_PARM_DESC(delay, "response delay (def=1 jiffy); 0:imm, -1,-2:tiny");
 MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
@@ -2818,13 +2952,14 @@ MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
+MODULE_PARM_DESC(host_lock, "use host_lock around all commands (def=0)");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbprz, "unmapped blocks return 0 on read (def=1)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
-MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to 255(def))");
+MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
 MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
@@ -2872,7 +3007,7 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer, int lengt
 		return -EINVAL;
 	scsi_debug_opts = opts;
 	if (scsi_debug_every_nth != 0)
-		scsi_debug_cmnd_count = 0;
+		atomic_set(&sdebug_cmnd_count, 0);
 	return length;
 }
 
@@ -2881,15 +3016,16 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 	seq_printf(m, "scsi_debug adapter driver, version "
 	    "%s [%s]\n"
 	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
-	    "every_nth=%d(curr:%d)\n"
-	    "delay=%d, max_luns=%d, scsi_level=%d\n"
+	    "every_nth=%d (curr:%d)\n"
+	    "delay=%d, max_luns=%d, scsi_level=%d, queued_completions=%d\n"
 	    "sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
 	    "number of aborts=%d, device_reset=%d, bus_resets=%d, "
 	    "host_resets=%d\ndix_reads=%d dix_writes=%d dif_errors=%d\n",
 	    SCSI_DEBUG_VERSION, scsi_debug_version_date, scsi_debug_num_tgts,
 	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
-	    scsi_debug_cmnd_count, scsi_debug_delay,
+	    atomic_read(&sdebug_cmnd_count), scsi_debug_delay,
 	    scsi_debug_max_luns, scsi_debug_scsi_level,
+	    atomic_read(&sdebug_completions),
 	    scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
 	    sdebug_sectors_per, num_aborts, num_dev_resets, num_bus_resets,
 	    num_host_resets, dix_reads, dix_writes, dif_errors);
@@ -2908,7 +3044,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 	char work[20];
 
         if (1 == sscanf(buf, "%10s", work)) {
-		if ((1 == sscanf(work, "%d", &delay)) && (delay >= 0)) {
+		if (1 == sscanf(work, "%d", &delay)) {
 			scsi_debug_delay = delay;
 			return count;
 		}
@@ -2940,7 +3076,7 @@ static ssize_t opts_store(struct device_driver *ddp, const char *buf,
 	return -EINVAL;
 opts_done:
 	scsi_debug_opts = opts;
-	scsi_debug_cmnd_count = 0;
+	atomic_set(&sdebug_cmnd_count, 0);
 	return count;
 }
 static DRIVER_ATTR_RW(opts);
@@ -3054,7 +3190,7 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &nth))) {
 		scsi_debug_every_nth = nth;
-		scsi_debug_cmnd_count = 0;
+		atomic_set(&sdebug_cmnd_count, 0);
 		return count;
 	}
 	return -EINVAL;
@@ -3086,12 +3222,23 @@ static ssize_t max_queue_show(struct device_driver *ddp, char *buf)
 static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
 {
-        int n;
+	unsigned long iflags;
+	int n, k, res;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
 	    (n <= SCSI_DEBUG_CANQUEUE)) {
+		res = count;
+		spin_lock_irqsave(&queued_arr_lock, iflags);
+		k = find_last_bit(queued_in_use_bm, SCSI_DEBUG_CANQUEUE);
 		scsi_debug_max_queue = n;
-		return count;
+		if (SCSI_DEBUG_CANQUEUE == k)
+			retired_max_queue = 0;
+		else if (k >= n)
+			retired_max_queue = k + 1;
+		else
+			retired_max_queue = 0;
+		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		return res;
 	}
 	return -EINVAL;
 }
@@ -3235,6 +3382,24 @@ static ssize_t removable_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(removable);
 
+static ssize_t host_lock_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!scsi_debug_host_lock);
+}
+static ssize_t host_lock_store(struct device_driver *ddp, const char *buf,
+			       size_t count)
+{
+	int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		scsi_debug_host_lock = (n > 0);
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(host_lock);
+
+
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -3267,6 +3432,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_ato.attr,
 	&driver_attr_map.attr,
 	&driver_attr_removable.attr,
+	&driver_attr_host_lock.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
@@ -3280,6 +3446,8 @@ static int __init scsi_debug_init(void)
 	int k;
 	int ret;
 
+	atomic_set(&sdebug_cmnd_count, 0);
+	atomic_set(&sdebug_completions, 0);
 	switch (scsi_debug_sector_size) {
 	case  512:
 	case 1024:
@@ -3287,7 +3455,7 @@ static int __init scsi_debug_init(void)
 	case 4096:
 		break;
 	default:
-		printk(KERN_ERR "scsi_debug_init: invalid sector_size %d\n",
+		pr_err("%s: invalid sector_size %d\n", __func__,
 		       scsi_debug_sector_size);
 		return -EINVAL;
 	}
@@ -3301,28 +3469,28 @@ static int __init scsi_debug_init(void)
 		break;
 
 	default:
-		printk(KERN_ERR "scsi_debug_init: dif must be 0, 1, 2 or 3\n");
+		pr_err("%s: dif must be 0, 1, 2 or 3\n", __func__);
 		return -EINVAL;
 	}
 
 	if (scsi_debug_guard > 1) {
-		printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
+		pr_err("%s: guard must be 0 or 1\n", __func__);
 		return -EINVAL;
 	}
 
 	if (scsi_debug_ato > 1) {
-		printk(KERN_ERR "scsi_debug_init: ato must be 0 or 1\n");
+		pr_err("%s: ato must be 0 or 1\n", __func__);
 		return -EINVAL;
 	}
 
 	if (scsi_debug_physblk_exp > 15) {
-		printk(KERN_ERR "scsi_debug_init: invalid physblk_exp %u\n",
+		pr_err("%s: invalid physblk_exp %u\n", __func__,
 		       scsi_debug_physblk_exp);
 		return -EINVAL;
 	}
 
 	if (scsi_debug_lowest_aligned > 0x3fff) {
-		printk(KERN_ERR "scsi_debug_init: lowest_aligned too big: %u\n",
+		pr_err("%s: lowest_aligned too big: %u\n", __func__,
 		       scsi_debug_lowest_aligned);
 		return -EINVAL;
 	}
@@ -3352,7 +3520,7 @@ static int __init scsi_debug_init(void)
 
 	fake_storep = vmalloc(sz);
 	if (NULL == fake_storep) {
-		printk(KERN_ERR "scsi_debug_init: out of memory, 1\n");
+		pr_err("%s: out of memory, 1\n", __func__);
 		return -ENOMEM;
 	}
 	memset(fake_storep, 0, sz);
@@ -3365,11 +3533,11 @@ static int __init scsi_debug_init(void)
 		dif_size = sdebug_store_sectors * sizeof(struct sd_dif_tuple);
 		dif_storep = vmalloc(dif_size);
 
-		printk(KERN_ERR "scsi_debug_init: dif_storep %u bytes @ %p\n",
-		       dif_size, dif_storep);
+		pr_err("%s: dif_storep %u bytes @ %p\n", __func__, dif_size,
+			dif_storep);
 
 		if (dif_storep == NULL) {
-			printk(KERN_ERR "scsi_debug_init: out of mem. (DIX)\n");
+			pr_err("%s: out of mem. (DIX)\n", __func__);
 			ret = -ENOMEM;
 			goto free_vm;
 		}
@@ -3391,8 +3559,7 @@ static int __init scsi_debug_init(void)
 		if (scsi_debug_unmap_alignment &&
 		    scsi_debug_unmap_granularity <=
 		    scsi_debug_unmap_alignment) {
-			printk(KERN_ERR
-			       "%s: ERR: unmap_granularity <= unmap_alignment\n",
+			pr_err("%s: ERR: unmap_granularity <= unmap_alignment\n",
 			       __func__);
 			return -EINVAL;
 		}
@@ -3400,11 +3567,10 @@ static int __init scsi_debug_init(void)
 		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
 		map_storep = vmalloc(BITS_TO_LONGS(map_size) * sizeof(long));
 
-		printk(KERN_INFO "scsi_debug_init: %lu provisioning blocks\n",
-		       map_size);
+		pr_info("%s: %lu provisioning blocks\n", __func__, map_size);
 
 		if (map_storep == NULL) {
-			printk(KERN_ERR "scsi_debug_init: out of mem. (MAP)\n");
+			pr_err("%s: out of mem. (MAP)\n", __func__);
 			ret = -ENOMEM;
 			goto free_vm;
 		}
@@ -3418,20 +3584,18 @@ static int __init scsi_debug_init(void)
 
 	pseudo_primary = root_device_register("pseudo_0");
 	if (IS_ERR(pseudo_primary)) {
-		printk(KERN_WARNING "scsi_debug: root_device_register() error\n");
+		pr_warn("%s: root_device_register() error\n", __func__);
 		ret = PTR_ERR(pseudo_primary);
 		goto free_vm;
 	}
 	ret = bus_register(&pseudo_lld_bus);
 	if (ret < 0) {
-		printk(KERN_WARNING "scsi_debug: bus_register error: %d\n",
-			ret);
+		pr_warn("%s: bus_register error: %d\n", __func__, ret);
 		goto dev_unreg;
 	}
 	ret = driver_register(&sdebug_driverfs_driver);
 	if (ret < 0) {
-		printk(KERN_WARNING "scsi_debug: driver_register error: %d\n",
-			ret);
+		pr_warn("%s: driver_register error: %d\n", __func__, ret);
 		goto bus_unreg;
 	}
 
@@ -3442,15 +3606,15 @@ static int __init scsi_debug_init(void)
 
         for (k = 0; k < host_to_add; k++) {
                 if (sdebug_add_adapter()) {
-                        printk(KERN_ERR "scsi_debug_init: "
-                               "sdebug_add_adapter failed k=%d\n", k);
+			pr_err("%s: sdebug_add_adapter failed k=%d\n",
+				__func__, k);
                         break;
                 }
         }
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
-		printk(KERN_INFO "scsi_debug_init: built %d host(s)\n",
-		       scsi_debug_add_host);
+		pr_info("%s: built %d host(s)\n", __func__,
+			scsi_debug_add_host);
 	}
 	return 0;
 
@@ -3473,6 +3637,7 @@ static void __exit scsi_debug_exit(void)
 	int k = scsi_debug_add_host;
 
 	stop_all_queued();
+	free_all_queued();
 	for (; k; k--)
 		sdebug_remove_adapter();
 	driver_unregister(&sdebug_driverfs_driver);
@@ -3570,8 +3735,8 @@ static void sdebug_remove_adapter(void)
         --scsi_debug_add_host;
 }
 
-static
-int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
+static int
+scsi_debug_queuecommand(struct scsi_cmnd *SCpnt)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int len, k;
@@ -3597,25 +3762,17 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 		printk("\n");
 	}
 
-	if (target == SCpnt->device->host->hostt->this_id) {
-		printk(KERN_INFO "scsi_debug: initiator's id used as "
-		       "target!\n");
-		return schedule_resp(SCpnt, NULL, done,
-				     DID_NO_CONNECT << 16, 0);
-	}
-
 	if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
 	    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
-		return schedule_resp(SCpnt, NULL, done,
-				     DID_NO_CONNECT << 16, 0);
+		return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
 	devip = devInfoReg(SCpnt->device);
 	if (NULL == devip)
-		return schedule_resp(SCpnt, NULL, done,
-				     DID_NO_CONNECT << 16, 0);
+		return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
 
 	if ((scsi_debug_every_nth != 0) &&
-	    (++scsi_debug_cmnd_count >= abs(scsi_debug_every_nth))) {
-		scsi_debug_cmnd_count = 0;
+	    (atomic_inc_return(&sdebug_cmnd_count) >=
+	     abs(scsi_debug_every_nth))) {
+		atomic_set(&sdebug_cmnd_count, 0);
 		if (scsi_debug_every_nth < -1)
 			scsi_debug_every_nth = -1;
 		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
@@ -3649,8 +3806,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_OPCODE, 0);
 			errsts = check_condition_result;
-			return schedule_resp(SCpnt, devip, done, errsts,
-					     0);
+			return schedule_resp(SCpnt, devip, errsts, 0);
 		}
 	}
 
@@ -3679,7 +3835,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 		errsts = check_readiness(SCpnt, 1, devip);
 		break;
 	case TEST_UNIT_READY:     /* mandatory */
-		delay_override = 1;
+		/* delay_override = 1; */
 		errsts = check_readiness(SCpnt, 0, devip);
 		break;
 	case RESERVE:
@@ -3923,11 +4079,114 @@ write:
 		errsts = check_condition_result;
 		break;
 	}
-	return schedule_resp(SCpnt, devip, done, errsts,
+	return schedule_resp(SCpnt, devip, errsts,
 			     (delay_override ? 0 : scsi_debug_delay));
 }
 
-static DEF_SCSI_QCMD(scsi_debug_queuecommand)
+static int
+sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	unsigned long iflags;
+	int rc;
+
+	if (scsi_debug_host_lock) {
+		spin_lock_irqsave(shost->host_lock, iflags);
+		rc = scsi_debug_queuecommand(cmd);
+		spin_unlock_irqrestore(shost->host_lock, iflags);
+		return rc;
+	} else
+		return scsi_debug_queuecommand(cmd);
+}
+
+static int
+sdebug_change_qdepth(struct scsi_device *sdev, int qdepth, int reason)
+{
+	int num_in_q = 0;
+	int bad = 0;
+	unsigned long iflags;
+	struct sdebug_dev_info *devip;
+
+	spin_lock_irqsave(&queued_arr_lock, iflags);
+	devip = (struct sdebug_dev_info *)sdev->hostdata;
+	if (NULL == devip) {
+		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		return	-ENODEV;
+	}
+	num_in_q = devip->num_in_q;
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
+		if (qdepth < 1)
+			qdepth = 1;
+		/* allow to exceed max host queued_arr elements for testing */
+		if (qdepth > SCSI_DEBUG_CANQUEUE + 10)
+			qdepth = SCSI_DEBUG_CANQUEUE + 10;
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	} else if (reason == SCSI_QDEPTH_QFULL)
+		scsi_track_queue_full(sdev, qdepth);
+	else
+		bad = 1;
+	if (bad)
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: unknown reason=0x%x\n", __func__, reason);
+	if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) {
+		if (SCSI_QDEPTH_QFULL == reason)
+			sdev_printk(KERN_INFO, sdev,
+			    "%s: -> %d, num_in_q=%d, reason: queue full\n",
+				    __func__, qdepth, num_in_q);
+		else {
+			const char *cp;
+
+			switch (reason) {
+			case SCSI_QDEPTH_DEFAULT:
+				cp = "default (sysfs ?)";
+				break;
+			case SCSI_QDEPTH_RAMP_UP:
+				cp = "ramp up";
+				break;
+			default:
+				cp = "unknown";
+				break;
+			}
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: qdepth=%d, num_in_q=%d, reason: %s\n",
+				    __func__, qdepth, num_in_q, cp);
+		}
+	}
+	return sdev->queue_depth;
+}
+
+static int
+sdebug_change_qtype(struct scsi_device *sdev, int qtype)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, qtype);
+		if (qtype)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		qtype = 0;
+	if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) {
+		const char *cp;
+
+		switch (qtype) {
+		case 0:
+			cp = "untagged";
+			break;
+		case MSG_SIMPLE_TAG:
+			cp = "simple tags";
+			break;
+		case MSG_ORDERED_TAG:
+			cp = "ordered tags";
+			break;
+		default:
+			cp = "unknown";
+			break;
+		}
+		sdev_printk(KERN_INFO, sdev, "%s: to %s\n", __func__, cp);
+	}
+	return qtype;
+}
 
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
@@ -3939,7 +4198,9 @@ static struct scsi_host_template sdebug_driver_template = {
 	.slave_configure =	scsi_debug_slave_configure,
 	.slave_destroy =	scsi_debug_slave_destroy,
 	.ioctl =		scsi_debug_ioctl,
-	.queuecommand =		scsi_debug_queuecommand,
+	.queuecommand =		sdebug_queuecommand_lock_or_not,
+	.change_queue_depth =	sdebug_change_qdepth,
+	.change_queue_type =	sdebug_change_qtype,
 	.eh_abort_handler =	scsi_debug_abort,
 	.eh_bus_reset_handler = scsi_debug_bus_reset,
 	.eh_device_reset_handler = scsi_debug_device_reset,
@@ -3948,7 +4209,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.can_queue =		SCSI_DEBUG_CANQUEUE,
 	.this_id =		7,
 	.sg_tablesize =		SCSI_MAX_SG_CHAIN_SEGMENTS,
-	.cmd_per_lun =		16,
+	.cmd_per_lun =		DEF_CMD_PER_LUN,
 	.max_sectors =		-1U,
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
@@ -4033,8 +4294,7 @@ static int sdebug_driver_probe(struct device * dev)
         } else
 		scsi_scan_host(hpnt);
 
-
-        return error;
+	return error;
 }
 
 static int sdebug_driver_remove(struct device * dev)

--------------010008090000080500070005--
