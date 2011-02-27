From: <Menny_Hamburger@Dell.com>
Subject: [PATCH] sd: sd should not modify read capacity, cache type or write
 protect flag on rescan when there is a transport error
Date: Sun, 27 Feb 2011 14:21:58 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:38217 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1B0OWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2011 09:22:02 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Menny Hamburger <Menny_Hamburger@Dell.com>

When sd scan fails in apprehending capacity, cache_type or write protect flag
property from the device, it automatically assigns a default value to the
failed property. When rescanning, in case of transport/host error, this default 
value is invalid since the problem is with the connection to the device and not in 
the device itself that may (in most cases) still be intact. Applying a default value
when failing may lead to problems when connection is re-established since the default
value persists unless an additional rescan is performed.

This problem was witnessed when running in a iSCSI environment under multipath
(with I/O on the active path). In this case we get a ping-ping effect where
multipathd switches between alternate paths forever (until rescan) because the
path checker states that the device is OK, and I/O fails immediately because of
the 0 capacity (assigned to the device when rescanning while the device was 
disconnected from the storage).

Reproduction over ISCSI environment:
1) dd if=/dev/dm-0 of=/dev/zero bs=64 count=10000
2) ifdown ethN, ethM, ethK, ... (where ethX is an interface from which the
   machine establishes connection to the storage array).
3) iscsiadm -m session -R
4) ifup ethN, ethM, ethK, ...

The following patch leaves the capacity, cache type and write protect flag unchanged on a host/transport problem. 
I want to thank  Mike Cristie (mchristi@redhat.com) for helping out with this one.

diff -r -U 2 a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c    2011-02-27 11:57:52.159333000 +0200
+++ b/drivers/scsi/sd.c    2011-02-27 11:57:52.222659000 +0200
@@ -1502,10 +1502,16 @@
          set_media_not_present(sdkp);

-    /*
-    * We used to set media_present to 0 here to indicate no media
-    * in the drive, but some drives fail read capacity even with
-    * media present, so we can't do that.
-    */
-    sdkp->capacity = 0; /* unknown mapped to zero - as usual */
+    if (host_byte(the_result) && !sdkp->first_scan)
+          sd_printk(KERN_NOTICE, sdkp, "host error while reading capacity\n");
+    else {
+          /*
+          * We used to set media_present to 0 here to indicate no media
+          * in the drive, but some drives fail read capacity even with
+          * media present, so we can't do that.
+          */
+          sdkp->capacity = 0; /* unknown mapped to zero - as usual */
+    }
+
+    sd_printk(KERN_NOTICE, sdkp, "assuming capacity %llu.\n", sdkp->capacity);
}

@@ -1878,6 +1884,11 @@

     if (!scsi_status_is_good(res)) {
-          sd_printk(KERN_WARNING, sdkp,
-                 "Test WP failed, assume Write Enabled\n");
+          if (host_byte(res) && !sdkp->first_scan) {
+               sd_printk(KERN_NOTICE, sdkp, "host error while reading write protect flag\n");
+               set_disk_ro(sdkp->disk, sdkp->write_prot);
+          }
+
+          sd_printk(KERN_WARNING, sdkp, 
+                 "Test WP failed, assume Write %s\n", (sdkp->write_prot) ? "Disabled" : "Enabled");
    } else {
          sdkp->write_prot = ((data.device_specific & 0x80) != 0);
@@ -2034,8 +2045,14 @@

 defaults:
-    sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
-    sdkp->WCE = 0;
-    sdkp->RCD = 0;
-    sdkp->DPOFUA = 0;
+    if (host_byte(res) && !sdkp->first_scan) 
+          sd_printk(KERN_NOTICE, sdkp, "host error while reading cache type\n");
+    else {
+          sdkp->WCE = 0;
+          sdkp->RCD = 0;
+          sdkp->DPOFUA = 0;
+    }
+
+    sd_printk(KERN_ERR, sdkp, "Assuming drive cache: %s\n", 
+            sd_cache_types[sdkp->RCD + 2*sdkp->WCE]);
}


