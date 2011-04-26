From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/03] mptfusion: Adding inline data padding support for TAPE
 drive.
Date: Tue, 26 Apr 2011 12:09:46 +0530
Message-ID: <20110426063942.GD6066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:46405 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab1DZGUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2011 02:20:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Adding support for inline data padding for TAPE drive when running U320.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 6d9568d..5848fed 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -867,7 +867,11 @@ static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
 	struct _x_config_parms cfg;
 	struct _CONFIG_PAGE_HEADER hdr;
 	int err = -EBUSY;
-
+	u32 nego_parms;
+	u32 period;
+	struct scsi_device *sdev;
+	int i;
+	
 	/* don't allow updating nego parameters on RAID devices */
 	if (starget->channel == 0 &&
 	    mptspi_is_raid(hd, starget->id))
@@ -904,6 +908,24 @@ static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
 	pg1->Header.PageNumber = hdr.PageNumber;
 	pg1->Header.PageType = hdr.PageType;
 
+	nego_parms = le32_to_cpu(pg1->RequestedParameters);
+	period = (nego_parms & MPI_SCSIDEVPAGE1_RP_MIN_SYNC_PERIOD_MASK) >> 
+	    MPI_SCSIDEVPAGE1_RP_SHIFT_MIN_SYNC_PERIOD;
+	if (period == 8) {
+		/* Turn on inline data padding for TAPE when running U320 */
+		for (i = 0 ; i < 16; i++) {
+			sdev = scsi_device_lookup_by_target(starget, i);
+			if (sdev && sdev->type == TYPE_TAPE) {
+				sdev_printk(KERN_DEBUG, sdev, MYIOC_s_FMT 
+				     "IDP:ON\n", ioc->name);
+				nego_parms |= MPI_SCSIDEVPAGE1_RP_IDP;
+				pg1->RequestedParameters =
+				    cpu_to_le32(nego_parms);
+				break;
+			}
+		}
+	}
+
 	mptspi_print_write_nego(hd, starget, le32_to_cpu(pg1->RequestedParameters));
 
 	if (mpt_config(ioc, &cfg)) {
