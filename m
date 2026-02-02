Received: from out30-77.freemail.mail.aliyun.com (out30-77.freemail.mail.aliyun.com [115.124.30.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B45285CBA;
	Mon,  2 Feb 2026 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770040554; cv=none; b=ovLz0gd+fjqXBJ71BEG2b57sqz9olqxkaXZsE5W/RJO71/6qrKEfqJ8yw7H3/ed7lb7wJcodx3a6c0F2mK1tKl8cDcf2w6FvQVecDSZrYYRNs9YAgYSZGBccr2YzmDbl9qwpIhMzLyM5ixY515BF+ReO5gZGjSkOkHq+AZMSseA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770040554; c=relaxed/simple;
	bh=VcVQDkCEE0e6xriA5/JxCIUy00v+hKpSnsJVTJjbNhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XAfExC0BGftiEulyZqQM92/8UdgtPJDaEEWCpBlxjAY46ntXxpX8kCBbAqdHR680JKv7QOjRHM7M6+V0+1H1RrcFP0sRyDCEllNSNRZXXKDjXwAwbMBL+cn6ZiVftSkqmhRYh2FgQl4cdlnR1voKHnAW77dbY+Z00c3Lyjr4FKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=dv8Of681; arc=none smtp.client-ip=115.124.30.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="dv8Of681"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1770040548; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XbUSJ58P9tfLYl1HRcrbVq8JtieL3xwDYYIc5ffOtwc=;
	b=dv8Of68102YhJUOumriC13Pk5NDJc902E+n7E6gGFBq3F9E49U6p5RPZEoinuXeplmNyY5vaenqC5rl9MDQgV+C80gPGMHRIbrWGr1ZrE7SlHgQqt1AVdPPV6gQUyQoBCj7ssQR1mhOearRbchyQnpGa3HkPo59/O24jJ+i2zAU=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WyO5xop_1770040540 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Feb 2026 21:55:48 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: john.g.garry@oracle.com,
	yanaijie@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	johannes.thumshirn@wdc.com,
	dlemoal@kernel.org,
	wdhh6@aliyun.com,
	tglx@kernel.org,
	mingo@kernel.org,
	cassel@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: libsas: Fix dev_list race conditions with proper locking
Date: Mon,  2 Feb 2026 21:55:38 +0800
Message-ID: <20260202135538.662947-1-wdhh6@aliyun.com>
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

the conflict:
CPU 1: disco_q                          CPU 2: event_q
==============================          ==============================
sas_resume_devices()                    sas_porte_link_reset_err()

sas_resume_port()                       sas_deform_port(phy, true)

list_for_each_entry_safe(dev,           sas_unregister_domain_devices()
  &port->dev_list, ...)

NOP                                     free dev

visit dev->ex_dev(UAF)

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
v1->v2:
- Change sas_dev_present_in_domain() to return a bool. (Damien Le Moal)
- Fix comment style. (Damien Le Moal)
- Make commit more detailed. (Damien Le Moal)
---
 drivers/scsi/libsas/sas_discover.c | 14 ++++++++++++
 drivers/scsi/libsas/sas_expander.c | 34 +++++++++++++++++++++++-------
 drivers/scsi/libsas/sas_port.c     | 10 +++++++++
 3 files changed, 50 insertions(+), 8 deletions(-)

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
index d953225f6cc2..f91bd0601adc 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -639,18 +639,25 @@ static void sas_ex_disable_port(struct domain_device *dev, u8 *sas_addr)
 	}
 }
 
-static int sas_dev_present_in_domain(struct asd_sas_port *port,
+static bool sas_dev_present_in_domain(struct asd_sas_port *port,
 					    u8 *sas_addr)
 {
 	struct domain_device *dev;
+	bool found = false;
 
 	if (SAS_ADDR(port->sas_addr) == SAS_ADDR(sas_addr))
 		return 1;
+
+	spin_lock_irq(&port->dev_list_lock);
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr))
-			return 1;
+		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr)) {
+			found = true;
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

