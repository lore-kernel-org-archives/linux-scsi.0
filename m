From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 2/3] vhost: make vhost work queue visible
Date: Sat, 21 Jul 2012 06:55:37 +0000
Message-ID: <1342853738-27682-3-git-send-email-nab@linux-iscsi.org>
References: <1342853738-27682-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342853738-27682-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stefan Hajnoczi <stefanha@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Stefan Hajnoczi <stefanha@gmail.com>

The vhost work queue allows processing to be done in vhost worker thread
context, which uses the owner process mm.  Access to the vring and guest
memory is typically only possible from vhost worker context so it is
useful to allow work to be queued directly by users.

Currently vhost_net only uses the poll wrappers which do not expose the
work queue functions.  However, for tcm_vhost (vhost_scsi) it will be
necessary to queue custom work.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/vhost.c |    5 ++---
 drivers/vhost/vhost.h |    3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 94dbd25..1aab08b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -64,7 +64,7 @@ static int vhost_poll_wakeup(wait_queue_t *wait, unsigned mode, int sync,
 	return 0;
 }
 
-static void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn)
+void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn)
 {
 	INIT_LIST_HEAD(&work->node);
 	work->fn = fn;
@@ -137,8 +137,7 @@ void vhost_poll_flush(struct vhost_poll *poll)
 	vhost_work_flush(poll->dev, &poll->work);
 }
 
-static inline void vhost_work_queue(struct vhost_dev *dev,
-				    struct vhost_work *work)
+void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
 	unsigned long flags;
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 07b9763..1125af3 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -43,6 +43,9 @@ struct vhost_poll {
 	struct vhost_dev	 *dev;
 };
 
+void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
+void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
+
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     unsigned long mask, struct vhost_dev *dev);
 void vhost_poll_start(struct vhost_poll *poll, struct file *file);
-- 
1.7.2.5
