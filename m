From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg snprintf()s in 2.5.59
Date: Thu, 30 Jan 2003 16:45:49 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E38BC0D.9040608@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010204060806090903030403"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: patmans@us.ibm.com

This is a multi-part message in MIME format.
--------------010204060806090903030403
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick Mansfield reminded me that the attached patch
hasn't made it into the 2.5 series yet. It's absence
causes some corruption for long sg_driverfs_dev.name
strings.

Doug Gilbert

--------------010204060806090903030403
Content-Type: text/plain;
 name="sg_2559_snpr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2559_snpr.diff"

--- linux/drivers/scsi/sg.c	2003-01-14 10:46:58.000000000 +1100
+++ linux/drivers/scsi/sg.c2559snpr	2003-01-30 16:38:47.000000000 +1100
@@ -19,7 +19,7 @@
  */
 #include <linux/config.h>
 #ifdef CONFIG_PROC_FS
-static char *sg_version_str = "Version: 3.5.27 (20020812)";
+static char *sg_version_str = "Version: 3.5.27 (20030130)";
 #endif
 static int sg_version_num = 30527;	/* 2 digits for each component */
 /*
@@ -1455,9 +1455,9 @@
 	sdp->sg_tablesize = scsidp->host ? scsidp->host->sg_tablesize : 0;
 
 	memset(&sdp->sg_driverfs_dev, 0, sizeof (struct device));
-	sprintf(sdp->sg_driverfs_dev.bus_id, "%s:gen",
+	snprintf(sdp->sg_driverfs_dev.bus_id, BUS_ID_SIZE, "%s:gen",
 		scsidp->sdev_driverfs_dev.bus_id);
-	sprintf(sdp->sg_driverfs_dev.name, "%sgeneric",
+	snprintf(sdp->sg_driverfs_dev.name, DEVICE_NAME_SIZE, "%sgeneric",
 		scsidp->sdev_driverfs_dev.name);
 	sdp->sg_driverfs_dev.parent = &scsidp->sdev_driverfs_dev;
 	sdp->sg_driverfs_dev.bus = scsidp->sdev_driverfs_dev.bus;

--------------010204060806090903030403--


