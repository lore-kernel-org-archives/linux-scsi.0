From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2.5.41 sd.c sd_synchronize_cache free request after error check
Date: Wed, 9 Oct 2002 11:05:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021009110533.A968@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e3.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g99I5gxw132112
	for <linux-scsi@vger.kernel.org>; Wed, 9 Oct 2002 14:05:42 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by northrelay03.pok.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g99I5cn4092000
	for <linux-scsi@vger.kernel.org>; Wed, 9 Oct 2002 14:05:39 -0400
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g99I5Zv25413
	for <linux-scsi@vger.kernel.org>; Wed, 9 Oct 2002 11:05:35 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g99I5Xu20784
	for linux-scsi@vger.kernel.org; Wed, 9 Oct 2002 11:05:33 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi -

This fixes sd_synchronize_cache() to free the scsi request after its
possible use in printing sense data.

I hit this while running with scsi_debug (with Mike A's patch, or in
current ac) with 2.5.41, there was an oops when trying to print the
request sense of a failed SYNCHRONIZE_CACHE.

diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Wed Oct  9 10:57:02 2002
+++ b/drivers/scsi/sd.c	Wed Oct  9 10:57:02 2002
@@ -1616,7 +1616,6 @@
 	}
 
 	the_result = SRpnt->sr_result;
-	scsi_release_request(SRpnt);
 	if(verbose) {
 		if(the_result != 0) {
 			printk("FAILED\n  status = %x, message = %02x, host = %d, driver = %02x\n  ",
@@ -1629,6 +1628,7 @@
 
 		}
 	}
+	scsi_release_request(SRpnt);
 	return (the_result == 0);
 }
 
