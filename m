From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] seagate cleanup
Date: Sun, 22 Jun 2003 02:04:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030622000402.GL23337@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@rustcorp.com.au
List-Id: linux-scsi@vger.kernel.org

The patch below does the following cleanups on 
drivers/scsi/seagate.{c,h}:
- remove two unused functions
- remove a function declaration for a function that is no longer present

I've tested the compilation with 2.5.72-mm2.

cu
Adrian

--- linux-2.5.72-mm2/drivers/scsi/seagate.c.old	2003-06-22 01:07:11.000000000 +0200
+++ linux-2.5.72-mm2/drivers/scsi/seagate.c	2003-06-22 01:07:30.000000000 +0200
@@ -266,20 +266,6 @@
 #define WRITE_CONTROL(d) { isa_writeb((d), st0x_cr_sr); }
 #define WRITE_DATA(d) { isa_writeb((d), st0x_dr); }
 
-static void st0x_setup (char *str, int *ints)
-{
-	controller_type = SEAGATE;
-	base_address = ints[1];
-	irq = ints[2];
-}
-
-static void tmc8xx_setup (char *str, int *ints)
-{
-	controller_type = FD;
-	base_address = ints[1];
-	irq = ints[2];
-}
-
 #ifndef OVERRIDE
 static unsigned int seagate_bases[] = {
 	0xc8000, 0xca000, 0xcc000,
--- linux-2.5.72-mm2/drivers/scsi/seagate.h.old	2003-06-22 01:06:20.000000000 +0200
+++ linux-2.5.72-mm2/drivers/scsi/seagate.h	2003-06-22 01:06:40.000000000 +0200
@@ -10,7 +10,6 @@
 #define SEAGATE_H
 
 static int seagate_st0x_detect(Scsi_Host_Template *);
-static int seagate_st0x_command(Scsi_Cmnd *);
 static int seagate_st0x_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 
 static int seagate_st0x_abort(Scsi_Cmnd *);
