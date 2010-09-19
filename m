From: Vasiliy Kulikov <segooon@gmail.com>
Subject: [PATCH 10/14] scsi: osd: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:07 +0400
Message-ID: <1284900907-24621-1-git-send-email-segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/scsi/osd/osd_uld.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index cefb2c0..3e0edc2 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -474,7 +474,7 @@ static int osd_probe(struct device *dev)
 	error = device_register(&oud->class_dev);
 	if (error) {
 		OSD_ERR("device_register failed => %d\n", error);
-		goto err_put_cdev;
+		goto err_put_device;
 	}
 
 	get_device(&oud->class_dev);
@@ -482,6 +482,8 @@ static int osd_probe(struct device *dev)
 	OSD_INFO("osd_probe %s\n", disk->disk_name);
 	return 0;
 
+err_put_device:
+	put_device(&oud->class_dev);
 err_put_cdev:
 	cdev_del(&oud->cdev);
 err_put_disk:
-- 
1.7.0.4
