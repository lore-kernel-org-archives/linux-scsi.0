From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V7 5/5] virtio-scsi: reset virtqueue affinity when doing cpu
	hotplug
Date: Sat, 23 Mar 2013 19:28:44 +0800
Message-ID: <1364038124-32479-6-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

Add hot cpu notifier to reset the request virtqueue affinity
when doing cpu hotplug.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Asias He <asias@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8dcdef0..2168258 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -110,6 +110,9 @@ struct virtio_scsi {
 	/* If the affinity hint is set for virtqueues */
 	bool affinity_hint_set;
 
+	/* CPU hotplug notifier */
+	struct notifier_block nb;
+
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
 	struct virtio_scsi_vq req_vqs[];
@@ -762,6 +765,23 @@ static void virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
 	put_online_cpus();
 }
 
+static int virtscsi_cpu_callback(struct notifier_block *nfb,
+				 unsigned long action, void *hcpu)
+{
+	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
+	switch(action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		__virtscsi_set_affinity(vscsi, true);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
 			     struct virtqueue *vq)
 {
@@ -884,6 +904,13 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	if (err)
 		goto virtscsi_init_failed;
 
+	vscsi->nb.notifier_call = &virtscsi_cpu_callback;
+	err = register_hotcpu_notifier(&vscsi->nb);
+	if (err) {
+		pr_err("registering cpu notifier failed\n");
+		goto scsi_add_host_failed;
+	}
+
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
 	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
@@ -921,6 +948,8 @@ static void virtscsi_remove(struct virtio_device *vdev)
 
 	scsi_remove_host(shost);
 
+	unregister_hotcpu_notifier(&vscsi->nb);
+
 	virtscsi_remove_vqs(vdev);
 	scsi_host_put(shost);
 }
-- 
1.8.2.rc2
