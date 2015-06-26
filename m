From: =?UTF-8?B?5Yav5Yqb?= <lifeng1519@gmail.com>
Subject: [PATCH] drivers/scsi: fix macro in sg
Date: Fri, 26 Jun 2015 11:05:53 +0800
Message-ID: <CAEK8JBDNs=v-15ZiGt+HSzbKAaDhY0fuVHW77pUnLmonuyD8AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch fix the macro transport_class_to_sdev to the resonable name
and use the macro.


Signed-off-by: vonnyfly <lifeng1519@gmail.com>
---
 drivers/scsi/sg.c          |    6 +++---
 include/scsi/scsi_device.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9d7b7db..be7f132 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1454,10 +1454,10 @@ out_unlock:
 static int
 sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
- struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
- struct gendisk *disk;
+ struct scsi_device *scsidp = transport_class_to_scsi_device(cl_dev);
+ struct gendisk *disk = NULL;
  Sg_device *sdp = NULL;
- struct cdev * cdev = NULL;
+ struct cdev *cdev = NULL;
  int error;
  unsigned long iflags;

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ae84b22..f6a5473 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -227,7 +227,7 @@ struct scsi_dh_data {
  container_of(d, struct scsi_device, sdev_gendev)
 #define class_to_sdev(d) \
  container_of(d, struct scsi_device, sdev_dev)
-#define transport_class_to_sdev(class_dev) \
+#define transport_class_to_scsi_device(class_dev) \
  to_scsi_device(class_dev->parent)

 #define sdev_dbg(sdev, fmt, a...) \
--
1.7.10.4

-- 
Thanks and Best Regards,
Feng Li(Alex)
