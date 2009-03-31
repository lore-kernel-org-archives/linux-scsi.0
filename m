From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] osd_uld: Remove creation of osd_scsi class symlink
Date: Tue, 31 Mar 2009 20:06:44 +0300
Message-ID: <49D24DA4.3030207@panasas.com>
References: <49D24BD3.2030801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:26031 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754098AbZCaRIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 13:08:43 -0400
In-Reply-To: <49D24BD3.2030801@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xu Yang <onlyxuyang@qq.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>


Remove the creation of the symlink from the device to
it's class. On modern systems this is already created by
a udev rule and would WARN on load. On old systems it is
not needed, none of the current osd user-mode tools use
this link.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index f8b1a74..f644c95 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -345,10 +345,6 @@ static int osd_probe(struct device *dev)
 	}
 
 	dev_set_drvdata(oud->class_member, oud);
-	error = sysfs_create_link(&scsi_device->sdev_gendev.kobj,
-				  &oud->class_member->kobj, osd_symlink);
-	if (error)
-		OSD_ERR("warning: unable to make symlink\n");
 
 	OSD_INFO("osd_probe %s\n", disk->disk_name);
 	return 0;
@@ -377,8 +373,6 @@ static int osd_remove(struct device *dev)
 			scsi_device);
 	}
 
-	sysfs_remove_link(&oud->od.scsi_device->sdev_gendev.kobj, osd_symlink);
-
 	if (oud->class_member)
 		device_destroy(osd_sysfs_class,
 			       MKDEV(SCSI_OSD_MAJOR, oud->minor));
-- 
1.6.2.1


