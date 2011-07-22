From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 5/8] drm/vmwgfx: use ida_simple_get for id allocation.
Date: Fri, 22 Jul 2011 17:41:14 +0100
Message-ID: <1311352886-4047-6-git-send-email-jic23@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie, Jonathan Cameron <jic23@cam.ac.uk>
List-Id: linux-scsi@vger.kernel.org

Some messing with error codes to return 0 on out id's and match
current situation.  Is this necessary? Looks a touch 'interesting'.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c |   34 ++++++-------------------
 1 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
index ac6e0d1..d51577b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
@@ -37,7 +37,6 @@
 #include <linux/kernel.h>
 
 struct vmwgfx_gmrid_man {
-	spinlock_t lock;
 	struct ida gmr_ida;
 	uint32_t max_gmr_ids;
 };
@@ -49,34 +48,20 @@ static int vmw_gmrid_man_get_node(struct ttm_mem_type_manager *man,
 {
 	struct vmwgfx_gmrid_man *gman =
 		(struct vmwgfx_gmrid_man *)man->priv;
-	int ret;
 	int id;
 
 	mem->mm_node = NULL;
 
-	do {
-		if (unlikely(ida_pre_get(&gman->gmr_ida, GFP_KERNEL) == 0))
-			return -ENOMEM;
-
-		spin_lock(&gman->lock);
-		ret = ida_get_new(&gman->gmr_ida, &id);
-
-		if (unlikely(ret == 0 && id >= gman->max_gmr_ids)) {
-			ida_remove(&gman->gmr_ida, id);
-			spin_unlock(&gman->lock);
+	id = ida_simple_get(&gman->gmr_ida, 0, gman->max_gmr_ids, GFP_KERNEL);
+	if (id < 0) {
+		if (id == -ENOSPC)
 			return 0;
-		}
-
-		spin_unlock(&gman->lock);
-
-	} while (ret == -EAGAIN);
-
-	if (likely(ret == 0)) {
-		mem->mm_node = gman;
-		mem->start = id;
+		return id;
 	}
+	mem->mm_node = gman;
+	mem->start = id;
 
-	return ret;
+	return 0;
 }
 
 static void vmw_gmrid_man_put_node(struct ttm_mem_type_manager *man,
@@ -86,9 +71,7 @@ static void vmw_gmrid_man_put_node(struct ttm_mem_type_manager *man,
 		(struct vmwgfx_gmrid_man *)man->priv;
 
 	if (mem->mm_node) {
-		spin_lock(&gman->lock);
-		ida_remove(&gman->gmr_ida, mem->start);
-		spin_unlock(&gman->lock);
+		ida_simple_remove(&gman->gmr_ida, mem->start);
 		mem->mm_node = NULL;
 	}
 }
@@ -102,7 +85,6 @@ static int vmw_gmrid_man_init(struct ttm_mem_type_manager *man,
 	if (unlikely(gman == NULL))
 		return -ENOMEM;
 
-	spin_lock_init(&gman->lock);
 	ida_init(&gman->gmr_ida);
 	gman->max_gmr_ids = p_size;
 	man->priv = (void *) gman;
-- 
1.7.3.4
