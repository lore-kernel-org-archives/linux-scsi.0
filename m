From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Mention scsi_scan_host() in scsi_mid_low_api.txt
Date: Thu, 10 Nov 2005 07:45:55 -0700
Message-ID: <20051110144555.GD1736@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:23711 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750967AbVKJOp4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 09:45:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update to mention scsi_scan_host()

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff -u -p -r1.13 scsi_mid_low_api.txt
--- a/Documentation/scsi/scsi_mid_low_api.txt	14 Sep 2005 12:53:54 -0000	1.13
+++ b/Documentation/scsi/scsi_mid_low_api.txt	10 Nov 2005 14:20:42 -0000
@@ -150,7 +150,8 @@ scsi devices of which only the first 2 r
 LLD                   mid level                    LLD
 ===-------------------=========--------------------===------
 scsi_host_alloc()  -->
-scsi_add_host()  --------+
+scsi_add_host()  ---->
+scsi_scan_host()  -------+
                          |
                     slave_alloc()
                     slave_configure() -->  scsi_adjust_queue_depth()
@@ -196,7 +197,7 @@ of the issues involved. See the section 
 
 
 The hotplug concept may be extended to SCSI devices. Currently, when an
-HBA is added, the scsi_add_host() function causes a scan for SCSI devices
+HBA is added, the scsi_scan_host() function causes a scan for SCSI devices
 attached to the HBA's SCSI transport. On newer SCSI transports the HBA
 may become aware of a new SCSI device _after_ the scan has completed.
 An LLD can use this sequence to make the mid level aware of a SCSI device:
@@ -372,7 +373,7 @@ names all start with "scsi_".
 Summary:
    scsi_activate_tcq - turn on tag command queueing
    scsi_add_device - creates new scsi device (lu) instance
-   scsi_add_host - perform sysfs registration and SCSI bus scan.
+   scsi_add_host - perform sysfs registration and set up transport class
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
    scsi_assign_lock - replace default host_lock with given lock
    scsi_bios_ptable - return copy of block device's partition table
@@ -386,6 +387,7 @@ Summary:
    scsi_remove_device - detach and remove a SCSI device
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
+   scsi_scan_host - scan SCSI bus
    scsi_track_queue_full - track successive QUEUE_FULL events 
    scsi_unblock_requests - allow further commands to be queued to given host
    scsi_unregister - [calls scsi_host_put()]
@@ -425,10 +427,10 @@ void scsi_activate_tcq(struct scsi_devic
  *      Might block: yes
  *
  *      Notes: This call is usually performed internally during a scsi
- *      bus scan when an HBA is added (i.e. scsi_add_host()). So it
+ *      bus scan when an HBA is added (i.e. scsi_scan_host()). So it
  *      should only be called if the HBA becomes aware of a new scsi
- *      device (lu) after scsi_add_host() has completed. If successful
- *      this call we lead to slave_alloc() and slave_configure() callbacks
+ *      device (lu) after scsi_scan_host() has completed. If successful
+ *      this call can lead to slave_alloc() and slave_configure() callbacks
  *      into the LLD.
  *
  *      Defined in: drivers/scsi/scsi_scan.c
@@ -439,7 +441,7 @@ struct scsi_device * scsi_add_device(str
 
 
 /**
- * scsi_add_host - perform sysfs registration and SCSI bus scan.
+ * scsi_add_host - perform sysfs registration and set up transport class
  * @shost:   pointer to scsi host instance
  * @dev:     pointer to struct device of type scsi class
  *
@@ -448,7 +450,11 @@ struct scsi_device * scsi_add_device(str
  *      Might block: no
  *
  *      Notes: Only required in "hotplug initialization model" after a
- *      successful call to scsi_host_alloc().
+ *      successful call to scsi_host_alloc().  This function does not
+ *	scan the bus; this can be done by calling scsi_scan_host() or
+ *	in some other transport-specific way.  The LLD must set up
+ *	the transport template before calling this function and may only
+ *	access the transport class data after this function has been called.
  *
  *      Defined in: drivers/scsi/hosts.c
  **/
@@ -559,7 +565,7 @@ void scsi_deactivate_tcq(struct scsi_dev
  *      area for the LLD's exclusive use.
  *      Both associated refcounting objects have their refcount set to 1.
  *      Full registration (in sysfs) and a bus scan are performed later when
- *      scsi_add_host() is called.
+ *      scsi_add_host() and scsi_scan_host() are called.
  *
  *      Defined in: drivers/scsi/hosts.c .
  **/
@@ -696,6 +702,19 @@ int scsi_remove_host(struct Scsi_Host *s
  *      Defined in: drivers/scsi/scsi_error.c .
  **/
 void scsi_report_bus_reset(struct Scsi_Host * shost, int channel)
+
+
+/**
+ * scsi_scan_host - scan SCSI bus
+ * @shost: a pointer to a scsi host instance
+ *
+ *	Might block: yes
+ *
+ *	Notes: Should be called after scsi_add_host()
+ *
+ *	Defined in: drivers/scsi/scsi_scan.c
+ **/
+void scsi_scan_host(struct Scsi_Host *shost)
 
 
 /**
