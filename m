From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2] scsi_debug: support scsi-mq, queues and locks
Date: Mon, 07 Jul 2014 09:30:44 -0400
Message-ID: <53BAA104.6090207@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020306020802050708020803"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:45366 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbaGGNa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 09:30:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 511142041CE
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2014 15:30:56 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y6-1kFR8PUs6 for <linux-scsi@vger.kernel.org>;
	Mon,  7 Jul 2014 15:30:48 +0200 (CEST)
Received: from [192.168.48.86] (unknown [199.127.109.253])
	by smtp.infotech.no (Postfix) with ESMTPA id D95C020415A
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2014 15:30:46 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020306020802050708020803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Resend, looks like the list does not like html attachments.


This v2 patch is against Christoph's core-for-3.17 branch which
includes scsi-mq V2. Here is a link to a partially updated
version of the scsi_debug html page.
   http://sg.danny.cz/scsi/sdebug26.html


Since v1 of this patch a week ago, this driver has been used
to discover an anomaly in fio and raised questions about the
mid-layer's Task Set Full handling. The addition of sub-jiffy
response delays and control over WCE allows scsi_debug to
better model SSD behaviour.

With fio and four (pseudo) devices I have observed 1.2 M IOPS
on my equipment. Rob Elliott who has done much testing and made
numerous suggestions, has better IOPS results than mine.


ChangeLog v1:
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

ChangeLog v2 (since v1):
   - add ndelay=<nanosecs> option that uses high resolution
     timers; active if > 0 and then overrides delay= option
   - expand Unit Attention handling: POR, BUS_RESET and
     MODE PARAMETERS CHANGED
   - support .eh_target_reset_handler and drop .bios_param
   - add OPT_N_WCE mask so caching page yields WCE=0
   - add OPT_RESET_NOISE mask to log aborts and resets
   - add OPT_NO_CDB_NOISE mask to not log each cdb
   - MODE SELECT support for changing caching page's WCE
   - name common ioctls in log
   - when fake_rw=1, do not vmalloc fake store; make
     UNMAP and WRITE SAME obey fake_rw
   - more logging and code improvements including better
     sense buffer handling


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Robert Elliott <elliott@hp.com>

--------------020306020802050708020803
Content-Type: text/x-patch;
 name="sdebug_cf317dg16.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug_cf317dg16.patch"

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6ed43fd..d19c0e3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -42,6 +42,10 @@
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/atomic.h>
+#include <linux/hrtimer.h>
 
 #include <net/checksum.h>
 
@@ -53,13 +57,16 @@
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
+static const char *scsi_debug_version_date = "20140706";
+
+#define MY_NAME "scsi_debug"
 
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
@@ -72,7 +79,11 @@ static const char * scsi_debug_version_date = "20100324";
 #define INVALID_COMMAND_OPCODE 0x20
 #define INVALID_FIELD_IN_CDB 0x24
 #define INVALID_FIELD_IN_PARAM_LIST 0x26
-#define POWERON_RESET 0x29
+#define UA_RESET_ASC 0x29
+#define UA_CHANGED_ASC 0x2a
+#define POWER_ON_RESET_ASCQ 0x0
+#define BUS_RESET_ASCQ 0x2	/* scsi bus reset occurred */
+#define MODE_CHANGED_ASCQ 0x1	/* mode parameters changed */
 #define SAVING_PARAMS_UNSUP 0x39
 #define TRANSPORT_PROBLEM 0x4b
 #define THRESHOLD_EXCEEDED 0x5d
@@ -81,7 +92,6 @@ static const char * scsi_debug_version_date = "20100324";
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
 
-#define SDEBUG_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 
 /* Default values for driver parameters */
 #define DEF_NUM_HOST   1
@@ -91,7 +101,7 @@ static const char * scsi_debug_version_date = "20100324";
  * (id 0) containing 1 logical unit (lun 0). That is 1 device.
  */
 #define DEF_ATO 1
-#define DEF_DELAY   1
+#define DEF_DELAY   1		/* if > 0 unit is a jiffy */
 #define DEF_DEV_SIZE_MB   8
 #define DEF_DIF 0
 #define DEF_DIX 0
@@ -99,11 +109,13 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_EVERY_NTH   0
 #define DEF_FAKE_RW	0
 #define DEF_GUARD 0
+#define DEF_HOST_LOCK 0
 #define DEF_LBPU 0
 #define DEF_LBPWS 0
 #define DEF_LBPWS10 0
 #define DEF_LBPRZ 1
 #define DEF_LOWEST_ALIGNED 0
+#define DEF_NDELAY   0		/* if > 0 unit is a nanosecond */
 #define DEF_NO_LUN_0   0
 #define DEF_NUM_PARTS   0
 #define DEF_OPTS   0
@@ -113,6 +125,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_REMOVABLE false
 #define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
 #define DEF_SECTOR_SIZE 512
+#define DEF_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 #define DEF_UNMAP_ALIGNMENT 0
 #define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
@@ -120,6 +133,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_VIRTUAL_GB   0
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
+#define DELAY_OVERRIDDEN -9999
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -130,7 +144,14 @@ static const char * scsi_debug_version_date = "20100324";
 #define SCSI_DEBUG_OPT_DIF_ERR   32
 #define SCSI_DEBUG_OPT_DIX_ERR   64
 #define SCSI_DEBUG_OPT_MAC_TIMEOUT  128
-#define SCSI_DEBUG_OPT_SHORT_TRANSFER	256
+#define SCSI_DEBUG_OPT_SHORT_TRANSFER	0x100
+#define SCSI_DEBUG_OPT_Q_NOISE	0x200
+#define SCSI_DEBUG_OPT_ALL_TSF	0x400
+#define SCSI_DEBUG_OPT_RARE_TSF	0x800
+#define SCSI_DEBUG_OPT_N_WCE	0x1000
+#define SCSI_DEBUG_OPT_RESET_NOISE 0x2000
+#define SCSI_DEBUG_OPT_NO_CDB_NOISE 0x4000
+#define SCSI_DEBUG_OPT_ALL_NOISE (0x1 | 0x200 | 0x2000)
 /* When "every_nth" > 0 then modulo "every_nth" commands:
  *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
@@ -148,6 +169,19 @@ static const char * scsi_debug_version_date = "20100324";
  * writing a new value (other than -1 or 1) to every_nth via sysfs).
  */
 
+/* As indicated in SAM-5 and SPC-4 Unit Attentions (UAs)are returned in
+ * priority order. In the subset implemented here lower numbers have higher
+ * priority. The UA numbers should be a sequence starting from 0 with
+ * SDEBUG_NUM_UAS being 1 higher than the highest numbered UA. */
+#define SDEBUG_UA_POR 0		/* Power on, reset, or bus device reset */
+#define SDEBUG_UA_BUS_RESET 1
+#define SDEBUG_UA_MODE_CHANGED 2
+#define SDEBUG_NUM_UAS 3
+
+/* for check_readiness() */
+#define UAS_ONLY 1
+#define UAS_TUR 0
+
 /* when 1==SCSI_DEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
  * sector on read commands: */
 #define OPT_MEDIUM_ERR_ADDR   0x1234 /* that's sector 4660 in decimal */
@@ -158,9 +192,19 @@ static const char * scsi_debug_version_date = "20100324";
 #define SAM2_LUN_ADDRESS_METHOD 0
 #define SAM2_WLUN_REPORT_LUNS 0xc101
 
-/* Can queue up to this number of commands. Typically commands that
- * that have a non-zero delay are queued. */
-#define SCSI_DEBUG_CANQUEUE  255
+/* SCSI_DEBUG_CANQUEUE is the maximum number of commands that can be queued
+ * (for response) at one time. Can be reduced by max_queue option. Command
+ * responses are not queued when delay=0 and ndelay=0. The per-device
+ * DEF_CMD_PER_LUN can be changed via sysfs:
+ * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth but cannot exceed
+ * SCSI_DEBUG_CANQUEUE. */
+#define SCSI_DEBUG_CANQUEUE_WORDS  9	/* a WORD is bits in a long */
+#define SCSI_DEBUG_CANQUEUE  (SCSI_DEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
+#define DEF_CMD_PER_LUN  255
+
+#if DEF_CMD_PER_LUN > SCSI_DEBUG_CANQUEUE
+#warning "Expect DEF_CMD_PER_LUN <= SCSI_DEBUG_CANQUEUE"
+#endif
 
 static int scsi_debug_add_host = DEF_NUM_HOST;
 static int scsi_debug_ato = DEF_ATO;
@@ -175,6 +219,8 @@ static unsigned int scsi_debug_guard = DEF_GUARD;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_max_luns = DEF_MAX_LUNS;
 static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
+static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
+static int scsi_debug_ndelay = DEF_NDELAY;
 static int scsi_debug_no_lun_0 = DEF_NO_LUN_0;
 static int scsi_debug_no_uld = 0;
 static int scsi_debug_num_parts = DEF_NUM_PARTS;
@@ -198,8 +244,11 @@ static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
 static bool scsi_debug_clustering;
+static bool scsi_debug_host_lock = DEF_HOST_LOCK;
 
-static int scsi_debug_cmnd_count = 0;
+static atomic_t sdebug_cmnd_count;
+static atomic_t sdebug_completions;
+static atomic_t sdebug_a_tsf;		/* counter of 'almost' TSFs */
 
 #define DEV_READONLY(TGT)      (0)
 
@@ -214,24 +263,23 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
 
 #define SDEBUG_MAX_PARTS 4
 
-#define SDEBUG_SENSE_LEN 32
-
 #define SCSI_DEBUG_MAX_CMD_LEN 32
 
 static unsigned int scsi_debug_lbp(void)
 {
-	return scsi_debug_lbpu | scsi_debug_lbpws | scsi_debug_lbpws10;
+	return ((0 == scsi_debug_fake_rw) &&
+		(scsi_debug_lbpu | scsi_debug_lbpws | scsi_debug_lbpws10));
 }
 
 struct sdebug_dev_info {
 	struct list_head dev_list;
-	unsigned char sense_buff[SDEBUG_SENSE_LEN];	/* weak nexus */
 	unsigned int channel;
 	unsigned int target;
 	u64 lun;
 	struct sdebug_host_info *sdbg_host;
 	u64 wlun;
-	char reset;
+	unsigned long uas_bm[1];
+	atomic_t num_in_q;
 	char stopped;
 	char used;
 };
@@ -249,26 +297,33 @@ struct sdebug_host_info {
 static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
-typedef void (* done_funct_t) (struct scsi_cmnd *);
+
+struct sdebug_hrtimer {		/* ... is derived from hrtimer */
+	struct hrtimer hrt;	/* must be first element */
+	int qa_indx;
+};
 
 struct sdebug_queued_cmd {
-	int in_use;
-	struct timer_list cmnd_timer;
-	done_funct_t done_funct;
+	/* in_use flagged by a bit in queued_in_use_bm[] */
+	struct timer_list *cmnd_timerp;
+	struct tasklet_struct *tletp;
+	struct sdebug_hrtimer *sd_hrtp;
 	struct scsi_cmnd * a_cmnd;
-	int scsi_result;
 };
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
+static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
+
 
 static unsigned char * fake_storep;	/* ramdisk storage */
 static struct sd_dif_tuple *dif_storep;	/* protection info */
 static void *map_storep;		/* provisioning map */
 
 static unsigned long map_size;
-static int num_aborts = 0;
-static int num_dev_resets = 0;
-static int num_bus_resets = 0;
-static int num_host_resets = 0;
+static int num_aborts;
+static int num_dev_resets;
+static int num_target_resets;
+static int num_bus_resets;
+static int num_host_resets;
 static int dix_writes;
 static int dix_reads;
 static int dif_errors;
@@ -276,7 +331,8 @@ static int dif_errors;
 static DEFINE_SPINLOCK(queued_arr_lock);
 static DEFINE_RWLOCK(atomic_rw);
 
-static char sdebug_proc_name[] = "scsi_debug";
+static char sdebug_proc_name[] = MY_NAME;
+static const char *my_name = MY_NAME;
 
 static struct bus_type pseudo_lld_bus;
 
@@ -291,6 +347,12 @@ static const int check_condition_result =
 static const int illegal_condition_result =
 	(DRIVER_SENSE << 24) | (DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 
+static const int device_qfull_result =
+	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
+
+static unsigned char caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
+				     0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,
+				     0, 0, 0, 0};
 static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 				    0, 0, 0x2, 0x4b};
 static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
@@ -332,19 +394,24 @@ static void sdebug_max_tgts_luns(void)
 	spin_unlock(&sdebug_host_list_lock);
 }
 
-static void mk_sense_buffer(struct sdebug_dev_info *devip, int key,
-			    int asc, int asq)
+static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 {
 	unsigned char *sbuff;
 
-	sbuff = devip->sense_buff;
-	memset(sbuff, 0, SDEBUG_SENSE_LEN);
+	sbuff = scp->sense_buffer;
+	if (!sbuff) {
+		sdev_printk(KERN_ERR, scp->device,
+			    "%s: sense_buffer is NULL\n", __func__);
+		return;
+	}
+	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
 
 	scsi_build_sense_buffer(scsi_debug_dsense, sbuff, key, asc, asq);
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug:    [sense_key,asc,ascq]: "
-		      "[0x%x,0x%x,0x%x]\n", key, asc, asq);
+		sdev_printk(KERN_INFO, scp->device,
+			    "%s:  [sense_key,asc,ascq]: [0x%x,0x%x,0x%x]\n",
+			    my_name, key, asc, asq);
 }
 
 static void get_data_transfer_info(unsigned char *cmd,
@@ -409,29 +476,71 @@ static void get_data_transfer_info(unsigned char *cmd,
 static int scsi_debug_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
-		printk(KERN_INFO "scsi_debug: ioctl: cmd=0x%x\n", cmd);
+		if (0x1261 == cmd)
+			sdev_printk(KERN_INFO, dev,
+				    "%s: BLKFLSBUF [0x1261]\n", __func__);
+		else if (0x5331 == cmd)
+			sdev_printk(KERN_INFO, dev,
+				    "%s: CDROM_GET_CAPABILITY [0x5331]\n",
+				    __func__);
+		else
+			sdev_printk(KERN_INFO, dev, "%s: cmd=0x%x\n",
+				    __func__, cmd);
 	}
 	return -EINVAL;
 	/* return -ENOTTY; // correct return but upsets fdisk */
 }
 
-static int check_readiness(struct scsi_cmnd * SCpnt, int reset_only,
+static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			   struct sdebug_dev_info * devip)
 {
-	if (devip->reset) {
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk(KERN_INFO "scsi_debug: Reporting Unit "
-			       "attention: power on reset\n");
-		devip->reset = 0;
-		mk_sense_buffer(devip, UNIT_ATTENTION, POWERON_RESET, 0);
+	int k;
+	bool debug = !!(SCSI_DEBUG_OPT_NOISE & scsi_debug_opts);
+
+	k = find_first_bit(devip->uas_bm, SDEBUG_NUM_UAS);
+	if (k != SDEBUG_NUM_UAS) {
+		const char *cp = NULL;
+
+		switch (k) {
+		case SDEBUG_UA_POR:
+			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+					UA_RESET_ASC, POWER_ON_RESET_ASCQ);
+			if (debug)
+				cp = "power on reset";
+			break;
+		case SDEBUG_UA_BUS_RESET:
+			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+					UA_RESET_ASC, BUS_RESET_ASCQ);
+			if (debug)
+				cp = "bus reset";
+			break;
+		case SDEBUG_UA_MODE_CHANGED:
+			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+					UA_CHANGED_ASC, MODE_CHANGED_ASCQ);
+			if (debug)
+				cp = "mode parameters changed";
+			break;
+		default:
+			pr_warn("%s: unexpected unit attention code=%d\n",
+				__func__, k);
+			if (debug)
+				cp = "unknown";
+			break;
+		}
+		clear_bit(k, devip->uas_bm);
+		if (debug)
+			sdev_printk(KERN_INFO, SCpnt->device,
+				   "%s reports: Unit attention: %s\n",
+				   my_name, cp);
 		return check_condition_result;
 	}
-	if ((0 == reset_only) && devip->stopped) {
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk(KERN_INFO "scsi_debug: Reporting Not "
-			       "ready: initializing command required\n");
-		mk_sense_buffer(devip, NOT_READY, LOGICAL_UNIT_NOT_READY,
+	if ((UAS_TUR == uas_only) && devip->stopped) {
+		mk_sense_buffer(SCpnt, NOT_READY, LOGICAL_UNIT_NOT_READY,
 				0x2);
+		if (debug)
+			sdev_printk(KERN_INFO, SCpnt->device,
+				    "%s reports: Not ready: %s\n", my_name,
+				    "initializing command required");
 		return check_condition_result;
 	}
 	return 0;
@@ -471,8 +580,9 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 
 static const char * inq_vendor_id = "Linux   ";
 static const char * inq_product_id = "scsi_debug      ";
-static const char * inq_product_rev = "0004";
+static const char *inq_product_rev = "0184";	/* version less '.' */
 
+/* Device identification VPD page. Returns number of bytes placed in arr */
 static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
 			   int target_dev_id, int dev_id_num,
 			   const char * dev_id_str,
@@ -573,12 +683,14 @@ static unsigned char vpd84_data[] = {
     0x22,0x22,0x22,0x0,0xbb,0x2,
 };
 
+/*  Software interface identification VPD page */
 static int inquiry_evpd_84(unsigned char * arr)
 {
 	memcpy(arr, vpd84_data, sizeof(vpd84_data));
 	return sizeof(vpd84_data);
 }
 
+/* Management network addresses VPD page */
 static int inquiry_evpd_85(unsigned char * arr)
 {
 	int num = 0;
@@ -713,6 +825,7 @@ static unsigned char vpd89_data[] = {
 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0xa5,0x51,
 };
 
+/* ATA Information VPD page */
 static int inquiry_evpd_89(unsigned char * arr)
 {
 	memcpy(arr, vpd89_data, sizeof(vpd89_data));
@@ -720,7 +833,6 @@ static int inquiry_evpd_89(unsigned char * arr)
 }
 
 
-/* Block limits VPD page (SBC-3) */
 static unsigned char vpdb0_data[] = {
 	/* from 4th byte */ 0,0,0,4, 0,0,0x4,0, 0,0,0,64,
 	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
@@ -728,6 +840,7 @@ static unsigned char vpdb0_data[] = {
 	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
 };
 
+/* Block limits VPD page (SBC-3) */
 static int inquiry_evpd_b0(unsigned char * arr)
 {
 	unsigned int gran;
@@ -811,7 +924,7 @@ static int inquiry_evpd_b2(unsigned char *arr)
 #define SDEBUG_LONG_INQ_SZ 96
 #define SDEBUG_MAX_INQ_ARR_SZ 584
 
-static int resp_inquiry(struct scsi_cmnd * scp, int target,
+static int resp_inquiry(struct scsi_cmnd *scp, int target,
 			struct sdebug_dev_info * devip)
 {
 	unsigned char pq_pdt;
@@ -831,7 +944,7 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 		pq_pdt = (scsi_debug_ptype & 0x1f);
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
 			       	0);
 		kfree(arr);
 		return check_condition_result;
@@ -917,7 +1030,7 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 			arr[3] = inquiry_evpd_b2(&arr[4]);
 		} else {
 			/* Illegal request, invalid field in cdb */
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
 			kfree(arr);
 			return check_condition_result;
@@ -963,15 +1076,13 @@ static int resp_requests(struct scsi_cmnd * scp,
 {
 	unsigned char * sbuff;
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
-	unsigned char arr[SDEBUG_SENSE_LEN];
+	unsigned char arr[SCSI_SENSE_BUFFERSIZE];
 	int want_dsense;
 	int len = 18;
 
 	memset(arr, 0, sizeof(arr));
-	if (devip->reset == 1)
-		mk_sense_buffer(devip, 0, NO_ADDITIONAL_SENSE, 0);
 	want_dsense = !!(cmd[1] & 1) || scsi_debug_dsense;
-	sbuff = devip->sense_buff;
+	sbuff = scp->sense_buffer;
 	if ((iec_m_pg[2] & 0x4) && (6 == (iec_m_pg[3] & 0xf))) {
 		if (want_dsense) {
 			arr[0] = 0x72;
@@ -986,7 +1097,7 @@ static int resp_requests(struct scsi_cmnd * scp,
 			arr[13] = 0xff;		/* TEST set and MRIE==6 */
 		}
 	} else {
-		memcpy(arr, sbuff, SDEBUG_SENSE_LEN);
+		memcpy(arr, sbuff, SCSI_SENSE_BUFFERSIZE);
 		if ((cmd[1] & 1) && (! scsi_debug_dsense)) {
 			/* DESC bit set and sense_buff in fixed format */
 			memset(arr, 0, sizeof(arr));
@@ -997,7 +1108,7 @@ static int resp_requests(struct scsi_cmnd * scp,
 			len = 8;
 		}
 	}
-	mk_sense_buffer(devip, 0, NO_ADDITIONAL_SENSE, 0);
+	mk_sense_buffer(scp, 0, NO_ADDITIONAL_SENSE, 0);
 	return fill_from_dev_buffer(scp, arr, len);
 }
 
@@ -1007,11 +1118,12 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 	int power_cond, errsts, start;
 
-	if ((errsts = check_readiness(scp, 1, devip)))
+	errsts = check_readiness(scp, UAS_ONLY, devip);
+	if (errsts)
 		return errsts;
 	power_cond = (cmd[4] & 0xf0) >> 4;
 	if (power_cond) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
 			       	0);
 		return check_condition_result;
 	}
@@ -1038,7 +1150,8 @@ static int resp_readcap(struct scsi_cmnd * scp,
 	unsigned int capac;
 	int errsts;
 
-	if ((errsts = check_readiness(scp, 1, devip)))
+	errsts = check_readiness(scp, UAS_ONLY, devip);
+	if (errsts)
 		return errsts;
 	/* following just in case virtual_gb changed */
 	sdebug_capacity = get_sdebug_capacity();
@@ -1069,7 +1182,8 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	unsigned long long capac;
 	int errsts, k, alloc_len;
 
-	if ((errsts = check_readiness(scp, 1, devip)))
+	errsts = check_readiness(scp, UAS_ONLY, devip);
+	if (errsts)
 		return errsts;
 	alloc_len = ((cmd[10] << 24) + (cmd[11] << 16) + (cmd[12] << 8)
 		     + cmd[13]);
@@ -1230,12 +1344,18 @@ static int resp_format_pg(unsigned char * p, int pcontrol, int target)
 
 static int resp_caching_pg(unsigned char * p, int pcontrol, int target)
 { 	/* Caching page for mode_sense */
-	unsigned char caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
+	unsigned char ch_caching_pg[] = {/* 0x8, 18, */ 0x4, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+	unsigned char d_caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
 		0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,     0, 0, 0, 0};
 
+	if (SCSI_DEBUG_OPT_N_WCE & scsi_debug_opts)
+		caching_pg[2] &= ~0x4;	/* set WCE=0 (default WCE=1) */
 	memcpy(p, caching_pg, sizeof(caching_pg));
 	if (1 == pcontrol)
-		memset(p + 2, 0, sizeof(caching_pg) - 2);
+		memcpy(p + 2, ch_caching_pg, sizeof(ch_caching_pg));
+	else if (2 == pcontrol)
+		memcpy(p, d_caching_pg, sizeof(d_caching_pg));
 	return sizeof(caching_pg);
 }
 
@@ -1350,7 +1470,8 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 
-	if ((errsts = check_readiness(scp, 1, devip)))
+	errsts = check_readiness(scp, UAS_ONLY, devip);
+	if (errsts)
 		return errsts;
 	dbd = !!(cmd[1] & 0x8);
 	pcontrol = (cmd[2] & 0xc0) >> 6;
@@ -1365,8 +1486,7 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 	alloc_len = msense_6 ? cmd[4] : ((cmd[7] << 8) | cmd[8]);
 	memset(arr, 0, SDEBUG_MAX_MSENSE_SZ);
 	if (0x3 == pcontrol) {  /* Saving values not supported */
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, SAVING_PARAMS_UNSUP,
-			       	0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, SAVING_PARAMS_UNSUP, 0);
 		return check_condition_result;
 	}
 	target_dev_id = ((devip->sdbg_host->shost->host_no + 1) * 2000) +
@@ -1422,7 +1542,7 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 
 	if ((subpcode > 0x0) && (subpcode < 0xff) && (0x19 != pcode)) {
 		/* TODO: Control Extension page */
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
 			       	0);
 		return check_condition_result;
 	}
@@ -1449,7 +1569,7 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 		break;
 	case 0x19:	/* if spc==1 then sas phy, control+discover */
 		if ((subpcode > 0x2) && (subpcode < 0xff)) {
-		        mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
 			return check_condition_result;
 	        }
@@ -1482,14 +1602,14 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 			}
 			len += resp_iec_m_pg(ap + len, pcontrol, target);
 		} else {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
 			return check_condition_result;
                 }
 		offset += len;
 		break;
 	default:
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
 			       	0);
 		return check_condition_result;
 	}
@@ -1512,14 +1632,15 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
 	unsigned char arr[SDEBUG_MAX_MSELECT_SZ];
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 
-	if ((errsts = check_readiness(scp, 1, devip)))
+	errsts = check_readiness(scp, UAS_ONLY, devip);
+	if (errsts)
 		return errsts;
 	memset(arr, 0, sizeof(arr));
 	pf = cmd[1] & 0x10;
 	sp = cmd[1] & 0x1;
 	param_len = mselect6 ? cmd[4] : ((cmd[7] << 8) + cmd[8]);
 	if ((0 == pf) || sp || (param_len > SDEBUG_MAX_MSELECT_SZ)) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
@@ -1528,12 +1649,13 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
                 return (DID_ERROR << 16);
         else if ((res < param_len) &&
                  (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
-                printk(KERN_INFO "scsi_debug: mode_select: cdb indicated=%d, "
-                       " IO sent=%d bytes\n", param_len, res);
+		sdev_printk(KERN_INFO, scp->device,
+			    "%s: cdb indicated=%d, IO sent=%d bytes\n",
+			    __func__, param_len, res);
 	md_len = mselect6 ? (arr[0] + 1) : ((arr[0] << 8) + arr[1] + 2);
 	bd_len = mselect6 ? arr[3] : ((arr[6] << 8) + arr[7]);
 	if (md_len > 2) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_PARAM_LIST, 0);
 		return check_condition_result;
 	}
@@ -1541,7 +1663,7 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
 	mpage = arr[off] & 0x3f;
 	ps = !!(arr[off] & 0x80);
 	if (ps) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_PARAM_LIST, 0);
 		return check_condition_result;
 	}
@@ -1549,32 +1671,42 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
 	pg_len = spf ? ((arr[off + 2] << 8) + arr[off + 3] + 4) :
 		       (arr[off + 1] + 2);
 	if ((pg_len + off) > param_len) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
 				PARAMETER_LIST_LENGTH_ERR, 0);
 		return check_condition_result;
 	}
 	switch (mpage) {
+	case 0x8:      /* Caching Mode page */
+		if (caching_pg[1] == arr[off + 1]) {
+			memcpy(caching_pg + 2, arr + off + 2,
+			       sizeof(caching_pg) - 2);
+			goto set_mode_changed_ua;
+		}
+		break;
 	case 0xa:      /* Control Mode page */
 		if (ctrl_m_pg[1] == arr[off + 1]) {
 			memcpy(ctrl_m_pg + 2, arr + off + 2,
 			       sizeof(ctrl_m_pg) - 2);
 			scsi_debug_dsense = !!(ctrl_m_pg[2] & 0x4);
-			return 0;
+			goto set_mode_changed_ua;
 		}
 		break;
 	case 0x1c:      /* Informational Exceptions Mode page */
 		if (iec_m_pg[1] == arr[off + 1]) {
 			memcpy(iec_m_pg + 2, arr + off + 2,
 			       sizeof(iec_m_pg) - 2);
-			return 0;
+			goto set_mode_changed_ua;
 		}
 		break;
 	default:
 		break;
 	}
-	mk_sense_buffer(devip, ILLEGAL_REQUEST,
+	mk_sense_buffer(scp, ILLEGAL_REQUEST,
 			INVALID_FIELD_IN_PARAM_LIST, 0);
 	return check_condition_result;
+set_mode_changed_ua:
+	set_bit(SDEBUG_UA_MODE_CHANGED, devip->uas_bm);
+	return 0;
 }
 
 static int resp_temp_l_pg(unsigned char * arr)
@@ -1609,13 +1741,14 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 
-	if ((errsts = check_readiness(scp, 1, devip)))
+	errsts = check_readiness(scp, UAS_ONLY, devip);
+	if (errsts)
 		return errsts;
 	memset(arr, 0, sizeof(arr));
 	ppc = cmd[1] & 0x2;
 	sp = cmd[1] & 0x1;
 	if (ppc || sp) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
@@ -1640,7 +1773,7 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 			arr[3] = resp_ie_l_pg(arr + 4);
 			break;
 		default:
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
 			return check_condition_result;
 		}
@@ -1673,12 +1806,12 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 			arr[3] = n - 4;
 			break;
 		default:
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
 			return check_condition_result;
 		}
 	} else {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
@@ -1687,16 +1820,16 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 		    min(len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
-static int check_device_access_params(struct sdebug_dev_info *devi,
+static int check_device_access_params(struct scsi_cmnd *scp,
 				      unsigned long long lba, unsigned int num)
 {
 	if (lba + num > sdebug_capacity) {
-		mk_sense_buffer(devi, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE, 0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
 	/* transfer length excessive (tie in to block limits VPD page) */
 	if (num > sdebug_store_sectors) {
-		mk_sense_buffer(devi, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
 	return 0;
@@ -1704,7 +1837,6 @@ static int check_device_access_params(struct sdebug_dev_info *devi,
 
 /* Returns number of bytes copied or -1 if error. */
 static int do_device_access(struct scsi_cmnd *scmd,
-			    struct sdebug_dev_info *devi,
 			    unsigned long long lba, unsigned int num, int write)
 {
 	int ret;
@@ -1861,13 +1993,12 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 }
 
 static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
-		     unsigned int num, struct sdebug_dev_info *devip,
-		     u32 ei_lba)
+		     unsigned int num, u32 ei_lba)
 {
 	unsigned long iflags;
 	int ret;
 
-	ret = check_device_access_params(devip, lba, num);
+	ret = check_device_access_params(SCpnt, lba, num);
 	if (ret)
 		return ret;
 
@@ -1875,16 +2006,16 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 	    (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
 	    ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
 		/* claim unrecoverable read error */
-		mk_sense_buffer(devip, MEDIUM_ERROR, UNRECOVERED_READ_ERR, 0);
+		mk_sense_buffer(SCpnt, MEDIUM_ERROR, UNRECOVERED_READ_ERR, 0);
 		/* set info field and valid bit for fixed descriptor */
-		if (0x70 == (devip->sense_buff[0] & 0x7f)) {
-			devip->sense_buff[0] |= 0x80;	/* Valid bit */
+		if (0x70 == (SCpnt->sense_buffer[0] & 0x7f)) {
+			SCpnt->sense_buffer[0] |= 0x80;	/* Valid bit */
 			ret = (lba < OPT_MEDIUM_ERR_ADDR)
 			      ? OPT_MEDIUM_ERR_ADDR : (int)lba;
-			devip->sense_buff[3] = (ret >> 24) & 0xff;
-			devip->sense_buff[4] = (ret >> 16) & 0xff;
-			devip->sense_buff[5] = (ret >> 8) & 0xff;
-			devip->sense_buff[6] = ret & 0xff;
+			SCpnt->sense_buffer[3] = (ret >> 24) & 0xff;
+			SCpnt->sense_buffer[4] = (ret >> 16) & 0xff;
+			SCpnt->sense_buffer[5] = (ret >> 8) & 0xff;
+			SCpnt->sense_buffer[6] = ret & 0xff;
 		}
 	        scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 		return check_condition_result;
@@ -1898,12 +2029,12 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 
 		if (prot_ret) {
 			read_unlock_irqrestore(&atomic_rw, iflags);
-			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, prot_ret);
+			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	ret = do_device_access(SCpnt, devip, lba, num, 0);
+	ret = do_device_access(SCpnt, lba, num, 0);
 	read_unlock_irqrestore(&atomic_rw, iflags);
 	if (ret == -1)
 		return DID_ERROR << 16;
@@ -1915,22 +2046,23 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 
 void dump_sector(unsigned char *buf, int len)
 {
-	int i, j;
-
-	printk(KERN_ERR ">>> Sector Dump <<<\n");
+	int i, j, n;
 
+	pr_err(">>> Sector Dump <<<\n");
 	for (i = 0 ; i < len ; i += 16) {
-		printk(KERN_ERR "%04d: ", i);
+		char b[128];
 
-		for (j = 0 ; j < 16 ; j++) {
+		for (j = 0, n = 0; j < 16; j++) {
 			unsigned char c = buf[i+j];
+
 			if (c >= 0x20 && c < 0x7e)
-				printk(" %c ", buf[i+j]);
+				n += scnprintf(b + n, sizeof(b) - n,
+					       " %c ", buf[i+j]);
 			else
-				printk("%02x ", buf[i+j]);
+				n += scnprintf(b + n, sizeof(b) - n,
+					       "%02x ", buf[i+j]);
 		}
-
-		printk("\n");
+		pr_err("%04d: %s\n", i, b);
 	}
 }
 
@@ -2092,13 +2224,12 @@ static void unmap_region(sector_t lba, unsigned int len)
 }
 
 static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
-		      unsigned int num, struct sdebug_dev_info *devip,
-		      u32 ei_lba)
+		      unsigned int num, u32 ei_lba)
 {
 	unsigned long iflags;
 	int ret;
 
-	ret = check_device_access_params(devip, lba, num);
+	ret = check_device_access_params(SCpnt, lba, num);
 	if (ret)
 		return ret;
 
@@ -2110,12 +2241,13 @@ static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
 
 		if (prot_ret) {
 			write_unlock_irqrestore(&atomic_rw, iflags);
-			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, prot_ret);
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10,
+					prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	ret = do_device_access(SCpnt, devip, lba, num, 1);
+	ret = do_device_access(SCpnt, lba, num, 1);
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 	write_unlock_irqrestore(&atomic_rw, iflags);
@@ -2123,26 +2255,26 @@ static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
 		return (DID_ERROR << 16);
 	else if ((ret < (num * scsi_debug_sector_size)) &&
 		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
-		printk(KERN_INFO "scsi_debug: write: cdb indicated=%u, "
-		       " IO sent=%d bytes\n", num * scsi_debug_sector_size, ret);
+		sdev_printk(KERN_INFO, SCpnt->device,
+			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
+			    my_name, num * scsi_debug_sector_size, ret);
 
 	return 0;
 }
 
 static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
-		      unsigned int num, struct sdebug_dev_info *devip,
-			   u32 ei_lba, unsigned int unmap)
+		      unsigned int num, u32 ei_lba, unsigned int unmap)
 {
 	unsigned long iflags;
 	unsigned long long i;
 	int ret;
 
-	ret = check_device_access_params(devip, lba, num);
+	ret = check_device_access_params(scmd, lba, num);
 	if (ret)
 		return ret;
 
 	if (num > scsi_debug_write_same_length) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+		mk_sense_buffer(scmd, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
 				0);
 		return check_condition_result;
 	}
@@ -2164,8 +2296,10 @@ static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
 		return (DID_ERROR << 16);
 	} else if ((ret < (num * scsi_debug_sector_size)) &&
 		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
-		printk(KERN_INFO "scsi_debug: write same: cdb indicated=%u, "
-		       " IO sent=%d bytes\n", num * scsi_debug_sector_size, ret);
+		sdev_printk(KERN_INFO, scmd->device,
+			    "%s: %s: cdb indicated=%u, IO sent=%d bytes\n",
+			    my_name, "write same",
+			    num * scsi_debug_sector_size, ret);
 
 	/* Copy first sector to remaining blocks */
 	for (i = 1 ; i < num ; i++)
@@ -2195,7 +2329,7 @@ static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
 	int ret;
 	unsigned long iflags;
 
-	ret = check_readiness(scmd, 1, devip);
+	ret = check_readiness(scmd, UAS_ONLY, devip);
 	if (ret)
 		return ret;
 
@@ -2221,7 +2355,7 @@ static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
 		unsigned int num = get_unaligned_be32(&desc[i].blocks);
 
-		ret = check_device_access_params(devip, lba, num);
+		ret = check_device_access_params(scmd, lba, num);
 		if (ret)
 			goto out;
 
@@ -2247,7 +2381,7 @@ static int resp_get_lba_status(struct scsi_cmnd * scmd,
 	unsigned char arr[SDEBUG_GET_LBA_STATUS_LEN];
 	int ret;
 
-	ret = check_readiness(scmd, 1, devip);
+	ret = check_readiness(scmd, UAS_ONLY, devip);
 	if (ret)
 		return ret;
 
@@ -2257,7 +2391,7 @@ static int resp_get_lba_status(struct scsi_cmnd * scmd,
 	if (alloc_len < 24)
 		return 0;
 
-	ret = check_device_access_params(devip, lba, 1);
+	ret = check_device_access_params(scmd, lba, 1);
 	if (ret)
 		return ret;
 
@@ -2288,7 +2422,7 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 
 	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
 	if ((alloc_len < 4) || (select_report > 2)) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
 			       	0);
 		return check_condition_result;
 	}
@@ -2342,7 +2476,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	/* better not to use temporary buffer. */
 	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
 	if (!buf) {
-		mk_sense_buffer(devip, NOT_READY,
+		mk_sense_buffer(scp, NOT_READY,
 				LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 		return check_condition_result;
 	}
@@ -2366,34 +2500,125 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	return 0;
 }
 
-/* When timer goes off this function is called. */
-static void timer_intr_handler(unsigned long indx)
+/* When timer or tasklet goes off this function is called. */
+static void sdebug_q_cmd_complete(unsigned long indx)
 {
-	struct sdebug_queued_cmd * sqcp;
+	int qa_indx;
+	int retiring = 0;
 	unsigned long iflags;
+	struct sdebug_queued_cmd *sqcp;
+	struct scsi_cmnd *scp;
+	struct sdebug_dev_info *devip;
 
-	if (indx >= scsi_debug_max_queue) {
-		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "
-		       "large\n");
+	atomic_inc(&sdebug_completions);
+	qa_indx = indx;
+	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
+		pr_err("%s: wild qa_indx=%d\n", __func__, qa_indx);
 		return;
 	}
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	sqcp = &queued_arr[(int)indx];
-	if (! sqcp->in_use) {
-		printk(KERN_ERR "scsi_debug:timer_intr_handler: Unexpected "
-		       "interrupt\n");
+	sqcp = &queued_arr[qa_indx];
+	scp = sqcp->a_cmnd;
+	if (NULL == scp) {
+		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		pr_err("%s: scp is NULL\n", __func__);
+		return;
+	}
+	devip = (struct sdebug_dev_info *)scp->device->hostdata;
+	if (devip)
+		atomic_dec(&devip->num_in_q);
+	else
+		pr_err("%s: devip=NULL\n", __func__);
+	if (atomic_read(&retired_max_queue) > 0)
+		retiring = 1;
+
+	sqcp->a_cmnd = NULL;
+	if (!test_and_clear_bit(qa_indx, queued_in_use_bm)) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		pr_err("%s: Unexpected completion\n", __func__);
 		return;
 	}
-	sqcp->in_use = 0;
-	if (sqcp->done_funct) {
-		sqcp->a_cmnd->result = sqcp->scsi_result;
-		sqcp->done_funct(sqcp->a_cmnd); /* callback to mid level */
+
+	if (unlikely(retiring)) {	/* user has reduced max_queue */
+		int k, retval;
+
+		retval = atomic_read(&retired_max_queue);
+		if (qa_indx >= retval) {
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			pr_err("%s: index %d too large\n", __func__, retval);
+			return;
+		}
+		k = find_last_bit(queued_in_use_bm, retval);
+		if ((k < scsi_debug_max_queue) || (k == retval))
+			atomic_set(&retired_max_queue, 0);
+		else
+			atomic_set(&retired_max_queue, k + 1);
 	}
-	sqcp->done_funct = NULL;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	scp->scsi_done(scp); /* callback to mid level */
 }
 
+/* When high resolution timer goes off this function is called. */
+static enum hrtimer_restart
+sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
+{
+	int qa_indx;
+	int retiring = 0;
+	unsigned long iflags;
+	struct sdebug_hrtimer *sd_hrtp = (struct sdebug_hrtimer *)timer;
+	struct sdebug_queued_cmd *sqcp;
+	struct scsi_cmnd *scp;
+	struct sdebug_dev_info *devip;
+
+	atomic_inc(&sdebug_completions);
+	qa_indx = sd_hrtp->qa_indx;
+	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
+		pr_err("%s: wild qa_indx=%d\n", __func__, qa_indx);
+		goto the_end;
+	}
+	spin_lock_irqsave(&queued_arr_lock, iflags);
+	sqcp = &queued_arr[qa_indx];
+	scp = sqcp->a_cmnd;
+	if (NULL == scp) {
+		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		pr_err("%s: scp is NULL\n", __func__);
+		goto the_end;
+	}
+	devip = (struct sdebug_dev_info *)scp->device->hostdata;
+	if (devip)
+		atomic_dec(&devip->num_in_q);
+	else
+		pr_err("%s: devip=NULL\n", __func__);
+	if (atomic_read(&retired_max_queue) > 0)
+		retiring = 1;
+
+	sqcp->a_cmnd = NULL;
+	if (!test_and_clear_bit(qa_indx, queued_in_use_bm)) {
+		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		pr_err("%s: Unexpected completion\n", __func__);
+		goto the_end;
+	}
+
+	if (unlikely(retiring)) {	/* user has reduced max_queue */
+		int k, retval;
+
+		retval = atomic_read(&retired_max_queue);
+		if (qa_indx >= retval) {
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			pr_err("%s: index %d too large\n", __func__, retval);
+			goto the_end;
+		}
+		k = find_last_bit(queued_in_use_bm, retval);
+		if ((k < scsi_debug_max_queue) || (k == retval))
+			atomic_set(&retired_max_queue, 0);
+		else
+			atomic_set(&retired_max_queue, k + 1);
+	}
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	scp->scsi_done(scp); /* callback to mid level */
+the_end:
+	return HRTIMER_NORESTART;
+}
 
 static struct sdebug_dev_info *
 sdebug_device_create(struct sdebug_host_info *sdbg_host, gfp_t flags)
@@ -2419,7 +2644,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 		return devip;
 	sdbg_host = *(struct sdebug_host_info **)shost_priv(sdev->host);
 	if (!sdbg_host) {
-                printk(KERN_ERR "Host info NULL\n");
+		pr_err("%s: Host info NULL\n", __func__);
 		return NULL;
         }
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
@@ -2445,15 +2670,9 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 	open_devip->target = sdev->id;
 	open_devip->lun = sdev->lun;
 	open_devip->sdbg_host = sdbg_host;
-	open_devip->reset = 1;
+	atomic_set(&open_devip->num_in_q, 0);
+	set_bit(SDEBUG_UA_POR, open_devip->uas_bm);
 	open_devip->used = 1;
-	memset(open_devip->sense_buff, 0, SDEBUG_SENSE_LEN);
-	if (scsi_debug_dsense)
-		open_devip->sense_buff[0] = 0x72;
-	else {
-		open_devip->sense_buff[0] = 0x70;
-		open_devip->sense_buff[7] = 0xa;
-	}
 	if (sdev->lun == SAM2_WLUN_REPORT_LUNS)
 		open_devip->wlun = SAM2_WLUN_REPORT_LUNS & 0xff;
 
@@ -2482,9 +2701,10 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
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
@@ -2506,150 +2726,230 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 	}
 }
 
-/* Returns 1 if found 'cmnd' and deleted its timer. else returns 0 */
+/* Returns 1 if cmnd found (deletes its timer or tasklet), else returns 0 */
 static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 {
 	unsigned long iflags;
-	int k;
+	int k, qmax, r_qmax;
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
+	r_qmax = atomic_read(&retired_max_queue);
+	if (r_qmax > qmax)
+		qmax = r_qmax;
+	for (k = 0; k < qmax; ++k) {
+		if (test_bit(k, queued_in_use_bm)) {
+			sqcp = &queued_arr[k];
+			if (cmnd == sqcp->a_cmnd) {
+				if (scsi_debug_ndelay > 0) {
+					if (sqcp->sd_hrtp)
+						hrtimer_cancel(
+							&sqcp->sd_hrtp->hrt);
+				} else if (scsi_debug_delay > 0) {
+					if (sqcp->cmnd_timerp)
+						del_timer_sync(
+							sqcp->cmnd_timerp);
+				} else if (scsi_debug_delay < 0) {
+					if (sqcp->tletp)
+						tasklet_kill(sqcp->tletp);
+				}
+				__clear_bit(k, queued_in_use_bm);
+				devip = (struct sdebug_dev_info *)
+					cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+				break;
+			}
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	return (k < scsi_debug_max_queue) ? 1 : 0;
+	return (k < qmax) ? 1 : 0;
 }
 
-/* Deletes (stops) timers of all queued commands */
+/* Deletes (stops) timers or tasklets of all queued commands */
 static void stop_all_queued(void)
 {
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
+				if (scsi_debug_ndelay > 0) {
+					if (sqcp->sd_hrtp)
+						hrtimer_cancel(
+							&sqcp->sd_hrtp->hrt);
+				} else if (scsi_debug_delay > 0) {
+					if (sqcp->cmnd_timerp)
+						del_timer_sync(
+							sqcp->cmnd_timerp);
+				} else if (scsi_debug_delay < 0) {
+					if (sqcp->tletp)
+						tasklet_kill(sqcp->tletp);
+				}
+				__clear_bit(k, queued_in_use_bm);
+				devip = (struct sdebug_dev_info *)
+					sqcp->a_cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+			}
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
-static int scsi_debug_abort(struct scsi_cmnd * SCpnt)
+/* Free queued command memory on heap */
+static void free_all_queued(void)
 {
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: abort\n");
-	++num_aborts;
-	stop_queued_cmnd(SCpnt);
-	return SUCCESS;
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
+		kfree(sqcp->sd_hrtp);
+		sqcp->sd_hrtp = NULL;
+	}
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
-static int scsi_debug_biosparam(struct scsi_device *sdev,
-		struct block_device * bdev, sector_t capacity, int *info)
+static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 {
-	int res;
-	unsigned char *buf;
-
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: biosparam\n");
-	buf = scsi_bios_ptable(bdev);
-	if (buf) {
-		res = scsi_partsize(buf, capacity,
-				    &info[2], &info[0], &info[1]);
-		kfree(buf);
-		if (! res)
-			return res;
-	}
-	info[0] = sdebug_heads;
-	info[1] = sdebug_sectors_per;
-	info[2] = sdebug_cylinders_per;
-	return 0;
+	++num_aborts;
+	if (SCpnt) {
+		if (SCpnt->device &&
+		    (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts))
+			sdev_printk(KERN_INFO, SCpnt->device, "%s\n",
+				    __func__);
+		stop_queued_cmnd(SCpnt);
+	}
+	return SUCCESS;
 }
 
 static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
 {
 	struct sdebug_dev_info * devip;
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: device_reset\n");
 	++num_dev_resets;
-	if (SCpnt) {
-		devip = devInfoReg(SCpnt->device);
+	if (SCpnt && SCpnt->device) {
+		struct scsi_device *sdp = SCpnt->device;
+
+		if (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts)
+			sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
+		devip = devInfoReg(sdp);
 		if (devip)
-			devip->reset = 1;
+			set_bit(SDEBUG_UA_POR, devip->uas_bm);
+	}
+	return SUCCESS;
+}
+
+static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
+{
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
+	struct scsi_device *sdp;
+	struct Scsi_Host *hp;
+	int k = 0;
+
+	++num_target_resets;
+	if (!SCpnt)
+		goto lie;
+	sdp = SCpnt->device;
+	if (!sdp)
+		goto lie;
+	if (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts)
+		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
+	hp = sdp->host;
+	if (!hp)
+		goto lie;
+	sdbg_host = *(struct sdebug_host_info **)shost_priv(hp);
+	if (sdbg_host) {
+		list_for_each_entry(devip,
+				    &sdbg_host->dev_info_list,
+				    dev_list)
+			if (devip->target == sdp->id) {
+				set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+				++k;
+			}
 	}
+	if (SCSI_DEBUG_OPT_RESET_NOISE & scsi_debug_opts)
+		sdev_printk(KERN_INFO, sdp,
+			    "%s: %d device(s) found in target\n", __func__, k);
+lie:
 	return SUCCESS;
 }
 
 static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	struct sdebug_host_info *sdbg_host;
-        struct sdebug_dev_info * dev_info;
+	struct sdebug_dev_info *devip;
         struct scsi_device * sdp;
         struct Scsi_Host * hp;
+	int k = 0;
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: bus_reset\n");
 	++num_bus_resets;
-	if (SCpnt && ((sdp = SCpnt->device)) && ((hp = sdp->host))) {
+	if (!(SCpnt && SCpnt->device))
+		goto lie;
+	sdp = SCpnt->device;
+	if (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts)
+		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
+	hp = sdp->host;
+	if (hp) {
 		sdbg_host = *(struct sdebug_host_info **)shost_priv(hp);
 		if (sdbg_host) {
-			list_for_each_entry(dev_info,
+			list_for_each_entry(devip,
                                             &sdbg_host->dev_info_list,
-                                            dev_list)
-				dev_info->reset = 1;
+					    dev_list) {
+				set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+				++k;
+			}
 		}
 	}
+	if (SCSI_DEBUG_OPT_RESET_NOISE & scsi_debug_opts)
+		sdev_printk(KERN_INFO, sdp,
+			    "%s: %d device(s) found in host\n", __func__, k);
+lie:
 	return SUCCESS;
 }
 
 static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
 {
 	struct sdebug_host_info * sdbg_host;
-        struct sdebug_dev_info * dev_info;
+	struct sdebug_dev_info *devip;
+	int k = 0;
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: host_reset\n");
 	++num_host_resets;
+	if ((SCpnt->device) && (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts))
+		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
         spin_lock(&sdebug_host_list_lock);
         list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
-                list_for_each_entry(dev_info, &sdbg_host->dev_info_list,
-                                    dev_list)
-                        dev_info->reset = 1;
+		list_for_each_entry(devip, &sdbg_host->dev_info_list,
+				    dev_list) {
+			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			++k;
+		}
         }
         spin_unlock(&sdebug_host_list_lock);
 	stop_all_queued();
+	if (SCSI_DEBUG_OPT_RESET_NOISE & scsi_debug_opts)
+		sdev_printk(KERN_INFO, SCpnt->device,
+			    "%s: %d device(s) found\n", __func__, k);
 	return SUCCESS;
 }
 
-/* Initializes timers in queued array */
-static void __init init_all_queued(void)
-{
-	unsigned long iflags;
-	int k;
-	struct sdebug_queued_cmd * sqcp;
-
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < scsi_debug_max_queue; ++k) {
-		sqcp = &queued_arr[k];
-		init_timer(&sqcp->cmnd_timer);
-		sqcp->in_use = 0;
-		sqcp->a_cmnd = NULL;
-	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-}
-
 static void __init sdebug_build_parts(unsigned char *ramp,
 				      unsigned long store_size)
 {
@@ -2663,8 +2963,8 @@ static void __init sdebug_build_parts(unsigned char *ramp,
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
@@ -2701,62 +3001,130 @@ static void __init sdebug_build_parts(unsigned char *ramp,
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
+	unsigned long iflags;
+	int k, num_in_q, tsf, qdepth, inject;
+	struct sdebug_queued_cmd *sqcp = NULL;
+	struct scsi_device *sdp = cmnd->device;
+
+	if (NULL == cmnd || NULL == devip) {
+		pr_warn("%s: called with NULL cmnd or devip pointer\n",
+			__func__);
+		/* no particularly good error to report back */
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
+		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
+			    __func__, scsi_result);
+	if (delta_jiff == 0) {
+		/* using same thread to call back mid-layer */
+		cmnd->result = scsi_result;
+		cmnd->scsi_done(cmnd);
+		return 0;
+	}
 
-			printk(KERN_INFO "scsi_debug:    <%u %u %u %llu> "
-			       "non-zero result=0x%x\n", sdp->host->host_no,
-			       sdp->channel, sdp->id, sdp->lun, scsi_result);
+	/* deferred response cases */
+	spin_lock_irqsave(&queued_arr_lock, iflags);
+	num_in_q = atomic_read(&devip->num_in_q);
+	qdepth = cmnd->device->queue_depth;
+	k = find_first_zero_bit(queued_in_use_bm, scsi_debug_max_queue);
+	tsf = 0;
+	inject = 0;
+	if ((qdepth > 0) && (num_in_q >= qdepth))
+		tsf = 1;
+	else if ((scsi_debug_every_nth != 0) &&
+		 (SCSI_DEBUG_OPT_RARE_TSF & scsi_debug_opts)) {
+		if ((num_in_q == (qdepth - 1)) &&
+		    (atomic_inc_return(&sdebug_a_tsf) >=
+		     abs(scsi_debug_every_nth))) {
+			atomic_set(&sdebug_a_tsf, 0);
+			inject = 1;
+			tsf = 1;
 		}
 	}
-	if (cmnd && devip) {
-		/* simulate autosense by this driver */
-		if (SAM_STAT_CHECK_CONDITION == (scsi_result & 0xff))
-			memcpy(cmnd->sense_buffer, devip->sense_buff,
-			       (SCSI_SENSE_BUFFERSIZE > SDEBUG_SENSE_LEN) ?
-			       SDEBUG_SENSE_LEN : SCSI_SENSE_BUFFERSIZE);
-	}
-	if (delta_jiff <= 0) {
-		if (cmnd)
-			cmnd->result = scsi_result;
-		if (done)
-			done(cmnd);
-		return 0;
-	} else {
-		unsigned long iflags;
-		int k;
-		struct sdebug_queued_cmd * sqcp = NULL;
 
-		spin_lock_irqsave(&queued_arr_lock, iflags);
-		for (k = 0; k < scsi_debug_max_queue; ++k) {
-			sqcp = &queued_arr[k];
-			if (! sqcp->in_use)
-				break;
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
+				    "%s: num_in_q=%d, bypass q, %s%s\n",
+				    __func__, num_in_q,
+				    (inject ? "<inject> " : ""),
+				    (tsf ?  "status: TASK SET FULL" :
+					    "report: host busy"));
+		if (tsf) {
+			/* queued_arr full so respond in same thread */
+			cmnd->result = scsi_result;
+			cmnd->scsi_done(cmnd);
+			/* As scsi_done() is called "inline" must return 0 */
+			return 0;
+		} else
+			return SCSI_MLQUEUE_HOST_BUSY;
+	}
+	__set_bit(k, queued_in_use_bm);
+	atomic_inc(&devip->num_in_q);
+	sqcp = &queued_arr[k];
+	sqcp->a_cmnd = cmnd;
+	cmnd->result = scsi_result;
+	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	if (delta_jiff > 0) {
+		if (NULL == sqcp->cmnd_timerp) {
+			sqcp->cmnd_timerp = kmalloc(sizeof(struct timer_list),
+						    GFP_ATOMIC);
+			if (NULL == sqcp->cmnd_timerp)
+				return SCSI_MLQUEUE_HOST_BUSY;
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
+	} else if (scsi_debug_ndelay > 0) {
+		ktime_t kt = ktime_set(0, scsi_debug_ndelay);
+		struct sdebug_hrtimer *sd_hp = sqcp->sd_hrtp;
+
+		if (NULL == sd_hp) {
+			sd_hp = kmalloc(sizeof(*sd_hp), GFP_ATOMIC);
+			if (NULL == sd_hp)
+				return SCSI_MLQUEUE_HOST_BUSY;
+			sqcp->sd_hrtp = sd_hp;
+			hrtimer_init(&sd_hp->hrt, CLOCK_MONOTONIC,
+				     HRTIMER_MODE_REL);
+			sd_hp->hrt.function = sdebug_q_cmd_hrt_complete;
+			sd_hp->qa_indx = k;
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
+		hrtimer_start(&sd_hp->hrt, kt, HRTIMER_MODE_REL);
+	} else {	/* delay < 0 */
+		if (NULL == sqcp->tletp) {
+			sqcp->tletp = kmalloc(sizeof(*sqcp->tletp),
+					      GFP_ATOMIC);
+			if (NULL == sqcp->tletp)
+				return SCSI_MLQUEUE_HOST_BUSY;
+			tasklet_init(sqcp->tletp,
+				     sdebug_q_cmd_complete, k);
+		}
+		if (-1 == delta_jiff)
+			tasklet_hi_schedule(sqcp->tletp);
+		else
+			tasklet_schedule(sqcp->tletp);
 	}
+	if (tsf && (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts))
+		sdev_printk(KERN_INFO, sdp,
+			    "%s: num_in_q=%d +1, %s%s\n", __func__,
+			    num_in_q, (inject ? "<inject> " : ""),
+			    "status: TASK SET FULL");
+	return 0;
 }
+
 /* Note: The following macros create attribute files in the
    /sys/module/scsi_debug/parameters directory. Unfortunately this
    driver is unaware of a change and cannot trigger auxiliary actions
@@ -2774,6 +3142,7 @@ module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
 module_param_named(guard, scsi_debug_guard, uint, S_IRUGO);
+module_param_named(host_lock, scsi_debug_host_lock, bool, S_IRUGO | S_IWUSR);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
@@ -2781,6 +3150,7 @@ module_param_named(lbprz, scsi_debug_lbprz, int, S_IRUGO);
 module_param_named(lowest_aligned, scsi_debug_lowest_aligned, int, S_IRUGO);
 module_param_named(max_luns, scsi_debug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, scsi_debug_max_queue, int, S_IRUGO | S_IWUSR);
+module_param_named(ndelay, scsi_debug_ndelay, int, S_IRUGO | S_IWUSR);
 module_param_named(no_lun_0, scsi_debug_no_lun_0, int, S_IRUGO | S_IWUSR);
 module_param_named(no_uld, scsi_debug_no_uld, int, S_IRUGO);
 module_param_named(num_parts, scsi_debug_num_parts, int, S_IRUGO);
@@ -2810,7 +3180,7 @@ MODULE_VERSION(SCSI_DEBUG_VERSION);
 MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
-MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
+MODULE_PARM_DESC(delay, "response delay (def=1 jiffy); 0:imm, -1,-2:tiny");
 MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
@@ -2818,13 +3188,15 @@ MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
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
+MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
 MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
@@ -2855,9 +3227,7 @@ static const char * scsi_debug_info(struct Scsi_Host * shp)
 	return sdebug_info;
 }
 
-/* scsi_debug_proc_info
- * Used if the driver currently has no own support for /proc/scsi
- */
+/* 'echo <val> > /proc/scsi/scsi_debug/<host_id>' writes to opts */
 static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer, int length)
 {
 	char arr[16];
@@ -2872,27 +3242,49 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer, int lengt
 		return -EINVAL;
 	scsi_debug_opts = opts;
 	if (scsi_debug_every_nth != 0)
-		scsi_debug_cmnd_count = 0;
+		atomic_set(&sdebug_cmnd_count, 0);
 	return length;
 }
 
+/* Output seen with 'cat /proc/scsi/scsi_debug/<host_id>'. It will be the
+ * same for each scsi_debug host (if more than one). Some of the counters
+ * output are not atomics so might be inaccurate in a busy system. */
 static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
-	seq_printf(m, "scsi_debug adapter driver, version "
-	    "%s [%s]\n"
-	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
-	    "every_nth=%d(curr:%d)\n"
-	    "delay=%d, max_luns=%d, scsi_level=%d\n"
-	    "sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
-	    "number of aborts=%d, device_reset=%d, bus_resets=%d, "
-	    "host_resets=%d\ndix_reads=%d dix_writes=%d dif_errors=%d\n",
-	    SCSI_DEBUG_VERSION, scsi_debug_version_date, scsi_debug_num_tgts,
-	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
-	    scsi_debug_cmnd_count, scsi_debug_delay,
-	    scsi_debug_max_luns, scsi_debug_scsi_level,
-	    scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
-	    sdebug_sectors_per, num_aborts, num_dev_resets, num_bus_resets,
-	    num_host_resets, dix_reads, dix_writes, dif_errors);
+	int f, l;
+	char b[32];
+
+	if (scsi_debug_every_nth > 0)
+		snprintf(b, sizeof(b), " (curr:%d)",
+			 ((SCSI_DEBUG_OPT_RARE_TSF & scsi_debug_opts) ?
+				atomic_read(&sdebug_a_tsf) :
+				atomic_read(&sdebug_cmnd_count)));
+	else
+		b[0] = '\0';
+
+	seq_printf(m, "scsi_debug adapter driver, version %s [%s]\n"
+		"num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
+		"every_nth=%d%s\n"
+		"delay=%d, ndelay=%d, max_luns=%d, q_completions=%d\n"
+		"sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
+		"command aborts=%d; RESETs: device=%d, target=%d, bus=%d, "
+		"host=%d\ndix_reads=%d dix_writes=%d dif_errors=%d "
+		"usec_in_jiffy=%lu\n",
+		SCSI_DEBUG_VERSION, scsi_debug_version_date,
+		scsi_debug_num_tgts, scsi_debug_dev_size_mb, scsi_debug_opts,
+		scsi_debug_every_nth, b, scsi_debug_delay, scsi_debug_ndelay,
+		scsi_debug_max_luns, atomic_read(&sdebug_completions),
+		scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
+		sdebug_sectors_per, num_aborts, num_dev_resets,
+		num_target_resets, num_bus_resets, num_host_resets,
+		dix_reads, dix_writes, dif_errors, TICK_NSEC / 1000);
+
+	f = find_first_bit(queued_in_use_bm, scsi_debug_max_queue);
+	if (f != scsi_debug_max_queue) {
+		l = find_last_bit(queued_in_use_bm, scsi_debug_max_queue);
+		seq_printf(m, "   %s BUSY: first,last bits set: %d,%d\n",
+			   "queued_in_use_bm", f, l);
+	}
 	return 0;
 }
 
@@ -2900,23 +3292,69 @@ static ssize_t delay_show(struct device_driver *ddp, char *buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_delay);
 }
-
+/* Returns -EBUSY if delay is being changed and commands are queued */
 static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 			   size_t count)
 {
-        int delay;
-	char work[20];
-
-        if (1 == sscanf(buf, "%10s", work)) {
-		if ((1 == sscanf(work, "%d", &delay)) && (delay >= 0)) {
-			scsi_debug_delay = delay;
-			return count;
+	int delay, res;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &delay))) {
+		res = count;
+		if (scsi_debug_delay != delay) {
+			unsigned long iflags;
+			int k;
+
+			spin_lock_irqsave(&queued_arr_lock, iflags);
+			k = find_first_bit(queued_in_use_bm,
+					   scsi_debug_max_queue);
+			if (k != scsi_debug_max_queue)
+				res = -EBUSY;	/* have queued commands */
+			else {
+				scsi_debug_delay = delay;
+				scsi_debug_ndelay = 0;
+			}
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		}
+		return res;
 	}
 	return -EINVAL;
 }
 static DRIVER_ATTR_RW(delay);
 
+static ssize_t ndelay_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_ndelay);
+}
+/* Returns -EBUSY if ndelay is being changed and commands are queued */
+/* If > 0 and accepted then scsi_debug_delay is set to DELAY_OVERRIDDEN */
+static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
+			   size_t count)
+{
+	unsigned long iflags;
+	int ndelay, res, k;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &ndelay)) &&
+	    (ndelay >= 0) && (ndelay < 1000000000)) {
+		res = count;
+		if (scsi_debug_ndelay != ndelay) {
+			spin_lock_irqsave(&queued_arr_lock, iflags);
+			k = find_first_bit(queued_in_use_bm,
+					   scsi_debug_max_queue);
+			if (k != scsi_debug_max_queue)
+				res = -EBUSY;	/* have queued commands */
+			else {
+				scsi_debug_ndelay = ndelay;
+				scsi_debug_delay = ndelay ? DELAY_OVERRIDDEN
+							  : DEF_DELAY;
+			}
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		}
+		return res;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(ndelay);
+
 static ssize_t opts_show(struct device_driver *ddp, char *buf)
 {
         return scnprintf(buf, PAGE_SIZE, "0x%x\n", scsi_debug_opts);
@@ -2940,7 +3378,8 @@ static ssize_t opts_store(struct device_driver *ddp, const char *buf,
 	return -EINVAL;
 opts_done:
 	scsi_debug_opts = opts;
-	scsi_debug_cmnd_count = 0;
+	atomic_set(&sdebug_cmnd_count, 0);
+	atomic_set(&sdebug_a_tsf, 0);
 	return count;
 }
 static DRIVER_ATTR_RW(opts);
@@ -2989,7 +3428,24 @@ static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
         int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_fake_rw = n;
+		n = (n > 0);
+		scsi_debug_fake_rw = (scsi_debug_fake_rw > 0);
+		if (scsi_debug_fake_rw != n) {
+			if ((0 == n) && (NULL == fake_storep)) {
+				unsigned long sz =
+					(unsigned long)scsi_debug_dev_size_mb *
+					1048576;
+
+				fake_storep = vmalloc(sz);
+				if (NULL == fake_storep) {
+					pr_err("%s: out of memory, 9\n",
+					       __func__);
+					return -ENOMEM;
+				}
+				memset(fake_storep, 0, sz);
+			}
+			scsi_debug_fake_rw = n;
+		}
 		return count;
 	}
 	return -EINVAL;
@@ -3054,7 +3510,7 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &nth))) {
 		scsi_debug_every_nth = nth;
-		scsi_debug_cmnd_count = 0;
+		atomic_set(&sdebug_cmnd_count, 0);
 		return count;
 	}
 	return -EINVAL;
@@ -3083,14 +3539,26 @@ static ssize_t max_queue_show(struct device_driver *ddp, char *buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_max_queue);
 }
+/* N.B. max_queue can be changed while there are queued commands. In flight
+ * commands beyond the new max_queue will be completed. */
 static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
 {
-        int n;
+	unsigned long iflags;
+	int n, k;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
 	    (n <= SCSI_DEBUG_CANQUEUE)) {
+		spin_lock_irqsave(&queued_arr_lock, iflags);
+		k = find_last_bit(queued_in_use_bm, SCSI_DEBUG_CANQUEUE);
 		scsi_debug_max_queue = n;
+		if (SCSI_DEBUG_CANQUEUE == k)
+			atomic_set(&retired_max_queue, 0);
+		else if (k >= n)
+			atomic_set(&retired_max_queue, k + 1);
+		else
+			atomic_set(&retired_max_queue, 0);
+		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		return count;
 	}
 	return -EINVAL;
@@ -3235,6 +3703,40 @@ static ssize_t removable_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(removable);
 
+static ssize_t host_lock_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!scsi_debug_host_lock);
+}
+/* Returns -EBUSY if host_lock is being changed and commands are queued */
+static ssize_t host_lock_store(struct device_driver *ddp, const char *buf,
+			       size_t count)
+{
+	int n, res;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		bool new_host_lock = (n > 0);
+
+		res = count;
+		if (new_host_lock != scsi_debug_host_lock) {
+			unsigned long iflags;
+			int k;
+
+			spin_lock_irqsave(&queued_arr_lock, iflags);
+			k = find_first_bit(queued_in_use_bm,
+					   scsi_debug_max_queue);
+			if (k != scsi_debug_max_queue)
+				res = -EBUSY;	/* have queued commands */
+			else
+				scsi_debug_host_lock = new_host_lock;
+			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		}
+		return res;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(host_lock);
+
+
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -3267,6 +3769,8 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_ato.attr,
 	&driver_attr_map.attr,
 	&driver_attr_removable.attr,
+	&driver_attr_host_lock.attr,
+	&driver_attr_ndelay.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
@@ -3280,6 +3784,17 @@ static int __init scsi_debug_init(void)
 	int k;
 	int ret;
 
+	atomic_set(&sdebug_cmnd_count, 0);
+	atomic_set(&sdebug_completions, 0);
+	atomic_set(&retired_max_queue, 0);
+
+	if (scsi_debug_ndelay >= 1000000000) {
+		pr_warn("%s: ndelay must be less than 1 second, ignored\n",
+			__func__);
+		scsi_debug_ndelay = 0;
+	} else if (scsi_debug_ndelay > 0)
+		scsi_debug_delay = DELAY_OVERRIDDEN;
+
 	switch (scsi_debug_sector_size) {
 	case  512:
 	case 1024:
@@ -3287,7 +3802,7 @@ static int __init scsi_debug_init(void)
 	case 4096:
 		break;
 	default:
-		printk(KERN_ERR "scsi_debug_init: invalid sector_size %d\n",
+		pr_err("%s: invalid sector_size %d\n", __func__,
 		       scsi_debug_sector_size);
 		return -EINVAL;
 	}
@@ -3301,28 +3816,28 @@ static int __init scsi_debug_init(void)
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
@@ -3350,14 +3865,16 @@ static int __init scsi_debug_init(void)
 			       (sdebug_sectors_per * sdebug_heads);
 	}
 
-	fake_storep = vmalloc(sz);
-	if (NULL == fake_storep) {
-		printk(KERN_ERR "scsi_debug_init: out of memory, 1\n");
-		return -ENOMEM;
+	if (0 == scsi_debug_fake_rw) {
+		fake_storep = vmalloc(sz);
+		if (NULL == fake_storep) {
+			pr_err("%s: out of memory, 1\n", __func__);
+			return -ENOMEM;
+		}
+		memset(fake_storep, 0, sz);
+		if (scsi_debug_num_parts > 0)
+			sdebug_build_parts(fake_storep, sz);
 	}
-	memset(fake_storep, 0, sz);
-	if (scsi_debug_num_parts > 0)
-		sdebug_build_parts(fake_storep, sz);
 
 	if (scsi_debug_dix) {
 		int dif_size;
@@ -3365,11 +3882,11 @@ static int __init scsi_debug_init(void)
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
@@ -3391,8 +3908,7 @@ static int __init scsi_debug_init(void)
 		if (scsi_debug_unmap_alignment &&
 		    scsi_debug_unmap_granularity <=
 		    scsi_debug_unmap_alignment) {
-			printk(KERN_ERR
-			       "%s: ERR: unmap_granularity <= unmap_alignment\n",
+			pr_err("%s: ERR: unmap_granularity <= unmap_alignment\n",
 			       __func__);
 			return -EINVAL;
 		}
@@ -3400,11 +3916,10 @@ static int __init scsi_debug_init(void)
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
@@ -3418,39 +3933,35 @@ static int __init scsi_debug_init(void)
 
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
 
-	init_all_queued();
-
 	host_to_add = scsi_debug_add_host;
         scsi_debug_add_host = 0;
 
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
 
@@ -3473,6 +3984,7 @@ static void __exit scsi_debug_exit(void)
 	int k = scsi_debug_add_host;
 
 	stop_all_queued();
+	free_all_queued();
 	for (; k; k--)
 		sdebug_remove_adapter();
 	driver_unregister(&sdebug_driverfs_driver);
@@ -3570,8 +4082,8 @@ static void sdebug_remove_adapter(void)
         --scsi_debug_add_host;
 }
 
-static
-int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
+static int
+scsi_debug_queuecommand(struct scsi_cmnd *SCpnt)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int len, k;
@@ -3590,32 +4102,34 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 	int unmap = 0;
 
 	scsi_set_resid(SCpnt, 0);
-	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
-		printk(KERN_INFO "scsi_debug: cmd ");
-		for (k = 0, len = SCpnt->cmd_len; k < len; ++k)
-			printk("%02x ", (int)cmd[k]);
-		printk("\n");
-	}
-
-	if (target == SCpnt->device->host->hostt->this_id) {
-		printk(KERN_INFO "scsi_debug: initiator's id used as "
-		       "target!\n");
-		return schedule_resp(SCpnt, NULL, done,
-				     DID_NO_CONNECT << 16, 0);
+	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) &&
+	    !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts) && cmd) {
+		char b[120];
+		int n;
+
+		len = SCpnt->cmd_len;
+		if (len > 32)
+			strcpy(b, "too long, over 32 bytes");
+		else {
+			for (k = 0, n = 0; k < len; ++k)
+				n += scnprintf(b + n, sizeof(b) - n, "%02x ",
+					       (unsigned int)cmd[k]);
+		}
+		sdev_printk(KERN_INFO, SCpnt->device, "%s: cmd %s\n", my_name,
+			    b);
 	}
 
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
@@ -3646,11 +4160,10 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 			if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 				printk(KERN_INFO "scsi_debug: Opcode: 0x%x "
 				       "not supported for wlun\n", *cmd);
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 					INVALID_OPCODE, 0);
 			errsts = check_condition_result;
-			return schedule_resp(SCpnt, devip, done, errsts,
-					     0);
+			return schedule_resp(SCpnt, devip, errsts, 0);
 		}
 	}
 
@@ -3668,7 +4181,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 		errsts = resp_start_stop(SCpnt, devip);
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
-		errsts = check_readiness(SCpnt, 1, devip);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		if (errsts)
 			break;
 		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
@@ -3676,23 +4189,23 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 			       cmd[4] ? "inhibited" : "enabled");
 		break;
 	case SEND_DIAGNOSTIC:     /* mandatory */
-		errsts = check_readiness(SCpnt, 1, devip);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		break;
 	case TEST_UNIT_READY:     /* mandatory */
-		delay_override = 1;
-		errsts = check_readiness(SCpnt, 0, devip);
+		/* delay_override = 1; */
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		break;
 	case RESERVE:
-		errsts = check_readiness(SCpnt, 1, devip);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		break;
 	case RESERVE_10:
-		errsts = check_readiness(SCpnt, 1, devip);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		break;
 	case RELEASE:
-		errsts = check_readiness(SCpnt, 1, devip);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		break;
 	case RELEASE_10:
-		errsts = check_readiness(SCpnt, 1, devip);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		break;
 	case READ_CAPACITY:
 		errsts = resp_readcap(SCpnt, devip);
@@ -3703,20 +4216,20 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 		else if (cmd[1] == SAI_GET_LBA_STATUS) {
 
 			if (scsi_debug_lbp() == 0) {
-				mk_sense_buffer(devip, ILLEGAL_REQUEST,
+				mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 						INVALID_COMMAND_OPCODE, 0);
 				errsts = check_condition_result;
 			} else
 				errsts = resp_get_lba_status(SCpnt, devip);
 		} else {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 					INVALID_OPCODE, 0);
 			errsts = check_condition_result;
 		}
 		break;
 	case MAINTENANCE_IN:
 		if (MI_REPORT_TARGET_PGS != cmd[1]) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 					INVALID_OPCODE, 0);
 			errsts = check_condition_result;
 			break;
@@ -3729,7 +4242,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 		/* READ{10,12,16} and DIF Type 2 are natural enemies */
 		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
 		    cmd[1] & 0xe0) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 					INVALID_COMMAND_OPCODE, 0);
 			errsts = check_condition_result;
 			break;
@@ -3743,7 +4256,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 		/* fall through */
 	case READ_6:
 read:
-		errsts = check_readiness(SCpnt, 0, devip);
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		if (errsts)
 			break;
 		if (scsi_debug_fake_rw)
@@ -3753,20 +4266,21 @@ read:
 		if (inj_short)
 			num /= 2;
 
-		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
+		errsts = resp_read(SCpnt, lba, num, ei_lba);
 		if (inj_recovered && (0 == errsts)) {
-			mk_sense_buffer(devip, RECOVERED_ERROR,
+			mk_sense_buffer(SCpnt, RECOVERED_ERROR,
 					THRESHOLD_EXCEEDED, 0);
 			errsts = check_condition_result;
 		} else if (inj_transport && (0 == errsts)) {
-			mk_sense_buffer(devip, ABORTED_COMMAND,
+			mk_sense_buffer(SCpnt, ABORTED_COMMAND,
 					TRANSPORT_PROBLEM, ACK_NAK_TO);
 			errsts = check_condition_result;
 		} else if (inj_dif && (0 == errsts)) {
-			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, 1);
+			/* Logical block guard check failed */
+			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, 1);
 			errsts = illegal_condition_result;
 		} else if (inj_dix && (0 == errsts)) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, 1);
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10, 1);
 			errsts = illegal_condition_result;
 		}
 		break;
@@ -3775,7 +4289,7 @@ read:
 		errsts = resp_report_luns(SCpnt, devip);
 		break;
 	case VERIFY:		/* 10 byte SBC-2 command */
-		errsts = check_readiness(SCpnt, 0, devip);
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		break;
 	case WRITE_16:
 	case WRITE_12:
@@ -3783,7 +4297,7 @@ read:
 		/* WRITE{10,12,16} and DIF Type 2 are natural enemies */
 		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
 		    cmd[1] & 0xe0) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 					INVALID_COMMAND_OPCODE, 0);
 			errsts = check_condition_result;
 			break;
@@ -3797,22 +4311,22 @@ read:
 		/* fall through */
 	case WRITE_6:
 write:
-		errsts = check_readiness(SCpnt, 0, devip);
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		if (errsts)
 			break;
 		if (scsi_debug_fake_rw)
 			break;
 		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
-		errsts = resp_write(SCpnt, lba, num, devip, ei_lba);
+		errsts = resp_write(SCpnt, lba, num, ei_lba);
 		if (inj_recovered && (0 == errsts)) {
-			mk_sense_buffer(devip, RECOVERED_ERROR,
+			mk_sense_buffer(SCpnt, RECOVERED_ERROR,
 					THRESHOLD_EXCEEDED, 0);
 			errsts = check_condition_result;
 		} else if (inj_dif && (0 == errsts)) {
-			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, 1);
+			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, 1);
 			errsts = illegal_condition_result;
 		} else if (inj_dix && (0 == errsts)) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, 1);
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10, 1);
 			errsts = illegal_condition_result;
 		}
 		break;
@@ -3821,7 +4335,7 @@ write:
 		if (cmd[1] & 0x8) {
 			if ((*cmd == WRITE_SAME_16 && scsi_debug_lbpws == 0) ||
 			    (*cmd == WRITE_SAME && scsi_debug_lbpws10 == 0)) {
-				mk_sense_buffer(devip, ILLEGAL_REQUEST,
+				mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 						INVALID_FIELD_IN_CDB, 0);
 				errsts = check_condition_result;
 			} else
@@ -3829,19 +4343,23 @@ write:
 		}
 		if (errsts)
 			break;
-		errsts = check_readiness(SCpnt, 0, devip);
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		if (errsts)
 			break;
+		if (scsi_debug_fake_rw)
+			break;
 		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
-		errsts = resp_write_same(SCpnt, lba, num, devip, ei_lba, unmap);
+		errsts = resp_write_same(SCpnt, lba, num, ei_lba, unmap);
 		break;
 	case UNMAP:
-		errsts = check_readiness(SCpnt, 0, devip);
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		if (errsts)
 			break;
+		if (scsi_debug_fake_rw)
+			break;
 
 		if (scsi_debug_unmap_max_desc == 0 || scsi_debug_lbpu == 0) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 					INVALID_COMMAND_OPCODE, 0);
 			errsts = check_condition_result;
 		} else
@@ -3862,29 +4380,29 @@ write:
 		break;
 	case SYNCHRONIZE_CACHE:
 		delay_override = 1;
-		errsts = check_readiness(SCpnt, 0, devip);
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		break;
 	case WRITE_BUFFER:
-		errsts = check_readiness(SCpnt, 1, devip);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		break;
 	case XDWRITEREAD_10:
 		if (!scsi_bidi_cmnd(SCpnt)) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
 			errsts = check_condition_result;
 			break;
 		}
 
-		errsts = check_readiness(SCpnt, 0, devip);
+		errsts = check_readiness(SCpnt, UAS_TUR, devip);
 		if (errsts)
 			break;
 		if (scsi_debug_fake_rw)
 			break;
 		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
-		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
+		errsts = resp_read(SCpnt, lba, num, ei_lba);
 		if (errsts)
 			break;
-		errsts = resp_write(SCpnt, lba, num, devip, ei_lba);
+		errsts = resp_write(SCpnt, lba, num, ei_lba);
 		if (errsts)
 			break;
 		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
@@ -3907,27 +4425,138 @@ write:
 			}
 		}
 
-		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_CDB, 0);
 		errsts = check_condition_result;
 		break;
-
+	case 0x85:
+		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+			sdev_printk(KERN_INFO, SCpnt->device,
+			"%s: ATA PASS-THROUGH(16) not supported\n", my_name);
+		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
+				INVALID_OPCODE, 0);
+		errsts = check_condition_result;
+		break;
 	default:
 		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "
-			       "supported\n", *cmd);
-		errsts = check_readiness(SCpnt, 1, devip);
+			sdev_printk(KERN_INFO, SCpnt->device,
+				    "%s: Opcode: 0x%x not supported\n",
+				    my_name, *cmd);
+		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
 		if (errsts)
 			break;	/* Unit attention takes precedence */
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
+		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
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
+	if (scsi_debug_host_lock) {
+		unsigned long iflags;
+		int rc;
+
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
+	num_in_q = atomic_read(&devip->num_in_q);
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
@@ -3939,16 +4568,18 @@ static struct scsi_host_template sdebug_driver_template = {
 	.slave_configure =	scsi_debug_slave_configure,
 	.slave_destroy =	scsi_debug_slave_destroy,
 	.ioctl =		scsi_debug_ioctl,
-	.queuecommand =		scsi_debug_queuecommand,
+	.queuecommand =		sdebug_queuecommand_lock_or_not,
+	.change_queue_depth =	sdebug_change_qdepth,
+	.change_queue_type =	sdebug_change_qtype,
 	.eh_abort_handler =	scsi_debug_abort,
-	.eh_bus_reset_handler = scsi_debug_bus_reset,
 	.eh_device_reset_handler = scsi_debug_device_reset,
+	.eh_target_reset_handler = scsi_debug_target_reset,
+	.eh_bus_reset_handler = scsi_debug_bus_reset,
 	.eh_host_reset_handler = scsi_debug_host_reset,
-	.bios_param =		scsi_debug_biosparam,
 	.can_queue =		SCSI_DEBUG_CANQUEUE,
 	.this_id =		7,
 	.sg_tablesize =		SCSI_MAX_SG_CHAIN_SEGMENTS,
-	.cmd_per_lun =		16,
+	.cmd_per_lun =		DEF_CMD_PER_LUN,
 	.max_sectors =		-1U,
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
@@ -4033,8 +4664,7 @@ static int sdebug_driver_probe(struct device * dev)
         } else
 		scsi_scan_host(hpnt);
 
-
-        return error;
+	return error;
 }
 
 static int sdebug_driver_remove(struct device * dev)

--------------020306020802050708020803--
