From: Steven Dake <sdake@mvista.com>
Subject: subsecond RAID 1 failover using SCSI targets
Date: Fri, 17 Oct 2003 12:51:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066420311.4761.459.camel@persist.az.mvista.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-3hvxIMABhPMx88GxVqQt"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:3236 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S263591AbTJQTvw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 15:51:52 -0400
Received: from persist.az.mvista.com (persist.az.mvista.com [10.50.1.87])
	by zipcode.az.mvista.com (8.9.3/8.9.3) with ESMTP id NAA00898
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2003 13:09:21 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-3hvxIMABhPMx88GxVqQt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Folks,

I have made a patch (for 2.4) which adds fast failover capabilities to
the RAID 1 system (only tested with SCSI targets).  Without this patch,
failover can take as much as 3 minutes during device failure in the SCSI
layer.  With this patch, failover can reach subsecond ranges (with
appropriate configuration).

The patch does the following:
adds kernel tuneable for bus reset settle time
adds kernel tuneable for host reset settle time
adds kernel tuneable for timeout on normal I/O requests
adds kernel tuneable for timeout on fastfail I/O requests
adds fastfail flag to RAID/SCSI code
I/O requests from a RAID 1 device operating in redundant operation will
request FASTFAILs.  I/O requests from a RAID 1 device operating in
degraded mode will request normal I/Os.

adds ability to not unjam the SCSI host on fastfail I/O requests. 
Thisis useful for FibreChannel devices, where an unjam may be
unwarranted form of error recovery because it introduces LIP resets
which may slow performance when a failure has already happened and can't
be recovered.

Anyone interested in a 2.6 patch of the same flavor (the fastfail flag
is already in 2.6, but needs a little work on timing tuning)?  Any other
comments?

Thanks
-steve

--=-3hvxIMABhPMx88GxVqQt
Content-Disposition: attachment; filename=fast-failover.patch
Content-Type: text/plain; name=fast-failover.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux/drivers/md/raid1.c	2003-10-08 15:59:39.000000000 -0700
+++ linux-mdfix/drivers/md/raid1.c	2003-10-08 16:07:28.000000000 -0700
@@ -563,6 +563,7 @@
 	struct raid1_bh * r1_bh;
 	int disks = MD_SB_DISKS;
 	int i, sum_bhs = 0;
+	int operational_mirrors;
 	struct mirror_info *mirror;
 
 	if (!buffer_locked(bh))
@@ -592,6 +593,13 @@
 			set_bit(R1BH_SyncPhase, &r1_bh->state);
 	}
 	spin_unlock_irq(&conf->segment_lock);
+
+	for (operational_mirrors = 0, i = 0; i < disks; i++) {
+		if (conf->mirrors[i].operational) {
+			operational_mirrors++;
+		}
+	}
+
 	
 	/*
 	 * i think the read and write branch should be separated completely,
@@ -614,6 +622,7 @@
 		bh_req->b_blocknr = bh->b_rsector;
 		bh_req->b_dev = mirror->dev;
 		bh_req->b_rdev = mirror->dev;
+		bh_req->b_state |= operational_mirrors > 1 ? (1<<BH_FastFail) : 0;
 	/*	bh_req->b_rsector = bh->n_rsector; */
 		bh_req->b_end_io = raid1_end_request;
 		bh_req->b_private = r1_bh;
@@ -661,6 +670,7 @@
 		mbh->b_rsector	  = bh->b_rsector;
 		mbh->b_state      = (1<<BH_Req) | (1<<BH_Dirty) |
 						(1<<BH_Mapped) | (1<<BH_Lock);
+		mbh->b_state |= operational_mirrors > 1 ? (1<<BH_FastFail) : 0;
 
 		atomic_set(&mbh->b_count, 1);
  		mbh->b_size       = bh->b_size;
--- linux/drivers/scsi/Config.in	2003-10-08 15:59:39.000000000 -0700
+++ linux-mdfix/drivers/scsi/Config.in	2003-10-08 15:27:15.000000000 -0700
@@ -28,6 +28,13 @@
   
 bool '  Verbose SCSI error reporting (kernel size +=12K)' CONFIG_SCSI_CONSTANTS
 bool '  SCSI logging facility' CONFIG_SCSI_LOGGING
+bool '  Execute error recovery on I/Os marked FastFail' CONFIG_SCSI_ERROR_RECOVERY_ON_FASTFAIL
+int ' SCSI disk retries for normal requests' CONFIG_SCSI_SD_MAX_RETRIES 5
+int '  SCSI disk I/Os command timeout in jiffies for normal requests' CONFIG_SCSI_SD_TIMEOUT 3000
+int '    SCSI disk I/Os command timeout in jiffies for FastFail requests' CONFIG_SCSI_SD_TIMEOUT_FASTFAIL 25
+int '   SCSI bus reset settle time during error recovery in jiffies' CONFIG_SCSI_BUS_RESET_SETTLE_TIME 500
+int '  SCSI host reset settle time during error recovery in jiffies' CONFIG_SCSI_HOST_RESET_SETTLE_TIME 1000
+
 
 mainmenu_option next_comment
 comment 'SCSI low-level drivers'
--- linux/drivers/scsi/scsi_error.c	2003-10-08 15:59:41.000000000 -0700
+++ linux-mdfix/drivers/scsi/scsi_error.c	2003-10-08 15:20:10.000000000 -0700
@@ -66,9 +66,8 @@
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
  */
-#define BUS_RESET_SETTLE_TIME   5*HZ
-#define HOST_RESET_SETTLE_TIME  10*HZ
-
+#define BUS_RESET_SETTLE_TIME   CONFIG_SCSI_BUS_RESET_SETTLE_TIME
+#define HOST_RESET_SETTLE_TIME  CONFIG_SCSI_HOST_RESET_SETTLE_TIME
 
 static const char RCSid[] = "$Header: /cvsdev/hhl-kernel-campbell/linux/drivers/scsi/scsi_error.c,v 1.2 2002/04/01 00:59:20 jpuhlman Exp $";
 
@@ -236,9 +235,23 @@
 		panic("Error handler thread not present at %p %p %s %d", 
 		      SCpnt, SCpnt->host, __FILE__, __LINE__);
 	}
+	
+/*
+ * It is desireable on FibreChannel not to execute
+ * error recovery (unjam_host) on I/O failures because
+ * of the time expensive LIP Reset.
+ */
+#ifdef CONFIG_SCSI_ERROR_RECOVERY_ON_FASTFAIL
 	if (SCpnt->host->host_busy == SCpnt->host->host_failed) {
 		up(SCpnt->host->eh_wait);
 	}
+#else /* CONFIG_SCSI_ERROR_RECOVERY_ON_FASTFAIL */
+	if ((SCpnt->request.bh->b_state & (1<<BH_FastFail)) == 0) {
+		if (SCpnt->host->host_busy == SCpnt->host->host_failed) {
+			up(SCpnt->host->eh_wait);
+		}
+	}
+#endif /* CONFIG_SCSI_ERROR_RECOVERY_ON_FASTFAIL */
 }
 
 /*
--- linux/drivers/scsi/sd.c	2003-10-08 15:59:42.000000000 -0700
+++ linux-mdfix/drivers/scsi/sd.c	2003-10-08 15:26:57.000000000 -0700
@@ -76,13 +76,14 @@
 #define N_USED_SCSI_DISKS  (sd_template.dev_max + SCSI_DISKS_PER_MAJOR - 1)
 #define N_USED_SD_MAJORS   (N_USED_SCSI_DISKS / SCSI_DISKS_PER_MAJOR)
 
-#define MAX_RETRIES 5
+#define MAX_RETRIES CONFIG_SCSI_SD_MAX_RETRIES
 
 /*
- *  Time out in seconds for disks and Magneto-opticals (which are slower).
+ *  Time out in jiffies for disks and Magneto-opticals (which are slower).
  */
 
-#define SD_TIMEOUT (30 * HZ)
+#define SD_TIMEOUT_FASTFAIL CONFIG_SCSI_SD_TIMEOUT_FASTFAIL
+#define SD_TIMEOUT CONFIG_SCSI_SD_TIMEOUT
 #define SD_MOD_TIMEOUT (75 * HZ)
 
 struct hd_struct *sd;
@@ -416,9 +417,14 @@
 	SCpnt->transfersize = dpnt->device->sector_size;
 	SCpnt->underflow = this_count << 9;
 
-	SCpnt->allowed = MAX_RETRIES;
-	SCpnt->timeout_per_command = (SCpnt->device->type == TYPE_DISK ?
-				      SD_TIMEOUT : SD_MOD_TIMEOUT);
+	if (SCpnt->request.bh->b_state & (1<<BH_FastFail)) {
+		SCpnt->allowed = 0;
+		SCpnt->timeout_per_command = SD_TIMEOUT_FASTFAIL;
+	} else {
+		SCpnt->allowed = MAX_RETRIES;
+		SCpnt->timeout_per_command = (SCpnt->device->type == TYPE_DISK ?
+					      SD_TIMEOUT : SD_MOD_TIMEOUT);
+	}
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
--- linux/include/linux/fs.h	2003-10-08 15:59:43.000000000 -0700
+++ linux-mdfix/include/linux/fs.h	2003-10-08 10:44:08.000000000 -0700
@@ -236,6 +236,7 @@
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
 			 */
+	BH_FastFail,
 };
 
 /*
--- linux/Documentation/Configure.help	2003-08-08 15:56:10.000000000 -0700
+++ linux-mdfix/Documentation/Configure.help	2003-10-08 18:07:29.000000000 -0700
@@ -2446,6 +2446,55 @@
 CONFIG_MIPS_GT96100ETH
   Say Y here to support the Ethernet subsystem on your GT96100 card.
 
+Execute error recovery on I/O's marked FastFail
+CONFIG_SCSI_ERROR_RECOVERY_ON_FASTFAIL
+  The MD layer has been enhanced to support a FASTFAIL flag.  The
+  fastfail flag is a hint from the MD layer to the SCSI layer not
+  to retry I/O requests and shorten I/O timeouts when an array
+  is operating in a redundant mode.
+
+  The default behavior avoids error recovery on FASTFAIL I/Os
+  because the error recovery time would introduce I/O latency
+  when a redundant I/O path is available.
+
+  Configuring this option to execute error recovery on FASTFAIL
+  I/O failure by resetting the device, the bus, and the host adaptor.
+
+  I/Os that are not marked FASTFAIL will use the standard error
+  recovery mechanisms.
+
+SCSI disk retries for normal requests
+CONFIG_SCSI_SD_MAX_RETRIES
+  Normal requests will retry I/O's when an I/O fails in an adaptor.
+  This value sets the number of retries tried before giving up and
+  returning an error from the SCSI layer to the higher level I/O
+  layer.
+
+SCSI disk I/Os command timeout in jiffies for normal requests
+CONFIG_SCSI_SD_TIMEOUT
+  Normal requests will time out requests according to this value.
+  Once the request is timed out, it will be retried according
+  to the retry count.
+
+SCSI disk I/Os command timeout in jiffies for FastFail requests
+CONFIG_SCSI_SD_TIMEOUT_FASTFAIL
+  FASTFAIL requests are those requests issued by the MD layer
+  from a redundant array.  FASTFAIL requests will time out at
+  a rate configured by this value.  Also, when a FASTFAIL request
+  is issued, no retries will be attempted.
+
+SCSI bus reset settle time during error recovery in jiffies
+CONFIG_SCSI_BUS_RESET_SETTLE_TIME
+  After a SCSI bus reset during SCSI error handling, the bus
+  is unavailable for the settle time specified by this value.  This
+  provides time for the bus to enter a known good state.
+
+SCSI host reset settle time during error recovery in jiffies
+CONFIG_SCSI_HOST_RESET_SETTLE_TIME
+  After a SCSI host reset during SCSI error handling, the adaptor
+  is unavailable for the settle time specified by this value.  This
+  provides time for the adaptor to enter a known good state.
+
 Zalon SCSI support
 CONFIG_SCSI_ZALON
   The Zalon is an interface chip that sits between the PA-RISC

--=-3hvxIMABhPMx88GxVqQt--

