From: Andy Grover <agrover@redhat.com>
Subject: [RFCv2 2/4] uio: Export definition of struct uio_device
Date: Wed, 20 Aug 2014 11:28:16 -0700
Message-ID: <1408559298-20037-3-git-send-email-agrover@redhat.com>
References: <1408559298-20037-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaHTS22 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2014 14:28:28 -0400
In-Reply-To: <1408559298-20037-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org

In order to prevent a O(n) search of the filesystem to link up its uio
node with its target configuration, TCMU needs to know the minor number
that UIO assigned. Expose the definition of this struct so TCMU can
access this field.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/uio/uio.c          | 12 ------------
 include/linux/uio_driver.h | 12 +++++++++++-
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a673e5b..60fa627 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -28,18 +28,6 @@
 
 #define UIO_MAX_DEVICES		(1U << MINORBITS)
 
-struct uio_device {
-	struct module		*owner;
-	struct device		*dev;
-	int			minor;
-	atomic_t		event;
-	struct fasync_struct	*async_queue;
-	wait_queue_head_t	wait;
-	struct uio_info		*info;
-	struct kobject		*map_dir;
-	struct kobject		*portio_dir;
-};
-
 static int uio_major;
 static struct cdev *uio_cdev;
 static DEFINE_IDR(uio_idr);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1ad4724..baa8171 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -63,7 +63,17 @@ struct uio_port {
 
 #define MAX_UIO_PORT_REGIONS	5
 
-struct uio_device;
+struct uio_device {
+        struct module           *owner;
+        struct device           *dev;
+        int                     minor;
+        atomic_t                event;
+        struct fasync_struct    *async_queue;
+        wait_queue_head_t       wait;
+        struct uio_info         *info;
+        struct kobject          *map_dir;
+        struct kobject          *portio_dir;
+};
 
 /**
  * struct uio_info - UIO device capabilities
-- 
1.9.3

