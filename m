From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_mid_low_api doesn't mention scsi_scan_host
Date: Thu, 24 Mar 2005 18:45:40 +1000
Message-ID: <42427E34.6060308@torque.net>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AF54@xbl3.ad.emulex.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070904010005070900090603"
Received: from zorg.st.net.au ([203.16.233.9]:17885 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262434AbVCXIoZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2005 03:44:25 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AF54@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: matthew@wil.cx, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070904010005070900090603
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit

James.Smart@Emulex.Com wrote:
>>Thanks for the correction.  How does this look?
>>
>> *      Notes: Only required in "hotplug initialization model" after a
>> *      successful call to scsi_host_alloc().  This function does not
>> *      scan the bus; this can be done by calling scsi_scan_host() or
>> *      in some other transport-specific way.  The LLD must set up
>> *      the transport template before calling this function 
>>and may only
>> *      access the transport class data after this function 
>>has been called.
> 
> 
> a work of art :)

So attached is Matthew's patch plus the above change
diffed against lk 2.6.11


Signed-off-by: Douglas Gilbert <dougg@torque.net>



--------------070904010005070900090603
Content-Type: text/x-patch;
 name="scsi_mid_low_api2611mw.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_mid_low_api2611mw.diff"

--- linux/Documentation/scsi/scsi_mid_low_api.txt	2005-03-03 07:48:09.000000000 +1000
+++ linux/Documentation/scsi/scsi_mid_low_api.txt2611mw	2005-03-24 18:41:43.000000000 +1000
@@ -150,7 +150,8 @@
 LLD                   mid level                    LLD
 ===-------------------=========--------------------===------
 scsi_host_alloc()  -->
-scsi_add_host()  --------+
+scsi_add_host()  ---->
+scsi_scan_host()  -------+
                          |
                     slave_alloc()
                     slave_configure() -->  scsi_adjust_queue_depth()
@@ -196,7 +197,7 @@
 
 
 The hotplug concept may be extended to SCSI devices. Currently, when an
-HBA is added, the scsi_add_host() function causes a scan for SCSI devices
+HBA is added, the scsi_scan_host() function causes a scan for SCSI devices
 attached to the HBA's SCSI transport. On newer SCSI transports the HBA
 may become aware of a new SCSI device _after_ the scan has completed.
 An LLD can use this sequence to make the mid level aware of a SCSI device:
@@ -372,7 +373,7 @@
 Summary:
    scsi_activate_tcq - turn on tag command queueing
    scsi_add_device - creates new scsi device (lu) instance
-   scsi_add_host - perform sysfs registration and SCSI bus scan.
+   scsi_add_host - perform sysfs registration and set up transport class
    scsi_add_timer - (re-)start timer on a SCSI command.
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
    scsi_assign_lock - replace default host_lock with given lock
@@ -388,6 +389,7 @@
    scsi_remove_device - detach and remove a SCSI device
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
+   scsi_scan_host - scan SCSI bus
    scsi_set_device - place device reference in host structure
    scsi_to_pci_dma_dir - convert SCSI subsystem direction flag to PCI
    scsi_to_sbus_dma_dir - convert SCSI subsystem direction flag to SBUS
@@ -430,10 +432,10 @@
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
@@ -444,7 +446,7 @@
 
 
 /**
- * scsi_add_host - perform sysfs registration and SCSI bus scan.
+ * scsi_add_host - perform sysfs registration and set up transport class
  * @shost:   pointer to scsi host instance
  * @dev:     pointer to struct device of type scsi class
  *
@@ -453,7 +455,11 @@
  *      Might block: no
  *
  *      Notes: Only required in "hotplug initialization model" after a
- *      successful call to scsi_host_alloc().
+ *      successful call to scsi_host_alloc().  This function does not
+ *      scan the bus; this can be done by calling scsi_scan_host() or
+ *      in some other transport-specific way.  The LLD must set up
+ *      the transport template before calling this function and may only
+ *      access the transport class data after this function has been called.
  *
  *      Defined in: drivers/scsi/hosts.c
  **/
@@ -603,7 +609,7 @@
  *      area for the LLD's exclusive use.
  *      Both associated refcounting objects have their refcount set to 1.
  *      Full registration (in sysfs) and a bus scan are performed later when
- *      scsi_add_host() is called.
+ *      scsi_add_host() and scsi_scan_host() are called.
  *
  *      Defined in: drivers/scsi/hosts.c .
  **/
@@ -743,6 +749,19 @@
 
 
 /**
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
+
+
+/**
  * scsi_set_device - place device reference in host structure
  * @shost: a pointer to a scsi host instance
  * @pdev: pointer to device instance to assign
@@ -1539,8 +1558,9 @@
         Andries Brouwer <Andries dot Brouwer at cwi dot nl>
         Randy Dunlap <rddunlap at osdl dot org>
         Alan Stern <stern at rowland dot harvard dot edu>
+        Matthew Wilcox <matthew at wil dot cx>
 
 
 Douglas Gilbert
 dgilbert at interlog dot com
-21st September 2004
+24th March 2005

--------------070904010005070900090603--
