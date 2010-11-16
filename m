From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix kzalloc in scsi device handler
Date: Tue, 16 Nov 2010 21:34:17 +0800
Message-ID: <AANLkTimsOGcybKBvJCjbtUaUpg5asYMDSky2QhovjcG+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65162 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab0KPNeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 08:34:19 -0500
Received: by ewy8 with SMTP id 8so230569ewy.19
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2010 05:34:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

They look like typo, since there are four instances of kzalloc almost
typed by the same finger.

The pointer is replaced with a struct, which helps kzalloc return
correct result.

thanks for any comment on the possibility that mem overflow could happen.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/device_handler/scsi_dh_alua.c	2010-11-01
19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2010-11-16
20:40:36.000000000 +0800
@@ -759,7 +759,7 @@ static int alua_bus_attach(struct scsi_d
 	unsigned long flags;
 	int err = SCSI_DH_OK;

-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+	scsi_dh_data = kzalloc(sizeof(struct scsi_dh_data)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
--- a/drivers/scsi/device_handler/scsi_dh_emc.c	2010-11-01
19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c	2010-11-16
20:40:38.000000000 +0800
@@ -650,7 +650,7 @@ static int clariion_bus_attach(struct sc
 	unsigned long flags;
 	int err;

-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+	scsi_dh_data = kzalloc(sizeof(struct scsi_dh_data)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2010-11-01
19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2010-11-16
20:40:36.000000000 +0800
@@ -338,7 +338,7 @@ static int hp_sw_bus_attach(struct scsi_
 	unsigned long flags;
 	int ret;

-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+	scsi_dh_data = kzalloc(sizeof(struct scsi_dh_data)
 			       + sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-11-01
19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-11-16
20:40:32.000000000 +0800
@@ -800,7 +800,7 @@ static int rdac_bus_attach(struct scsi_d
 	int err;
 	char array_name[ARRAY_LABEL_LEN];

-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+	scsi_dh_data = kzalloc(sizeof(struct scsi_dh_data)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
