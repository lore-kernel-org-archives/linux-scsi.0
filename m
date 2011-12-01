From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH v3 1/4] scsi_dh_emc: Adding the match function for emc device handler
Date: Thu, 1 Dec 2011 15:01:16 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910AB8F8F@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:6830 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1LAUBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 15:01:24 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, hare@suse.de, Mike Snitzer <snitzer@redhat.com>, JBottomley@Parallels.com

This patch introduces the match function for emc device handler.
Included check for TPGS bit before proceeding further.
The match function was introduced by this patch
http://www.spinics.net/lists/linux-scsi/msg54284.html

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
--- linux-3.2-rc2/drivers/scsi/device_handler/scsi_dh_emc.c.orig	2011-11-15 11:02:59.000000000 -0600
+++ linux-3.2-rc2/drivers/scsi/device_handler/scsi_dh_emc.c	2011-11-19 10:46:12.000000000 -0600
@@ -629,6 +629,24 @@ static const struct scsi_dh_devlist clar
 	{NULL, NULL},
 };
 
+static bool clariion_match(struct scsi_device *sdev)
+{
+	int i;
+
+	if (scsi_device_tpgs(sdev))
+		return false;
+
+	for (i = 0; clariion_dev_list[i].vendor; i++) {
+		if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
+			strlen(clariion_dev_list[i].vendor)) &&
+		    !strncmp(sdev->model, clariion_dev_list[i].model,
+			strlen(clariion_dev_list[i].model))) {
+			return true;
+		}
+	}
+	return false;
+}
+
 static int clariion_bus_attach(struct scsi_device *sdev);
 static void clariion_bus_detach(struct scsi_device *sdev);
 
@@ -642,6 +660,7 @@ static struct scsi_device_handler clarii
 	.activate	= clariion_activate,
 	.prep_fn	= clariion_prep_fn,
 	.set_params	= clariion_set_params,
+	.match		= clariion_match,
 };
 
 static int clariion_bus_attach(struct scsi_device *sdev)


