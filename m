From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 12/17] Update the TI Flash Media driver to use idr helper functions.
Date: Tue, 15 Sep 2015 09:46:12 -0700
Message-ID: <1660d98f948e952cc62793619c45f764912e87ab.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>, Alex Dubov <oakad@yahoo.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/misc/tifm_core.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index a511b2a713b3..46385f828a8f 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -198,22 +198,15 @@ int tifm_add_adapter(struct tifm_adapter *fm)
 {
 	int rc;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&tifm_adapter_lock);
-	rc = idr_alloc(&tifm_adapter_idr, fm, 0, 0, GFP_NOWAIT);
-	if (rc >= 0)
-		fm->id = rc;
-	spin_unlock(&tifm_adapter_lock);
-	idr_preload_end();
+	rc = idr_get_index(&tifm_adapter_idr, &tifm_adapter_lock, fm);
 	if (rc < 0)
 		return rc;
+	fm->id = rc;
 
 	dev_set_name(&fm->dev, "tifm%u", fm->id);
 	rc = device_add(&fm->dev);
 	if (rc) {
-		spin_lock(&tifm_adapter_lock);
-		idr_remove(&tifm_adapter_idr, fm->id);
-		spin_unlock(&tifm_adapter_lock);
+		idr_put_index(&tifm_adapter_idr, &tifm_adapter_lock, fm->id);
 	}
 
 	return rc;
@@ -230,9 +223,7 @@ void tifm_remove_adapter(struct tifm_adapter *fm)
 			device_unregister(&fm->sockets[cnt]->dev);
 	}
 
-	spin_lock(&tifm_adapter_lock);
-	idr_remove(&tifm_adapter_idr, fm->id);
-	spin_unlock(&tifm_adapter_lock);
+	idr_put_index(&tifm_adapter_idr, &tifm_adapter_lock, fm->id);
 	device_del(&fm->dev);
 }
 EXPORT_SYMBOL(tifm_remove_adapter);
-- 
2.1.4
