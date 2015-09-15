From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 07/17] Update the memstick driver to use idr helper functions.
Date: Tue, 15 Sep 2015 09:46:07 -0700
Message-ID: <09696655141544933a380e88afe3c3ecf31e4f8d.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/memstick/core/memstick.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index a0547dbf9806..8f40a3d5108b 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -512,25 +512,16 @@ int memstick_add_host(struct memstick_host *host)
 {
 	int rc;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&memstick_host_lock);
-
-	rc = idr_alloc(&memstick_host_idr, host, 0, 0, GFP_NOWAIT);
-	if (rc >= 0)
-		host->id = rc;
-
-	spin_unlock(&memstick_host_lock);
-	idr_preload_end();
+	rc = idr_get_index(&memstick_host_idr, &memstick_host_lock, host);
 	if (rc < 0)
 		return rc;
+	host->id = rc;
 
 	dev_set_name(&host->dev, "memstick%u", host->id);
 
 	rc = device_add(&host->dev);
 	if (rc) {
-		spin_lock(&memstick_host_lock);
-		idr_remove(&memstick_host_idr, host->id);
-		spin_unlock(&memstick_host_lock);
+		idr_put_index(&memstick_host_idr, &memstick_host_lock, host->id);
 		return rc;
 	}
 
@@ -554,9 +545,7 @@ void memstick_remove_host(struct memstick_host *host)
 	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
 	mutex_unlock(&host->lock);
 
-	spin_lock(&memstick_host_lock);
-	idr_remove(&memstick_host_idr, host->id);
-	spin_unlock(&memstick_host_lock);
+	idr_put_index(&memstick_host_idr, &memstick_host_lock, host->id);
 	device_del(&host->dev);
 }
 EXPORT_SYMBOL(memstick_remove_host);
-- 
2.1.4
