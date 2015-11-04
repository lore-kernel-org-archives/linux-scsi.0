From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 08/27] hpsa: abandon rescans on memory alloaction
 failures.
Date: Wed, 04 Nov 2015 15:50:44 -0600
Message-ID: <20151104215044.15472.82408.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60753 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030228AbbKDVyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:36 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Abandon and reschedule rescan process only if device inquiries
fail due to mem alloc failures, which are likely to occur for
all devices.

Otherwise, skip device if inquiry fails for other reasons,
and continue rescanning process for other devices.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f010b8e..ce0341a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3366,10 +3366,13 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 
 	unsigned char *inq_buff;
 	unsigned char *obdr_sig;
+	int rc = 0;
 
 	inq_buff = kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
-	if (!inq_buff)
+	if (!inq_buff) {
+		rc = -ENOMEM;
 		goto bail_out;
+	}
 
 	/* Do an inquiry to the device to see what it is. */
 	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
@@ -3377,6 +3380,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		/* Inquiry failed (msg printed already) */
 		dev_err(&h->pdev->dev,
 			"hpsa_update_device_info: inquiry failed\n");
+		rc = -EIO;
 		goto bail_out;
 	}
 
@@ -3426,7 +3430,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 
 bail_out:
 	kfree(inq_buff);
-	return 1;
+	return rc;
 }
 
 static void hpsa_update_device_supports_aborts(struct ctlr_info *h,
@@ -3794,6 +3798,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 	n_ext_target_devs = 0;
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
 		u8 *lunaddrbytes, is_OBDR = 0;
+		int rc = 0;
 
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
@@ -3806,11 +3811,20 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 				continue;
 
 		/* Get device type, vendor, model, device id */
-		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
-							&is_OBDR)) {
+		rc = hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
+							&is_OBDR);
+		if (rc == -ENOMEM) {
+			dev_warn(&h->pdev->dev,
+				"Out of memory, rescan deferred.\n");
 			h->drv_req_rescan = 1;
-			continue; /* skip it if we can't talk to it. */
+			goto out;
 		}
+		if (rc) {
+			dev_warn(&h->pdev->dev,
+				"Inquiry failed, skipping device.\n");
+			continue;
+		}
+
 		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
 		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
 		this_device = currentsd[ncurrent];

