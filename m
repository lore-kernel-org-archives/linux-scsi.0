From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: [PATCH] improvement of fastfail operation
Date: Wed, 24 Mar 2004 09:38:00 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403240038.AA03092@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:7857 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262942AbUCXAiY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 19:38:24 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i2O0cMvH018889 for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2004 09:38:22 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s5.gw.fujitsu.co.jp by m3.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i2O0cMYx020607 for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2004 09:38:22 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail501.fjmail.jp.fujitsu.com (fjmail501-0.fjmail.jp.fujitsu.com [10.59.80.96]) by s5.gw.fujitsu.co.jp (8.12.10)
	id i2O0cLAb005155 for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2004 09:38:21 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan503-0.fjmail.jp.fujitsu.com [10.59.80.124])
 by fjmail501.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HV2004Z91RW9P@fjmail501.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Wed, 24 Mar 2004 09:38:20 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

We are planning to use linux for enterprise server.
Since the reliability of data is important factor, this server has RAID
or clustering system.
Also, this server needs quick response to host(< 30sec) even if device/
path error occurs.

We are planning to use fastfail flag for this purpose.
We reviewed the sequence of fastfail, but the operation is inadequate for
some error cases(mainly command timeout).

We propose the following improvements for fastfail.

1.Validate fastfail flag for command timeout.
  Currently fastfail flag is not valid for command timeout and repeats
  4 times.
2.Set timeout value to 10sec.
  Currently timeout value is set to 30sec.
3.Set wait time for bus reset/host reset to 5sec.
  Currently wait time is set to 10sec.
  (In many cases, abort task command fails for command timeout and it needs
  bus reset or host reset operation)

Each timeout values come from:
  timeout(10sec)+Abort/Bus reset(5sec+)+alt retry timeout(10sec) < 30sec

This is one idea for quick response on device/path error.
If you have any comments or idea for this improvements, please let me know.

Thanks,
Masao Fukuchi

diff -urN linux-2.6.4/drivers/scsi/scsi_error.c linux-2.6.4FF/drivers/scsi/scsi_error.c
--- linux-2.6.4/drivers/scsi/scsi_error.c       2004-02-18 12:57:12.000000000 +0900
+++ linux-2.6.4FF/drivers/scsi/scsi_error.c     2004-03-18 16:59:50.000000000 +0900
@@ -43,6 +43,8 @@
  */
 #define BUS_RESET_SETTLE_TIME   10*HZ
 #define HOST_RESET_SETTLE_TIME  10*HZ
+#define BUS_RESET_SETTLE_TIME_FAST   5*HZ
+#define HOST_RESET_SETTLE_TIME_FAST  5*HZ

 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
@@ -909,7 +911,10 @@
        spin_unlock_irqrestore(scmd->device->host->host_lock, flags);

        if (rtn == SUCCESS) {
-               scsi_sleep(BUS_RESET_SETTLE_TIME);
+               if (blk_noretry_request(scmd->request))
+                       scsi_sleep(BUS_RESET_SETTLE_TIME_FAST);
+               else
+                       scsi_sleep(BUS_RESET_SETTLE_TIME);
                spin_lock_irqsave(scmd->device->host->host_lock, flags);
                scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
                spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
@@ -940,7 +945,10 @@
        spin_unlock_irqrestore(scmd->device->host->host_lock, flags);

        if (rtn == SUCCESS) {
-               scsi_sleep(HOST_RESET_SETTLE_TIME);
+               if (blk_noretry_request(scmd->request))
+                       scsi_sleep(HOST_RESET_SETTLE_TIME_FAST);
+               else
+                       scsi_sleep(HOST_RESET_SETTLE_TIME);
                spin_lock_irqsave(scmd->device->host->host_lock, flags);
                scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
                spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
@@ -1421,7 +1429,8 @@
                scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
                list_del_init(lh);
                if (scmd->device->online &&
-                       (++scmd->retries < scmd->allowed)) {
+                       (++scmd->retries < scmd->allowed) &&
+                       (!blk_noretry_request(scmd->request))) {
                        SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
                                                          " retry cmd: %p\n",
                                                          current->comm,
diff -urN linux-2.6.4/drivers/scsi/sd.c linux-2.6.4FF/drivers/scsi/sd.c
--- linux-2.6.4/drivers/scsi/sd.c       2004-03-18 16:12:01.000000000 +0900
+++ linux-2.6.4FF/drivers/scsi/sd.c     2004-03-18 17:14:36.000000000 +0900
@@ -67,6 +67,7 @@
  * Time out in seconds for disks and Magneto-opticals (which are slower).
  */
 #define SD_TIMEOUT             (30 * HZ)
+#define SD_TIMEOUT_FAST         (10 * HZ)
 #define SD_MOD_TIMEOUT         (75 * HZ)

 /*
@@ -178,7 +179,10 @@
        sector_t block;
        struct scsi_device *sdp = SCpnt->device;

-       timeout = SD_TIMEOUT;
+        if (blk_noretry_request(SCpnt->request))
+               timeout = SD_TIMEOUT_FAST;
+        else
+               timeout = SD_TIMEOUT;
        if (SCpnt->device->type != TYPE_DISK)
                timeout = SD_MOD_TIMEOUT;
