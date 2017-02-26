From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 01/16] chardev: add helper function to register char devs
 with a struct device
Date: Sat, 25 Feb 2017 23:38:02 -0700
Message-ID: <1488091097-12328-2-git-send-email-logang@deltatee.com>
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

Credit for this patch goes is shared with Dan Williams [1]. I've
taken things one step further to make the helper function more
useful and clean up calling code.

There's a common pattern in the kernel whereby a struct cdev is placed
in a structure along side a struct device which manages the life-cycle
of both. In the naive approach, the reference counting is broken and
the struct device can free everything before the chardev code
is entirely released.

Many developers have solved this problem by linking the internal kobjs
in this fashion:

cdev.kobj.parent = &parent_dev.kobj;

The cdev code explicitly gets and puts a reference to it's kobj parent.
So this seems like it was intended to be used this way. Dmitrty Torokhov
first put this in place in 2012 with this commit:

2f0157f char_dev: pin parent kobject

and the first instance of the fix was then done in the input subsystem
in the following commit:

4a215aa Input: fix use-after-free introduced with dynamic minor changes

Subsequently over the years, however, this issue seems to have tripped
up multiple developers independently. For example, see these commits:

0d5b7da iio: Prevent race between IIO chardev opening and IIO device
(by Lars-Peter Clausen in 2013)

ba0ef85 tpm: Fix initialization of the cdev
(by Jason Gunthorpe in 2015)

5b28dde [media] media: fix use-after-free in cdev_put() when app exits
after driver unbind
(by Shauh Khan in 2016)

This technique is similarly done in at least 15 places within the kernel
and probably should have been done so in another, at least, 5 places.
The kobj line also looks very suspect in that one would not expect
drivers to have to mess with kobject internals in this way.
Even highly experienced kernel developers can be surprised by this
code, as seen in [2].

To help alleviate this situation, and hopefully prevent future
wasted effort on this problem, this patch introduces a helper function
to register a char device along with its parent struct device.
This creates a more regular API for tying a char device to its parent
without the developer having to set members in the underlying kobject.

This patch introduce cdev_device_add and cdev_device_del which
replaces a common pattern including setting the kobj parent, calling
cdev_add and then calling device_add. It also introduces cdev_set_parent
for the few cases that set the kobject parent without using device_add.

[1] https://lkml.org/lkml/2017/2/13/700
[2] https://lkml.org/lkml/2017/2/10/370

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/char_dev.c        | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cdev.h |  4 ++++
 2 files changed, 71 insertions(+)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 44a240c..471d480 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -471,6 +471,70 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 	return 0;
 }
 
+/**
+ * cdev_set_parent() - set the parent kobject for a char device
+ * @p: the cdev structure
+ * @kobj: the kobject to take a reference to
+ *
+ * cdev_set_parent() sets a parent kobject which will be referenced
+ * appropriately so the parent is not freed before the cdev. This
+ * should be called before cdev_add.
+ */
+void cdev_set_parent(struct cdev *p, struct kobject *kobj)
+{
+	WARN_ON(!kobj->state_initialized);
+	p->kobj.parent = kobj;
+}
+
+/**
+ * cdev_device_add() - add a char device and it's corresponding
+ *	struct device, linkink
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_add() adds the char device represented by @cdev to the system,
+ * just as cdev_add does. It then adds @dev to the system using device_add
+ * The dev_t for the char device will be taken from the struct device which
+ * needs to be initialized first. This helper function correctly takes a
+ * reference to the parent device so the parent will not get released until
+ * all references to the cdev are released.
+ *
+ * This function should be used whenever the struct cdev and the
+ * struct device are members of the same structure whose lifetime is
+ * managed by the struct device.
+ */
+int cdev_device_add(struct cdev *cdev, struct device *dev)
+{
+	int rc = 0;
+
+	cdev_set_parent(cdev, &dev->kobj);
+
+	rc = cdev_add(cdev, dev->devt, 1);
+	if (rc)
+		return rc;
+
+	rc = device_add(dev);
+	if (rc)
+		cdev_del(cdev);
+
+	return rc;
+}
+
+/**
+ * cdev_device_del() - inverse of cdev_device_add
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_del() is a helper function to call cdev_del
+ * and device_del. It should be used whenever cdev_device_add
+ * is used.
+ */
+void cdev_device_del(struct cdev *cdev, struct device *dev)
+{
+	device_del(dev);
+	cdev_del(cdev);
+}
+
 static void cdev_unmap(dev_t dev, unsigned count)
 {
 	kobj_unmap(cdev_map, dev, count);
@@ -570,5 +634,8 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
+EXPORT_SYMBOL(cdev_set_parent);
+EXPORT_SYMBOL(cdev_device_add);
+EXPORT_SYMBOL(cdev_device_del);
 EXPORT_SYMBOL(__register_chrdev);
 EXPORT_SYMBOL(__unregister_chrdev);
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index f876361..4c99579 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -26,6 +26,10 @@ void cdev_put(struct cdev *p);
 
 int cdev_add(struct cdev *, dev_t, unsigned);
 
+void cdev_set_parent(struct cdev *p, struct kobject *kobj);
+int cdev_device_add(struct cdev *cdev, struct device *dev);
+void cdev_device_del(struct cdev *cdev, struct device *dev);
+
 void cdev_del(struct cdev *);
 
 void cd_forget(struct inode *);
-- 
2.1.4
