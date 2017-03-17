From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 13/16] rapidio: utilize new cdev_device_add helper function
Date: Fri, 17 Mar 2017 12:48:20 -0600
Message-ID: <1489776503-3151-14-git-send-email-logang@deltatee.com>
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

This driver did not originally set kobj.parent so it likely had
potential a use after free bug which this patch fixes.

We convert from device_register to device_initialize/cdev_device_add.
While we are at it we use put_device instead of kfree (as recommended
by the device_initialize documentation). We also remove an unnecessary
extra get_device from the code.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 50b617a..5beb0c3 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2444,31 +2444,25 @@ static struct mport_dev *mport_cdev_add(struct rio_mport *mport)
 	mutex_init(&md->buf_mutex);
 	mutex_init(&md->file_mutex);
 	INIT_LIST_HEAD(&md->file_list);
-	cdev_init(&md->cdev, &mport_fops);
-	md->cdev.owner = THIS_MODULE;
-	ret = cdev_add(&md->cdev, MKDEV(MAJOR(dev_number), mport->id), 1);
-	if (ret < 0) {
-		kfree(md);
-		rmcd_error("Unable to register a device, err=%d", ret);
-		return NULL;
-	}
 
-	md->dev.devt = md->cdev.dev;
+	device_initialize(&md->dev);
+	md->dev.devt = MKDEV(MAJOR(dev_number), mport->id);
 	md->dev.class = dev_class;
 	md->dev.parent = &mport->dev;
 	md->dev.release = mport_device_release;
 	dev_set_name(&md->dev, DEV_NAME "%d", mport->id);
 	atomic_set(&md->active, 1);
 
-	ret = device_register(&md->dev);
+	cdev_init(&md->cdev, &mport_fops);
+	md->cdev.owner = THIS_MODULE;
+
+	ret = cdev_device_add(&md->cdev, &md->dev);
 	if (ret) {
 		rmcd_error("Failed to register mport %d (err=%d)",
 		       mport->id, ret);
 		goto err_cdev;
 	}
 
-	get_device(&md->dev);
-
 	INIT_LIST_HEAD(&md->doorbells);
 	spin_lock_init(&md->db_lock);
 	INIT_LIST_HEAD(&md->portwrites);
@@ -2513,8 +2507,7 @@ static struct mport_dev *mport_cdev_add(struct rio_mport *mport)
 	return md;
 
 err_cdev:
-	cdev_del(&md->cdev);
-	kfree(md);
+	put_device(&md->dev);
 	return NULL;
 }
 
@@ -2578,7 +2571,7 @@ static void mport_cdev_remove(struct mport_dev *md)
 	atomic_set(&md->active, 0);
 	mport_cdev_terminate_dma(md);
 	rio_del_mport_pw_handler(md->mport, md, rio_mport_pw_handler);
-	cdev_del(&(md->cdev));
+	cdev_device_del(&md->cdev, &md->dev);
 	mport_cdev_kill_fasync(md);
 
 	flush_workqueue(dma_wq);
@@ -2603,7 +2596,6 @@ static void mport_cdev_remove(struct mport_dev *md)
 
 	rio_release_inb_dbell(md->mport, 0, 0x0fff);
 
-	device_unregister(&md->dev);
 	put_device(&md->dev);
 }
 
-- 
2.1.4
