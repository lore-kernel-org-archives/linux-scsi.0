From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 2/3] scsi_dh: Change scsi device handler modules to utilize modalias
Date: Mon, 27 Apr 2009 11:06:21 -0700
Message-ID: <20090427180621.22758.25097.sendpatchset@chandra-ubuntu>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:44449 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbZD0SFk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 14:05:40 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3RI02Qw031958
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:00:04 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RI5U0G033200
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:05:30 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3RI5Toc011909
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:05:29 -0600
In-Reply-To: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, hare@suse.de, Chandra Seetharaman <sekharan@us.ibm.com>

From: Peter Jones <pjones@redhat.com>

This patch changes the scsi_dh files to make use of the modalias feature.

Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 drivers/scsi/device_handler/scsi_dh.c       |    5 +++-
 drivers/scsi/device_handler/scsi_dh_alua.c  |   23 ++++++++-------
 drivers/scsi/device_handler/scsi_dh_emc.c   |   11 ++++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   13 +++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c  |   42 +++++++++++++++-------------
 5 files changed, 51 insertions(+), 43 deletions(-)

Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh.c
@@ -75,7 +75,10 @@ static int scsi_dh_handler_lookup(struct
 {
 	int i, found = 0;
 
-	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
+	for(i = 0; scsi_dh->devlist[i].vendor[0]; i++) {
+		if ((scsi_dh->devlist[i].type != TYPE_ANY) &&
+				(scsi_dh->devlist[i].type != sdev->type))
+			continue;
 		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
 			     strlen(scsi_dh->devlist[i].vendor)) &&
 		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_alua.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -691,19 +691,21 @@ static int alua_prep_fn(struct scsi_devi
 }
 
 static const struct scsi_dh_devlist alua_dev_list[] = {
-	{"HP", "MSA VOLUME" },
-	{"HP", "HSV101" },
-	{"HP", "HSV111" },
-	{"HP", "HSV200" },
-	{"HP", "HSV210" },
-	{"HP", "HSV300" },
-	{"IBM", "2107900" },
-	{"IBM", "2145" },
-	{"Pillar", "Axiom" },
-	{"Intel", "Multi-Flex"},
-	{NULL, NULL}
+	{TYPE_ANY, "HP", "MSA VOLUME" },
+	{TYPE_ANY, "HP", "HSV101" },
+	{TYPE_ANY, "HP", "HSV111" },
+	{TYPE_ANY, "HP", "HSV200" },
+	{TYPE_ANY, "HP", "HSV210" },
+	{TYPE_ANY, "HP", "HSV300" },
+	{TYPE_ANY, "IBM", "2107900" },
+	{TYPE_ANY, "IBM", "2145" },
+	{TYPE_ANY, "Pillar", "Axiom" },
+	{TYPE_ANY, "Intel", "Multi-Flex"},
+	{0, "", ""},
 };
 
+MODULE_DEVICE_TABLE(scsi_dh, alua_dev_list);
+
 static int alua_bus_attach(struct scsi_device *sdev);
 static void alua_bus_detach(struct scsi_device *sdev);
 
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_emc.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -562,12 +562,13 @@ done:
 	return result;
 }
 
-static const struct scsi_dh_devlist clariion_dev_list[] = {
-	{"DGC", "RAID"},
-	{"DGC", "DISK"},
-	{"DGC", "VRAID"},
-	{NULL, NULL},
+static const struct scsi_dh_device_id clariion_dev_list[] = {
+	{TYPE_ANY, "DGC", "RAID"},
+	{TYPE_ANY, "DGC", "DISK"},
+	{TYPE_ANY, "DGC", "VRAID"},
+	{0, "", ""},
 };
+MODULE_DEVICE_TABLE(scsi_dh, clariion_dev_list);
 
 static int clariion_bus_attach(struct scsi_device *sdev);
 static void clariion_bus_detach(struct scsi_device *sdev);
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -286,13 +286,14 @@ static int hp_sw_activate(struct scsi_de
 	return ret;
 }
 
-static const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
-	{"COMPAQ", "MSA1000 VOLUME"},
-	{"COMPAQ", "HSV110"},
-	{"HP", "HSV100"},
-	{"DEC", "HSG80"},
-	{NULL, NULL},
+static const struct scsi_dh_device_id hp_sw_dh_data_list[] = {
+	{TYPE_ANY, "COMPAQ", "MSA1000 VOLUME"},
+	{TYPE_ANY, "COMPAQ", "HSV110"},
+	{TYPE_ANY, "HP", "HSV100"},
+	{TYPE_ANY, "DEC", "HSG80"},
+	{0, "", ""},
 };
+MODULE_DEVICE_TABLE(scsi_dh, hp_sw_dh_data_list);
 
 static int hp_sw_bus_attach(struct scsi_device *sdev);
 static void hp_sw_bus_detach(struct scsi_device *sdev);
Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -608,28 +608,30 @@ static int rdac_check_sense(struct scsi_
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-static const struct scsi_dh_devlist rdac_dev_list[] = {
-	{"IBM", "1722"},
-	{"IBM", "1724"},
-	{"IBM", "1726"},
-	{"IBM", "1742"},
-	{"IBM", "1814"},
-	{"IBM", "1815"},
-	{"IBM", "1818"},
-	{"IBM", "3526"},
-	{"SGI", "TP9400"},
-	{"SGI", "TP9500"},
-	{"SGI", "IS"},
-	{"STK", "OPENstorage D280"},
-	{"SUN", "CSM200_R"},
-	{"SUN", "LCSM100_F"},
-	{"DELL", "MD3000"},
-	{"DELL", "MD3000i"},
-	{"LSI", "INF-01-00"},
-	{"ENGENIO", "INF-01-00"},
-	{NULL, NULL},
+static const struct scsi_dh_device_id rdac_dev_list[] = {
+	{TYPE_ANY, "IBM", "1722"},
+	{TYPE_ANY, "IBM", "1724"},
+	{TYPE_ANY, "IBM", "1726"},
+	{TYPE_ANY, "IBM", "1742"},
+	{TYPE_ANY, "IBM", "1814"},
+	{TYPE_ANY, "IBM", "1815"},
+	{TYPE_ANY, "IBM", "1818"},
+	{TYPE_ANY, "IBM", "3526"},
+	{TYPE_ANY, "SGI", "TP9400"},
+	{TYPE_ANY, "SGI", "TP9500"},
+	{TYPE_ANY, "SGI", "IS"},
+	{TYPE_ANY, "STK", "OPENstorage D280"},
+	{TYPE_ANY, "SUN", "CSM200_R"},
+	{TYPE_ANY, "SUN", "LCSM100_F"},
+	{TYPE_ANY, "DELL", "MD3000"},
+	{TYPE_ANY, "DELL", "MD3000i"},
+	{TYPE_ANY, "LSI", "INF-01-00"},
+	{TYPE_ANY, "ENGENIO", "INF-01-00"},
+	{0, "", ""},
 };
 
+MODULE_DEVICE_TABLE(scsi_dh, rdac_dev_list);
+
 static int rdac_bus_attach(struct scsi_device *sdev);
 static void rdac_bus_detach(struct scsi_device *sdev);
 
