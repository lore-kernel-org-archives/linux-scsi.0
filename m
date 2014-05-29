From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 14/24] hpsa: define extended_report_lun_entry data structure
Date: Thu, 29 May 2014 10:53:34 -0500
Message-ID: <20140529155334.8180.95773.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37880 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbaE2PzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:01 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 1E1AE60CAF
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:55:01 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
---
 drivers/scsi/hpsa.c     |   21 ++++++++-------------
 drivers/scsi/hpsa_cmd.h |   12 +++++++++++-
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c6ed5ea..96436bb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2869,26 +2869,20 @@ static int hpsa_get_pdisk_of_ioaccel2(struct ctlr_info *h,
 	nphysicals = be32_to_cpu(*((__be32 *)physicals->LUNListLength)) /
 							responsesize;
 
-
 	/* find ioaccel2 handle in list of physicals: */
 	for (i = 0; i < nphysicals; i++) {
+		struct ext_report_lun_entry *entry = &physicals->LUN[i];
+
 		/* handle is in bytes 28-31 of each lun */
-		if (memcmp(&((struct ReportExtendedLUNdata *)
-				physicals)->LUN[i][20], &find, 4) != 0) {
+		if (entry->ioaccel_handle != find)
 			continue; /* didn't match */
-		}
 		found = 1;
-		memcpy(scsi3addr, &((struct ReportExtendedLUNdata *)
-					physicals)->LUN[i][0], 8);
+		memcpy(scsi3addr, entry->lunid, 8);
 		if (h->raid_offload_debug > 0)
 			dev_info(&h->pdev->dev,
-				"%s: Searched h=0x%08x, Found h=0x%08x, scsiaddr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+				"%s: Searched h=0x%08x, Found h=0x%08x, scsiaddr 0x%8phN\n",
 				__func__, find,
-				((struct ReportExtendedLUNdata *)
-					physicals)->LUN[i][20],
-				scsi3addr[0], scsi3addr[1], scsi3addr[2],
-				scsi3addr[3], scsi3addr[4], scsi3addr[5],
-				scsi3addr[6], scsi3addr[7]);
+				entry->ioaccel_handle, scsi3addr);
 		break; /* found it */
 	}
 
@@ -2973,7 +2967,8 @@ u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
 		return RAID_CTLR_LUNID;
 
 	if (i < logicals_start)
-		return &physdev_list->LUN[i - (raid_ctlr_position == 0)][0];
+		return &physdev_list->LUN[i -
+				(raid_ctlr_position == 0)].lunid[0];
 
 	if (i < last_device)
 		return &logdev_list->LUN[i - nphysicals -
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 104b67b..649b463 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -238,11 +238,21 @@ struct ReportLUNdata {
 	u8 LUN[HPSA_MAX_LUN][8];
 };
 
+struct ext_report_lun_entry {
+	u8 lunid[8];
+	u8 wwid[8];
+	u8 device_type;
+	u8 device_flags;
+	u8 lun_count; /* multi-lun device, how many luns */
+	u8 redundant_paths;
+	u32 ioaccel_handle; /* ioaccel1 only uses lower 16 bits */
+};
+
 struct ReportExtendedLUNdata {
 	u8 LUNListLength[4];
 	u8 extended_response_flag;
 	u8 reserved[3];
-	u8 LUN[HPSA_MAX_LUN][24];
+	struct ext_report_lun_entry LUN[HPSA_MAX_LUN];
 };
 
 struct SenseSubsystem_info {

