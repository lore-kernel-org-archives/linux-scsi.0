From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi/hosts.c device_register fix
Date: Thu, 28 Nov 2002 10:57:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211281657.gASGve102802@localhost.localdomain>
References: <UTC200211281647.gASGlrq03953.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_5066416220"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA09063
	for <linux-scsi@vger.kernel.org>; Thu, 28 Nov 2002 08:57:44 -0800
In-Reply-To: Message from Andries.Brouwer@cwi.nl
   of "Thu, 28 Nov 2002 17:47:53 +0100." <UTC200211281647.gASGlrq03953.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_5066416220
Content-Type: text/plain; charset=us-ascii

Actually, the patch is wrong.  It will wreak havoc with SCSI's use of sysfs.  
The device_register has to be done in scsi_add_host, which is called after all 
the driver specific sysfs setup has been done.  The correct fix is to move the 
corresponding device_unregister into scsi_remove_host so that they match.

I've attached it below.  I'll also commit it to the scsi-misc-2.5 BK tree.

James


--==_Exmh_5066416220
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== hosts.c 1.31 vs edited =====
--- 1.31/drivers/scsi/hosts.c	Sun Nov 17 15:47:02 2002
+++ edited/hosts.c	Sat Nov 23 17:25:57 2002
@@ -295,6 +295,8 @@
 		kfree(sdev);
 	}
 
+	device_unregister(&shost->host_driverfs_dev);
+
 	return 0;
 }
 
@@ -348,7 +350,6 @@
 
 	/* Cleanup proc and driverfs */
 	scsi_proc_host_rm(shost);
-	device_unregister(&shost->host_driverfs_dev);
 
 	kfree(shost);
 }

--==_Exmh_5066416220--


