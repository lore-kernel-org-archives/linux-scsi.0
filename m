From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH][2.5] SCSI hosts.c missing device_register
Date: Sat, 23 Nov 2002 14:44:03 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211232044.gANKi3h03901@localhost.localdomain>
References: <James.Bottomley@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_20000166300"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA06904
	for <linux-scsi@vger.kernel.org>; Sat, 23 Nov 2002 12:44:06 -0800
In-Reply-To: Message from "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
   of "Sat, 23 Nov 2002 14:14:59 CST." <200211232014.gANKExH03723@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Zwane Mwaikambo <zwane@holomorphy.com>, linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_20000166300
Content-Type: text/plain; charset=us-ascii

Actually, the last patch was wrong.  We can't do device_register until we've 
at least cleared the memory area.  This one moves it to the bottom of the 
routine.  I've actually booted it and it seems to work.

James


--==_Exmh_20000166300
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/hosts.c 1.37 vs edited =====
--- 1.37/drivers/scsi/hosts.c	Fri Nov 22 20:12:54 2002
+++ edited/drivers/scsi/hosts.c	Sat Nov 23 14:33:21 2002
@@ -297,7 +297,6 @@
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	device_register(&shost->host_driverfs_dev);
 	scsi_scan_host(shost);
 			
 	list_for_each_entry (sdev, &shost->my_devices, siblings) {
@@ -378,7 +377,7 @@
 		printk(KERN_ERR "%s: out of memory.\n", __FUNCTION__);
 		return NULL;
 	}
-
+	/* from here on, we can't fail */
 	memset(shost, 0, sizeof(struct Scsi_Host) + xtr_bytes);
 
 	shost->host_no = scsi_alloc_host_num(shost_tp->proc_name);
@@ -463,6 +462,8 @@
 	shost->eh_notify = NULL;
 
 	shost->hostt->present++;
+
+	device_register(&shost->host_driverfs_dev);
 
 	return shost;
 }

--==_Exmh_20000166300--


