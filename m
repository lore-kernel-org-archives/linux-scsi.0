From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 11 Jun 2014 12:09:57 +0300
Message-ID: <1402477799-24610-2-git-send-email-sagig@mellanox.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:44606 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932382AbaFKJPG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 05:15:06 -0400
In-Reply-To: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org

In case protection information exists on the wire
scsi transports should include it in the transfer
byte count (even if protection information does not
exist in the host memory space). This helper will
compute the total transfer length from the scsi
command data length and protection attributes.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/scsi/scsi_cmnd.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index dd7c998..a100c6e 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <scsi/scsi_device.h>
 
 struct Scsi_Host;
 struct scsi_device;
@@ -306,4 +307,20 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
 }
 
+static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
+{
+	unsigned int xfer_len = blk_rq_bytes(scmd->request);
+	unsigned int prot_op = scsi_get_prot_op(scmd);
+	unsigned int sector_size = scmd->device->sector_size;
+
+	switch (prot_op) {
+	case SCSI_PROT_NORMAL:
+	case SCSI_PROT_WRITE_STRIP:
+	case SCSI_PROT_READ_INSERT:
+		return xfer_len;
+	}
+
+	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
+}
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.7.1

