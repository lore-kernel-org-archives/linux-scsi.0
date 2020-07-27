Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E68C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 938042072E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgG0T6b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:58:31 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:62013 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbgG0T6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 15:58:31 -0400
IronPort-SDR: vWvd8a5nqLPh/JLoVGpGUZ6EQsFCUpjDZnOt7ifG0g4eZLINh3ai6pTNyKFxHWyKjI8wCkg+Uh
 4IZ2g8ps5XMOj5RzIWUgGhIytVQmox/CPhzxbVIeVn24NCan/sO5Yqnu2ogU2yGwDOFwUc8DL7
 qF+GWqqi70juZ7osIbUByy8THJ2dpN3JvrreVlAYnLKzwjCVjiAeN440/R8tCGjYWK9/7ue53a
 T7LBFjfjYtBTwxsPnwOti7WNXIbq6rnuLls8FNhUH8k7iYmWtk2V6mtEwRUvbAyp0LHAaBznrf
 nJs=
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="84786778"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jul 2020 12:58:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 12:57:45 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 27 Jul 2020 12:58:27 -0700
Subject: [PATCH V3 1/4] hpsa: correct rare oob condition
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 27 Jul 2020 14:58:28 -0500
Message-ID: <159587990819.28270.9067960539097372726.stgit@brunhilda>
In-Reply-To: <159587987792.28270.15427178888235104199.stgit@brunhilda>
References: <159587987792.28270.15427178888235104199.stgit@brunhilda>
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

