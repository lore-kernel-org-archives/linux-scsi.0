From: Doug Ledford <dledford@redhat.com>
Subject: aic7xxx_biosparam
Date: Sun, 17 Nov 2002 19:27:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118002742.GO3280@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Fba/0zbH8Xs+Fj9o"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id gAI0Rheh004262
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 19:27:43 -0500
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id gAI0Rh5r004260
	for linux-scsi@vger.kernel.org; Sun, 17 Nov 2002 19:27:43 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

So, this is the change I made to update it so that it won't puke on large 
devices.  It seems to be working OK for me, but I didn't check the gcc 
assembly output to see if it's horrible.  Unless someone tells me I'm 
smoking crack for making this change, I'll submit it pretty soon (I don't 
consider myself a partition expert, I'm just trying to make sure that when 
geometry does get defined on my driver that it at least is something the 
Adaptec BIOS will accept, and the Adaptec BIOS *only* accepts the two 
listed head/sector combos).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="aic.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.878   -> 1.878.1.1
#	drivers/scsi/aic7xxx_old.c	1.32    -> 1.33   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/11/17	dledford@aladin.rdu.redhat.com	1.878.1.1
# aic7xxx_old: fix up the biosparam function to do 64bit math safely
# --------------------------------------------
#
diff -Nru a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c	Sun Nov 17 19:19:48 2002
+++ b/drivers/scsi/aic7xxx_old.c	Sun Nov 17 19:19:49 2002
@@ -10974,7 +10974,8 @@
 aic7xxx_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int geom[])
 {
-  int heads, sectors, cylinders, ret;
+  sector_t heads, sectors, cylinders;
+  int ret;
   struct aic7xxx_host *p;
   unsigned char *buf;
 
@@ -10991,18 +10992,26 @@
   
   heads = 64;
   sectors = 32;
-  cylinders = (unsigned long)capacity / (heads * sectors);
+  cylinders = capacity >> 11;
 
   if ((p->flags & AHC_EXTEND_TRANS_A) && (cylinders > 1024))
   {
     heads = 255;
     sectors = 63;
-    cylinders = (unsigned long)capacity / (heads * sectors);
+    /* pull this crap because 64bit math in the kernel is a no-no as far
+     * as division is concerned, but 64bit multiplication can be done */
+    /* This shift approximates capacity / (heads * sectors) */
+    cylinders = capacity >> 14;
+    /* Now we brute force upping cylinders until we go over by 1 */
+    while( capacity >= (cylinders * sectors * heads))
+      cylinders++;
+    /* Then back it back down by one */
+    cylinders--;
   }
 
-  geom[0] = heads;
-  geom[1] = sectors;
-  geom[2] = cylinders;
+  geom[0] = (int)heads;
+  geom[1] = (int)sectors;
+  geom[2] = (int)cylinders;
 
   return (0);
 }

--Fba/0zbH8Xs+Fj9o--
