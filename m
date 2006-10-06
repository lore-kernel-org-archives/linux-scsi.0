From: Hannes Reinecke <hare@suse.de>
Subject: aic7xxx: Adjust .max_sectors
Date: Fri, 06 Oct 2006 09:22:41 +0200
Message-ID: <45260441.1020102@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080909070109080002030509"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:23277 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1161082AbWJFHWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2006 03:22:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080909070109080002030509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi James,

the aic7xxx drivers do not set .max_sectors, and hence defaults to 
512kB. The adaptec sources indicate that it in realiter can handle up to 
4MB, so there is no reason not to adjust it.

Please apply,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------080909070109080002030509
Content-Type: text/plain;
 name="aic7xxx-max-sectors-adjust"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-max-sectors-adjust"

aic7xxx: Adjust .max_sectors

According to the adaptec sources aic7xxx / aic79xx really can do
4MB transfers. So we should adjust .max_sectors.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index c7eeace..7c05de2 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -773,6 +773,7 @@ #if defined(__i386__)
 #endif
 	.can_queue		= AHD_MAX_QUEUE,
 	.this_id		= -1,
+	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.slave_alloc		= ahd_linux_slave_alloc,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 64c8b88..4cda337 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -777,6 +777,7 @@ #if defined(__i386__)
 #endif
 	.can_queue		= AHC_MAX_QUEUE,
 	.this_id		= -1,
+	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.slave_alloc		= ahc_linux_slave_alloc,

--------------080909070109080002030509--
