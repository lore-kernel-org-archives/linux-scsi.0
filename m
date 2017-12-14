From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] driver core: Make it safe to use get_device() if the reference count is zero
Date: Thu, 14 Dec 2017 11:39:36 +0800
Message-ID: <20171214033936.6534-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jason Yan <yanaijie@huawei.com>, Bart Van Assche <bart.vanassche@wdc.com>, "Ewan D . Milne" <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Some driviers may have the chance to increase a reference count that
has dropped to zero when using get_device() because of their design.

We have met such a issue with scsi:
https://www.spinics.net/lists/linux-scsi/msg115295.html

The scsi core will keep the scsi device object in the host list after
it has been deleted and the iterator can still find it. All of the
places where need iterating have to check the state of the scsi device
and this makes a lot of code redundancy and complexity.

Provide a safe mechanism in get_device() by using
kobject_get_unless_zero().

Suggested-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Bart Van Assche <bart.vanassche@wdc.com>
CC: Ewan D. Milne <emilne@redhat.com>
CC: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
CC: Christoph Hellwig <hch@lst.de>
---
 drivers/base/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 12ebd05..cc74810 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1916,7 +1916,7 @@ EXPORT_SYMBOL_GPL(device_register);
  */
 struct device *get_device(struct device *dev)
 {
-	return dev ? kobj_to_dev(kobject_get(&dev->kobj)) : NULL;
+	return dev && kobject_get_unless_zero(&dev->kobj) ? dev : NULL;
 }
 EXPORT_SYMBOL_GPL(get_device);
 
-- 
2.9.5
