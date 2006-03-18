From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert mptsas over to end_device/expander allocations
Date: Sat, 18 Mar 2006 14:54:36 -0600
Message-ID: <1142715276.3773.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24261 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750841AbWCRUyu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 15:54:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>

The conversion of mptsas should allow the elimination of the contained
flag in the sas transport class.

James

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -363,6 +363,14 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *io
 	return error;
 }
 
+static int
+mptsas_slave_configure(struct scsi_device *sdev)
+{
+	sas_read_port_mode_page(sdev);
+
+	return mptscsih_slave_configure(sdev);
+}
+
 /*
  * This is pretty ugly.  We will be able to seriously clean it up
  * once the DV code in mptscsih goes away and we can properly
@@ -486,7 +494,7 @@ static struct scsi_host_template mptsas_
 	.queuecommand			= mptscsih_qcmd,
 	.target_alloc			= mptscsih_target_alloc,
 	.slave_alloc			= mptsas_slave_alloc,
-	.slave_configure		= mptscsih_slave_configure,
+	.slave_configure		= mptsas_slave_configure,
 	.target_destroy			= mptscsih_target_destroy,
 	.slave_destroy			= mptsas_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
@@ -1249,6 +1257,7 @@ static int mptsas_probe_one_phy(struct d
 	    (!phy_info->rphy)) {
 
 		struct sas_rphy *rphy;
+		struct sas_identify identify;
 
 		ioc = phy_to_ioc(phy_info->phy);
 
@@ -1261,11 +1270,24 @@ static int mptsas_probe_one_phy(struct d
 			mptsas_is_end_device(&phy_info->attached))
 			return 0;
 
-		rphy = sas_rphy_alloc(phy);
+		mptsas_parse_device_info(&identify, &phy_info->attached);
+		switch (identify.device_type) {
+		case SAS_END_DEVICE:
+			rphy = sas_end_device_alloc(phy);
+			break;
+		case SAS_EDGE_EXPANDER_DEVICE:
+		case SAS_FANOUT_EXPANDER_DEVICE:
+			rphy = sas_expander_alloc(phy, identify.device_type);
+			break;
+		default:
+			rphy = NULL;
+			break;
+		}
 		if (!rphy)
 			return 0; /* non-fatal: an rphy can be added later */
 
-		mptsas_parse_device_info(&rphy->identify, &phy_info->attached);
+		rphy->identify = identify;
+
 		error = sas_rphy_add(rphy);
 		if (error) {
 			sas_rphy_free(rphy);
@@ -1654,6 +1676,7 @@ mptsas_hotplug_work(void *arg)
 	struct mptsas_phyinfo *phy_info;
 	struct sas_rphy *rphy;
 	struct scsi_device *sdev;
+	struct sas_identify identify;
 	char *ds = NULL;
 	struct mptsas_devinfo sas_device;
 	VirtTarget *vtarget;
@@ -1779,11 +1802,23 @@ mptsas_hotplug_work(void *arg)
 		       "attaching %s device, channel %d, id %d, phy %d\n",
 		       ioc->name, ds, ev->channel, ev->id, ev->phy_id);
 
-		rphy = sas_rphy_alloc(phy_info->phy);
+		mptsas_parse_device_info(&identify, &phy_info->attached);
+		switch (identify.device_type) {
+		case SAS_END_DEVICE:
+			rphy = sas_end_device_alloc(phy_info->phy);
+			break;
+		case SAS_EDGE_EXPANDER_DEVICE:
+		case SAS_FANOUT_EXPANDER_DEVICE:
+			rphy = sas_expander_alloc(phy_info->phy, identify.device_type);
+			break;
+		default:
+			rphy = NULL;
+			break;
+		}
 		if (!rphy)
 			break; /* non-fatal: an rphy can be added later */
 
-		mptsas_parse_device_info(&rphy->identify, &phy_info->attached);
+		rphy->identify = identify;
 		if (sas_rphy_add(rphy)) {
 			sas_rphy_free(rphy);
 			break;


