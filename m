From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 14:37:54 +0200 (CEST)
Message-ID: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:11425 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261348AbVGIMiJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 08:38:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Hi linux-scsi people and linux1394 people,

there are a few changes to sbp2 in linux-2.6.13 (-rc2) that were not
merged back into the linux1394.org repository (and were not tested by
linux1394 maintainers as far as I have heard). Most of these changes
deal with TYPE_RBC devices.

Previous discussion:
 - "TYPE_RBC cache fixes (sbp2.c affected)"
   http://marc.theaimsgroup.com/?t=111620896500001

 - "Problems with Firewire and -mm kernels"
   http://marc.theaimsgroup.com/?t=111994463000003
   http://marc.theaimsgroup.com/?t=112027470800001
   http://marc.theaimsgroup.com/?t=112029841400001

I have one question for now: Is the following part of the diff related
to the TYPE_RBC issue, or is it unrelated? As you can see, locking is
removed from sbp2scsi_complete_command() but added to sbp2scsi_reset():


--- ieee1394_linux1394.org/sbp2.c	2005-07-03 12:29:55.000000000 +0200
+++ linux-2.6.13-rc2/drivers/ieee1394/sbp2.c	2005-07-06 05:46:33.000000000 +0200
@@ -2580,8 +2454,6 @@ static void sbp2scsi_complete_command(st
 				      u32 scsi_status, struct scsi_cmnd *SCpnt,
 				      void (*done)(struct scsi_cmnd *))
 {
-	unsigned long flags;
-
 	SBP2_DEBUG("sbp2scsi_complete_command");
 
 	/*
@@ -2680,11 +2552,7 @@ static void sbp2scsi_complete_command(st
 	/*
 	 * Tell scsi stack that we're done with this command
 	 */
-	spin_lock_irqsave(scsi_id->scsi_host->host_lock,flags);
 	done (SCpnt);
-	spin_unlock_irqrestore(scsi_id->scsi_host->host_lock,flags);
-
-	return;
 }
 
 
@@ -2747,7 +2616,7 @@ static int sbp2scsi_abort(struct scsi_cm
 /*
  * Called by scsi stack when something has really gone wrong.
  */
-static int sbp2scsi_reset(struct scsi_cmnd *SCpnt)
+static int __sbp2scsi_reset(struct scsi_cmnd *SCpnt)
 {
 	struct scsi_id_instance_data *scsi_id =
 		(struct scsi_id_instance_data *)SCpnt->device->host->hostdata[0];
@@ -2762,6 +2631,18 @@ static int sbp2scsi_reset(struct scsi_cm
 	return(SUCCESS);
 }
 
+static int sbp2scsi_reset(struct scsi_cmnd *SCpnt)
+{
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
+	rc = __sbp2scsi_reset(SCpnt);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
+
+	return rc;
+}
+
 static const char *sbp2scsi_info (struct Scsi_Host *host)
 {
         return "SCSI emulation for IEEE-1394 SBP-2 Devices";



Thanks in advance for clarification.
-- 
Stefan Richter
-=====-=-=-= -=== -=--=
http://arcgraph.de/sr/

