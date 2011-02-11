From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH v2] [SCSI] fix kzalloc in scsi device handler
Date: Fri, 11 Feb 2011 15:17:33 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF60C1F7@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38500 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758267Ab1BKWQj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2011 17:16:39 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "dhillf@gmail.com" <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

Fixing the type for the kzalloc. Original path is here. http://marc.info/?l=linux-scsi&m=128991446117137&w=2

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Babu Moger <babu.moger@lsi.com>

---
diff -uprN -X linux-2.6.38-rc4/Documentation/dontdiff linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_alua.c linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_alua.c
--- linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_alua.c	2011-02-07 18:03:55.000000000 -0600
+++ linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_alua.c	2011-02-11 15:29:31.000000000 -0600
@@ -759,7 +759,7 @@ static int alua_bus_attach(struct scsi_d
 	unsigned long flags;
 	int err = SCSI_DH_OK;
 
-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
diff -uprN -X linux-2.6.38-rc4/Documentation/dontdiff linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_emc.c linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_emc.c
--- linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_emc.c	2011-02-07 18:03:55.000000000 -0600
+++ linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_emc.c	2011-02-11 15:29:50.000000000 -0600
@@ -650,7 +650,7 @@ static int clariion_bus_attach(struct sc
 	unsigned long flags;
 	int err;
 
-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
diff -uprN -X linux-2.6.38-rc4/Documentation/dontdiff linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_hp_sw.c linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_hp_sw.c
--- linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2011-02-07 18:03:55.000000000 -0600
+++ linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_hp_sw.c	2011-02-11 15:30:45.000000000 -0600
@@ -338,8 +338,8 @@ static int hp_sw_bus_attach(struct scsi_
 	unsigned long flags;
 	int ret;
 
-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
-			       + sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
+	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
+			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
diff -uprN -X linux-2.6.38-rc4/Documentation/dontdiff linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_rdac.c
--- linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-02-07 18:03:55.000000000 -0600
+++ linux-2.6.38-rc4-patched//drivers/scsi/device_handler/scsi_dh_rdac.c	2011-02-11 15:29:18.000000000 -0600
@@ -800,7 +800,7 @@ static int rdac_bus_attach(struct scsi_d
 	int err;
 	char array_name[ARRAY_LABEL_LEN];
 
-	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
+	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",


