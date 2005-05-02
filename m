From: Tom Coughlan <coughlan@redhat.com>
Subject: [PATCH] fix disk geometry calculation for large disks
Date: Mon, 02 May 2005 12:48:33 -0400
Message-ID: <1115052512.11434.2738.camel@bianchi.boston.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-pPxMRJ0jENMf5Tn5XA1D"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56528 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261471AbVEBQuM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2005 12:50:12 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id j42GoAvi031206
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 12:50:10 -0400
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id j42Go9O21119
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 12:50:09 -0400
Received: from bianchi.boston.redhat.com (bianchi.boston.redhat.com [172.16.80.116])
	by mail.boston.redhat.com (8.12.8/8.12.8) with ESMTP id j42Go90D031271
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 12:50:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-pPxMRJ0jENMf5Tn5XA1D
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Testing with multi-terabyte disks shows that HDIO_GETGEO sometimes
returns heads=0. This causes parted to die with a Floating Point
Exception, among other possible effects. 

The problem occurs because several routines in scsicam_bios_param cast
sector_t capacity to unsigned long. 

The attached patch avoids this, by checking first to see if the capacity
exceeds the maximum allowed values for cylinder/sector/head
(65535*63*255). If so, just return those values right away. 

Tom

--=-pPxMRJ0jENMf5Tn5XA1D
Content-Disposition: attachment; filename=scsicam-geom-fix-2.6.12-rc3.patch
Content-Type: text/plain; name=scsicam-geom-fix-2.6.12-rc3.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

--- linux-2.6.12-rc3/drivers/scsi/scsicam.c.orig
+++ linux-2.6.12-rc3/drivers/scsi/scsicam.c
@@ -59,6 +59,15 @@ int scsicam_bios_param(struct block_devi
 	unsigned char *p;
 	int ret;
 
+	/* Are we above the max. allowed for cylinder/sector/head? */
+	if (capacity > 65535*63*255) {
+		ip[0] = 255;
+		ip[1] = 63;
+		ip[2] = 65535;
+
+		return 0;
+	}
+
 	p = scsi_bios_ptable(bdev);
 	if (!p)
 		return -1;
@@ -86,11 +95,7 @@ int scsicam_bios_param(struct block_devi
 			ip[0] = 64;
 			ip[1] = 32;
 		}
-
-		if (capacity > 65535*63*255)
-			ip[2] = 65535;
-		else
-			ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
+		ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
 	}
 
 	return 0;

--=-pPxMRJ0jENMf5Tn5XA1D--

