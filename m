From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH][2.5] SCSI hosts.c missing device_register
Date: Sat, 23 Nov 2002 16:52:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211232252.gANMqZ504354@localhost.localdomain>
References: <zwane@holomorphy.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_20328363910"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by montezuma.mastecende.com (8.12.5/8.12.5) with ESMTP id gANNECIN019464
	for <linux-scsi@vger.kernel.org>; Sat, 23 Nov 2002 18:14:13 -0500
In-Reply-To: Message from Zwane Mwaikambo <zwane@holomorphy.com>
   of "Sat, 23 Nov 2002 15:09:11 EST." <Pine.LNX.4.50.0211231508220.1462-100000@montezuma.mastecende.com>
List-Id: linux-scsi@vger.kernel.org
To: Zwane Mwaikambo <zwane@holomorphy.com>
Cc: linux-scsi@bkbits.net

This is a multipart MIME message.

--==_Exmh_20328363910
Content-Type: text/plain; charset=us-ascii

Well, the previous patch now fails to parent the scsi busses correctly in 
sysfs, because the HBA driver does the scsi_set_pci_device between the 
register and the end of the detect routine.

How about, an alternative solution involving moving device_unregister() 
instead?

James


--==_Exmh_20328363910
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/hosts.c 1.37 vs edited =====
--- 1.37/drivers/scsi/hosts.c	Fri Nov 22 20:12:54 2002
+++ edited/drivers/scsi/hosts.c	Sat Nov 23 16:41:01 2002
@@ -285,6 +285,7 @@
 	}
 
 	scsi_forget_host(shost);
+	device_unregister(&shost->host_driverfs_dev);
 	return 0;
 }
 
@@ -335,7 +336,6 @@
 
 	/* Cleanup proc and driverfs */
 	scsi_proc_host_rm(shost);
-	device_unregister(&shost->host_driverfs_dev);
 
 	kfree(shost);
 }

--==_Exmh_20328363910--


