From: Hannes Reinecke <hare@suse.de>
Subject: HP XP devinfo update
Date: Thu, 22 Jun 2006 09:19:51 +0200
Message-ID: <449A4497.8000106@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060405080303080307010808"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:29912 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751068AbWFVHTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jun 2006 03:19:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Anthony Cheung <anthony.cheung@hp.com>

This is a multi-part message in MIME format.
--------------060405080303080307010808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

we've had some bug reports that the sequential scanning fails with HP XP
arrays. Fancy, though, as (according to HP) those boxes support REPORT_LUN.

This patch updates the blacklist to always use REPORT_LUN scan on HP XP
arrays.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------060405080303080307010808
Content-Type: text/plain;
 name="scsi-update-hp-xp-devinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-update-hp-xp-devinfo"

HP XP array devinfo update

According to Anthony Cheung all HP XP arrays with "OPEN-" 
types support REPORT_LUN. So there is no reason why we
shouldn't use it.

Signed-off-by: Anthony Cheung <anthony.cheung@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index ae13e4a..83d30ee 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -160,7 +160,7 @@ static struct {
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
-	{"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, /* HP XP Arrays */
+	{"HP", "OPEN-", "*", BLIST_REPORTLUN2}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
 	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},

--------------060405080303080307010808--
