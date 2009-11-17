From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 10/10] osduld: No need to use dev_set_drvdata on embedded
 devices
Date: Tue, 17 Nov 2009 15:50:59 +0200
Message-ID: <4B02AA43.4010407@panasas.com>
References: <4B019BEC.3080909@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:22404 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752018AbZKQNuz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 08:50:55 -0500
In-Reply-To: <4B019BEC.3080909@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>


This is a micro optimization patch on cold path code.
Use container_of() on embedded device instead of using
dev_set_drvdata. Also makes code structure more clear.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 0484bae..0a90702 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -246,7 +246,8 @@ struct find_oud_t {
 
 int _mach_odi(struct device *dev, void *find_data)
 {
-	struct osd_uld_device *oud = dev_get_drvdata(dev);
+	struct osd_uld_device *oud = container_of(dev, struct osd_uld_device,
+						  class_dev);
 	struct find_oud_t *fot = find_data;
 	const struct osd_dev_info *odi = fot->odi;
 
@@ -367,7 +368,8 @@ static int __detect_osd(struct osd_uld_device *oud)
 
 static void __remove(struct device *dev)
 {
-	struct osd_uld_device *oud = dev_get_drvdata(dev);
+	struct osd_uld_device *oud = container_of(dev, struct osd_uld_device,
+						  class_dev);
 	struct scsi_device *scsi_device = oud->od.scsi_device;
 
 	kfree(oud->odi.osdname);
@@ -461,7 +463,6 @@ static int osd_probe(struct device *dev)
 	oud->class_dev.class = &osd_uld_class;
 	oud->class_dev.parent = dev;
 	oud->class_dev.release = __remove;
-	dev_set_drvdata(&oud->class_dev, oud);
 	error = dev_set_name(&oud->class_dev, disk->disk_name);
 	if (error) {
 		OSD_ERR("dev_set_name failed => %d\n", error);
-- 
1.6.5.2


