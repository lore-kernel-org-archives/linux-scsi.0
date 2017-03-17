From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 11/16] media: utilize new cdev_device_add helper function
Date: Fri, 17 Mar 2017 12:48:18 -0600
Message-ID: <1489776503-3151-12-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1489776503-3151-1-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cyrille Pitchen <cyrille.pitchen-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Replace the open coded registration of the cdev and dev with the
new device_add_cdev() helper. The helper replaces a common pattern by
taking the proper reference against the parent device and adding both
the cdev and the device.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Acked-by: Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/media/cec/cec-core.c  | 16 ++++------------
 drivers/media/media-devnode.c | 20 +++++---------------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 37217e2..3163e03 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -137,24 +137,17 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &cec_devnode_fops);
-	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 	devnode->cdev.owner = owner;
 
-	ret = cdev_add(&devnode->cdev, devnode->dev.devt, 1);
-	if (ret < 0) {
-		pr_err("%s: cdev_add failed\n", __func__);
+	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
+	if (ret) {
+		pr_err("%s: cdev_device_add failed\n", __func__);
 		goto clr_bit;
 	}
 
-	ret = device_add(&devnode->dev);
-	if (ret)
-		goto cdev_del;
-
 	devnode->registered = true;
 	return 0;
 
-cdev_del:
-	cdev_del(&devnode->cdev);
 clr_bit:
 	mutex_lock(&cec_devnode_lock);
 	clear_bit(devnode->minor, cec_devnode_nums);
@@ -190,8 +183,7 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	devnode->unregistered = true;
 	mutex_unlock(&devnode->lock);
 
-	device_del(&devnode->dev);
-	cdev_del(&devnode->cdev);
+	cdev_device_del(&devnode->cdev, &devnode->dev);
 	put_device(&devnode->dev);
 }
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ae46753..423248f 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -248,31 +248,22 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	dev_set_name(&devnode->dev, "media%d", devnode->minor);
 	device_initialize(&devnode->dev);
 
-	/* Part 2: Initialize and register the character device */
+	/* Part 2: Initialize the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
 	devnode->cdev.owner = owner;
-	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 
-	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
+	/* Part 3: Add the media and char device */
+	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
 	if (ret < 0) {
-		pr_err("%s: cdev_add failed\n", __func__);
+		pr_err("%s: cdev_device_add failed\n", __func__);
 		goto cdev_add_error;
 	}
 
-	/* Part 3: Add the media device */
-	ret = device_add(&devnode->dev);
-	if (ret < 0) {
-		pr_err("%s: device_add failed\n", __func__);
-		goto device_add_error;
-	}
-
 	/* Part 4: Activate this minor. The char device can now be used. */
 	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 
 	return 0;
 
-device_add_error:
-	cdev_del(&devnode->cdev);
 cdev_add_error:
 	mutex_lock(&media_devnode_lock);
 	clear_bit(devnode->minor, media_devnode_nums);
@@ -298,9 +289,8 @@ void media_devnode_unregister(struct media_devnode *devnode)
 {
 	mutex_lock(&media_devnode_lock);
 	/* Delete the cdev on this minor as well */
-	cdev_del(&devnode->cdev);
+	cdev_device_del(&devnode->cdev, &devnode->dev);
 	mutex_unlock(&media_devnode_lock);
-	device_del(&devnode->dev);
 	devnode->media_dev = NULL;
 	put_device(&devnode->dev);
 }
-- 
2.1.4
