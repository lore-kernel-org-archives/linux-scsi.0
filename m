From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/2] Fix a memory leak in scsi_host_dev_release()
Date: Fri, 20 Nov 2015 13:34:12 -0800
Message-ID: <564F91D4.2010003@sandisk.com>
References: <564F910E.9070306@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0096.outbound.protection.outlook.com ([157.56.110.96]:51040
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbbKTVeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 16:34:18 -0500
In-Reply-To: <564F910E.9070306@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Fix a memory leak that occurs if a SCSI LLD calls scsi_host_alloc()
and scsi_host_put() but neither scsi_host_add() nor scsi_host_remove().
This leak is fixed by ensuring that put_device(&shost->shost_dev) is
always called. This patch also removes the get_device() call from
scsi_add_host*() and the put_device() call from scsi_remove_host()
since these calls are no longer needed.

The following shell command triggers the scenario described above:

for ((i=0; i<2; i++)); do
  srp_daemon -oac |
  while read line; do
    echo $line >/sys/class/infiniband_srp/srp-mlx4_0-1/add_target
  done
done

The kmemleak report is as follows:

unreferenced object 0xffff88021b24a220 (size 8):
  comm "srp_daemon", pid 56421, jiffies 4295006762 (age 4240.750s)
  hex dump (first 8 bytes):
    68 6f 73 74 35 38 00 a5                          host58..
  backtrace:
[<ffffffff8151014a>] kmemleak_alloc+0x7a/0xc0
[<ffffffff81165c1e>] __kmalloc_track_caller+0xfe/0x160
[<ffffffff81260d2b>] kvasprintf+0x5b/0x90
[<ffffffff81260e2d>] kvasprintf_const+0x8d/0xb0
[<ffffffff81254b0c>] kobject_set_name_vargs+0x3c/0xa0
[<ffffffff81337e3c>] dev_set_name+0x3c/0x40
[<ffffffff81355757>] scsi_host_alloc+0x327/0x4b0
[<ffffffffa03edc8e>] srp_create_target+0x4e/0x8a0 [ib_srp]
[<ffffffff8133778b>] dev_attr_store+0x1b/0x20
[<ffffffff811f27fa>] sysfs_kf_write+0x4a/0x60
[<ffffffff811f1e8e>] kernfs_fop_write+0x14e/0x180
[<ffffffff81176eef>] __vfs_write+0x2f/0xf0
[<ffffffff811771e4>] vfs_write+0xa4/0x100
[<ffffffff81177c64>] SyS_write+0x54/0xc0
[<ffffffff8151b257>] entry_SYSCALL_64_fastpath+0x12/0x6f

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: stable <stable@vger.kernel.org>
---
 drivers/scsi/hosts.c     | 57 +++++++++++++++++++++++++++++++++---------------
 include/scsi/scsi_host.h |  5 +++++
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 323982f..b9fa1f9 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -45,16 +45,6 @@
 static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
 
 
-static void scsi_host_cls_release(struct device *dev)
-{
-	put_device(&class_to_shost(dev)->shost_gendev);
-}
-
-static struct class shost_class = {
-	.name		= "scsi_host",
-	.dev_release	= scsi_host_cls_release,
-};
-
 /**
  *	scsi_host_set_state - Take the given host through the host state model.
  *	@shost:	scsi host to change the state of.
@@ -180,7 +170,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	transport_unregister_device(&shost->shost_gendev);
-	device_unregister(&shost->shost_dev);
+	device_del(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
 }
 EXPORT_SYMBOL(scsi_remove_host);
@@ -263,8 +253,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto out_del_gendev;
 
-	get_device(&shost->shost_gendev);
-
 	if (shost->transportt->host_size) {
 		shost->shost_data = kzalloc(shost->transportt->host_size,
 					 GFP_KERNEL);
@@ -311,10 +299,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 }
 EXPORT_SYMBOL(scsi_add_host_with_dma);
 
-static void scsi_host_dev_release(struct device *dev)
+static void scsi_host_free(struct kref *kref)
 {
-	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct device *parent = dev->parent;
+	struct Scsi_Host *shost = container_of(kref, typeof(*shost), kref2);
+	struct device *parent = shost->shost_gendev.parent;
 	struct request_queue *q;
 	void *queuedata;
 
@@ -349,6 +337,35 @@ static void scsi_host_dev_release(struct device *dev)
 	kfree(shost);
 }
 
+/* Called if shost_gendev refcnt drops to zero. */
+static void scsi_host_dev_release(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+
+	kref_put(&shost->kref2, scsi_host_free);
+}
+
+/* Called if shost_dev refcnt drops to zero. */
+static void scsi_host_cls_release(struct device *dev)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	kref_put(&shost->kref2, scsi_host_free);
+}
+
+static struct class shost_class = {
+	.name		= "scsi_host",
+	.dev_release	= scsi_host_cls_release,
+};
+
+static void scsi_host_release(struct kref *kref)
+{
+	struct Scsi_Host *shost = container_of(kref, typeof(*shost), kref1);
+
+	put_device(&shost->shost_gendev);
+	put_device(&shost->shost_dev);
+}
+
 static int shost_eh_deadline = -1;
 
 module_param_named(eh_deadline, shost_eh_deadline, int, S_IRUGO|S_IWUSR);
@@ -467,6 +484,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
 	shost->use_blk_mq = scsi_use_blk_mq && !shost->hostt->disable_blk_mq;
 
+	kref_init(&shost->kref1);
+	kref_init(&shost->kref2);
+	kref_get(&shost->kref2);
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
@@ -571,7 +592,7 @@ EXPORT_SYMBOL(scsi_host_lookup);
 struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
 {
 	if ((shost->shost_state == SHOST_DEL) ||
-		!get_device(&shost->shost_gendev))
+		!kref_get_unless_zero(&shost->kref1))
 		return NULL;
 	return shost;
 }
@@ -583,7 +604,7 @@ EXPORT_SYMBOL(scsi_host_get);
  **/
 void scsi_host_put(struct Scsi_Host *shost)
 {
-	put_device(&shost->shost_gendev);
+	kref_put(&shost->kref1, scsi_host_release);
 }
 EXPORT_SYMBOL(scsi_host_put);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ed52712..4f32cf3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -707,6 +707,11 @@ struct Scsi_Host {
 
 	enum scsi_host_state shost_state;
 
+	/* refcnt manipulated by scsi_host_get() / scsi_host_put() */
+	struct kref		kref1;
+	/* refcnt that tracks existence of shost_gendev and shost_dev */
+	struct kref		kref2;
+
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
 
-- 
2.1.4

