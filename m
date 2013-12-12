From: Loc Ho <lho@apm.com>
Subject: [PATCH v4 1/4] PHY: Add function set_speed to generic PHY framework
Date: Thu, 12 Dec 2013 00:30:32 -0700
Message-ID: <1386833435-30498-2-git-send-email-lho@apm.com>
References: <1386833435-30498-1-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1386833435-30498-1-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds function set_speed to the generic PHY framework operation
structure. This function can be called to instruct the PHY underlying layer
at specified lane to configure for specified speed in hertz.

Signed-off-by: Loc Ho <lho@apm.com>
---
 drivers/phy/phy-core.c  |   21 +++++++++++++++++++++
 include/linux/phy/phy.h |    8 ++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..b525e72 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -239,6 +239,27 @@ out:
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
index 6d72269..ed2b897 100644
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

@@ -127,6 +129,7 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
+int phy_set_speed(struct phy *phy, int lane, u64 speed);
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
@@ -199,6 +202,11 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
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

