From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH] SCSI device/adapter/bus address correlation?
Date: Thu, 2 Sep 2004 17:19:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409021719.15267.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel8.hp.com ([156.153.255.206]:2729 "EHLO atlrel8.hp.com")
	by vger.kernel.org with ESMTP id S269282AbUIBXT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2004 19:19:26 -0400
Received: from smtp2.fc.hp.com (smtp.fc.hp.com [15.15.136.253])
	by atlrel8.hp.com (Postfix) with ESMTP id 8EFB4639B
	for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2004 19:19:17 -0400 (EDT)
Received: from ldl.fc.hp.com (ldl.fc.hp.com [15.11.146.30])
	by smtp2.fc.hp.com (Postfix) with ESMTP id 50ADA41E414
	for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2004 17:19:17 -0600 (MDT)
Received: from localhost (localhost [127.0.0.1])
	by ldl.fc.hp.com (Postfix) with ESMTP id B5D5F1340F2
	for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2004 17:19:16 -0600 (MDT)
Received: from ldl.fc.hp.com ([127.0.0.1])
	by localhost (ldl [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 23296-04 for <linux-scsi@vger.kernel.org>;
	Thu, 2 Sep 2004 17:19:15 -0600 (MDT)
Received: from eeyore.helgaas (lart.fc.hp.com [15.11.146.31])
	by ldl.fc.hp.com (Postfix) with ESMTP id 8BDF21340D4
	for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2004 17:19:15 -0600 (MDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Not being a real SCSI person, I'm sure there's some clever way I'm
supposed to figure out which disk is /dev/sda.  But sometimes it's
not clear from the kernel boot messages, particularly for drivers
that don't print the PCI address of the adapter.

Is there any interest in a patch like the attached, which makes
things look like this:

    Attached scsi disk sda at 0000:20:01.0: scsi0, channel 0, id 0, lun 0
    Attached scsi disk sdb at 0000:20:01.0: scsi0, channel 0, id 1, lun 0


===== drivers/scsi/osst.c 1.58 vs edited =====
--- 1.58/drivers/scsi/osst.c	2004-08-08 15:07:47 -06:00
+++ edited/drivers/scsi/osst.c	2004-09-02 16:56:07 -06:00
@@ -5564,8 +5564,9 @@
 	drive->number = devfs_register_tape(SDp->devfs_name);
 
 	printk(KERN_INFO
-		"osst :I: Attached OnStream %.5s tape at scsi%d, channel %d, id %d, lun %d as %s\n",
-		SDp->model, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun, tape_name(tpnt));
+		"osst :I: Attached OnStream %.5s tape at %s: scsi%d, channel %d, id %d, lun %d as %s\n",
+		SDp->model, scsi_get_device(SDp->host)->bus_id,
+		SDp->host->host_no, SDp->channel, SDp->id, SDp->lun, tape_name(tpnt));
 
 	return 0;
 
===== drivers/scsi/sd.c 1.156 vs edited =====
--- 1.156/drivers/scsi/sd.c	2004-08-23 02:14:46 -06:00
+++ edited/drivers/scsi/sd.c	2004-09-02 16:51:56 -06:00
@@ -1489,10 +1489,10 @@
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
-	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
+	printk(KERN_NOTICE "Attached scsi %sdisk %s at %s: scsi%d, channel %d, "
 	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
-	       gd->disk_name, sdp->host->host_no, sdp->channel,
-	       sdp->id, sdp->lun);
+	       gd->disk_name, scsi_get_device(sdp->host)->bus_id, 
+	       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 
 	return 0;
 
===== drivers/scsi/sg.c 1.95 vs edited =====
--- 1.95/drivers/scsi/sg.c	2004-08-07 20:11:33 -06:00
+++ edited/drivers/scsi/sg.c	2004-09-02 16:54:05 -06:00
@@ -1468,8 +1468,9 @@
 		printk(KERN_WARNING "sg_add: sg_sys INvalid\n");
 
 	printk(KERN_NOTICE
-	       "Attached scsi generic sg%d at scsi%d, channel"
+	       "Attached scsi generic sg%d at %s: scsi%d, channel"
 	       " %d, id %d, lun %d,  type %d\n", k,
+	       scsi_get_device(scsidp->host)->bus_id,
 	       scsidp->host->host_no, scsidp->channel, scsidp->id,
 	       scsidp->lun, scsidp->type);
 
===== drivers/scsi/sr.c 1.114 vs edited =====
--- 1.114/drivers/scsi/sr.c	2004-08-12 18:03:53 -06:00
+++ edited/drivers/scsi/sr.c	2004-09-02 16:54:55 -06:00
@@ -637,8 +637,9 @@
 	add_disk(disk);
 
 	printk(KERN_DEBUG
-	    "Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
-	    cd->cdi.name, sdev->host->host_no, sdev->channel,
+	    "Attached scsi CD-ROM %s at %s: scsi%d, channel %d, id %d, lun %d\n",
+	    cd->cdi.name, scsi_get_device(sdev->host)->bus_id,
+	    sdev->host->host_no, sdev->channel,
 	    sdev->id, sdev->lun);
 	return 0;
 
===== drivers/scsi/st.c 1.93 vs edited =====
--- 1.93/drivers/scsi/st.c	2004-08-12 18:03:53 -06:00
+++ edited/drivers/scsi/st.c	2004-09-02 16:55:30 -06:00
@@ -3919,8 +3919,9 @@
 	disk->number = devfs_register_tape(SDp->devfs_name);
 
 	printk(KERN_WARNING
-	"Attached scsi tape %s at scsi%d, channel %d, id %d, lun %d\n",
-	       tape_name(tpnt), SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
+	"Attached scsi tape %s at %s: scsi%d, channel %d, id %d, lun %d\n",
+	       tape_name(tpnt), scsi_get_device(SDp->host)->bus_id,
+	       SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
 	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B), max page reachable by HBA %lu\n",
 	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
 	       queue_dma_alignment(SDp->request_queue) + 1, tpnt->max_pfn);

