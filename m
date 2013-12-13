From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 13/32] target: Move spinlock inside core_release_port
Date: Fri, 13 Dec 2013 15:59:01 -0800
Message-ID: <1386979160-6928-14-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3LMX7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:31 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Keep locks closer to things they need to lock.

sparse annotation no longer needed.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 295b5e4..7b5697a 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -546,16 +546,14 @@ static void core_export_port(
 	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFIER */
 }
 
-/*
- *	Called with struct se_device->se_port_lock spinlock held.
- */
 static void core_release_port(struct se_device *dev, struct se_port *port)
-	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
 {
+	spin_lock(&dev->se_port_lock);
 	core_alua_free_tg_pt_gp_mem(port);
-
 	list_del(&port->sep_node);
 	dev->dev_port_count--;
+	spin_unlock(&dev->se_port_lock);
+
 	put_port(port);
 }
 
@@ -596,9 +594,7 @@ void core_dev_unexport(
 	}
 	spin_unlock(&lun->lun_sep_lock);
 
-	spin_lock(&dev->se_port_lock);
 	core_release_port(dev, port);
-	spin_unlock(&dev->se_port_lock);
 
 	spin_lock(&hba->device_lock);
 	dev->export_count--;
-- 
1.7.1

