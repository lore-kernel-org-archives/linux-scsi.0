From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_mid_low_api.txt in lk 2.5.69
Date: Sun, 18 May 2003 11:29:06 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC6E1E2.90801@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040701030600030501060409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:55825 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261916AbTERBPg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 21:15:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

This is a multi-part message in MIME format.
--------------040701030600030501060409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This is a catch up, applying the patch that Andries
Brouwer sent a while back. It will apply to lk 2.5.69
and 2.5.69-bk10 .

Other people who change this interface feel free to send
patches to James :-)

Doug Gilbert

--------------040701030600030501060409
Content-Type: text/plain;
 name="scsi_mid_low_api_2569.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_mid_low_api_2569.diff"

--- scsi_mid_low_api.txt	2003-05-05 14:03:22.000000000 +1000
+++ scsi_mid_low_api.txt030429	2003-04-29 09:34:05.000000000 +1000
@@ -22,7 +22,10 @@
 a SCSI host and a PCI device is common but not required (e.g. with
 ISA or MCA adapters).]
 
-This version of the document roughly matches linux kernel version 2.5.67 .
+This version of the document roughly matches linux kernel version 2.5.68 .
+This document can be found in the Linux kernel source Documentation/scsi
+directory and is called scsi_mid_low_api.txt . A more recent copy may
+be found at http://www.torque.net/scsi/scsi_mid_low_api.txt.gz .
 
 Documentation
 =============
@@ -142,13 +145,14 @@
                     slave_configure() -->  scsi_adjust_queue_depth()
 			 |
 		    slave_alloc()
-                    slave_configure() -->  scsi_adjust_queue_depth()
+                    slave_configure()
 			 |
 		    slave_alloc()   **
                     slave_destroy() **
 
-The invocation of scsi_adjust_queue_depth() by the LLD is required
-if slave_configure() is supplied.
+If the LLD wants to adjust the default queue settings, it can invoke
+scsi_adjust_queue_depth() in its slave_configure() routine.
+
 ** For scsi devices that the mid level tries to scan but do not
    respond, a slave_alloc(), slave_destroy() pair is called.
 
@@ -179,7 +183,7 @@
 scsi_add_device()  ------+
                          |
 		    slave_alloc()
-                    slave_configure() -->  scsi_adjust_queue_depth()
+                    slave_configure()   [--> scsi_adjust_queue_depth()]
 
 [DEVICE unplug]
 LLD                      mid level                 LLD
@@ -228,13 +232,14 @@
 		      slave_destroy() **
                             |
 		      slave_alloc()
-                      slave_configure()  -->  scsi_adjust_queue_depth()
+                      slave_configure()
 		      slave_alloc()   **
 		      slave_destroy() **
 
-If the LLD does not supply a slave_configure() then the mid level invokes
-scsi_adjust_queue_depth() itself with tagged queuing off and "cmd_per_lun"
-for that host as the queue length.
+The mid level invokes scsi_adjust_queue_depth() with tagged queuing off and
+"cmd_per_lun" for that host as the queue length. These settings can be
+overridden by a slave_configure() supplied by the LLD.
+
 ** For scsi devices that the mid level tries to scan but do not
    respond, a slave_alloc(), slave_destroy() pair is called.
 
@@ -1093,11 +1098,6 @@
  *      Notes: Allows the driver to inspect the response to the initial
  *	INQUIRY done by the scanning code and take appropriate action.
  *	For more details see the hosts.h file.
- *	If this function is not supplied, the mid level will call
- *	scsi_adjust_queue_depth() with the struct Scsi_Host::cmd_per_lun
- *	value on behalf of the given device. If this function is
- *	supplied then its implementation must call
- *	scsi_adjust_queue_depth(). 	
  *
  *	Defined in: LLD
  **/
@@ -1277,8 +1277,9 @@
         Patrick Mansfield <patmans@us.ibm.com> 
 	Christoph Hellwig <hch@infradead.org>
 	Doug Ledford <dledford@redhat.com>
+        Andries Brouwer <Andries.Brouwer@cwi.nl>
 
 
 Douglas Gilbert
 dgilbert@interlog.com
-19th April 2003
+29th April 2003

--------------040701030600030501060409--

