From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_mid_low_api.txt against 2.5.62-bk3
Date: Fri, 21 Feb 2003 15:47:14 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E55AF52.2040606@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010206050808030702050205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-52.triode.net.au [202.147.125.52])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h1L4i3VY006678
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2003 15:44:04 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010206050808030702050205
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is an update for this document following on from
the changes that Christoph made around bk2 (changing
scsi_set_pci_device() to scsi_set_device() ).

Doug Gilbert

--------------010206050808030702050205
Content-Type: text/plain;
 name="scsi_mid_low_api_2562bk3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_mid_low_api_2562bk3.diff"

--- linux/Documentation/scsi/scsi_mid_low_api.txt	2003-02-21 14:42:15.000000000 +1100
+++ linux/Documentation/scsi/scsi_mid_low_api.txt2562bk3pl	2003-02-21 14:44:33.000000000 +1100
@@ -22,13 +22,28 @@
 a SCSI host and a PCI device is common but not required (e.g. with
 ISA or MCA adapters).]
 
+This version of the document roughly matches linux kernel version 2.5.63 .
+
+Documentation
+=============
+There is a SCSI documentation directory within the kernel source tree.
+That directory is typically /usr/src/linux/Documentation/scsi . Most
+documents are in plain (i.e. ASCII) text. This file can be found in that
+directory, named scsi_mid_low_api.txt . Many LLDs are documented there
+(e.g. aic7xxx.txt). The SCSI mid-level is briefly described in scsi.txt
+(with a url to a document describing the SCSI subsystem in the lk 2.4
+series). Two upper level drivers have documents in that directory:
+st.txt (SCSI tape driver) and scsi-generic.txt .
+
+Some documentation (or urls) for LLDs may be in the C source code or
+in the same directory. For example to find a url about the USB mass
+storage driver see the /usr/src/linux/drivers/usb/storage directory.
+
 The Linux kernel source Documentation/DocBook/scsidrivers.tmpl file
 refers to this file. With the appropriate DocBook toolset, this permits
 users to generate html, ps and pdf renderings of information within this
 file (e.g. the interface functions).
 
-This version of the document roughly matches lk 2.5.50 .
-
 Driver structure
 ================
 Traditionally a LLD for the SCSI subsystem has been at least two files in
@@ -100,12 +115,11 @@
 since the effected disk can be "cleaned up" the next time it is seen.
 
 During LLD initialization the driver should register itself with the
-appropriate IO bus that it expects to find HBA(s) (e.g. the PCI bus). This
-can probably be done via sysfs (formerly known as driverfs). Any driver
-parameters (especially those that are writeable after the driver is
-loaded) could also be registered with sysfs at this point. At the end of
-driver initialization the SCSI mid level is typically not aware of its
-presence.
+appropriate IO bus on which it expects to find HBA(s) (e.g. the PCI bus).
+This can probably be done via sysfs. Any driver parameters (especially
+those that are writeable after the driver is loaded) could also be
+registered with sysfs at this point. At the end of driver initialization
+the SCSI mid level is typically not aware of its presence.
 
 At some later time, the LLD becomes aware of a HBA and what follows
 is a typical sequence of calls between the LLD and the mid level.
@@ -149,7 +163,7 @@
 (a pointer is returned by scsi_register() ) and struct scsi_device
 instances (a pointer is passed as the parameter to slave_alloc() and
 slave_configure() ). Both classes of instances are "owned" by the 
-mid-level. struct scsi_devices instances are freed after slave_destroy().
+mid-level. struct scsi_device instances are freed after slave_destroy().
 struct Scsi_Host instances are freed after scsi_unregister().
 
 
@@ -249,6 +263,8 @@
 /**
  * scsi_add_host - perform sysfs registration and SCSI bus scan.
  * @shost:   pointer to scsi host instance
+ * @dev:     pointer to struct device host instance of class type scsi
+ *           (or related)
  *
  *      Returns 0 on success, negative errno of failure (e.g. -ENOMEM)
  *
@@ -256,7 +272,24 @@
  *	successful call to scsi_register().
  *	Defined in drivers/scsi/hosts.c
  **/
-int scsi_add_host(struct Scsi_Host *shost)
+int scsi_add_host(struct Scsi_Host *shost, struct device * dev)
+
+
+/**
+ * scsi_add_timer - (re-)start timer on a SCSI command.
+ * @scmd:    pointer to scsi command instance
+ * @timeout: duration of timeout in "jiffies"
+ * @complete: pointer to function to call if timeout expires
+ *
+ *      Returns nothing
+ *
+ *	Notes: All commands issued by upper levels already have a timeout
+ *	associated with them. A LLD can use this function to change
+ *	the existing timeout value.
+ *	Defined in drivers/scsi/scsi_error.c
+ **/
+void scsi_add_timer(Scsi_Cmnd *scmd, int timeout, void (*complete)
+                    (Scsi_Cmnd *))
 
 
 /**
@@ -322,6 +355,21 @@
 
 
 /**
+ * scsi_delete_timer - cancel timer on a SCSI command.
+ * @scmd:    pointer to scsi command instance
+ *
+ *      Returns 1 if able to cancel timer else 0 (i.e. too late or already
+ *	cancelled).
+ *
+ *	Notes: All commands issued by upper levels already have a timeout
+ *	associated with them. A LLD can use this function to cancel the
+ *	timer.
+ *	Defined in drivers/scsi/scsi_error.c
+ **/
+int scsi_delete_timer(Scsi_Cmnd *scmd)
+
+
+/**
  * scsi_partsize - parse partition table into cylinders, heads + sectors
  * @buf: pointer to partition table
  * @capacity: size of (total) disk in 512 byte sectors
@@ -430,6 +478,26 @@
 
 
 /**
+ * scsi_track_queue_full - track successive QUEUE_FULL events on given
+ *			device to determine if and when there is a need
+ *			to adjust the queue depth on the device.
+ * @SDptr: pointer to SCSI device instance
+ * @depth: Current number of outstanding SCSI commands on this device,
+ *	   not counting the one returned as QUEUE_FULL.
+ *
+ *      Returns 0  - no change needed
+ *		>0 - adjust queue depth to this new depth
+ *		-1 - drop back to untagged operation using host->cmd_per_lun
+ *		     as the untagged command depth
+ *
+ *      Notes: LLDs may call this at any time and we will do "The Right
+ *		Thing"; interrupt context safe. 
+ *		Defined in drivers/scsi/scsi.c .
+ **/
+int scsi_track_queue_full(Scsi_Device *SDptr, int depth)
+
+
+/**
  * scsi_unblock_requests - allow further commands to be queued to given host
  *
  * @SHpnt: pointer to host to unblock commands on
@@ -1008,4 +1076,4 @@
 
 Douglas Gilbert
 dgilbert@interlog.com
-29th November 2002
+21st February 2003

--------------010206050808030702050205--

