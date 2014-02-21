From: Loc Ho <lho@apm.com>
Subject: [PATCH v10 1/4] PHY: Add function set_speed to generic PHY framework
Date: Fri, 21 Feb 2014 10:46:38 -0700
Message-ID: <1393004801-25970-2-git-send-email-lho@apm.com>
References: <1393004801-25970-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:53535 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933012AbaBURq5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 12:46:57 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so3784840pab.10
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 09:46:56 -0800 (PST)
In-Reply-To: <1393004801-25970-1-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

This patch adds function set_speed to the generic PHY framework operation
structure. This function can be called to instruct the PHY underlying layer
at specified lane to configure for specified speed in hertz.

Signed-off-by: Loc Ho <lho@apm.com>
---
 drivers/phy/phy-core.c  |   21 +++++++++++++++++++++
 include/linux/phy/phy.h |    8 ++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 645c867..44f2f63 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -257,6 +257,27 @@ int phy_power_off(struct phy *phy)
 }
 EXPORT_SYMBOL_GPL(phy_power_off);
 
+int phy_set_speed(struct phy *phy, int lane, u64 speed)
+{
+        int ret = -ENOTSUPP;
+
+        mutex_lock(&phy->mutex);
+        if (phy->ops->set_speed) {
+                ret =  phy->ops->set_speed(phy, lane, speed);
+                if (ret < 0) {
+                        dev_err(&phy->dev, "phy set speed failed --> %d\n",
+                                ret);
+                        goto out;
+                }
+        }
+
+out:
+        mutex_unlock(&phy->mutex);
+
+        return ret;
+}
+EXPORT_SYMBOL_GPL(phy_set_speed);
+
 /**
  * of_phy_get() - lookup and obtain a reference to a phy by phandle
  * @dev: device that requests this phy
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e273e5a..4eb589c 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -27,6 +27,7 @@ struct phy;
  * @exit: operation to be performed while exiting
  * @power_on: powering on the phy
  * @power_off: powering off the phy
+ * @set_speed: set operation speed in hz
  * @owner: the module owner containing the ops
  */
 struct phy_ops {
@@ -34,6 +35,7 @@ struct phy_ops {
 	int	(*exit)(struct phy *phy);
 	int	(*power_on)(struct phy *phy);
 	int	(*power_off)(struct phy *phy);
+	int	(*set_speed)(struct phy *phy, int lane, u64 speed);
 	struct module *owner;
 };
 
@@ -145,6 +147,7 @@ static inline void phy_set_bus_width(struct phy *phy, int bus_width)
 {
 	phy->attrs.bus_width = bus_width;
 }
+int phy_set_speed(struct phy *phy, int lane, u64 speed);
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
@@ -227,6 +230,11 @@ static inline void phy_set_bus_width(struct phy *phy, int bus_width)
 	return;
 }
 
+static inline int phy_set_speed(struct phy *phy, int lane, u64 speed)
+{
+	return -ENOSYS;
+}
+
 static inline struct phy *phy_get(struct device *dev, const char *string)
 {
 	return ERR_PTR(-ENOSYS);
-- 
1.5.5

