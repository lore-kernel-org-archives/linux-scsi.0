From: berthiaume_wayne@emc.com
Subject: RE: [PATCH] SD_EXTRA_DEVS module option
Date: Sun, 28 Jul 2002 12:14:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BFDC3@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matt_Domsch@Dell.com
Cc: linux-scsi@vger.kernel.org

	Well in RH 7.1, lk 2.4.2, the option already exist under SCSI
Support -> Maximum number of SCSI diasks that can be loaded as modules. I
haven't looked at a vanilla kernel so this may be a Red Hat addition.
Wayne
EMC Corp
Centera Engineering
4400 Computer Drive
M/S F213
Westboro,  MA    01580

email:       Berthiaume_Wayne@emc.com

"One man can make a difference, and every man should try."  - JFK


-----Original Message-----
From: Matt Domsch [mailto:Matt_Domsch@Dell.com]
Sent: Thursday, July 25, 2002 5:10 PM
To: linux-scsi@vger.kernel.org
Subject: [PATCH] SD_EXTRA_DEVS module option


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
+MODULE_PARM_DESCRIPTION(sd_extra_devs, "Number of extra SCSI disks
allowed");
+
 static Scsi_Disk *rscsi_disks;
 static struct gendisk *sd_gendisks;
 static int *sd_sizes;
@@ -1113,7 +1117,7 @@ static int sd_init()
 		return 0;
 
 	if (!rscsi_disks)
-		sd_template.dev_max = sd_template.dev_noticed +
SD_EXTRA_DEVS;
+		sd_template.dev_max = sd_template.dev_noticed +
sd_extra_devs;
 
 	if (sd_template.dev_max > N_SD_MAJORS * SCSI_DISKS_PER_MAJOR)
 		sd_template.dev_max = N_SD_MAJORS * SCSI_DISKS_PER_MAJOR;

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
