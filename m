From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] ibmmca cleanup
Date: Sun, 22 Jun 2003 01:57:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621235725.GI23337@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:40168 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264424AbTFUXnY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 19:43:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@rustcorp.com.au

The patch below does the following:
- remove an unused static function
- removes the declaration of a function that is no longer present
- removes a variable declaration that shadows a function parameter

I've tested the compilation with 2.5.72-mm2.

cu
Adrian

--- linux-2.5.72-mm2/drivers/scsi/ibmmca.c.old	2003-06-22 01:10:04.000000000 +0200
+++ linux-2.5.72-mm2/drivers/scsi/ibmmca.c	2003-06-22 01:11:15.000000000 +0200
@@ -2379,7 +2379,6 @@
 {
 	int len = 0;
 	int i, id, lun, host_index;
-	struct Scsi_Host *shpnt;
 	unsigned long flags;
 	int max_pun;
 
@@ -2452,11 +2451,6 @@
 	return len;
 }
 
-static void ibmmca_scsi_setup(char *str, int *ints)
-{
-	internal_ibmmca_scsi_setup(str, ints);
-}
-
 static int option_setup(char *str)
 {
 	int ints[IM_MAX_HOSTS];
--- linux-2.5.72-mm2/drivers/scsi/ibmmca.h.old	2003-06-22 01:11:38.000000000 +0200
+++ linux-2.5.72-mm2/drivers/scsi/ibmmca.h	2003-06-22 01:12:00.000000000 +0200
@@ -13,7 +13,6 @@
 /* Interfaces to the midlevel Linux SCSI driver */
 static int ibmmca_detect (Scsi_Host_Template *);
 static int ibmmca_release (struct Scsi_Host *);
-static int ibmmca_command (Scsi_Cmnd *);
 static int ibmmca_queuecommand (Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 static int ibmmca_abort (Scsi_Cmnd *);
 static int ibmmca_host_reset (Scsi_Cmnd *);
