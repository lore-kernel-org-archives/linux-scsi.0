From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH] test capacity early in setsize() to avoid bad casts
Date: Tue, 12 Jul 2005 16:33:16 -0500
Message-ID: <1121203996.3499.2.camel@madmax.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:19934 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262495AbVGLVd1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 17:33:27 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id j6CLXRFH014931
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 17:33:27 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [172.16.52.156])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id j6CLXHV20399
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 17:33:17 -0400
Received: from dhcp80-217.msp.redhat.com (dhcp80-217.msp.redhat.com [10.15.80.217])
	by pobox.corp.redhat.com (8.12.8/8.12.8) with ESMTP id j6CLXGUk013226
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2005 17:33:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 32 bit archs with LBD set, setsize can cast a capacity so
that we result in heads==0 (capacity is sector_t which would
be a 64 bit value with LBD but it gets cast to a unsigned long
which is only 32 bits). Some userspace programs will then blindly
use this heads value to do fun things. This patch avoids the bad
casts by having setsize check for the max value it can support
which is 7905 MB. By returning early when something greater than
its limit is passed to it we also avoid bad casts which could result
in heads getting set to zero here.

Patch is made against 2.6.13.rc2


--- linux-2.6.13-rc2/drivers/scsi/scsicam.c	2005-07-05 22:46:33.000000000 -0500
+++ linux-2.6.13-rc2.work/drivers/scsi/scsicam.c	2005-07-12 16:15:07.000000000 -0500
@@ -21,7 +21,7 @@
 #include <scsi/scsicam.h>
 
 
-static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
+static int setsize(sector_t capacity, unsigned int *cyls, unsigned int *hds,
 		   unsigned int *secs);
 
 unsigned char *scsi_bios_ptable(struct block_device *dev)
@@ -72,7 +72,7 @@ int scsicam_bios_param(struct block_devi
 		/* pick some standard mapping with at most 1024 cylinders,
 		   and at most 62 sectors per track - this works up to
 		   7905 MB */
-		ret = setsize((unsigned long)capacity, (unsigned int *)ip + 2,
+		ret = setsize(capacity, (unsigned int *)ip + 2,
 		       (unsigned int *)ip + 0, (unsigned int *)ip + 1);
 	}
 
@@ -213,12 +213,21 @@ EXPORT_SYMBOL(scsi_partsize);
  * accommodated. This algorithm does not use physical geometry. 
  */
 
-static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
+static int setsize(sector_t cap, unsigned int *cyls, unsigned int *hds,
 		   unsigned int *secs)
 {
 	unsigned int rv = 0;
-	unsigned long heads, sectors, cylinders, temp;
+	unsigned long heads, sectors, cylinders, temp, capacity;
 
+	/*
+	 * A capacity > 7905 MB (16189440 512 byte sectors) will result
+	 * in heads > 255 and a capacity >> 7905 will result in bad casts
+	 * and possibly heads == 0.
+	 */
+	if (cap > 16189440)
+		return -1;
+
+	capacity = (unsigned long) cap;
 	cylinders = 1024L;	/* Set number of cylinders to max */
 	sectors = 62L;		/* Maximize sectors per track */
 


