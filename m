From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] compile fix cciss (bug 338)
Date: Tue, 11 Feb 2003 22:36:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212063615.GA1453@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e32.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1C6YT5V061176
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2003 01:34:29 -0500
Received: from hmsbounty (sig-9-65-2-81.mts.ibm.com [9.65.2.81])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1C6YS9Z145184
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 23:34:29 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is against scsi-misc-2.5 for

http://bugme.osdl.org/show_bug.cgi?id=338

I only compile tested this change
-andmike
--
Michael Anderson
andmike@us.ibm.com

 cciss_scsi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)
------

--- 1.8/drivers/block/cciss_scsi.c	Sun Nov 17 23:09:49 2002
+++ edited/drivers/block/cciss_scsi.c	Tue Feb 11 08:21:00 2003
@@ -1262,7 +1262,6 @@
 
 	int buflen, datalen;
 	struct Scsi_Host *sh;
-	int found;
 	ctlr_info_t *ci;
 	int cntl_num;
 
@@ -1379,11 +1378,11 @@
 
 	// Get the ptr to our adapter structure (hba[i]) out of cmd->host.
 	// We violate cmd->host privacy here.  (Is there another way?)
-	c = (ctlr_info_t **) &cmd->host->hostdata[0];	
+	c = (ctlr_info_t **) &cmd->device->host->hostdata[0];	
 	ctlr = (*c)->ctlr;
 
-	rc = lookup_scsi3addr(ctlr, cmd->channel, cmd->target, cmd->lun, 
-			scsi3addr);
+	rc = lookup_scsi3addr(ctlr, cmd->device->channel, cmd->device->id,
+			      cmd->device->lun, scsi3addr);
 	if (rc != 0) {
 		/* the scsi nexus does not match any that we presented... */
 		/* pretend to mid layer that we got selection timeout */

