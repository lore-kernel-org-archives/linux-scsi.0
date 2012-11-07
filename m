From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 4/5] virtio-scsi: create a separate work queue for virtio-scsi
Date: Wed, 7 Nov 2012 18:18:13 +0800
Message-ID: <1352283494-31200-5-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Create a separate work queue for virtio-scsi to improve the performance.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 765138a..fc05240 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -27,6 +27,8 @@
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
 
+struct workqueue_struct *virtscsi_wq;
+
 /* Command queue element */
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
@@ -337,7 +339,7 @@ static void virtscsi_complete_event(void *buf)
 	struct virtio_scsi_event_node *event_node = buf;
 
 	INIT_WORK(&event_node->work, virtscsi_handle_event);
-	schedule_work(&event_node->work);
+	queue_work(virtscsi_wq, &event_node->work);
 }
 
 static void virtscsi_event_done(struct virtqueue *vq)
@@ -788,6 +790,12 @@ static int __init init(void)
 {
 	int ret = -ENOMEM;
 
+	virtscsi_wq = alloc_workqueue("virtio-scsi", 0, 0);
+	if (!virtscsi_wq) {
+		pr_err("alloc_workqueue() for virtscsi_wq failed\n");
+		goto error;
+	}
+
 	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
 	if (!virtscsi_cmd_cache) {
 		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
@@ -817,6 +825,10 @@ error:
 		kmem_cache_destroy(virtscsi_cmd_cache);
 		virtscsi_cmd_cache = NULL;
 	}
+	if (virtscsi_wq) {
+		destroy_workqueue(virtscsi_wq);
+		virtscsi_wq = NULL;
+	}
 	return ret;
 }
 
@@ -825,6 +837,7 @@ static void __exit fini(void)
 	unregister_virtio_driver(&virtio_scsi_driver);
 	mempool_destroy(virtscsi_cmd_pool);
 	kmem_cache_destroy(virtscsi_cmd_cache);
+	destroy_workqueue(virtscsi_wq);
 }
 module_init(init);
 module_exit(fini);
-- 
1.8.0
