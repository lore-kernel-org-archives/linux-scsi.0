From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] scsi_mid_low_api doesn't mention scsi_scan_host
Date: Mon, 21 Mar 2005 13:43:15 +0000
Message-ID: <20050321134315.GR21986@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38884 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261786AbVCUNnY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 08:43:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org


scsi_mid_low_api doesn't seem to have been updated for the scsi_add_host /
scsi_scan_host split.  Here's a patch.

diff -u -p -r1.9 scsi_mid_low_api.txt
--- ./Documentation/scsi/scsi_mid_low_api.txt	12 Jan 2005 20:14:58 -0000	1.9
+++ ./Documentation/scsi/scsi_mid_low_api.txt	21 Mar 2005 13:17:39 -0000
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
    scsi_add_timer - (re-)start timer on a SCSI command.
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
    scsi_assign_lock - replace default host_lock with given lock
@@ -388,6 +389,7 @@ Summary:
    scsi_remove_device - detach and remove a SCSI device
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
+   scsi_scan_host - scan SCSI bus
    scsi_set_device - place device reference in host structure
    scsi_to_pci_dma_dir - convert SCSI subsystem direction flag to PCI
    scsi_to_sbus_dma_dir - convert SCSI subsystem direction flag to SBUS
@@ -430,10 +432,10 @@ void scsi_activate_tcq(struct scsi_devic
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
@@ -444,7 +446,7 @@ struct scsi_device * scsi_add_device(str
 
 
 /**
- * scsi_add_host - perform sysfs registration and SCSI bus scan.
+ * scsi_add_host - perform sysfs registration and set up transport class
  * @shost:   pointer to scsi host instance
  * @dev:     pointer to struct device of type scsi class
  *
@@ -453,7 +455,10 @@ struct scsi_device * scsi_add_device(str
  *      Might block: no
  *
  *      Notes: Only required in "hotplug initialization model" after a
- *      successful call to scsi_host_alloc().
+ *      successful call to scsi_host_alloc().  The LLD must call
+ *	scsi_scan_host() in order to scan the bus.  The LLD must set up
+ *	the transport template before calling this function and may only
+ *	access the transport class data after this function has been called.
  *
  *      Defined in: drivers/scsi/hosts.c
  **/
@@ -603,7 +608,7 @@ int scsi_delete_timer(struct scsi_cmnd *
  *      area for the LLD's exclusive use.
  *      Both associated refcounting objects have their refcount set to 1.
  *      Full registration (in sysfs) and a bus scan are performed later when
- *      scsi_add_host() is called.
+ *      scsi_add_host() and scsi_scan_host() are called.
  *
  *      Defined in: drivers/scsi/hosts.c .
  **/
@@ -740,6 +745,19 @@ int scsi_remove_host(struct Scsi_Host *s
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

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
