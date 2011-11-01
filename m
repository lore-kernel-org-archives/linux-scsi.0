From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 2/4] scsi_dh_hp_sw: Adding the match function for hp_sw device handler
Date: Tue, 1 Nov 2011 13:19:41 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D6@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:45034 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab1KARTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2011 13:19:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>

This patch introduces the match fuction for hp_sw device handler.
The match function was introduced by this patch
http://www.spinics.net/lists/linux-scsi/msg54284.html

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---

--- linux/drivers/scsi/device_handler/scsi_dh_hp_sw.c.orig	2011-10-31 11:25:07.000000000 -0500
+++ linux/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2011-10-31 12:33:05.000000000 -0500
@@ -319,6 +319,20 @@ static const struct scsi_dh_devlist hp_s
 	{NULL, NULL},
 };
 
+static bool hp_sw_match(struct scsi_device *sdev)
+{
+	int i;
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
 
@@ -330,6 +344,7 @@ static struct scsi_device_handler hp_sw_
 	.detach		= hp_sw_bus_detach,
 	.activate	= hp_sw_activate,
 	.prep_fn	= hp_sw_prep_fn,
+	.match		= hp_sw_match,
 };
 
 static int hp_sw_bus_attach(struct scsi_device *sdev)


