From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Tue, 22 Oct 2002 10:48:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210221548.g9MFmJx02529@localhost.localdomain>
References: <James.Bottomley@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_2121015800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA10649
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2002 08:48:23 -0700
In-Reply-To: Message from James Bottomley <James.Bottomley@SteelEye.com>
   of "Mon, 21 Oct 2002 18:58:36 CDT." <200210212358.g9LNwaV05299@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_2121015800
Content-Type: text/plain; charset=us-ascii

hch@lst.de said:
> the ->finish method is a relicat from the old day were we never had
> hotplugging and allowed the driver to do fixups after all busses had
> been scanned.  Nowdays only sd and sr actually implement it, and both
> only defer actions to there that should actually happen in ->attach.
> Change both drivers to move that code into ->attach, clenaup the
> Templates to use C99 initializers and get rid of the methods. 

James.Bottomley@SteelEye.com said:
> OK, this one causes a hang on boot for me.  I'll look at debugging the
> cause  some more tomorrow. 

I tracked down the essential problem: the CD rom finish method expects to have 
allocated command blocks to do a mode sense.  I also fixed a trivial 
initialisation problem (the device pointer in Scsi_CD was being used before it 
was initialised).

The attached patch fixes the problem for me.

I still can't detach and add a CD-ROM, but the panic is in sr_init, so doesn't 
look to be affected by these changes, but I'll continue debugging.

James


--==_Exmh_2121015800
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/hosts.c 1.17 vs edited =====
--- 1.17/drivers/scsi/hosts.c	Mon Oct 21 15:46:14 2002
+++ edited/drivers/scsi/hosts.c	Tue Oct 22 10:16:26 2002
@@ -561,15 +561,16 @@
 			shost = list_entry(lh, struct Scsi_Host, sh_list);
 			for (sdev = shost->host_queue; sdev; sdev = sdev->next)
 				if (sdev->host->hostt == shost_tp) {
+					scsi_build_commandblocks(sdev);
+					if (sdev->current_queue_depth == 0)
+						goto out_of_space;
 					for (sdev_tp = scsi_devicelist;
 					     sdev_tp;
 					     sdev_tp = sdev_tp->next)
 						if (sdev_tp->attach)
 							(*sdev_tp->attach) (sdev);
-					if (sdev->attached) {
-						scsi_build_commandblocks(sdev);
-						if (sdev->current_queue_depth == 0)
-							goto out_of_space;
+					if (!sdev->attached) {
+                                                scsi_release_commandblocks(sdev);
 					}
 				}
 		}
===== drivers/scsi/scsi.c 1.50 vs edited =====
--- 1.50/drivers/scsi/scsi.c	Mon Oct 21 17:58:31 2002
+++ edited/drivers/scsi/scsi.c	Tue Oct 22 09:56:52 2002
@@ -2024,18 +2024,22 @@
 	     shpnt = scsi_host_get_next(shpnt)) {
 		for (SDpnt = shpnt->host_queue; SDpnt;
 		     SDpnt = SDpnt->next) {
+			scsi_build_commandblocks(SDpnt);
+			if (SDpnt->current_queue_depth == 0) {
+				out_of_space = 1;
+				continue;
+			}
 			if (tpnt->attach)
 				(*tpnt->attach) (SDpnt);
+
 			/*
 			 * If this driver attached to the device, and don't have any
 			 * command blocks for this device, allocate some.
 			 */
-			if (SDpnt->attached && SDpnt->current_queue_depth == 0) {
+			if (SDpnt->attached)
 				SDpnt->online = TRUE;
-				scsi_build_commandblocks(SDpnt);
-				if (SDpnt->current_queue_depth == 0)
-					out_of_space = 1;
-			}
+			else
+				scsi_release_commandblocks(SDpnt);
 		}
 	}
 
===== drivers/scsi/scsi_scan.c 1.29 vs edited =====
--- 1.29/drivers/scsi/scsi_scan.c	Mon Oct 21 15:47:21 2002
+++ edited/drivers/scsi/scsi_scan.c	Tue Oct 22 10:38:19 2002
@@ -1995,24 +1995,28 @@
 	sdevscan->scsi_level = scsi_find_scsi_level(channel, id, shost);
 	res = scsi_probe_and_add_lun(sdevscan, &sdev, NULL);
 	scsi_free_sdev(sdevscan);
-	if (res == SCSI_SCAN_LUN_PRESENT) {
-		BUG_ON(sdev == NULL);
 
-		for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-			if (sdt->init && sdt->dev_noticed)
-				(*sdt->init) ();
-
-		for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-			if (sdt->attach) {
-				(*sdt->attach) (sdev);
-				if (sdev->attached) {
-					scsi_build_commandblocks(sdev);
-					if (sdev->current_queue_depth == 0)
-						printk(ALLOC_FAILURE_MSG,
-						       __FUNCTION__);
-				}
-			}
+	if (res != SCSI_SCAN_LUN_PRESENT) 
+		return;
+
+	BUG_ON(sdev == NULL);
+
+	scsi_build_commandblocks(sdev);
+	if (sdev->current_queue_depth == 0) {
+		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		return;
 	}
+
+	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
+		if (sdt->init && sdt->dev_noticed)
+			(*sdt->init) ();
+
+	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
+		if (sdt->attach)
+			(*sdt->attach) (sdev);
+
+	if (!sdev->attached)
+		scsi_release_commandblocks(sdev);
 }
 
 /**
===== drivers/scsi/sr.c 1.58 vs edited =====
--- 1.58/drivers/scsi/sr.c	Mon Oct 21 17:58:38 2002
+++ edited/drivers/scsi/sr.c	Tue Oct 22 10:28:30 2002
@@ -481,10 +481,10 @@
 	if (i >= sr_template.dev_max)
 		panic("scsi_devices corrupt (sr)");
 
+	scsi_CDs[i].device = SDp;
+
 	if (sr_init_one(cpnt, i))
 		goto fail;
-
-	scsi_CDs[i].device = SDp;
 
 	sr_template.nr_dev++;
 	if (sr_template.nr_dev > sr_template.dev_max)

--==_Exmh_2121015800--


