Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FD0C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18D5D208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgGaVB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:29 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:42097 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgGaVB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:29 -0400
IronPort-SDR: HwQTldh3eIBrUBMi80xIv4tNBIzbONBgSXgqsEXu+1g8cFkWH83FJxQE8bMci10U/hm1th9rkJ
 628HXIxePWRqfxeW12FcSzbDJEQlUbdbso/kd8ng+Q2ahWowAFD0HBJ/aZgrKTwvEgmlnln28l
 Y8kyRpxmmUKWSTf9uWrWkplg499tHst6s+D8sbsq7/XZ2fKEDWJTn71GH9gPX9a3pkb5zRt5oL
 DXlSCmccuU1f6E8v10MYweg5AuDFTRhy2u/u8xXhWdXfOSUX++bQLR26HkCMkhaX8M3VAkfoJ6
 mHU=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="85420459"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:26 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:26 -0700
Subject: [PATCH 3/7] smartpqi: update logical volume size after expansion
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:27 -0500
Message-ID: <159622928727.30579.298277463169866711.stgit@brunhilda>
In-Reply-To: <159622890296.30579.6820363566594432069.stgit@brunhilda>
References: <159622890296.30579.6820363566594432069.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>

- Have OS rescan after logical volume expansion to reflect
  new size.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 +
 drivers/scsi/smartpqi/smartpqi_init.c |   21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 48ca2ee06972..c2382eedbbc3 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -927,6 +927,7 @@ struct pqi_scsi_dev {
 	u8	new_device : 1;
 	u8	keep_device : 1;
 	u8	volume_offline : 1;
+	u8	rescan : 1;
 	bool	aio_enabled;		/* only valid for physical disks */
 	bool	in_reset;
 	bool	in_remove;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 4c13ee763974..92bc8ae2a1af 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1688,6 +1688,11 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 		existing_device->target_lun_valid = true;
 	}
 
+	if ((existing_device->volume_status == CISS_LV_QUEUED_FOR_EXPANSION ||
+		existing_device->volume_status == CISS_LV_UNDERGOING_EXPANSION) &&
+		new_device->volume_status == CISS_LV_OK)
+		existing_device->rescan = true;
+
 	/* By definition, the scsi3addr and wwid fields are already the same. */
 
 	existing_device->is_physical_device = new_device->is_physical_device;
@@ -1872,11 +1877,17 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	 */
 	list_for_each_entry(device, &ctrl_info->scsi_device_list,
 		scsi_device_list_entry) {
-		if (device->sdev && device->queue_depth !=
-			device->advertised_queue_depth) {
-			device->advertised_queue_depth = device->queue_depth;
-			scsi_change_queue_depth(device->sdev,
-				device->advertised_queue_depth);
+		if (device->sdev) {
+			if (device->queue_depth !=
+				device->advertised_queue_depth) {
+				device->advertised_queue_depth = device->queue_depth;
+				scsi_change_queue_depth(device->sdev,
+					device->advertised_queue_depth);
+			}
+			if (device->rescan) {
+				scsi_rescan_device(&device->sdev->sdev_gendev);
+				device->rescan = false;
+			}
 		}
 	}
 

