Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AA6C433E8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F07820719
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgG0TBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:01:18 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46521 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgG0TBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 15:01:17 -0400
IronPort-SDR: wrxnDl2RFkIkULauy/m3AXYHR69EH5nj8kuulxEEkkaC6goPymKCfPX8Wek1jD7UKXlu+SV1RW
 z2HCccHV9iqX/NRyJmwavbKDZ5080afuwtBooNGeg5awxKyvtSXYmz6zY00/hhOnlIt9Q6Pz+G
 9Qj3munFBEQPtsJig6bjeYNpKHOMkfEFUhw9gc0NIRSuPgDCSl4Fkzu0Cb3lt50GuqO7Q8imPf
 eCVM8SFmYej0hjM4Jc1d9gXGr1WgluTwHNdR1fnBkWwxIYNZVXKI3PcdWzN4DSXN0zAWcUKXbi
 644=
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="89292297"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jul 2020 12:01:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 12:01:15 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 27 Jul 2020 12:00:30 -0700
Subject: [PATCH 1/4] hpsa: correct rare oob condition
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 27 Jul 2020 14:01:16 -0500
Message-ID: <159587647598.27787.15511745962413099922.stgit@brunhilda>
In-Reply-To: <159587636236.27787.16970342225988726638.stgit@brunhilda>
References: <159587636236.27787.16970342225988726638.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are some rare conditions where a spare
is first in the device list causing an array
out-of-bounds condition.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 81d0414e2117..9b1edc541ed0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3443,9 +3443,14 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 	struct ErrorInfo *ei = NULL;
 	struct bmic_sense_storage_box_params *bssbp = NULL;
 	struct bmic_identify_physical_device *id_phys = NULL;
-	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
+	struct ext_report_lun_entry *rle;
 	u16 bmic_device_index = 0;
 
+	if (rle_index < 0 || rle_index >= HPSA_MAX_PHYS_LUN)
+		return;
+
+	rle = &rlep->LUN[rle_index];
+
 	encl_dev->eli =
 		hpsa_get_enclosure_logical_identifier(h, scsi3addr);
 
@@ -4174,6 +4179,9 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 	int rc;
 	struct ext_report_lun_entry *rle;
 
+	if (rle_index < 0 || rle_index >= HPSA_MAX_PHYS_LUN)
+		return;
+
 	rle = &rlep->LUN[rle_index];
 
 	dev->ioaccel_handle = rle->ioaccel_handle;
@@ -4198,7 +4206,12 @@ static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,
 	struct ReportExtendedLUNdata *rlep, int rle_index,
 	struct bmic_identify_physical_device *id_phys)
 {
-	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
+	struct ext_report_lun_entry *rle;
+
+	if (rle_index < 0 || rle_index >= HPSA_MAX_PHYS_LUN)
+		return;
+
+	rle = &rlep->LUN[rle_index];
 
 	if ((rle->device_flags & 0x08) && this_device->ioaccel_handle)
 		this_device->hba_ioaccel_enabled = 1;
@@ -4420,7 +4433,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		/*
 		 * Skip over some devices such as a spare.
 		 */
-		if (!tmpdevice->external && physical_device) {
+		if (phys_dev_index >= 0 && !tmpdevice->external &&
+			physical_device) {
 			skip_device = hpsa_skip_device(h, lunaddrbytes,
 					&physdev_list->LUN[phys_dev_index]);
 			if (skip_device)

