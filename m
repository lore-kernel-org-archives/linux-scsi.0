Received: from out30-72.freemail.mail.aliyun.com (out30-72.freemail.mail.aliyun.com [115.124.30.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F5737FF52;
	Thu, 29 Jan 2026 09:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769679571; cv=none; b=Aabcg9jqQ35cEWnQYOcqrohJkqo/KuOTBnCNvaMKy8haEVtVBWmXI6gK5tQFP1w7toSH/WpEe+rEy0AtSNkvtpUyuXrIn+8CE2fb0w3kAeFLv+aW8R0UbpTsgVJ68JwZrKu+LoADbu9mOuI0uVJ3fier4Wr1oVM2dDAUpiwpUy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769679571; c=relaxed/simple;
	bh=X2Xi5P4z7KzLpV2xm1tIgzyOZ8SQ/ESPGgIv9jUhGak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HkDOdI5lkHV0BW46hl1ofRqIL11UY6HI98W/U5m+g44rtTuAw1Dvm2w98Zq5hkF1t41sixI/zIHr+sXML8ic9Aaw5GplceXpaLkUqkRXO5xTqbPJDUIHcesfPqqWaVpp17uWdkz2k8r6vye8JM0ep8H4oGjBEoxY4jLunmLsBOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=GHndRsCv; arc=none smtp.client-ip=115.124.30.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="GHndRsCv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1769679566; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=MzQBnGK68iRiPz9mH5G5Su8c6ynoa/Xfuw9mrmamZGI=;
	b=GHndRsCv8MpPJpc1DwHrXMalNTTniDnZ5cJhmuRK6Ew2ccttNxzbKd9N0MaJ7BJfzybMdSOu2Xj/1sJbEy2vO5LzCMpaNol6+liy19XrQ/gd19qxihOvEqckPOUIyXf9e9QeqdtWeQxuOfD7ODqPJxf0n89Zoy2Swk4uPC2VlrE=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0Wy7.50Q_1769679559 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Jan 2026 17:39:25 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: john.g.garry@oracle.com,
	yanaijie@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dlemoal@kernel.org,
	wdhh6@aliyun.com,
	johannes.thumshirn@wdc.com,
	mingo@kernel.org,
	cassel@kernel.org,
	tglx@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libsas: Fix dev_list race conditions with proper locking
Date: Thu, 29 Jan 2026 17:38:59 +0800
Message-ID: <20260129093859.1418749-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multiple functions in libsas were accessing port->dev_list without
proper locking, leading to potential race conditions that could cause:
- Use-after-free when devices are removed during list traversal
- List corruption from concurrent modifications
- System crashes from accessing freed memory

This patch adds proper dev_list_lock protection to the following functions:

1. sas_ex_level_discovery(): Added locking around list traversal with
   safe iteration and reference counting for devices. The lock is
   released before calling functions that may sleep
   (sas_ex_discover_devices).

2. sas_dev_present_in_domain(): Added locking for read-only list access
   to prevent reading inconsistent list state.

3. sas_suspend_devices(): Added locking around list traversal to prevent
   concurrent modifications during device suspension.

4. sas_unregister_domain_devices(): Added proper locking with reference
   counting. The lock is released before calling sas_unregister_dev()
   which may sleep, but device references are held to prevent premature
   removal.

5. sas_port_event_worker(): Added locking around list traversal with
   reference counting for devices accessed outside the lock.

All modifications follow the pattern of:
- Hold dev_list_lock during list traversal
- Use list_for_each_entry_safe where list may be modified
- Take device reference (kref_get) before releasing lock
- Release lock before calling functions that may sleep
- Release device reference (sas_put_device) after use

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 drivers/scsi/libsas/sas_discover.c | 14 +++++++++++++
 drivers/scsi/libsas/sas_expander.c | 32 +++++++++++++++++++++++-------
 drivers/scsi/libsas/sas_port.c     | 10 ++++++++++
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index b07062db50b2..3c18fdfde8c2 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -245,8 +245,10 @@ static void sas_suspend_devices(struct work_struct *work)
 	 * suspension, we force the issue here to keep the reference
 	 * counts aligned
 	 */
+	spin_lock_irq(&port->dev_list_lock);
 	list_for_each_entry(dev, &port->dev_list, dev_list_node)
 		sas_notify_lldd_dev_gone(dev);
+	spin_unlock_irq(&port->dev_list_lock);
 
 	/* we are suspending, so we know events are disabled and
 	 * phy_list is not being mutated
@@ -410,11 +412,23 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, bool gone)
 {
 	struct domain_device *dev, *n;
 
+	/* Lock while iterating to prevent concurrent modifications.
+	 * We need to unlock before calling sas_unregister_dev() as it
+	 * may sleep, but we hold a reference to prevent device removal.
+	 */
+	spin_lock_irq(&port->dev_list_lock);
 	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node) {
 		if (gone)
 			set_bit(SAS_DEV_GONE, &dev->state);
+		kref_get(&dev->kref);
+		spin_unlock_irq(&port->dev_list_lock);
+
 		sas_unregister_dev(port, dev);
+		sas_put_device(dev);
+
+		spin_lock_irq(&port->dev_list_lock);
 	}
+	spin_unlock_irq(&port->dev_list_lock);
 
 	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
 		sas_unregister_dev(port, dev);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index d953225f6cc2..c82c9b3d5103 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -643,14 +643,21 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
 					    u8 *sas_addr)
 {
 	struct domain_device *dev;
+	int found = 0;
 
 	if (SAS_ADDR(port->sas_addr) == SAS_ADDR(sas_addr))
 		return 1;
+
+	spin_lock_irq(&port->dev_list_lock);
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr))
-			return 1;
+		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr)) {
+			found = 1;
+			break;
+		}
 	}
-	return 0;
+	spin_unlock_irq(&port->dev_list_lock);
+
+	return found;
 }
 
 #define RPEL_REQ_SIZE	16
@@ -1579,20 +1586,31 @@ static int sas_discover_expander(struct domain_device *dev)
 static int sas_ex_level_discovery(struct asd_sas_port *port, const int level)
 {
 	int res = 0;
-	struct domain_device *dev;
+	struct domain_device *dev, *n;
 
-	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+	spin_lock_irq(&port->dev_list_lock);
+	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
 		if (dev_is_expander(dev->dev_type)) {
 			struct sas_expander_device *ex =
 				rphy_to_expander_device(dev->rphy);
 
-			if (level == ex->level)
+			if (level == ex->level) {
+				kref_get(&dev->kref);
+				spin_unlock_irq(&port->dev_list_lock);
 				res = sas_ex_discover_devices(dev, -1);
-			else if (level > 0)
+				sas_put_device(dev);
+				spin_lock_irq(&port->dev_list_lock);
+			} else if (level > 0) {
+				kref_get(&port->port_dev->kref);
+				spin_unlock_irq(&port->dev_list_lock);
 				res = sas_ex_discover_devices(port->port_dev, -1);
+				sas_put_device(port->port_dev);
+				spin_lock_irq(&port->dev_list_lock);
+			}
 
 		}
 	}
+	spin_unlock_irq(&port->dev_list_lock);
 
 	return res;
 }
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index de7556070048..491c9f7104c6 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -44,13 +44,19 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 	 * 1/ presume every device came back
 	 * 2/ force the next revalidation to check all expander phys
 	 */
+	spin_lock_irq(&port->dev_list_lock);
 	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
 		int i, rc;
 
+		kref_get(&dev->kref);
+		spin_unlock_irq(&port->dev_list_lock);
+
 		rc = sas_notify_lldd_dev_found(dev);
 		if (rc) {
 			sas_unregister_dev(port, dev);
 			sas_destruct_devices(port);
+			sas_put_device(dev);
+			spin_lock_irq(&port->dev_list_lock);
 			continue;
 		}
 
@@ -62,7 +68,11 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 				phy->phy_change_count = -1;
 			}
 		}
+
+		sas_put_device(dev);
+		spin_lock_irq(&port->dev_list_lock);
 	}
+	spin_unlock_irq(&port->dev_list_lock);
 
 	sas_discover_event(port, DISCE_RESUME);
 }
-- 
2.43.7

