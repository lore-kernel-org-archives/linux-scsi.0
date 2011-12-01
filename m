From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH v3 2/4] scsi_dh_hp_sw: Adding the match function for hp_sw device handler
Date: Thu, 1 Dec 2011 15:01:28 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910AB8F91@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:18648 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1LAUBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 15:01:33 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, hare@suse.de, Mike Snitzer <snitzer@redhat.com>, JBottomley@Parallels.com

This patch introduces the match function for hp_sw device handler.
Included the check for TPGS bit before proceeding further per Hannes comment.
The match function was introduced by this patch
http://www.spinics.net/lists/linux-scsi/msg54284.html

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
--- linux-3.2-rc2/drivers/scsi/device_handler/scsi_dh_hp_sw.c.orig	2011-11-15 11:02:59.000000000 -0600
+++ linux-3.2-rc2/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2011-11-19 10:46:57.000000000 -0600
@@ -320,6 +320,24 @@ static const struct scsi_dh_devlist hp_s
 	{NULL, NULL},
 };
 
+static bool hp_sw_match(struct scsi_device *sdev)
+{
+	int i;
+
+	if (scsi_device_tpgs(sdev))
+		return false;
+
+	for (i = 0; hp_sw_dh_data_list[i].vendor; i++) {
+		if (!strncmp(sdev->vendor, hp_sw_dh_data_list[i].vendor,
+			strlen(hp_sw_dh_data_list[i].vendor)) &&
+		    !strncmp(sdev->model, hp_sw_dh_data_list[i].model,
+			strlen(hp_sw_dh_data_list[i].model))) {
+			return true;
+		}
+	}
+	return false;
+}
+
 static int hp_sw_bus_attach(struct scsi_device *sdev);
 static void hp_sw_bus_detach(struct scsi_device *sdev);
 
@@ -331,6 +349,7 @@ static struct scsi_device_handler hp_sw_
 	.detach		= hp_sw_bus_detach,
 	.activate	= hp_sw_activate,
 	.prep_fn	= hp_sw_prep_fn,
+	.match		= hp_sw_match,
 };
 
 static int hp_sw_bus_attach(struct scsi_device *sdev)


