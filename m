From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: [PATCH] SD_EXTRA_DEVS module option
Date: Thu, 25 Jul 2002 16:09:49 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207251605220.12595-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tux.us.dell.com (tux.us.dell.com [143.166.152.29])
	by smtp2.us.dell.com (8.12.1/8.12.1) with ESMTP id g6PL8Uk6009453
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jul 2002 16:08:30 -0500
Received: from humbolt.us.dell.com ([10.180.92.254])
	by tux.us.dell.com (8.11.0/8.11.0) with ESMTP id g6PL9nj06197
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jul 2002 16:09:49 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On systems with large numbers of SCSI disks, the standard value for 
CONFIG_SD_EXTRA_DEVS=40 is insufficient.  On systems with few SCSI disks, 
the value is too big.  So, how about making it a module option to sd?

Any objections the the patch below, which creates an sd_extra_devs module 
option, with the default value as provided in CONFIG_SD_EXTRA_DEVS?  If 
the given value is too large, the current code already validates this and 
limits it appropriately.

Thanks,
Matt


-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
#1 US Linux Server provider for 2001 and Q1/2002! (IDC May 2002)

--- linux-2.4/drivers/scsi/sd.c.orig	2002-07-25 16:17:35.000000000 -0500
+++ linux-2.4/drivers/scsi/sd.c	2002-07-25 16:21:56.000000000 -0500
@@ -89,6 +89,10 @@
 #define SD_TIMEOUT (60 * HZ)
 #define SD_MOD_TIMEOUT (75 * HZ)
 
+static unsigned int sd_extra_devs = SD_EXTRA_DEVS;
+MODULE_PARM(sd_extra_devs, "i");
+MODULE_PARM_DESCRIPTION(sd_extra_devs, "Number of extra SCSI disks allowed");
+
 static Scsi_Disk *rscsi_disks;
 static struct gendisk *sd_gendisks;
 static int *sd_sizes;
@@ -1113,7 +1117,7 @@ static int sd_init()
 		return 0;
 
 	if (!rscsi_disks)
-		sd_template.dev_max = sd_template.dev_noticed + SD_EXTRA_DEVS;
+		sd_template.dev_max = sd_template.dev_noticed + sd_extra_devs;
 
 	if (sd_template.dev_max > N_SD_MAJORS * SCSI_DISKS_PER_MAJOR)
 		sd_template.dev_max = N_SD_MAJORS * SCSI_DISKS_PER_MAJOR;

