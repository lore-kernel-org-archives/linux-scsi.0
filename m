From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] scsi: remove struct scsi_dh_devlist
Date: Thu, 30 Oct 2014 10:19:11 +0100
Message-ID: <1414660754-8431-4-git-send-email-hch@lst.de>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbaJ3JTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:19:05 -0400
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

All drivers now do their own matching, so there is no more need to expose
a device list as part of the interface.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_emc.c   | 6 ++++--
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 6 ++++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 6 ++++--
 include/scsi/scsi_device.h                  | 6 ------
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index c2e26cd..800deb7 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -622,7 +622,10 @@ done:
 	return result;
 }
 
-static const struct scsi_dh_devlist clariion_dev_list[] = {
+static const struct {
+	char *vendor;
+	char *model;
+} clariion_dev_list[] = {
 	{"DGC", "RAID"},
 	{"DGC", "DISK"},
 	{"DGC", "VRAID"},
@@ -653,7 +656,6 @@ static void clariion_bus_detach(struct scsi_device *sdev);
 static struct scsi_device_handler clariion_dh = {
 	.name		= CLARIION_NAME,
 	.module		= THIS_MODULE,
-	.devlist	= clariion_dev_list,
 	.attach		= clariion_bus_attach,
 	.detach		= clariion_bus_detach,
 	.check_sense	= clariion_check_sense,
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 040998c..aa40fcb 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -311,7 +311,10 @@ static int hp_sw_activate(struct scsi_device *sdev,
 	return 0;
 }
 
-static const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
+static const struct {
+	char *vendor;
+	char *model;
+} hp_sw_dh_data_list[] = {
 	{"COMPAQ", "MSA1000 VOLUME"},
 	{"COMPAQ", "HSV110"},
 	{"HP", "HSV100"},
@@ -343,7 +346,6 @@ static void hp_sw_bus_detach(struct scsi_device *sdev);
 static struct scsi_device_handler hp_sw_dh = {
 	.name		= HP_SW_NAME,
 	.module		= THIS_MODULE,
-	.devlist	= hp_sw_dh_data_list,
 	.attach		= hp_sw_bus_attach,
 	.detach		= hp_sw_bus_detach,
 	.activate	= hp_sw_activate,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index ef8caaa..8b09528 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -778,7 +778,10 @@ static int rdac_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-static const struct scsi_dh_devlist rdac_dev_list[] = {
+static const struct {
+	char *vendor;
+	char *model;
+} rdac_dev_list[] = {
 	{"IBM", "1722"},
 	{"IBM", "1724"},
 	{"IBM", "1726"},
@@ -830,7 +833,6 @@ static void rdac_bus_detach(struct scsi_device *sdev);
 static struct scsi_device_handler rdac_dh = {
 	.name = RDAC_NAME,
 	.module = THIS_MODULE,
-	.devlist = rdac_dev_list,
 	.prep_fn = rdac_prep_fn,
 	.check_sense = rdac_check_sense,
 	.attach = rdac_bus_attach,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 04cd5ad..2601c97 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -201,11 +201,6 @@ struct scsi_device {
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 
-struct scsi_dh_devlist {
-	char *vendor;
-	char *model;
-};
-
 typedef void (*activate_complete)(void *, int);
 struct scsi_device_handler {
 	/* Used by the infrastructure */
@@ -214,7 +209,6 @@ struct scsi_device_handler {
 	/* Filled by the hardware handler */
 	struct module *module;
 	const char *name;
-	const struct scsi_dh_devlist *devlist;
 	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
 	int (*attach)(struct scsi_device *);
 	void (*detach)(struct scsi_device *);
-- 
1.9.1

