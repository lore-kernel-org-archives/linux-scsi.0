From: Fam Zheng <famz@redhat.com>
Subject: [PATCH 2/2] virtio_scsi: Implement fc_host
Date: Tue, 17 Jan 2017 00:04:30 +0800
Message-ID: <20170116160430.11815-3-famz@redhat.com>
References: <20170116160430.11815-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20170116160430.11815-1-famz@redhat.com>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This implements the VIRTIO_SCSI_F_FC_HOST feature by reading the config
fields and presenting them as sysfs fc_host attributes. The config
change handler is added here because primary_active will toggle during
migration.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index ec91bd0..9e92db9 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -28,6 +28,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport_fc.h>
 #include <linux/seqlock.h>
 
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
@@ -795,6 +796,15 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.track_queue_depth = 1,
 };
 
+static struct fc_function_template virtscsi_fc_template = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_port_type = 1,
+	.show_host_port_state = 1,
+};
+
+static struct scsi_transport_template *virtscsi_fc_transport_template;
+
 #define virtscsi_config_get(vdev, fld) \
 	({ \
 		typeof(((struct virtio_scsi_config *)0)->fld) __val; \
@@ -956,15 +966,38 @@ static int virtscsi_init(struct virtio_device *vdev,
 	return err;
 }
 
+static void virtscsi_update_fc_host_attrs(struct virtio_device *vdev)
+{
+	struct Scsi_Host *shost = vdev->priv;
+	u64 node_name, port_name;
+
+	if (virtscsi_config_get(vdev, primary_active)) {
+		node_name = virtio_cread64(vdev,
+			offsetof(struct virtio_scsi_config, primary_wwnn));
+		port_name = virtio_cread64(vdev,
+			offsetof(struct virtio_scsi_config, primary_wwpn));
+	} else {
+		node_name = virtio_cread64(vdev,
+			offsetof(struct virtio_scsi_config, secondary_wwnn));
+		port_name = virtio_cread64(vdev,
+			offsetof(struct virtio_scsi_config, secondary_wwpn));
+	}
+	fc_host_node_name(shost) = node_name;
+	fc_host_port_name(shost) = port_name;
+	fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
+	fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+}
+
 static int virtscsi_probe(struct virtio_device *vdev)
 {
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost = NULL;
 	struct virtio_scsi *vscsi;
 	int err;
 	u32 sg_elems, num_targets;
 	u32 cmd_per_lun;
 	u32 num_queues;
 	struct scsi_host_template *hostt;
+	bool fc_host_enabled;
 
 	if (!vdev->config->get) {
 		dev_err(&vdev->dev, "%s failure: config access disabled\n",
@@ -987,6 +1020,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	if (!shost)
 		return -ENOMEM;
 
+	fc_host_enabled = virtio_has_feature(vdev, VIRTIO_SCSI_F_FC_HOST);
+	if (fc_host_enabled)
+		shost->transportt = virtscsi_fc_transport_template;
 	sg_elems = virtscsi_config_get(vdev, seg_max) ?: 1;
 	shost->sg_tablesize = sg_elems;
 	vscsi = shost_priv(shost);
@@ -1032,6 +1068,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	if (err)
 		goto scsi_add_host_failed;
 
+	if (fc_host_enabled)
+		virtscsi_update_fc_host_attrs(vdev);
+
 	virtio_device_ready(vdev);
 
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
@@ -1098,6 +1137,11 @@ static int virtscsi_restore(struct virtio_device *vdev)
 }
 #endif
 
+static void virtscsi_config_changed(struct virtio_device *vdev)
+{
+	virtscsi_update_fc_host_attrs(vdev);
+}
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_SCSI, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -1109,6 +1153,7 @@ static unsigned int features[] = {
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	VIRTIO_SCSI_F_T10_PI,
 #endif
+	VIRTIO_SCSI_F_FC_HOST,
 };
 
 static struct virtio_driver virtio_scsi_driver = {
@@ -1123,12 +1168,19 @@ static struct virtio_driver virtio_scsi_driver = {
 	.restore = virtscsi_restore,
 #endif
 	.remove = virtscsi_remove,
+	.config_changed = virtscsi_config_changed,
 };
 
 static int __init init(void)
 {
 	int ret = -ENOMEM;
 
+	virtscsi_fc_transport_template = fc_attach_transport(&virtscsi_fc_template);
+	if (!virtscsi_fc_transport_template) {
+		pr_err("fc_attach_transport() failed\n");
+		goto error;
+	}
+
 	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
 	if (!virtscsi_cmd_cache) {
 		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
@@ -1176,6 +1228,7 @@ static int __init init(void)
 
 static void __exit fini(void)
 {
+	fc_release_transport(virtscsi_fc_transport_template);
 	unregister_virtio_driver(&virtio_scsi_driver);
 	cpuhp_remove_multi_state(virtioscsi_online);
 	cpuhp_remove_multi_state(CPUHP_VIRT_SCSI_DEAD);
-- 
2.9.3
