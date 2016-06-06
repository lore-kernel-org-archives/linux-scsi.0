From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 1/3] driver-core: Implement device_match_always()
Date: Mon,  6 Jun 2016 09:32:36 +0200
Message-ID: <20160606073238.1073-1-thierry.reding@gmail.com>
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This is a helper function that can be used in iterators, such as
bus_find_device(), and will always match. This is useful to implement a
custom iterator interface on top of bus_find_device() or to check if any
devices have been registered at all.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/device.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 38f02814d53a..bea9566cea96 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1031,6 +1031,11 @@ extern int device_online(struct device *dev);
 extern void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
 extern void set_secondary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
 
+static inline int device_match_always(struct device *device, void *data)
+{
+	return 1;
+}
+
 /*
  * Root device objects for grouping under /sys/devices
  */
-- 
2.8.3
