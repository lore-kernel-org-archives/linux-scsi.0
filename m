From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_mid_low_api.txt update
Date: Tue, 21 Sep 2004 12:37:02 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414F93CE.40905@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030103070204090804020908"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:4482 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267400AbUIUGkB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 02:40:01 -0400
Received: from [192.168.48.80] (dsl-46.128.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.128.46])
	by borg.st.net.au (Postfix) with ESMTP id DC3B53944AD
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2004 16:39:58 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030103070204090804020908
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Changes:
    - initiator device -> initiator port
    - add scsi_activate_tcq() + scsi_deactivate_tcq()

Doug Gilbert

--------------030103070204090804020908
Content-Type: text/x-patch;
 name="scsi_mid_low_api269rc2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_mid_low_api269rc2.diff"

--- linux/Documentation/scsi/scsi_mid_low_api.txt	2004-09-14 09:51:04.000000000 +1000
+++ linux/Documentation/scsi/scsi_mid_low_api.txt269rc2add	2004-09-21 12:24:17.397103864 +1000
@@ -8,11 +8,11 @@
 SCSI lower level drivers. Lower level drivers (LLDs) are variously called 
 host bus adapter (HBA) drivers and host drivers (HD). A "host" in this
 context is a bridge between a computer IO bus (e.g. PCI or ISA) and a
-single SCSI initiator device on a SCSI transport. An "initiator" device
-(SCSI terminology) sends SCSI commands to "target" SCSI devices (e.g.
-disks). There can be many LLDs in a running system, but only one per
-hardware type. Most LLDs can control one or more SCSI HBAs. Some HBAs 
-contain multiple hosts.
+single SCSI initiator port on a SCSI transport. An "initiator" port
+(SCSI terminology, see SAM-3 at http://www.t10.org) sends SCSI commands
+to "target" SCSI ports (e.g. disks). There can be many LLDs in a running
+system, but only one per hardware type. Most LLDs can control one or more
+SCSI HBAs. Some HBAs contain multiple hosts.
 
 In some cases the SCSI transport is an external bus that already has
 its own subsystem in Linux (e.g. USB and ieee1394). In such cases the
@@ -370,6 +370,7 @@
 names all start with "scsi_".
 
 Summary:
+   scsi_activate_tcq - turn on tag command queueing
    scsi_add_device - creates new scsi device (lu) instance
    scsi_add_host - perform sysfs registration and SCSI bus scan.
    scsi_add_timer - (re-)start timer on a SCSI command.
@@ -377,6 +378,7 @@
    scsi_assign_lock - replace default host_lock with given lock
    scsi_bios_ptable - return copy of block device's partition table
    scsi_block_requests - prevent further commands being queued to given host
+   scsi_deactivate_tcq - turn off tag command queueing
    scsi_delete_timer - cancel timer on a SCSI command.
    scsi_host_alloc - return a new scsi_host instance whose refcount==1
    scsi_host_get - increments Scsi_Host instance's refcount
@@ -397,6 +399,24 @@
 Details:
 
 /**
+ * scsi_activate_tcq - turn on tag command queueing ("ordered" task attribute)
+ * @sdev:       device to turn on TCQ for
+ * @depth:      queue depth
+ *
+ *      Returns nothing
+ *
+ *      Might block: no
+ *
+ *      Notes: Eventually, it is hoped depth would be the maximum depth
+ *      the device could cope with and the real queue depth
+ *      would be adjustable from 0 to depth.
+ *
+ *      Defined (inline) in: include/scsi/scsi_tcq.h
+ **/
+void scsi_activate_tcq(struct scsi_device *sdev, int depth)
+
+
+/**
  * scsi_add_device - creates new scsi device (lu) instance
  * @shost:   pointer to scsi host instance
  * @channel: channel number (rarely other than 0)
@@ -462,10 +482,10 @@
 
 
 /**
- * scsi_adjust_queue_depth - change the queue depth on a SCSI device
+ * scsi_adjust_queue_depth - allow LLD to change queue depth on a SCSI device
  * @sdev:       pointer to SCSI device to change queue depth on
  * @tagged:     0 - no tagged queuing
- *              MSG_SIMPLE_TAG - simple (unordered) tagged queuing
+ *              MSG_SIMPLE_TAG - simple tagged queuing
  *              MSG_ORDERED_TAG - ordered tagged queuing
  * @tags        Number of tags allowed if tagged queuing enabled,
  *              or number of commands the LLD can queue up
@@ -479,7 +499,7 @@
  *      LLD. [Specifically during and after slave_configure() and prior to
  *      slave_destroy().] Can safely be invoked from interrupt code. Actual
  *      queue depth change may be delayed until the next command is being
- *      processed.
+ *      processed. See also scsi_activate_tcq() and scsi_deactivate_tcq().
  *
  *      Defined in: drivers/scsi/scsi.c [see source code for more notes]
  *
@@ -535,6 +555,20 @@
 
 
 /**
+ * scsi_deactivate_tcq - turn off tag command queueing
+ * @sdev:       device to turn off TCQ for
+ * @depth:      queue depth (stored in sdev)
+ *
+ *      Returns nothing
+ *
+ *      Might block: no
+ *
+ *      Defined (inline) in: include/scsi/scsi_tcq.h
+ **/
+void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
+
+
+/**
  * scsi_delete_timer - cancel timer on a SCSI command.
  * @scmd:    pointer to scsi command instance
  *
@@ -1515,4 +1549,4 @@
 
 Douglas Gilbert
 dgilbert at interlog dot com
-25th August 2004
+21st September 2004

--------------030103070204090804020908--

