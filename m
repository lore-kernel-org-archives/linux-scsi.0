From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Degraded I/O performance, since 2.5.41
Date: Thu, 10 Oct 2002 18:09:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210110109.g9B19FJ14530@localhost.localdomain>
References: <haveblue@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_-5647072960"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id SAA07754
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 18:09:18 -0700
In-Reply-To: Message from Dave Hansen <haveblue@us.ibm.com>
   of "Thu, 10 Oct 2002 16:48:47 PDT." <3DA611DF.3000206@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_-5647072960
Content-Type: text/plain; charset=us-ascii

OK, this patch should fix it.  Do your performance numbers for ips improve 
again with this?

James


--==_Exmh_-5647072960
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/scsi_scan.c 1.24 vs edited =====
--- 1.24/drivers/scsi/scsi_scan.c	Tue Oct  8 15:45:57 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Oct 10 17:40:53 2002
@@ -1477,11 +1477,14 @@
 		if (sdt->detect)
 			sdev->attached += (*sdt->detect) (sdev);
 
-	if (sdev->host->hostt->slave_attach != NULL)
+	if (sdev->host->hostt->slave_attach != NULL) {
 		if (sdev->host->hostt->slave_attach(sdev) != 0) {
 			printk(KERN_INFO "scsi_add_lun: failed low level driver attach, setting device offline");
 			sdev->online = FALSE;
 		}
+	} else if(sdev->host->cmd_per_lun) {
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+	}
 
 	if (sdevnew != NULL)
 		*sdevnew = sdev;

--==_Exmh_-5647072960--


