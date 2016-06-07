From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 1/8] nvmet: Add nvmet_fabric_ops get/put transport helpers
Date: Tue,  7 Jun 2016 06:36:49 +0000
Message-ID: <1465281416-28355-2-git-send-email-nab@linux-iscsi.org>
References: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-nvme <linux-nvme@lists.infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch introduces two helpers for obtaining + releasing
nvmet_fabric_ops for nvmet_port usage, and the associated
struct module ops->owner reference.

This is required in order to support nvmet/configfs-ng
and multiple nvmet_port configfs groups living under
/sys/kernel/config/nvmet/subsystems/$SUBSYS_NQN/ports/

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/core.c  | 31 +++++++++++++++++++++++++++++++
 drivers/nvme/target/nvmet.h |  3 +++
 2 files changed, 34 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index e0b3f01..9af813c 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -191,6 +191,37 @@ void nvmet_disable_port(struct nvmet_port *port)
 	module_put(ops->owner);
 }
 
+struct nvmet_fabrics_ops *nvmet_get_transport(struct nvmet_port *port)
+{
+	struct nvmet_fabrics_ops *ops;
+
+	down_write(&nvmet_config_sem);
+	ops = nvmet_transports[port->disc_addr.trtype];
+	if (!ops) {
+		pr_err("transport type %d not supported\n",
+			port->disc_addr.trtype);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!try_module_get(ops->owner)) {
+		up_write(&nvmet_config_sem);
+		return ERR_PTR(-EINVAL);
+	}
+	up_write(&nvmet_config_sem);
+
+	return ops;
+}
+
+void nvmet_put_transport(struct nvmet_port *port)
+{
+	struct nvmet_fabrics_ops *ops;
+
+	down_write(&nvmet_config_sem);
+	ops = nvmet_transports[port->disc_addr.trtype];
+	module_put(ops->owner);
+	up_write(&nvmet_config_sem);
+}
+
 static void nvmet_keep_alive_timer(struct work_struct *work)
 {
 	struct nvmet_ctrl *ctrl = container_of(to_delayed_work(work),
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 57dd6d8..2bf15088b 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -299,6 +299,9 @@ void nvmet_unregister_transport(struct nvmet_fabrics_ops *ops);
 int nvmet_enable_port(struct nvmet_port *port);
 void nvmet_disable_port(struct nvmet_port *port);
 
+struct nvmet_fabrics_ops *nvmet_get_transport(struct nvmet_port *port);
+void nvmet_put_transport(struct nvmet_port *port);
+
 void nvmet_referral_enable(struct nvmet_port *parent, struct nvmet_port *port);
 void nvmet_referral_disable(struct nvmet_port *port);
 
-- 
1.9.1
