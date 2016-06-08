From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 0/2] nvme/loop: Add support for controllers-per-port model
Date: Wed, 8 Jun 2016 14:14:48 +0200
Message-ID: <20160608121448.GA31119@lst.de>
References: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

multiple ports have been on the todo list ever since we put that short
cut in place, but your patches aren't really how this should work.

The host NQN is not available for the actual drivers - we need to be able
to virtualize it for containers for example, that's why we need to pass
it by pointer depending on the arguments.  Also there is no need to
add another sysfs interface - just like for real drivers we can simply
create the ports in configfs and assign an address to it, we just need
to stop ignoring it.

Something like the patch below is the right way, it just needs a bit more
fine tuning and proper test cases:

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 94e7829..ecd2c4c 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -57,6 +57,7 @@ struct nvme_loop_ctrl {
 	struct blk_mq_tag_set	tag_set;
 	struct nvme_loop_iod	async_event_iod;
 	struct nvme_ctrl	ctrl;
+	struct nvme_loop_port	*port;
 
 	struct nvmet_ctrl	*target_ctrl;
 	struct work_struct	delete_work;
@@ -74,11 +75,17 @@ struct nvme_loop_queue {
 	struct nvme_loop_ctrl	*ctrl;
 };
 
-static struct nvmet_port *nvmet_loop_port;
-
 static LIST_HEAD(nvme_loop_ctrl_list);
 static DEFINE_MUTEX(nvme_loop_ctrl_mutex);
 
+struct nvme_loop_port {
+	struct list_head	entry;
+	struct nvmet_port	*port;
+};
+
+static LIST_HEAD(nvme_loop_ports);
+static DEFINE_SPINLOCK(nvme_loop_port_lock);
+
 static void nvme_loop_queue_response(struct nvmet_req *nvme_req);
 static void nvme_loop_delete_ctrl(struct nvmet_ctrl *ctrl);
 
@@ -172,7 +179,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return ret;
 
 	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
-	iod->req.port = nvmet_loop_port;
+	iod->req.port = queue->ctrl->port->port;
 	if (!nvmet_req_init(&iod->req, &queue->nvme_cq,
 			&queue->nvme_sq, &nvme_loop_ops)) {
 		nvme_cleanup_cmd(req);
@@ -210,6 +217,7 @@ static void nvme_loop_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
 	iod->cmd.common.opcode = nvme_admin_async_event;
 	iod->cmd.common.command_id = NVME_LOOP_AQ_BLKMQ_DEPTH;
 	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
+	iod->req.port = queue->ctrl->port->port;
 
 	if (!nvmet_req_init(&iod->req, &queue->nvme_cq, &queue->nvme_sq,
 			&nvme_loop_ops)) {
@@ -597,6 +605,20 @@ out_destroy_queues:
 	return ret;
 }
 
+static struct nvme_loop_port *
+__nvme_loop_find_port(const char *traddr)
+{
+	struct nvme_loop_port *p;
+
+	list_for_each_entry(p, &nvme_loop_ports, entry) {
+		if (!strncmp(traddr, p->port->disc_addr.traddr,
+				NVMF_TRADDR_SIZE))
+			return p;
+	}
+
+	return NULL;
+}
+
 static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
@@ -610,6 +632,17 @@ static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 	ctrl->ctrl.opts = opts;
 	INIT_LIST_HEAD(&ctrl->list);
 
+	spin_lock(&nvme_loop_port_lock);
+	ctrl->port = __nvme_loop_find_port(opts->traddr);
+	spin_unlock(&nvme_loop_port_lock);
+	if (!ctrl->port) {
+		ret = -EINVAL;
+		dev_warn(ctrl->ctrl.device,
+			 "could not find port at addr %s\n",
+			 opts->traddr);
+		goto out_put_ctrl;
+	}
+
 	INIT_WORK(&ctrl->delete_work, nvme_loop_del_ctrl_work);
 	INIT_WORK(&ctrl->reset_work, nvme_loop_reset_ctrl_work);
 
@@ -684,27 +717,40 @@ out_put_ctrl:
 
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
+	struct nvme_loop_port *p, *old;
+
+	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	spin_lock(&nvme_loop_port_lock);
+	old = __nvme_loop_find_port(port->disc_addr.traddr);
+	if (old)
+		goto out_dup;
 
-	if (nvmet_loop_port)
-		return -EPERM;
+	p->port = port;
+	list_add_tail_rcu(&p->entry, &nvme_loop_ports);
+	port->priv = p;
+	spin_unlock(&nvme_loop_port_lock);
 
-	nvmet_loop_port = port;
 	return 0;
+out_dup:
+	spin_unlock(&nvme_loop_port_lock);
+	kfree(p);
+	pr_err("duplicate port name: %s\n", port->disc_addr.traddr);
+	return -EINVAL;
 }
 
 static void nvme_loop_remove_port(struct nvmet_port *port)
 {
-	if (port == nvmet_loop_port)
-		nvmet_loop_port = NULL;
+	struct nvme_loop_port *p = port->priv;
+
+	spin_lock(&nvme_loop_port_lock);
+	list_del_rcu(&p->entry);
+	spin_unlock(&nvme_loop_port_lock);
+
+	synchronize_rcu();
+	kfree(p);
 }
 
 static struct nvmet_fabrics_ops nvme_loop_ops = {
@@ -718,6 +764,7 @@ static struct nvmet_fabrics_ops nvme_loop_ops = {
 
 static struct nvmf_transport_ops nvme_loop_transport = {
 	.name		= "loop",
+	.required_opts	= NVMF_OPT_TRADDR,
 	.create_ctrl	= nvme_loop_create_ctrl,
 };
 
