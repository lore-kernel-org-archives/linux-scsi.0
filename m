From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/35] hpsa: use extended report luns command for HP SSD
	SmartPath
Date: Tue, 18 Feb 2014 13:55:07 -0600
Message-ID: <20140218195506.15787.5413.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57013 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBRT5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:57:21 -0500
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 5ED1CB0A
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:56:51 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Matt Gates <matthew.gates@hp.com>

There is an extended report luns command which contains
additional information about physical devices.  In particular
we need to get the physical device handle so we can use an
alternate i/o path for fast physical devices like SSDs so
we can speed up certain i/o's by bypassing the RAID stack
code in the controller firmware.

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |   13 ++++++++-----
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 868318a..efaad6a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1888,11 +1888,12 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	struct ReportLUNdata *physdev, u32 *nphysicals,
 	struct ReportLUNdata *logdev, u32 *nlogicals)
 {
-	if (hpsa_scsi_do_report_phys_luns(h, physdev, reportlunsize, 0)) {
+	if (hpsa_scsi_do_report_phys_luns(h, physdev, reportlunsize,
+					HPSA_REPORT_PHYS_EXTENDED)) {
 		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
 		return -1;
 	}
-	*nphysicals = be32_to_cpu(*((__be32 *)physdev->LUNListLength)) / 8;
+	*nphysicals = be32_to_cpu(*((__be32 *)physdev->LUNListLength)) / 24;
 	if (*nphysicals > HPSA_MAX_PHYS_LUN) {
 		dev_warn(&h->pdev->dev, "maximum physical LUNs (%d) exceeded."
 			"  %d LUNs ignored.\n", HPSA_MAX_PHYS_LUN,
@@ -1923,7 +1924,8 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 }
 
 u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
-	int nphysicals, int nlogicals, struct ReportLUNdata *physdev_list,
+	int nphysicals, int nlogicals,
+	struct ReportExtendedLUNdata *physdev_list,
 	struct ReportLUNdata *logdev_list)
 {
 	/* Helper function, figure out where the LUN ID info is coming from
@@ -1959,7 +1961,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	 * tell which devices we already know about, vs. new
 	 * devices, vs.  disappearing devices.
 	 */
-	struct ReportLUNdata *physdev_list = NULL;
+	struct ReportExtendedLUNdata *physdev_list = NULL;
 	struct ReportLUNdata *logdev_list = NULL;
 	u32 nphysicals = 0;
 	u32 nlogicals = 0;
@@ -1982,7 +1984,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	}
 	memset(lunzerobits, 0, sizeof(lunzerobits));
 
-	if (hpsa_gather_lun_info(h, reportlunsize, physdev_list, &nphysicals,
+	if (hpsa_gather_lun_info(h, reportlunsize,
+			(struct ReportLUNdata *) physdev_list, &nphysicals,
 			logdev_list, &nlogicals))
 		goto out;
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index bfc8c4e..3f96b66 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -162,6 +162,7 @@ struct InquiryData {
 
 #define HPSA_REPORT_LOG 0xc2    /* Report Logical LUNs */
 #define HPSA_REPORT_PHYS 0xc3   /* Report Physical LUNs */
+#define HPSA_REPORT_PHYS_EXTENDED 0x02
 struct ReportLUNdata {
 	u8 LUNListLength[4];
 	u32 reserved;

