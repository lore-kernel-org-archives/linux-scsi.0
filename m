From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 3/5] virtio-scsi: use pr_err instead of printk
Date: Wed, 7 Nov 2012 18:18:12 +0800
Message-ID: <1352283494-31200-4-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Use pr_err() instead of printk() for code cleanups.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 5390229..765138a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -790,8 +790,7 @@ static int __init init(void)
 
 	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
 	if (!virtscsi_cmd_cache) {
-		printk(KERN_ERR "kmem_cache_create() for "
-				"virtscsi_cmd_cache failed\n");
+		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
 		goto error;
 	}
 
@@ -800,8 +799,7 @@ static int __init init(void)
 		mempool_create_slab_pool(VIRTIO_SCSI_MEMPOOL_SZ,
 					 virtscsi_cmd_cache);
 	if (!virtscsi_cmd_pool) {
-		printk(KERN_ERR "mempool_create() for"
-				"virtscsi_cmd_pool failed\n");
+		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
 		goto error;
 	}
 	ret = register_virtio_driver(&virtio_scsi_driver);
-- 
1.8.0
