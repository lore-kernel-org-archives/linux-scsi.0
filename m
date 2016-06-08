From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 1/2] nvme-fabrics: Add nvmf_get_default_host helper
Date: Wed,  8 Jun 2016 03:34:20 +0000
Message-ID: <1465356861-4321-2-git-send-email-nab@linux-iscsi.org>
References: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a nvmf_get_default_host() helper used to
setup nvmf_ctrl_options->host to internal nvmf_default_host
reference, following existing nvmf_parse_options() code.

Note it's required for nvme-loop multi-controller support,
in order to drive nvmet_port creation directly via configfs
attribute write from in ../nvmet/subsystems/$NQN/ports/$PORT/
group context.

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
 drivers/nvme/host/fabrics.c | 13 +++++++++++--
 drivers/nvme/host/fabrics.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index ee4b7f1..04317be 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -497,6 +497,16 @@ static struct nvmf_transport_ops *nvmf_lookup_transport(
 	return NULL;
 }
 
+void nvmf_get_default_host(struct nvmf_ctrl_options *opts)
+{
+	if (opts->host)
+		return;
+
+	kref_get(&nvmf_default_host->ref);
+	opts->host = nvmf_default_host;
+}
+EXPORT_SYMBOL_GPL(nvmf_get_default_host);
+
 static const match_table_t opt_tokens = {
 	{ NVMF_OPT_TRANSPORT,		"transport=%s"		},
 	{ NVMF_OPT_TRADDR,		"traddr=%s"		},
@@ -686,8 +696,7 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	}
 
 	if (!opts->host) {
-		kref_get(&nvmf_default_host->ref);
-		opts->host = nvmf_default_host;
+		nvmf_get_default_host(opts);
 	}
 
 out:
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index b540674..73ef7a7 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -128,6 +128,7 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl);
 int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid);
 void nvmf_register_transport(struct nvmf_transport_ops *ops);
 void nvmf_unregister_transport(struct nvmf_transport_ops *ops);
+void nvmf_get_default_host(struct nvmf_ctrl_options *opts);
 void nvmf_free_options(struct nvmf_ctrl_options *opts);
 const char *nvmf_get_subsysnqn(struct nvme_ctrl *ctrl);
 int nvmf_get_address(struct nvme_ctrl *ctrl, char *buf, int size);
-- 
1.9.1
