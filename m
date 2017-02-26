From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 08/16] IB/ucm: utilize new cdev_device_add helper function
Date: Sat, 25 Feb 2017 23:38:09 -0700
Message-ID: <1488091097-12328-9-git-send-email-logang@deltatee.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1488091097-12328-1-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

The use after free is not triggerable here because the cdev holds
the module lock and the only device_unregister is only triggered by
module unload, however make the change for consistency.

To make this work the cdev_del needs to move out of the struct device
release function.

This cleans up the error path significantly and thus also fixes a minor
bug where the devnum would not be released if cdev_add failed.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Reviewed-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ucm.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index e0a995b..c348701 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1205,12 +1205,15 @@ static void ib_ucm_release_dev(struct device *dev)
 	struct ib_ucm_device *ucm_dev;
 
 	ucm_dev = container_of(dev, struct ib_ucm_device, dev);
-	cdev_del(&ucm_dev->cdev);
+	kfree(ucm_dev);
+}
+
+static void ib_ucm_free_dev(struct ib_ucm_device *ucm_dev)
+{
 	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
 		clear_bit(ucm_dev->devnum, dev_map);
 	else
 		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, overflow_map);
-	kfree(ucm_dev);
 }
 
 static const struct file_operations ucm_fops = {
@@ -1266,7 +1269,9 @@ static void ib_ucm_add_one(struct ib_device *device)
 	if (!ucm_dev)
 		return;
 
+	device_initialize(&ucm_dev->dev);
 	ucm_dev->ib_dev = device;
+	ucm_dev->dev.release = ib_ucm_release_dev;
 
 	devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
 	if (devnum >= IB_UCM_MAX_DEVICES) {
@@ -1283,19 +1288,18 @@ static void ib_ucm_add_one(struct ib_device *device)
 		set_bit(devnum, dev_map);
 	}
 
+
 	cdev_init(&ucm_dev->cdev, &ucm_fops);
 	ucm_dev->cdev.owner = THIS_MODULE;
 	kobject_set_name(&ucm_dev->cdev.kobj, "ucm%d", ucm_dev->devnum);
-	if (cdev_add(&ucm_dev->cdev, base, 1))
-		goto err;
 
 	ucm_dev->dev.class = &cm_class;
 	ucm_dev->dev.parent = device->dma_device;
-	ucm_dev->dev.devt = ucm_dev->cdev.dev;
-	ucm_dev->dev.release = ib_ucm_release_dev;
+	ucm_dev->dev.devt = base;
+
 	dev_set_name(&ucm_dev->dev, "ucm%d", ucm_dev->devnum);
-	if (device_register(&ucm_dev->dev))
-		goto err_cdev;
+	if (cdev_device_add(&ucm_dev->cdev, &ucm_dev->dev))
+		goto err_devnum;
 
 	if (device_create_file(&ucm_dev->dev, &dev_attr_ibdev))
 		goto err_dev;
@@ -1304,15 +1308,11 @@ static void ib_ucm_add_one(struct ib_device *device)
 	return;
 
 err_dev:
-	device_unregister(&ucm_dev->dev);
-err_cdev:
-	cdev_del(&ucm_dev->cdev);
-	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
-		clear_bit(devnum, dev_map);
-	else
-		clear_bit(devnum, overflow_map);
+	cdev_device_del(&ucm_dev->cdev, &ucm_dev->dev);
+err_devnum:
+	ib_ucm_free_dev(ucm_dev);
 err:
-	kfree(ucm_dev);
+	put_device(&ucm_dev->dev);
 	return;
 }
 
@@ -1323,7 +1323,9 @@ static void ib_ucm_remove_one(struct ib_device *device, void *client_data)
 	if (!ucm_dev)
 		return;
 
-	device_unregister(&ucm_dev->dev);
+	cdev_device_del(&ucm_dev->cdev, &ucm_dev->dev);
+	ib_ucm_free_dev(ucm_dev);
+	put_device(&ucm_dev->dev);
 }
 
 static CLASS_ATTR_STRING(abi_version, S_IRUGO,
-- 
2.1.4
