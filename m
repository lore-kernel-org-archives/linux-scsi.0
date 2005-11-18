From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Sat, 19 Nov 2005 09:05:02 +1000
Message-ID: <437E5E1E.2080902@torque.net>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437D97E9.8020709@torque.net> <200511181355.17911.kilian.cavalotti@lip6.fr> <437DECDB.3070509@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000501080107010803030106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:39079 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751165AbVKRXDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 18:03:50 -0500
In-Reply-To: <437DECDB.3070509@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000501080107010803030106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Brian King wrote:
> Kilian CAVALOTTI wrote:
> 
> 
>>What I can't really understand is how a device could fail on a READ CAPACITY 
>>16 if plugged on an HBA, but work if plugged on another one... 
> 
> 
> Looks to me like the aic7xxx driver does not change max_cmd_len from
> the default of 12, so any 16 byte cdb gets failed back by scsi core.

Indeed, the DID_ABORT on the READ CAPACITY(16) suggests
that the command is not making it out to the scsi bus.
Strange that in lk 2.6 the scsi subsystem still defaults
to a maximum of 12 byte scsi commands, unless overridden
by the LLD.

Perhaps Kilian could try the following patch (borrowed from
scsi_debug). The patch is against lk 2.6.15-rc1 but should
by widely applicable (unless the aic7... series really
does have a 12 byte limit). I will report back if this
patch has any adverse impact on "sg_readcap -16" which
should report: "illegal request/invalid command operation
code" on my hardware.

Doug Gilbert



--------------000501080107010803030106
Content-Type: text/x-patch;
 name="aic2615rc1big.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic2615rc1big.diff"

--- linux/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-11-15 13:15:26.000000000 +1000
+++ linux/drivers/scsi/aic7xxx/aic7xxx_osm.c2615rc1big	2005-11-19 08:45:08.000000000 +1000
@@ -637,6 +637,9 @@
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
+        if (sdev->host->max_cmd_len < MAX_COMMAND_SIZE)
+                sdev->host->max_cmd_len = MAX_COMMAND_SIZE;
+
 	ahc_linux_device_queue_depth(sdev);
 
 	/* Initial Domain Validation */
--- linux/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-11-15 13:15:26.000000000 +1000
+++ linux/drivers/scsi/aic7xxx/aic79xx_osm.c2615rc1big	2005-11-19 08:45:29.000000000 +1000
@@ -559,6 +559,9 @@
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
+        if (sdev->host->max_cmd_len < MAX_COMMAND_SIZE)
+                sdev->host->max_cmd_len = MAX_COMMAND_SIZE;
+
 	ahd_linux_device_queue_depth(sdev);
 
 	/* Initial Domain Validation */

--------------000501080107010803030106--
