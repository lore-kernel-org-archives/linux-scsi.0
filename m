From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH 1/2] PHY: Add function set_rate to generic PHY framework
Date: Fri, 18 Apr 2014 23:33:16 +0530
Message-ID: <1397844197-13356-2-git-send-email-stripathi@apm.com>
References: <1397844197-13356-1-git-send-email-stripathi@apm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397844197-13356-1-git-send-email-stripathi@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, tj@kernel.org
Cc: olof@lixom.net, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds function set_rate to the generic PHY framework operation
structure. This function can be called to instruct the PHY underlying
layer at specified lane to configure for specified rate.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/phy/phy-core.c  | 27 +++++++++++++++++++++++++++
 include/linux/phy/phy.h |  8 ++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 645c867..51f82e0 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -258,6 +258,33 @@ int phy_power_off(struct phy *phy)
 EXPORT_SYMBOL_GPL(phy_power_off);

 /**
+ * phy_set_rate - set an specified lane at an specified rate
+ * @phy: phy instance to be set
+ * @lane: zero-based lane index
+ * @rate: operating rate in bps (bits per second)
+ *
+ * Returns 0 if successful, -ENOTSUPP if not supported
+ * -EINVAL if parameter out of range.
+ */
+int phy_set_rate(struct phy *phy, int lane, u64 rate)
+{
+	int ret = 0;
+
+	mutex_lock(&phy->mutex);
+ 	if (phy->ops->set_rate) {
+		ret = phy->ops->set_rate(phy, lane, rate);
+		if (ret < 0) {
+			dev_err(&phy->dev, "phy set rate failed --> %d\n",
+				ret);
+		}
+	}
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_set_rate);
+
+/**
  * of_phy_get() - lookup and obtain a reference to a phy by phandle
  * @dev: device that requests this phy
  * @index: the index of the phy
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e273e5a..2dfcb34 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -27,6 +27,7 @@ struct phy;
  * @exit: operation to be performed while exiting
  * @power_on: powering on the phy
  * @power_off: powering off the phy
+ * @set_rate: set the rate
  * @owner: the module owner containing the ops
  */
 struct phy_ops {
@@ -34,6 +35,7 @@ struct phy_ops {
 	int	(*exit)(struct phy *phy);
 	int	(*power_on)(struct phy *phy);
 	int	(*power_off)(struct phy *phy);
+	int     (*set_rate)(struct phy *phy, int lane, u64 rate);
 	struct module *owner;
 };

@@ -137,6 +139,7 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
+int phy_set_rate(struct phy *phy, int lane, u64 rate);
 static inline int phy_get_bus_width(struct phy *phy)
 {
 	return phy->attrs.bus_width;
@@ -217,6 +220,11 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
 }

+static inline int phy_set_rate(struct phy *phy, int lane, u64 rate)
+{
+	return -ENOSYS;
+}
+
 static inline int phy_get_bus_width(struct phy *phy)
 {
 	return -ENOSYS;
--
1.8.2.1
