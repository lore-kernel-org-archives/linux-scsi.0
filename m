From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/21] virtio scsi: Convert to hotplug state machine
Date: Tue,  6 Sep 2016 19:04:46 +0200
Message-ID: <20160906170457.32393-11-bigeasy@linutronix.de>
References: <20160906170457.32393-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160906170457.32393-1-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rt@linutronix.de, tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Install the callbacks via the state machine. It uses the multi instance
infrastructure of the hotplug code to handle each interface.

virtscsi_set_affinity() is removed from virtscsi_init() because
virtscsi_cpu_notif_add() (the function which registers the instance) is inv=
oked
right after it and the cpuhp_state_add_instance() functions invokes the sta=
rtup
callback on all online CPUs.

The same thing can not be applied virtscsi_cpu_notif_remove() because
virtscsi_remove_vqs() invokes virtscsi_set_affinity() with affinity =3D fal=
se as
argument but the old CPU_DEAD state invoked the function with affinity =3D =
true
(which does not match the DEAD callback).

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/virtio_scsi.c | 76 ++++++++++++++++++++++++++++++------------=
----
 include/linux/cpuhotplug.h |  1 +
 2 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7dbbb29d24c6..deefab3a94d0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -107,8 +107,8 @@ struct virtio_scsi {
 	/* If the affinity hint is set for virtqueues */
 	bool affinity_hint_set;
=20
-	/* CPU hotplug notifier */
-	struct notifier_block nb;
+	struct hlist_node node;
+	struct hlist_node node_dead;
=20
 	/* Protected by event_vq lock */
 	bool stop_events;
@@ -118,6 +118,7 @@ struct virtio_scsi {
 	struct virtio_scsi_vq req_vqs[];
 };
=20
+static enum cpuhp_state virtioscsi_online;
 static struct kmem_cache *virtscsi_cmd_cache;
 static mempool_t *virtscsi_cmd_pool;
=20
@@ -852,21 +853,33 @@ static void virtscsi_set_affinity(struct virtio_scsi =
*vscsi, bool affinity)
 	put_online_cpus();
 }
=20
-static int virtscsi_cpu_callback(struct notifier_block *nfb,
-				 unsigned long action, void *hcpu)
+static int virtscsi_cpu_online(unsigned int cpu, struct hlist_node *node)
 {
-	struct virtio_scsi *vscsi =3D container_of(nfb, struct virtio_scsi, nb);
-	switch(action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		__virtscsi_set_affinity(vscsi, true);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
+	struct virtio_scsi *vscsi =3D hlist_entry_safe(node, struct virtio_scsi,
+						     node);
+	__virtscsi_set_affinity(vscsi, true);
+	return 0;
+}
+
+static int virtscsi_cpu_notif_add(struct virtio_scsi *vi)
+{
+	int ret;
+
+	ret =3D cpuhp_state_add_instance(virtioscsi_online, &vi->node);
+	if (ret)
+		return ret;
+
+	ret =3D cpuhp_state_add_instance(CPUHP_VIRT_SCSI_DEAD, &vi->node_dead);
+	if (ret)
+		cpuhp_state_remove_instance(virtioscsi_online, &vi->node);
+	return ret;
+}
+
+static void virtscsi_cpu_notif_remove(struct virtio_scsi *vi)
+{
+	cpuhp_state_remove_instance_nocalls(virtioscsi_online, &vi->node);
+	cpuhp_state_remove_instance_nocalls(CPUHP_VIRT_SCSI_DEAD,
+					    &vi->node_dead);
 }
=20
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
@@ -929,8 +942,6 @@ static int virtscsi_init(struct virtio_device *vdev,
 		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
 				 vqs[i]);
=20
-	virtscsi_set_affinity(vscsi, true);
-
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
=20
@@ -987,12 +998,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	if (err)
 		goto virtscsi_init_failed;
=20
-	vscsi->nb.notifier_call =3D &virtscsi_cpu_callback;
-	err =3D register_hotcpu_notifier(&vscsi->nb);
-	if (err) {
-		pr_err("registering cpu notifier failed\n");
+	err =3D virtscsi_cpu_notif_add(vscsi);
+	if (err)
 		goto scsi_add_host_failed;
-	}
=20
 	cmd_per_lun =3D virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun =3D min_t(u32, cmd_per_lun, shost->can_queue);
@@ -1049,7 +1057,7 @@ static void virtscsi_remove(struct virtio_device *vde=
v)
=20
 	scsi_remove_host(shost);
=20
-	unregister_hotcpu_notifier(&vscsi->nb);
+	virtscsi_cpu_notif_remove(vscsi);
=20
 	virtscsi_remove_vqs(vdev);
 	scsi_host_put(shost);
@@ -1061,7 +1069,7 @@ static int virtscsi_freeze(struct virtio_device *vdev)
 	struct Scsi_Host *sh =3D virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi =3D shost_priv(sh);
=20
-	unregister_hotcpu_notifier(&vscsi->nb);
+	virtscsi_cpu_notif_remove(vscsi);
 	virtscsi_remove_vqs(vdev);
 	return 0;
 }
@@ -1076,12 +1084,11 @@ static int virtscsi_restore(struct virtio_device *v=
dev)
 	if (err)
 		return err;
=20
-	err =3D register_hotcpu_notifier(&vscsi->nb);
+	err =3D virtscsi_cpu_notif_add(vscsi);
 	if (err) {
 		vdev->config->del_vqs(vdev);
 		return err;
 	}
-
 	virtio_device_ready(vdev);
=20
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
@@ -1136,6 +1143,16 @@ static int __init init(void)
 		pr_err("mempool_create() for virtscsi_cmd_pool failed\n");
 		goto error;
 	}
+	ret =3D cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
+				      "scsi/virtio:online",
+				      virtscsi_cpu_online, NULL);
+	if (ret < 0)
+		goto error;
+	virtioscsi_online =3D ret;
+	ret =3D cpuhp_setup_state_multi(CPUHP_VIRT_SCSI_DEAD, "scsi/virtio:dead",
+				      NULL, virtscsi_cpu_online);
+	if (ret)
+		goto error;
 	ret =3D register_virtio_driver(&virtio_scsi_driver);
 	if (ret < 0)
 		goto error;
@@ -1151,12 +1168,17 @@ static int __init init(void)
 		kmem_cache_destroy(virtscsi_cmd_cache);
 		virtscsi_cmd_cache =3D NULL;
 	}
+	if (virtioscsi_online)
+		cpuhp_remove_multi_state(virtioscsi_online);
+	cpuhp_remove_multi_state(CPUHP_VIRT_SCSI_DEAD);
 	return ret;
 }
=20
 static void __exit fini(void)
 {
 	unregister_virtio_driver(&virtio_scsi_driver);
+	cpuhp_remove_multi_state(virtioscsi_online);
+	cpuhp_remove_multi_state(CPUHP_VIRT_SCSI_DEAD);
 	mempool_destroy(virtscsi_cmd_pool);
 	kmem_cache_destroy(virtscsi_cmd_cache);
 }
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index a12044828e03..73a4daf08c04 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -24,6 +24,7 @@ enum cpuhp_state {
 	CPUHP_ARM_OMAP_WAKE_DEAD,
 	CPUHP_IRQ_POLL_DEAD,
 	CPUHP_BLOCK_SOFTIRQ_DEAD,
+	CPUHP_VIRT_SCSI_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
--=20
2.9.3
