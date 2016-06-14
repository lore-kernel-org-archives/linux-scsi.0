From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 06/11] nvmet/rdma: Convert to struct nvmet_port_binding
Date: Tue, 14 Jun 2016 04:35:41 +0000
Message-ID: <1465878946-26556-7-git-send-email-nab@linux-iscsi.org>
References: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38505 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbcFNEg5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 00:36:57 -0400
In-Reply-To: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts nvmet/rdma to nvmet_port_binding in
configfs-ng, and introduces a nvmet_rdma_port that allows
for multiple nvmet_subsys nvmet_port_bindings to be mapped
to a single nvmet_rdma_port rdma_cm_id listener.

It moves rdma_cm_id setup into nvmet_rdma_listen_cmid(),
and rdma_cm_id destroy into nvmet_rmda_destroy_cmid()
using nvmet_rdma_port->ref.

It also updates nvmet_rdma_add_port() to do internal
port lookup matching traddr and trsvcid, and grabs
nvmet_rdma_port->ref if a matching port already exists.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jay Freyensee <james.p.freyensee@intel.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/rdma.c | 127 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 114 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index fccb01d..62638f7af 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -118,6 +118,17 @@ struct nvmet_rdma_device {
 	struct list_head	entry;
 };
 
+struct nvmet_rdma_port {
+	atomic_t		enabled;
+
+	struct rdma_cm_id	*cm_id;
+	struct nvmf_disc_rsp_page_entry port_addr;
+
+	struct list_head	node;
+	struct kref		ref;
+	struct nvmet_port	port;
+};
+
 static bool nvmet_rdma_use_srq;
 module_param_named(use_srq, nvmet_rdma_use_srq, bool, 0444);
 MODULE_PARM_DESC(use_srq, "Use shared receive queue.");
@@ -129,6 +140,9 @@ static DEFINE_MUTEX(nvmet_rdma_queue_mutex);
 static LIST_HEAD(device_list);
 static DEFINE_MUTEX(device_list_mutex);
 
+static LIST_HEAD(nvmet_rdma_ports);
+static DEFINE_MUTEX(nvmet_rdma_ports_mutex);
+
 static bool nvmet_rdma_execute_command(struct nvmet_rdma_rsp *rsp);
 static void nvmet_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void nvmet_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc);
@@ -1127,6 +1141,7 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 {
 	struct nvmet_rdma_device *ndev;
 	struct nvmet_rdma_queue *queue;
+	struct nvmet_rdma_port *rdma_port;
 	int ret = -EINVAL;
 
 	ndev = nvmet_rdma_find_get_device(cm_id);
@@ -1141,7 +1156,8 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 		ret = -ENOMEM;
 		goto put_device;
 	}
-	queue->port = cm_id->context;
+	rdma_port = cm_id->context;
+	queue->port = &rdma_port->port;
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
 	if (ret)
@@ -1306,26 +1322,50 @@ static void nvmet_rdma_delete_ctrl(struct nvmet_ctrl *ctrl)
 		nvmet_rdma_queue_disconnect(queue);
 }
 
-static int nvmet_rdma_add_port(struct nvmet_port *port)
+static struct nvmet_rdma_port *nvmet_rdma_listen_cmid(struct nvmet_port_binding *pb)
 {
+	struct nvmet_rdma_port *rdma_port;
 	struct rdma_cm_id *cm_id;
 	struct sockaddr_in addr_in;
 	u16 port_in;
 	int ret;
 
-	ret = kstrtou16(port->disc_addr.trsvcid, 0, &port_in);
+	rdma_port = kzalloc(sizeof(*rdma_port), GFP_KERNEL);
+	if (!rdma_port)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&rdma_port->node);
+	kref_init(&rdma_port->ref);
+	mutex_init(&rdma_port->port.port_binding_mutex);
+	INIT_LIST_HEAD(&rdma_port->port.port_binding_list);
+	rdma_port->port.priv = rdma_port;
+	rdma_port->port.nf_subsys = pb->nf_subsys;
+	rdma_port->port.nf_ops = pb->nf_ops;
+	pb->port = &rdma_port->port;
+
+	memcpy(&rdma_port->port_addr, &pb->disc_addr,
+		sizeof(struct nvmf_disc_rsp_page_entry));
+
+	nvmet_port_binding_enable(pb, &rdma_port->port);
+
+	mutex_lock(&nvmet_rdma_ports_mutex);
+	list_add_tail(&rdma_port->node, &nvmet_rdma_ports);
+	mutex_unlock(&nvmet_rdma_ports_mutex);
+
+	ret = kstrtou16(pb->disc_addr.trsvcid, 0, &port_in);
 	if (ret)
-		return ret;
+		goto out_port_disable;
 
 	addr_in.sin_family = AF_INET;
-	addr_in.sin_addr.s_addr = in_aton(port->disc_addr.traddr);
+	addr_in.sin_addr.s_addr = in_aton(pb->disc_addr.traddr);
 	addr_in.sin_port = htons(port_in);
 
-	cm_id = rdma_create_id(&init_net, nvmet_rdma_cm_handler, port,
+	cm_id = rdma_create_id(&init_net, nvmet_rdma_cm_handler, rdma_port,
 			RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cm_id)) {
 		pr_err("CM ID creation failed\n");
-		return PTR_ERR(cm_id);
+		ret = PTR_ERR(cm_id);
+		goto out_port_disable;
 	}
 
 	ret = rdma_bind_addr(cm_id, (struct sockaddr *)&addr_in);
@@ -1340,21 +1380,82 @@ static int nvmet_rdma_add_port(struct nvmet_port *port)
 		goto out_destroy_id;
 	}
 
+	atomic_set(&rdma_port->enabled, 1);
 	pr_info("enabling port %d (%pISpc)\n",
-		le16_to_cpu(port->disc_addr.portid), &addr_in);
-	port->priv = cm_id;
-	return 0;
+		le16_to_cpu(pb->disc_addr.portid), &addr_in);
+
+	return rdma_port;
 
 out_destroy_id:
 	rdma_destroy_id(cm_id);
-	return ret;
+out_port_disable:
+	mutex_lock(&nvmet_rdma_ports_mutex);
+	list_del_init(&rdma_port->node);
+	mutex_unlock(&nvmet_rdma_ports_mutex);
+
+	nvmet_port_binding_disable(pb, &rdma_port->port);
+	kfree(rdma_port);
+	return ERR_PTR(ret);
 }
 
-static void nvmet_rdma_remove_port(struct nvmet_port *port)
+static void nvmet_rmda_destroy_cmid(struct kref *ref)
 {
-	struct rdma_cm_id *cm_id = port->priv;
+	struct nvmet_rdma_port *rdma_port = container_of(ref,
+				struct nvmet_rdma_port, ref);
+	struct rdma_cm_id *cm_id = rdma_port->cm_id;
+
+	mutex_lock(&nvmet_rdma_ports_mutex);
+	atomic_set(&rdma_port->enabled, 0);
+	list_del_init(&rdma_port->node);
+	mutex_unlock(&nvmet_rdma_ports_mutex);
 
 	rdma_destroy_id(cm_id);
+	kfree(rdma_port);
+}
+
+static int nvmet_rdma_add_port(struct nvmet_port_binding *pb)
+{
+	struct nvmet_rdma_port *rdma_port;
+	struct nvmf_disc_rsp_page_entry *pb_addr = &pb->disc_addr;
+
+	mutex_lock(&nvmet_rdma_ports_mutex);
+	list_for_each_entry(rdma_port, &nvmet_rdma_ports, node) {
+		struct nvmf_disc_rsp_page_entry *port_addr = &rdma_port->port_addr;
+
+		if (!strcmp(port_addr->traddr, pb_addr->traddr) &&
+		    !strcmp(port_addr->trsvcid, pb_addr->trsvcid)) {
+			if (!atomic_read(&rdma_port->enabled)) {
+				mutex_unlock(&nvmet_rdma_ports_mutex);
+				return -ENODEV;
+			}
+			kref_get(&rdma_port->ref);
+			mutex_unlock(&nvmet_rdma_ports_mutex);
+
+			nvmet_port_binding_enable(pb, &rdma_port->port);
+			return 0;
+		}
+	}
+	mutex_unlock(&nvmet_rdma_ports_mutex);
+
+	rdma_port = nvmet_rdma_listen_cmid(pb);
+	if (IS_ERR(rdma_port))
+		return PTR_ERR(rdma_port);
+
+	return 0;
+}
+
+static void nvmet_rdma_remove_port(struct nvmet_port_binding *pb)
+{
+	struct nvmet_port *port = pb->port;
+	struct nvmet_rdma_port *rdma_port;
+
+	if (!port)
+		return;
+
+	rdma_port = container_of(port, struct nvmet_rdma_port, port);
+	nvmet_port_binding_disable(pb, &rdma_port->port);
+
+	kref_put(&rdma_port->ref, nvmet_rmda_destroy_cmid);
 }
 
 static struct nvmet_fabrics_ops nvmet_rdma_ops = {
-- 
1.9.1

