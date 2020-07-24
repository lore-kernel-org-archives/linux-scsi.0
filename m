Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A294C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 15:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F432064B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 15:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgGXPzh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 11:55:37 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55111 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgGXPzg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jul 2020 11:55:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 34A08204190;
        Fri, 24 Jul 2020 17:55:35 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id llmETjHueHtl; Fri, 24 Jul 2020 17:55:35 +0200 (CEST)
Received: from xtwo70.bingwo.ca (vpn.infotech.no [82.134.31.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 2277F204170;
        Fri, 24 Jul 2020 17:55:33 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2] scsi_debug: tur_ms_to_ready parameter
Date:   Fri, 24 Jul 2020 11:55:31 -0400
Message-Id: <20200724155531.668144-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current driver responds to TEST UNIT READY (TUR) with a GOOD
status immediately after a scsi_debug device (LU) is created. This is
unrealistic as even SSDs take some time after power-on before
accepting media access commands.

Add the tur_ms_to_ready parameter whose unit is milliseconds (default
0) and is the period before which a TUR (or any media access command)
will set the CHECK CONDITION status with a sense key of NOT READY and
an additional sense of "Logical unit is in process of becoming ready".
The period starts when each scsi_debug device is created.

This patch was prompted by T10 proposal 20-061r2 which was accepted on
2020716. It adds that a TUR in the situation described in the previous
paragraph may set the INFO field (or descriptor) in the sense data to
the estimated number in milliseconds before a subsequent TUR will
yield a GOOD status. This patch follows that advice.

Changes since version 1:
  - change 64 bit division into call to do_div() per kbuild robot
    report

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 110 ++++++++++++++++++++++++++++++++------
 1 file changed, 93 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 01d40f6eec20..dd3da268e2fd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -151,6 +151,7 @@ static const char *sdebug_version_date = "20200710";
 #define DEF_STRICT 0
 #define DEF_STATISTICS false
 #define DEF_SUBMIT_QUEUES 1
+#define DEF_TUR_MS_TO_READY 0
 #define DEF_UUID_CTL 0
 #define JDELAY_OVERRIDDEN -9999
 
@@ -288,7 +289,7 @@ struct sdebug_dev_info {
 	struct sdebug_host_info *sdbg_host;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
-	atomic_t stopped;
+	atomic_t stopped;	/* 1: by SSU, 2: device start */
 	bool used;
 
 	/* For ZBC devices */
@@ -301,6 +302,7 @@ struct sdebug_dev_info {
 	unsigned int nr_exp_open;
 	unsigned int nr_closed;
 	unsigned int max_open;
+	ktime_t create_ts;	/* time since bootup that this device was created */
 	struct sdeb_zone_state *zstate;
 };
 
@@ -758,6 +760,7 @@ static int sdebug_opt_xferlen_exp = DEF_OPT_XFERLEN_EXP;
 static int sdebug_ptype = DEF_PTYPE; /* SCSI peripheral device type */
 static int sdebug_scsi_level = DEF_SCSI_LEVEL;
 static int sdebug_sector_size = DEF_SECTOR_SIZE;
+static int sdeb_tur_ms_to_ready = DEF_TUR_MS_TO_READY;
 static int sdebug_virtual_gb = DEF_VIRTUAL_GB;
 static int sdebug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
 static unsigned int sdebug_lbpu = DEF_LBPU;
@@ -1774,11 +1777,10 @@ static int resp_requests(struct scsi_cmnd *scp,
 	return fill_from_dev_buffer(scp, arr, len);
 }
 
-static int resp_start_stop(struct scsi_cmnd *scp,
-			   struct sdebug_dev_info *devip)
+static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char *cmd = scp->cmnd;
-	int power_cond, stop;
+	int power_cond, want_stop, stopped_state;
 	bool changing;
 
 	power_cond = (cmd[4] & 0xf0) >> 4;
@@ -1786,10 +1788,33 @@ static int resp_start_stop(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, 7);
 		return check_condition_result;
 	}
-	stop = !(cmd[4] & 1);
-	changing = atomic_read(&devip->stopped) == !stop;
-	atomic_xchg(&devip->stopped, stop);
-	if (!changing || cmd[1] & 0x1)  /* state unchanged or IMMED set */
+	want_stop = !(cmd[4] & 1);
+	stopped_state = atomic_read(&devip->stopped);
+	if (stopped_state == 2) {
+		ktime_t now_ts = ktime_get_boottime();
+
+		if (ktime_to_ns(now_ts) > ktime_to_ns(devip->create_ts)) {
+			u64 diff_ns = ktime_to_ns(ktime_sub(now_ts, devip->create_ts));
+
+			if (diff_ns >= ((u64)sdeb_tur_ms_to_ready * 1000000)) {
+				/* tur_ms_to_ready timer extinguished */
+				atomic_set(&devip->stopped, 0);
+				stopped_state = 0;
+			}
+		}
+		if (stopped_state == 2) {
+			if (want_stop) {
+				stopped_state = 1;	/* dummy up success */
+			} else {	/* Disallow tur_ms_to_ready delay to be overridden */
+				mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, 0 /* START bit */);
+				return check_condition_result;
+			}
+		}
+	}
+	changing = (stopped_state != want_stop);
+	if (changing)
+		atomic_xchg(&devip->stopped, want_stop);
+	if (!changing || (cmd[1] & 0x1))  /* state unchanged or IMMED bit set in cdb */
 		return SDEG_RES_IMMED_MASK;
 	else
 		return 0;
@@ -4018,7 +4043,7 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
-	if (!write_since_sync || cmd[1] & 0x2)
+	if (!write_since_sync || (cmd[1] & 0x2))
 		res = SDEG_RES_IMMED_MASK;
 	else		/* delay if write_since_sync and IMMED clear */
 		write_since_sync = false;
@@ -4894,6 +4919,8 @@ static struct sdebug_dev_info *sdebug_device_create(
 			devip->zmodel = BLK_ZONED_NONE;
 		}
 		devip->sdbg_host = sdbg_host;
+		devip->create_ts = ktime_get_boottime();
+		atomic_set(&devip->stopped, (sdeb_tur_ms_to_ready > 0 ? 2 : 0));
 		list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);
 	}
 	return devip;
@@ -5568,6 +5595,7 @@ module_param_named(sector_size, sdebug_sector_size, int, S_IRUGO);
 module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
 module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
 module_param_named(submit_queues, submit_queues, int, S_IRUGO);
+module_param_named(tur_ms_to_ready, sdeb_tur_ms_to_ready, int, S_IRUGO);
 module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
@@ -5634,6 +5662,7 @@ MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
 MODULE_PARM_DESC(statistics, "collect statistics on commands, queues (def=0)");
 MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
 MODULE_PARM_DESC(submit_queues, "support for block multi-queue (def=1)");
+MODULE_PARM_DESC(tur_ms_to_ready, "TEST UNIT READY millisecs before initial good status (def=0)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
@@ -6460,6 +6489,12 @@ static ssize_t zbc_show(struct device_driver *ddp, char *buf)
 }
 static DRIVER_ATTR_RO(zbc);
 
+static ssize_t tur_ms_to_ready_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdeb_tur_ms_to_ready);
+}
+static DRIVER_ATTR_RO(tur_ms_to_ready);
+
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -6501,6 +6536,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_strict.attr,
 	&driver_attr_uuid_ctl.attr,
 	&driver_attr_cdb_len.attr,
+	&driver_attr_tur_ms_to_ready.attr,
 	&driver_attr_zbc.attr,
 	NULL,
 };
@@ -7017,6 +7053,49 @@ static bool fake_timeout(struct scsi_cmnd *scp)
 	return false;
 }
 
+/* Response to TUR or media access command when device stopped */
+static int resp_not_ready(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	int stopped_state;
+	u64 diff_ns = 0;
+	ktime_t now_ts = ktime_get_boottime();
+	struct scsi_device *sdp = scp->device;
+
+	stopped_state = atomic_read(&devip->stopped);
+	if (stopped_state == 2) {
+		if (ktime_to_ns(now_ts) > ktime_to_ns(devip->create_ts)) {
+			diff_ns = ktime_to_ns(ktime_sub(now_ts, devip->create_ts));
+			if (diff_ns >= ((u64)sdeb_tur_ms_to_ready * 1000000)) {
+				/* tur_ms_to_ready timer extinguished */
+				atomic_set(&devip->stopped, 0);
+				return 0;
+			}
+		}
+		mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x1);
+		if (sdebug_verbose)
+			sdev_printk(KERN_INFO, sdp,
+				    "%s: Not ready: in process of becoming ready\n", my_name);
+		if (scp->cmnd[0] == TEST_UNIT_READY) {
+			u64 tur_nanosecs_to_ready = (u64)sdeb_tur_ms_to_ready * 1000000;
+
+			if (diff_ns <= tur_nanosecs_to_ready)
+				diff_ns = tur_nanosecs_to_ready - diff_ns;
+			else
+				diff_ns = tur_nanosecs_to_ready;
+			/* As per 20-061r2 approved for spc6 by T10 on 20200716 */
+			do_div(diff_ns, 1000000);	/* diff_ns becomes milliseconds */
+			scsi_set_sense_information(scp->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+						   diff_ns);
+			return check_condition_result;
+		}
+	}
+	mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x2);
+	if (sdebug_verbose)
+		sdev_printk(KERN_INFO, sdp, "%s: Not ready: initializing command required\n",
+			    my_name);
+	return check_condition_result;
+}
+
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
@@ -7141,14 +7220,11 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		if (errsts)
 			goto check_cond;
 	}
-	if (unlikely((F_M_ACCESS & flags) && atomic_read(&devip->stopped))) {
-		mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x2);
-		if (sdebug_verbose)
-			sdev_printk(KERN_INFO, sdp, "%s reports: Not ready: "
-				    "%s\n", my_name, "initializing command "
-				    "required");
-		errsts = check_condition_result;
-		goto fini;
+	if (unlikely(((F_M_ACCESS & flags) || scp->cmnd[0] == TEST_UNIT_READY) &&
+		     atomic_read(&devip->stopped))) {
+		errsts = resp_not_ready(scp, devip);
+		if (errsts)
+			goto fini;
 	}
 	if (sdebug_fake_rw && (F_FAKE_RW & flags))
 		goto fini;
-- 
2.25.1

