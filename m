From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/3] hpsa: fix handling of hpsa_volume_offline return value
Date: Wed, 21 May 2014 11:16:13 -0500
Message-ID: <20140521161613.14409.35734.stgit@beardog.cce.hp.com>
References: <20140521161600.14409.36072.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:48732 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaEUQRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 12:17:20 -0400
Received: from g5t1625.atlanta.hp.com (g5t1625.atlanta.hp.com [15.192.137.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id A79DC6200D
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 16:17:19 +0000 (UTC)
In-Reply-To: <20140521161600.14409.36072.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Make return value an int instead of an unsigned char so that
we do not lose negative error return values.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/hpsa.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af51e7d..13ec036 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1191,7 +1191,7 @@ static void hpsa_monitor_offline_device(struct ctlr_info *h,
 static void hpsa_show_volume_status(struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *sd)
 {
-	if (sd->volume_offline == HPSA_VPD_LV_STATUS_UNSUPPORTED)
+	if (sd->volume_offline == (u8) HPSA_VPD_LV_STATUS_UNSUPPORTED)
 		dev_info(&h->pdev->dev,
 			"C%d:B%d:T%d:L%d Volume status is not available through vital product data pages.\n",
 			h->scsi_host->host_no,
@@ -2547,7 +2547,7 @@ exit_failed:
  *  # (integer code indicating one of several NOT READY states
  *     describing why a volume is to be kept offline)
  */
-static unsigned char hpsa_volume_offline(struct ctlr_info *h,
+static int hpsa_volume_offline(struct ctlr_info *h,
 					unsigned char scsi3addr[])
 {
 	struct CommandList *c;
@@ -2650,7 +2650,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
 		this_device->volume_offline =
-			hpsa_volume_offline(h, scsi3addr);
+			(u8) hpsa_volume_offline(h, scsi3addr);
 	} else {
 		this_device->raid_level = RAID_UNKNOWN;
 		this_device->offload_config = 0;

