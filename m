From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: fix bug in figure_lunaddrbytes()
Date: Thu, 20 Mar 2014 11:34:04 -0500
Message-ID: <20140320163404.19241.47881.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:35934 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaCTQfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 12:35:07 -0400
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id E0362265D
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2014 16:34:56 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Depending on whether we use "extended" or "normal"
CISS_REPORT_LUNS command, the returned data is either
8 or 24 bytes per LUN, and the code needs to take this
into account instead of just always assuming 24 bytes
per LUN.  This would cause physical devices like tape
drives not to show up when attached to older controllers
that do not support "HP SSD Smart Path"

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9a6e4a2..63835c4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2936,12 +2936,15 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 
 u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
 	int nphysicals, int nlogicals,
-	struct ReportExtendedLUNdata *physdev_list,
-	struct ReportLUNdata *logdev_list)
+	void *physdev_list, struct ReportLUNdata *logdev_list,
+	int physical_mode)
 {
 	/* Helper function, figure out where the LUN ID info is coming from
 	 * given index i, lists of physical and logical devices, where in
-	 * the list the raid controller is supposed to appear (first or last)
+	 * the list the raid controller is supposed to appear (first or last).
+	 * if extended_physicals is set, then physdev_list points to
+	 * a struct ReportExtendedLUNdata otherwise it points to a struct
+	 * ReportLUNdata.
 	 */
 
 	int logicals_start = nphysicals + (raid_ctlr_position == 0);
@@ -2950,9 +2953,16 @@ u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
 	if (i == raid_ctlr_position)
 		return RAID_CTLR_LUNID;
 
-	if (i < logicals_start)
-		return &physdev_list->LUN[i - (raid_ctlr_position == 0)][0];
-
+	if (i < logicals_start) {
+		const int index = i - (raid_ctlr_position == 0);
+		if (physical_mode) {
+			struct ReportExtendedLUNdata *p = physdev_list;
+			return &p->LUN[index][0];
+		} else {
+			struct ReportLUNdata *p = physdev_list;
+			return &p->LUN[index][0];
+		}
+	}
 	if (i < last_device)
 		return &logdev_list->LUN[i - nphysicals -
 			(raid_ctlr_position == 0)][0];
@@ -3065,7 +3075,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
-			i, nphysicals, nlogicals, physdev_list, logdev_list);
+			i, nphysicals, nlogicals, physdev_list, logdev_list,
+			physical_mode);
 		/* skip masked physical devices. */
 		if (lunaddrbytes[3] & 0xC0 &&
 			i < nphysicals + (raid_ctlr_position == 0))

