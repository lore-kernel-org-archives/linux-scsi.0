From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] enclosure: fix sysfs symlinks creation when using multipath
Date: Thu,  2 Mar 2017 12:30:04 +0100
Message-ID: <1488454204-21251-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdCBMSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Mar 2017 07:18:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

With multipath, it may happen that the same device is passed
to enclosure_add_device() multiple times and that the enclosure_add_links()
function fails to create the symlinks because the device's sysfs
directory entry is still NULL.
In this case, the links will never be created because all the subsequent
calls to enclosure_add_device() will immediately fail with EEXIST.

This is an example of what happens:

[   19.251902] scsi 0:0:27:0: Direct-Access     SEAGATE  ST8000NM0075     E002 PQ: 0 ANSI: 6
[   19.261874] scsi 0:0:27:0: SSP: handle(0x0027), sas_addr(0x5000c50085826dd6), phy(34), device_name(0x5000c50085826dd4)
[   19.274656] scsi 0:0:27:0: SSP: enclosure_logical_id(0x500093d001be4000), slot(57)
[   19.283944] scsi 0:0:27:0: SSP: enclosure level(0x0000), connector name(     )
[   19.292933] scsi 0:0:27:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_l
[...]
[   60.066524] enclosure_add_device(0:0:27:0) called, enclosure_add_links() failed with error -2
[...]
[   75.119146] sd 0:0:27:0: Attached scsi generic sg27 type 0
[   75.126722] sd 0:0:27:0: [sdaa] 15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)
[   75.126723] sd 0:0:27:0: [sdaa] 4096-byte physical blocks
[   75.129059] sd 0:0:27:0: [sdaa] Write Protect is off
[   75.129061] sd 0:0:27:0: [sdaa] Mode Sense: db 00 10 08
[   75.130417] sd 0:0:27:0: [sdaa] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   75.158088] sd 0:0:27:0: [sdaa] Attached SCSI disk
[...]
[   75.192722] enclosure_add_device(0:0:27:0) called, device already exists

This patch modifies the code so the driver will detect this condition
and will retry to create the symlinks when enclosure_add_device() is called.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/misc/enclosure.c  | 16 ++++++++++++++--
 include/linux/enclosure.h |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 65fed71..a856c98 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -375,21 +375,33 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
 			 struct device *dev)
 {
 	struct enclosure_component *cdev;
+	int error;
 
 	if (!edev || component >= edev->components)
 		return -EINVAL;
 
 	cdev = &edev->component[component];
 
-	if (cdev->dev == dev)
+	if (cdev->dev == dev) {
+		if (!cdev->links_created) {
+			error = enclosure_add_links(cdev);
+			if (!error)
+				cdev->links_created = 1;
+		}
 		return -EEXIST;
+	}
 
 	if (cdev->dev)
 		enclosure_remove_links(cdev);
 
 	put_device(cdev->dev);
 	cdev->dev = get_device(dev);
-	return enclosure_add_links(cdev);
+	error = enclosure_add_links(cdev);
+	if (!error)
+		cdev->links_created = 1;
+	else
+		cdev->links_created = 0;
+	return error;
 }
 EXPORT_SYMBOL_GPL(enclosure_add_device);
 
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index a4cf57c..c3bdc4c 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -97,6 +97,7 @@ struct enclosure_component {
 	struct device cdev;
 	struct device *dev;
 	enum enclosure_component_type type;
+	int links_created;
 	int number;
 	int fault;
 	int active;
-- 
Maurizio Lombardi
