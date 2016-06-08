From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 2/2] nvme/loop: Add support for controller-per-port model
Date: Wed,  8 Jun 2016 03:34:21 +0000
Message-ID: <1465356861-4321-3-git-send-email-nab@linux-iscsi.org>
References: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34414 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbcFHDfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 23:35:16 -0400
In-Reply-To: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch introduces loopback support for a nvme host
controller per nvmet_port instance model, following what
we've done in drivers/target/loopback/ for allowing
multiple host LLDs to co-exist.

It changes nvme_loop_add_port() to use struct nvme_loop_port
and take the nvmf_get_default_host() reference, and invokes
device_register() to nvme_loop_driver_probe() to kick off
controller creation within nvme_loop_create_ctrl().

This allows nvme_loop_queue_rq to setup iod->req.port to
the per nvmet_port pointer, instead of a single hardcoded
global nvmet_loop_port.

Subsequently, it also adds nvme_loop_remove_port() to call
device_unregister() and call nvme_loop_del_ctrl() and
nvmf_free_options() to drop vmet_port's nvme_default_host
rereference, when the nvmet_port port is being removed
from the associated nvmet_subsys.

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
 drivers/nvme/target/loop.c | 183 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 165 insertions(+), 18 deletions(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index b4b4da9..01b73dc 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -46,6 +46,13 @@ struct nvme_loop_iod {
 	struct scatterlist	first_sgl[];
 };
 
+struct nvme_loop_port {
+	struct device		dev;
+	struct nvmf_ctrl_options *opts;
+	struct nvmet_port	*port;
+	struct nvme_ctrl	*ctrl;
+};
+
 struct nvme_loop_ctrl {
 	spinlock_t		lock;
 	struct nvme_loop_queue	*queues;
@@ -62,6 +69,8 @@ struct nvme_loop_ctrl {
 	struct nvmet_ctrl	*target_ctrl;
 	struct work_struct	delete_work;
 	struct work_struct	reset_work;
+
+	struct nvme_loop_port	*port;
 };
 
 static inline struct nvme_loop_ctrl *to_loop_ctrl(struct nvme_ctrl *ctrl)
@@ -75,8 +84,6 @@ struct nvme_loop_queue {
 	struct nvme_loop_ctrl	*ctrl;
 };
 
-static struct nvmet_port *nvmet_loop_port;
-
 static LIST_HEAD(nvme_loop_ctrl_list);
 static DEFINE_MUTEX(nvme_loop_ctrl_mutex);
 
@@ -173,7 +180,8 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return ret;
 
 	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
-	iod->req.port = nvmet_loop_port;
+	iod->req.port = queue->ctrl->port->port;
+
 	if (!nvmet_req_init(&iod->req, &queue->nvme_cq,
 			&queue->nvme_sq, &nvme_loop_ops)) {
 		nvme_cleanup_cmd(req);
@@ -618,6 +626,8 @@ out_destroy_queues:
 static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
+	struct nvme_loop_port *loop_port = container_of(dev,
+				struct nvme_loop_port, dev);
 	struct nvme_loop_ctrl *ctrl;
 	bool changed;
 	int ret;
@@ -626,6 +636,7 @@ static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 	if (!ctrl)
 		return ERR_PTR(-ENOMEM);
 	ctrl->ctrl.opts = opts;
+	ctrl->port = loop_port;
 	INIT_LIST_HEAD(&ctrl->list);
 
 	INIT_WORK(&ctrl->delete_work, nvme_loop_del_ctrl_work);
@@ -700,29 +711,117 @@ out_put_ctrl:
 	return ERR_PTR(ret);
 }
 
+static int nvme_loop_driver_probe(struct device *dev)
+{
+	struct nvme_loop_port *loop_port = container_of(dev,
+				struct nvme_loop_port, dev);
+	struct nvme_ctrl *ctrl;
+
+	ctrl = nvme_loop_create_ctrl(dev, loop_port->opts);
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	loop_port->ctrl = ctrl;
+	return 0;
+}
+
+static int nvme_loop_driver_remove(struct device *dev)
+{
+	struct nvme_loop_port *loop_port = container_of(dev,
+				struct nvme_loop_port, dev);
+	struct nvme_ctrl *ctrl = loop_port->ctrl;
+	struct nvmf_ctrl_options *opts = loop_port->opts;
+
+	nvme_loop_del_ctrl(ctrl);
+	nvmf_free_options(opts);
+	return 0;
+}
+
+static int pseudo_bus_match(struct device *dev,
+			    struct device_driver *dev_driver)
+{
+	return 1;
+}
+
+static struct bus_type nvme_loop_bus = {
+	.name			= "nvme_loop_bus",
+	.match			= pseudo_bus_match,
+	.probe			= nvme_loop_driver_probe,
+	.remove			= nvme_loop_driver_remove,
+};
+
+static struct device_driver nvme_loop_driverfs = {
+	.name			= "nvme_loop",
+	.bus			= &nvme_loop_bus,
+};
+
+static void nvme_loop_release_adapter(struct device *dev)
+{
+	struct nvme_loop_port *loop_port = container_of(dev,
+				struct nvme_loop_port, dev);
+
+	kfree(loop_port);
+}
+
+static struct device *nvme_loop_primary;
+
 static int nvme_loop_add_port(struct nvmet_port *port)
 {
-	/*
-	 * XXX: disalow adding more than one port so
-	 * there is no connection rejections when a
-	 * a subsystem is assigned to a port for which
-	 * loop doesn't have a pointer.
-	 * This scenario would be possible if we allowed
-	 * more than one port to be added and a subsystem
-	 * was assigned to a port other than nvmet_loop_port.
-	 */
+	struct nvmet_subsys *subsys = port->nf_subsys;
+	struct nvme_loop_port *loop_port;
+	struct nvmf_ctrl_options *opts;
+	struct device *dev;
+	int ret;
 
-	if (nvmet_loop_port)
-		return -EPERM;
+	loop_port = kzalloc(sizeof(*loop_port), GFP_KERNEL);
+	if (!loop_port)
+		return -ENOMEM;
+
+	opts = kzalloc(sizeof(*opts), GFP_KERNEL);
+	if (!opts) {
+		kfree(loop_port);
+		return -ENOMEM;
+	}
+	loop_port->opts = opts;
+
+	/* Set defaults */
+	opts->queue_size = NVMF_DEF_QUEUE_SIZE;
+	opts->nr_io_queues = num_online_cpus();
+	opts->tl_retry_count = 2;
+	opts->reconnect_delay = NVMF_DEF_RECONNECT_DELAY;
+	opts->kato = NVME_DEFAULT_KATO;
+
+	nvmf_get_default_host(opts);
+	opts->transport = kstrdup("loop", GFP_KERNEL);
+	opts->subsysnqn = kstrdup(subsys->subsysnqn, GFP_KERNEL);
+
+	dev = &loop_port->dev;
+	dev->bus = &nvme_loop_bus;
+	dev->parent = nvme_loop_primary;
+	dev->release = &nvme_loop_release_adapter;
+	dev_set_name(dev, "nvme_loop_ctrl:%s", subsys->subsysnqn);
+
+	port->priv = loop_port;
+	loop_port->port = port;
+
+	ret = device_register(dev);
+	if (ret) {
+		pr_err("device_register() failed: %d\n", ret);
+		kfree(loop_port);
+		return ret;
+	}
 
-	nvmet_loop_port = port;
 	return 0;
 }
 
 static void nvme_loop_remove_port(struct nvmet_port *port)
 {
-	if (port == nvmet_loop_port)
-		nvmet_loop_port = NULL;
+	struct nvme_loop_port *loop_port = port->priv;
+
+	if (!loop_port)
+		return;
+
+	device_unregister(&loop_port->dev);
 }
 
 static struct nvmet_fabrics_ops nvme_loop_ops = {
@@ -739,13 +838,59 @@ static struct nvmf_transport_ops nvme_loop_transport = {
 	.create_ctrl	= nvme_loop_create_ctrl,
 };
 
+static int nvme_loop_alloc_core_bus(void)
+{
+	int ret;
+
+	nvme_loop_primary = root_device_register("nvme_loop_0");
+	if (IS_ERR(nvme_loop_primary)) {
+		pr_err("Unable to allocate nvme_loop_primary\n");
+		return PTR_ERR(nvme_loop_primary);
+	}
+
+	ret = bus_register(&nvme_loop_bus);
+	if (ret) {
+		pr_err("bus_register() failed for nvme_loop_bus\n");
+		goto dev_unreg;
+	}
+
+	ret = driver_register(&nvme_loop_driverfs);
+	if (ret) {
+		pr_err("driver_register() failed for"
+				" nvme_loop_driverfs\n");
+		goto bus_unreg;
+	}
+
+	return ret;
+
+bus_unreg:
+	bus_unregister(&nvme_loop_bus);
+dev_unreg:
+	root_device_unregister(nvme_loop_primary);
+	return ret;
+}
+
+static void nvme_loop_release_core_bus(void)
+{
+	driver_unregister(&nvme_loop_driverfs);
+	bus_unregister(&nvme_loop_bus);
+	root_device_unregister(nvme_loop_primary);
+}
+
 static int __init nvme_loop_init_module(void)
 {
 	int ret;
 
-	ret = nvmet_register_transport(&nvme_loop_ops);
+	ret = nvme_loop_alloc_core_bus();
 	if (ret)
 		return ret;
+
+	ret = nvmet_register_transport(&nvme_loop_ops);
+	if (ret) {
+		nvme_loop_release_core_bus();
+		return ret;
+	}
+
 	nvmf_register_transport(&nvme_loop_transport);
 	return 0;
 }
@@ -763,6 +908,8 @@ static void __exit nvme_loop_cleanup_module(void)
 	mutex_unlock(&nvme_loop_ctrl_mutex);
 
 	flush_scheduled_work();
+
+	nvme_loop_release_core_bus();
 }
 
 module_init(nvme_loop_init_module);
-- 
1.9.1

