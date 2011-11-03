From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [RESEND][PATCH 3/4] scsi_dh_rdac: Adding the match function for rdac device handler
Date: Thu, 3 Nov 2011 11:51:53 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DBE65@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:11276 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab1KCPv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 11:51:56 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>

This patch introduces the match function for rdac device handler. Without this,
sometimes handler attach fails during the device_add. Included check for TPGS
bit before proceeding further. The match function was introduced by this patch
http://www.spinics.net/lists/linux-scsi/msg54284.html

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---

--- linux-d211858/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-11-02 14:17:52.000000000 -0500
+++ linux-d211858/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-11-02 15:27:51.000000000 -0500
@@ -819,6 +819,24 @@ static const struct scsi_dh_devlist rdac
 	{NULL, NULL},
 };
 
+static bool rdac_match(struct scsi_device *sdev)
+{
+	int i;
+
+	if (scsi_device_tpgs(sdev))
+		return false;
+
+	for (i = 0; rdac_dev_list[i].vendor; i++) {
+		if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
+			strlen(rdac_dev_list[i].vendor)) &&
+		    !strncmp(sdev->model, rdac_dev_list[i].model,
+			strlen(rdac_dev_list[i].model))) {
+			return true;
+		}
+	}
+	return false;
+}
+
 static int rdac_bus_attach(struct scsi_device *sdev);
 static void rdac_bus_detach(struct scsi_device *sdev);
 
@@ -831,6 +849,7 @@ static struct scsi_device_handler rdac_d
 	.attach = rdac_bus_attach,
 	.detach = rdac_bus_detach,
 	.activate = rdac_activate,
+	.match = rdac_match,
 };
 
 static int rdac_bus_attach(struct scsi_device *sdev)


