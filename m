From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Sun,  8 Jun 2014 13:27:06 +0300
Message-ID: <1402223228-23768-2-git-send-email-sagig@mellanox.com>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In case protection information exists on the wire
scsi transports should include it in the transfer
byte count (even if protection information does not
exist in the host memory space). This helper will
compute the total transfer length from the scsi
command data length and protection attributes.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 include/scsi/scsi_cmnd.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index dd7c998..84d9593 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <scsi/scsi_device.h>
 
 struct Scsi_Host;
 struct scsi_device;
@@ -306,4 +307,42 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
 }
 
+static inline unsigned scsi_prot_length(unsigned data_length,
+					unsigned sector_size)
+{
+	switch (sector_size) {
+	case 512:
+		return (data_length >> 9) * 8;
+	case 1024:
+		return (data_length >> 10) * 8;
+	case 2048:
+		return (data_length >> 11) * 8;
+	case 4096:
+		return (data_length >> 12) * 8;
+	default:
+		return (data_length >> ilog2(sector_size)) * 8;
+	}
+}
+
+static inline unsigned scsi_transfer_length(struct scsi_cmnd *cmd)
+{
+	unsigned data_length;
+
+	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		data_length = scsi_in(cmd)->length;
+		if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
+		    scsi_get_prot_op(cmd) ==  SCSI_PROT_READ_INSERT)
+			return data_length;
+	} else {
+		data_length = scsi_out(cmd)->length;
+		if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
+		    scsi_get_prot_op(cmd) ==  SCSI_PROT_WRITE_STRIP)
+			return data_length;
+	}
+
+	/* Protection information exists on the wire */
+	return data_length + scsi_prot_length(data_length,
+					      cmd->device->sector_size);
+}
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.7.1
