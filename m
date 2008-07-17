From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [scsi_dh] [PATCH] Verify "dev" is a sdev before accessing it.
Date: Wed, 16 Jul 2008 17:35:08 -0700
Message-ID: <1216254908.27507.245.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39703 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYGQAfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 20:35:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>

Before accessing the device data structure in hardware handlers,
make sure it is a indeed a sdev device.

Yinghai Lu <yhlu.kernel@gmail.com> found the bug on Jul 16, 2008,
and later tested/verified the following fix.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
--

Index: linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux2.6.26-git3.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -608,12 +608,17 @@ static int rdac_bus_notify(struct notifi
 			    unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device *sdev;
 	struct scsi_dh_data *scsi_dh_data;
 	struct rdac_dh_data *h;
 	int i, found = 0;
 	unsigned long flags;
 
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		for (i = 0; rdac_dev_list[i].vendor; i++) {
 			if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
Index: linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux2.6.26-git3.orig/drivers/scsi/device_handler/scsi_dh_emc.c
+++ linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -416,12 +416,17 @@ static int clariion_bus_notify(struct no
 				unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device *sdev;
 	struct scsi_dh_data *scsi_dh_data;
 	struct clariion_dh_data *h;
 	int i, found = 0;
 	unsigned long flags;
 
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		for (i = 0; clariion_dev_list[i].vendor; i++) {
 			if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
Index: linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- linux2.6.26-git3.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -131,11 +131,16 @@ static int hp_sw_bus_notify(struct notif
 			    unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device *sdev;
 	struct scsi_dh_data *scsi_dh_data;
 	int i, found = 0;
 	unsigned long flags;
 
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		for (i = 0; hp_sw_dh_data_list[i].vendor; i++) {
 			if (!strncmp(sdev->vendor, hp_sw_dh_data_list[i].vendor,


