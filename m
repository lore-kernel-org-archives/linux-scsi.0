From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 1/4] scsi_dh_emc: Adding the match function for emc device handler
Date: Tue, 1 Nov 2011 13:19:31 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D5@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:53582 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab1KARTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2011 13:19:33 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>

This patch introduces the match fuction for emc device handler.
The match function was introduced by this patch
http://www.spinics.net/lists/linux-scsi/msg54284.html

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---

--- linux/drivers/scsi/device_handler/scsi_dh_emc.c.orig	2011-10-31 11:24:29.000000000 -0500
+++ linux/drivers/scsi/device_handler/scsi_dh_emc.c	2011-10-31 11:27:45.000000000 -0500
@@ -628,6 +628,20 @@ static const struct scsi_dh_devlist clar
 	{NULL, NULL},
 };
 
+static bool clariion_match(struct scsi_device *sdev)
+{
+	int i;
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
 
@@ -641,6 +655,7 @@ static struct scsi_device_handler clarii
 	.activate	= clariion_activate,
 	.prep_fn	= clariion_prep_fn,
 	.set_params	= clariion_set_params,
+	.match		= clariion_match,
 };
 
 static int clariion_bus_attach(struct scsi_device *sdev)


