From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH][2.5] SCSI hosts.c missing device_register
Date: Sat, 23 Nov 2002 14:14:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211232014.gANKExH03723@localhost.localdomain>
References: <zwane@holomorphy.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_19954764400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA05041
	for <linux-scsi@vger.kernel.org>; Sat, 23 Nov 2002 12:15:04 -0800
In-Reply-To: Message from Zwane Mwaikambo <zwane@holomorphy.com>
   of "Sat, 23 Nov 2002 15:09:11 EST." <Pine.LNX.4.50.0211231508220.1462-100000@montezuma.mastecende.com>
List-Id: linux-scsi@vger.kernel.org
To: Zwane Mwaikambo <zwane@holomorphy.com>
Cc: "J.E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_19954764400
Content-Type: text/plain; charset=us-ascii

zwane@holomorphy.com said:
> aha1542.c without the device physically installed. I presume the ->
> detect function failed. 

Yes, It looks like it calls scsi_register, then decides it doesn't have 
anything, so calls scsi_unregister (which has the device_remove() in it).  
That does look like a reasonable use of the API.

It looks like moving the device_register into scsi_register (from 
scsi_add_host()) does look like the correct fix.  How do you fare with the 
attached?

James


--==_Exmh_19954764400
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== hosts.c 1.37 vs edited =====
--- 1.37/drivers/scsi/hosts.c	Fri Nov 22 20:12:54 2002
+++ edited/hosts.c	Sat Nov 23 14:13:57 2002
@@ -297,7 +297,6 @@
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	device_register(&shost->host_driverfs_dev);
 	scsi_scan_host(shost);
 			
 	list_for_each_entry (sdev, &shost->my_devices, siblings) {
@@ -378,6 +377,8 @@
 		printk(KERN_ERR "%s: out of memory.\n", __FUNCTION__);
 		return NULL;
 	}
+	/* from here on, we can't fail */
+	device_register(&shost->host_driverfs_dev);
 
 	memset(shost, 0, sizeof(struct Scsi_Host) + xtr_bytes);
 

--==_Exmh_19954764400--


