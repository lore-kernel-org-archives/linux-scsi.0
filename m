From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 10/14] mtd: utilize new device_add_cdev helper function
Date: Mon, 20 Feb 2017 22:00:49 -0700
Message-ID: <1487653253-11497-11-git-send-email-logang@deltatee.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1487653253-11497-1-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Note: neither of the cdev instances in the mtd tree originally
set the kobject parent. Thus, I'm reasonably confident that
both these instances would have suffered from a minor use after
free bug if the cdevs were open when the backing device was released.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
---
 drivers/mtd/ubi/build.c |  8 +++++---
 drivers/mtd/ubi/vmt.c   | 10 +++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 85d54f3..a509f15 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -434,11 +434,10 @@ static int ubi_sysfs_init(struct ubi_device *ubi, int *ref)
 	int err;
 
 	ubi->dev.release = dev_release;
-	ubi->dev.devt = ubi->cdev.dev;
 	ubi->dev.class = &ubi_class;
 	ubi->dev.groups = ubi_dev_groups;
 	dev_set_name(&ubi->dev, UBI_NAME_STR"%d", ubi->ubi_num);
-	err = device_register(&ubi->dev);
+	err = device_add(&ubi->dev);
 	if (err)
 		return err;
 
@@ -508,12 +507,15 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 		return err;
 	}
 
+	device_initialize(&ubi->dev);
+	ubi->dev.devt = dev;
+
 	ubi_assert(MINOR(dev) == 0);
 	cdev_init(&ubi->cdev, &ubi_cdev_operations);
 	dbg_gen("%s major is %u", ubi->ubi_name, MAJOR(dev));
 	ubi->cdev.owner = THIS_MODULE;
 
-	err = cdev_add(&ubi->cdev, dev, 1);
+	err = device_add_cdev(&ubi->dev, &ubi->cdev);
 	if (err) {
 		ubi_err(ubi, "cannot add character device");
 		goto out_unreg;
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 7ac78c1..df84ba7 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -159,7 +159,6 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	struct ubi_volume *vol;
 	struct ubi_vtbl_record vtbl_rec;
 	struct ubi_eba_table *eba_tbl = NULL;
-	dev_t dev;
 
 	if (ubi->ro_mode)
 		return -EROFS;
@@ -265,11 +264,13 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 			vol->last_eb_bytes = vol->usable_leb_size;
 	}
 
+	device_initialize(&vol->dev);
+	vol->dev.devt = MKDEV(MAJOR(ubi->cdev.dev), vol_id + 1);
+
 	/* Register character device for the volume */
 	cdev_init(&vol->cdev, &ubi_vol_cdev_operations);
 	vol->cdev.owner = THIS_MODULE;
-	dev = MKDEV(MAJOR(ubi->cdev.dev), vol_id + 1);
-	err = cdev_add(&vol->cdev, dev, 1);
+	err = device_add_cdev(&vol->dev, &vol->cdev);
 	if (err) {
 		ubi_err(ubi, "cannot add character device");
 		goto out_mapping;
@@ -277,12 +278,11 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 
 	vol->dev.release = vol_release;
 	vol->dev.parent = &ubi->dev;
-	vol->dev.devt = dev;
 	vol->dev.class = &ubi_class;
 	vol->dev.groups = volume_dev_groups;
 
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
-	err = device_register(&vol->dev);
+	err = device_add(&vol->dev);
 	if (err) {
 		ubi_err(ubi, "cannot register device");
 		goto out_cdev;
-- 
2.1.4
