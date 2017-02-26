From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 02/16] device-dax: fix cdev leak
Date: Sat, 25 Feb 2017 23:38:03 -0700
Message-ID: <1488091097-12328-3-git-send-email-logang@deltatee.com>
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
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If device_add() fails, cleanup the cdev. Otherwise, we leak a kobj_map()
with a stale device number.

As Jason points out, there is a small possibility that userspace has
opened and mapped the device in the time between cdev_add() and the
device_add() failure. We need a new kill_dax_dev() helper to invalidate
any established mappings.

Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Reported-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/dax/dax.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index ed758b7..b62a52f 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -630,13 +630,10 @@ static void dax_dev_release(struct device *dev)
 	kfree(dax_dev);
 }
 
-static void unregister_dax_dev(void *dev)
+static void kill_dax_dev(struct dax_dev *dax_dev)
 {
-	struct dax_dev *dax_dev = to_dax_dev(dev);
 	struct cdev *cdev = &dax_dev->cdev;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	/*
 	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
 	 * ensuring that any fault handlers that might have seen
@@ -648,6 +645,15 @@ static void unregister_dax_dev(void *dev)
 	synchronize_rcu();
 	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
 	cdev_del(cdev);
+}
+
+static void unregister_dax_dev(void *dev)
+{
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	kill_dax_dev(dax_dev);
 	device_unregister(dev);
 }
 
@@ -724,6 +730,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
 	rc = device_add(dev);
 	if (rc) {
+		kill_dax_dev(dax_dev);
 		put_device(dev);
 		return ERR_PTR(rc);
 	}
-- 
2.1.4
