From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 5/5] virtio-scsi: tidy up the goto label in init()
Date: Wed, 7 Nov 2012 18:18:14 +0800
Message-ID: <1352283494-31200-6-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Tidy up the goto label in init(), and remove the useless
NULL pointer assignment.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index fc05240..afee1d4 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -793,13 +793,13 @@ static int __init init(void)
 	virtscsi_wq = alloc_workqueue("virtio-scsi", 0, 0);
 	if (!virtscsi_wq) {
 		pr_err("alloc_workqueue() for virtscsi_wq failed\n");
-		goto error;
+		goto workqueue_failed;
 	}
 
 	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
 	if (!virtscsi_cmd_cache) {
 		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
-		goto error;
+		goto kmem_cache_failed;
 	}
 
 
@@ -808,27 +808,21 @@ static int __init init(void)
 					 virtscsi_cmd_cache);
 	if (!virtscsi_cmd_pool) {
 		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
-		goto error;
+		goto mempool_failed;
 	}
 	ret = register_virtio_driver(&virtio_scsi_driver);
 	if (ret < 0)
-		goto error;
+		goto register_failed;
 
 	return 0;
 
-error:
-	if (virtscsi_cmd_pool) {
-		mempool_destroy(virtscsi_cmd_pool);
-		virtscsi_cmd_pool = NULL;
-	}
-	if (virtscsi_cmd_cache) {
-		kmem_cache_destroy(virtscsi_cmd_cache);
-		virtscsi_cmd_cache = NULL;
-	}
-	if (virtscsi_wq) {
-		destroy_workqueue(virtscsi_wq);
-		virtscsi_wq = NULL;
-	}
+register_failed:
+	mempool_destroy(virtscsi_cmd_pool);
+mempool_failed:
+	kmem_cache_destroy(virtscsi_cmd_cache);
+kmem_cache_failed:
+	destroy_workqueue(virtscsi_wq);
+workqueue_failed:
 	return ret;
 }
 
-- 
1.8.0

