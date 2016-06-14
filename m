From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 10/11] nvmet/admin-cmd: Hookup T10-PI to ID_NS.ms + ID_NS.dps feature bits
Date: Tue, 14 Jun 2016 04:35:45 +0000
Message-ID: <1465878946-26556-11-git-send-email-nab@linux-iscsi.org>
References: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38552 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbcFNEhC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 00:37:02 -0400
In-Reply-To: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates nvmet_execute_identify_ns() to report
target-core backend T10-PI related feature bits to the
NVMe host controller.

Note this assumes support for NVME_NS_DPC_PI_TYPE1 and
NVME_NS_DPC_PI_TYPE3 as reported by backend drivers via
/sys/kernel/config/target/core/*/*/attrib/pi_prot_type.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/admin-cmd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 240e323..3a808dc 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -200,6 +200,7 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 {
 	struct nvmet_ns *ns;
 	struct nvme_id_ns *id;
+	struct se_device *dev;
 	u16 status = 0;
 
 	ns = nvmet_find_namespace(req->sq->ctrl, req->cmd->identify.nsid);
@@ -228,6 +229,22 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 	id->nlbaf = 0;
 	id->flbas = 0;
 
+	/* Populate bits for T10-PI from se_device backend */
+	rcu_read_lock();
+	dev = rcu_dereference(ns->dev);
+	if (dev && dev->dev_attrib.pi_prot_type) {
+		int pi_prot_type = dev->dev_attrib.pi_prot_type;
+
+		id->lbaf[0].ms = cpu_to_le16(sizeof(struct t10_pi_tuple));
+		printk("nvmet_set_id_ns: ms: %u\n", id->lbaf[0].ms);
+
+		if (pi_prot_type == 1)
+			id->dps = NVME_NS_DPC_PI_TYPE1;
+		else if (pi_prot_type == 3)
+			id->dps = NVME_NS_DPC_PI_TYPE3;
+	}
+	rcu_read_unlock();
+
 	/*
 	 * Our namespace might always be shared.  Not just with other
 	 * controllers, but also with any other user of the block device.
-- 
1.9.1

