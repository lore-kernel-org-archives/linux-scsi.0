From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 03/16] device-dax: utilize new cdev_device_add helper
 function
Date: Fri, 17 Mar 2017 12:48:10 -0600
Message-ID: <1489776503-3151-4-git-send-email-logang@deltatee.com>
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
Reviewed-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/dax/dax.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index a5ed59a..e5f8555 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -677,8 +677,6 @@ static void dax_dev_release(struct device *dev)
 
 static void kill_dax_dev(struct dax_dev *dax_dev)
 {
-	struct cdev *cdev = &dax_dev->cdev;
-
 	/*
 	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
 	 * ensuring that any fault handlers that might have seen
@@ -689,7 +687,6 @@ static void kill_dax_dev(struct dax_dev *dax_dev)
 	dax_dev->alive = false;
 	synchronize_rcu();
 	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
-	cdev_del(cdev);
 }
 
 static void unregister_dax_dev(void *dev)
@@ -699,7 +696,8 @@ static void unregister_dax_dev(void *dev)
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dax_dev(dax_dev);
-	device_unregister(dev);
+	cdev_device_del(&dax_dev->cdev, dev);
+	put_device(dev);
 }
 
 struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
@@ -750,18 +748,13 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		goto err_inode;
 	}
 
-	/* device_initialize() so cdev can reference kobj parent */
+	/* from here on we're committed to teardown via dax_dev_release() */
 	device_initialize(dev);
 
 	cdev = &dax_dev->cdev;
 	cdev_init(cdev, &dax_fops);
 	cdev->owner = parent->driver->owner;
-	cdev->kobj.parent = &dev->kobj;
-	rc = cdev_add(&dax_dev->cdev, dev_t, 1);
-	if (rc)
-		goto err_cdev;
 
-	/* from here on we're committed to teardown via dax_dev_release() */
 	dax_dev->num_resources = count;
 	dax_dev->alive = true;
 	dax_dev->region = dax_region;
@@ -773,7 +766,8 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	dev->groups = dax_attribute_groups;
 	dev->release = dax_dev_release;
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
-	rc = device_add(dev);
+
+	rc = cdev_device_add(cdev, dev);
 	if (rc) {
 		kill_dax_dev(dax_dev);
 		put_device(dev);
@@ -786,8 +780,6 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 
 	return dax_dev;
 
- err_cdev:
-	iput(dax_dev->inode);
  err_inode:
 	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
-- 
2.1.4
