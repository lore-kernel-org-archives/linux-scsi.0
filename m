From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/10] scsi: Rename SERVICE_ACTION_IN to SERVICE_ACTION_IN_16
Date: Tue,  4 Nov 2014 09:06:46 +0100
Message-ID: <1415088409-46590-8-git-send-email-hare@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaKDIGy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:06:54 -0500
In-Reply-To: <1415088409-46590-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

SPC-3 defines SERVICE ACTION IN(12) and SERVICE ACTION IN(16).
So rename SERVICE_ACTION_IN to SERVICE_ACTION_IN_16 to be
consistent with SPC and to allow for better distinction.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/scsi_ioctl.c                         | 2 +-
 drivers/ata/libata-scsi.c                  | 2 +-
 drivers/block/nvme-scsi.c                  | 4 ++--
 drivers/scsi/aacraid/aachba.c              | 4 ++--
 drivers/scsi/aacraid/linit.c               | 2 +-
 drivers/scsi/constants.c                   | 1 -
 drivers/scsi/gdth.c                        | 4 ++--
 drivers/scsi/scsi_debug.c                  | 2 +-
 drivers/scsi/scsi_trace.c                  | 2 +-
 drivers/scsi/sd.c                          | 2 +-
 drivers/target/target_core_alua.c          | 2 +-
 drivers/target/target_core_sbc.c           | 2 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c | 2 +-
 include/scsi/scsi.h                        | 2 +-
 include/trace/events/scsi.h                | 2 +-
 include/trace/events/target.h              | 2 +-
 tools/lib/traceevent/plugin_scsi.c         | 4 ++--
 17 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 1e053d9..c7bbc19 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -142,7 +142,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
 	__set_bit(VERIFY_16, filter->read_ok);
 	__set_bit(REPORT_LUNS, filter->read_ok);
-	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
+	__set_bit(SERVICE_ACTION_IN_16, filter->read_ok);
 	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
 	__set_bit(MAINTENANCE_IN, filter->read_ok);
 	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0586f66..52a1b7e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3570,7 +3570,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 		break;
 
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
 			ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 		else
diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index a4cd6d6..0b4b277 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -329,7 +329,7 @@ INQUIRY_EVPD_BIT_MASK) ? 1 : 0)
 (GET_U32_FROM_CDB(cdb, READ_CAP_16_CDB_ALLOC_LENGTH_OFFSET))
 
 #define IS_READ_CAP_16(cdb)					\
-((cdb[0] == SERVICE_ACTION_IN && cdb[1] == SAI_READ_CAPACITY_16) ? 1 : 0)
+((cdb[0] == SERVICE_ACTION_IN_16 && cdb[1] == SAI_READ_CAPACITY_16) ? 1 : 0)
 
 /* Request Sense Helper Macros */
 #define GET_REQUEST_SENSE_ALLOC_LENGTH(cdb)			\
@@ -2947,7 +2947,7 @@ static int nvme_scsi_translate(struct nvme_ns *ns, struct sg_io_hdr *hdr)
 	case READ_CAPACITY:
 		retcode = nvme_trans_read_capacity(ns, hdr, cmd);
 		break;
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		if (IS_READ_CAP_16(cmd))
 			retcode = nvme_trans_read_capacity(ns, hdr, cmd);
 		else
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 681434e..b32e77d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2181,7 +2181,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			  (fsa_dev_ptr[cid].sense_data.sense_key ==
 			   NOT_READY)) {
 				switch (scsicmd->cmnd[0]) {
-				case SERVICE_ACTION_IN:
+				case SERVICE_ACTION_IN_16:
 					if (!(dev->raw_io_interface) ||
 					    !(dev->raw_io_64) ||
 					    ((scsicmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
@@ -2309,7 +2309,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd, &inq_data, sizeof(inq_data));
 		return aac_get_container_name(scsicmd);
 	}
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		if (!(dev->raw_io_interface) ||
 		    !(dev->raw_io_64) ||
 		    ((scsicmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a759cb2..0ba7758 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -555,7 +555,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 		AAC_DRIVERNAME,
 		host->host_no, sdev_channel(dev), sdev_id(dev), dev->lun);
 	switch (cmd->cmnd[0]) {
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		if (!(aac->raw_io_interface) ||
 		    !(aac->raw_io_64) ||
 		    ((cmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 4ec2d79e..0d2ec4d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -24,7 +24,6 @@
 #define SERVICE_ACTION_IN_12 0xab
 #define SERVICE_ACTION_OUT_12 0xa9
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
-#define SERVICE_ACTION_IN_16 0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
 #define THIRD_PARTY_COPY_OUT 0x83
 #define THIRD_PARTY_COPY_IN 0x84
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 0f1ae13..28c7b54 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2159,7 +2159,7 @@ static void gdth_next(gdth_ha_str *ha)
               case VERIFY:
               case START_STOP:
               case MODE_SENSE:
-              case SERVICE_ACTION_IN:
+              case SERVICE_ACTION_IN_16:
                 TRACE(("cache cmd %x/%x/%x/%x/%x/%x\n",nscp->cmnd[0],
                        nscp->cmnd[1],nscp->cmnd[2],nscp->cmnd[3],
                        nscp->cmnd[4],nscp->cmnd[5]));
@@ -2391,7 +2391,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data));
         break;
 
-      case SERVICE_ACTION_IN:
+      case SERVICE_ACTION_IN_16:
         if ((scp->cmnd[1] & 0x1f) == SAI_READ_CAPACITY_16 &&
             (ha->cache_feat & GDT_64BIT)) {
             gdth_rdcap16_data rdc16;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 238e06f..99fc31d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4214,7 +4214,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *SCpnt)
 	case READ_CAPACITY:
 		errsts = resp_readcap(SCpnt, devip);
 		break;
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		if (cmd[1] == SAI_READ_CAPACITY_16)
 			errsts = resp_readcap16(SCpnt, devip);
 		else if (cmd[1] == SAI_GET_LBA_STATUS) {
diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 503594e..82af28b 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -278,7 +278,7 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_rw16(p, cdb, len);
 	case UNMAP:
 		return scsi_trace_unmap(p, cdb, len);
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		return scsi_trace_service_action_in(p, cdb, len);
 	case VARIABLE_LENGTH_CMD:
 		return scsi_trace_varlen(p, cdb, len);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e7333de..27a9ea4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1992,7 +1992,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	do {
 		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN;
+		cmd[0] = SERVICE_ACTION_IN_16;
 		cmd[1] = SAI_READ_CAPACITY_16;
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index fb87780..75cbde1 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -576,7 +576,7 @@ static inline int core_alua_state_standby(
 	case SEND_DIAGNOSTIC:
 	case READ_CAPACITY:
 		return 0;
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		switch (cdb[1] & 0x1f) {
 		case SAI_READ_CAPACITY_16:
 			return 0;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ebe62af..8d171ff 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -852,7 +852,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = READ_CAP_LEN;
 		cmd->execute_cmd = sbc_emulate_readcapacity;
 		break;
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		switch (cmd->t_task_cdb[1] & 0x1f) {
 		case SAI_READ_CAPACITY_16:
 			cmd->execute_cmd = sbc_emulate_readcapacity_16;
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 6cdb7a5..024f584 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -912,7 +912,7 @@ static int get_cmd_dir(const unsigned char *cdb)
 	case INQUIRY:
 	case MODE_SENSE:
 	case MODE_SENSE_10:
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 	case MAINTENANCE_IN:
 	case PERSISTENT_RESERVE_IN:
 	case SECURITY_PROTOCOL_IN:
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index afd2a1b..046fe12 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -151,7 +151,7 @@ enum scsi_timeouts {
 #define VERIFY_16	      0x8f
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16	      0x93
-#define SERVICE_ACTION_IN     0x9e
+#define SERVICE_ACTION_IN_16  0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
 #define SAI_GET_LBA_STATUS    0x12
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index db6c935..079bd10 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -94,7 +94,7 @@
 		scsi_opcode_name(WRITE_16),			\
 		scsi_opcode_name(VERIFY_16),			\
 		scsi_opcode_name(WRITE_SAME_16),		\
-		scsi_opcode_name(SERVICE_ACTION_IN),		\
+		scsi_opcode_name(SERVICE_ACTION_IN_16),		\
 		scsi_opcode_name(SAI_READ_CAPACITY_16),		\
 		scsi_opcode_name(SAI_GET_LBA_STATUS),		\
 		scsi_opcode_name(MI_REPORT_TARGET_PGS),		\
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index da9cc0f..4540344 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -96,7 +96,7 @@
 		scsi_opcode_name(WRITE_16),			\
 		scsi_opcode_name(VERIFY_16),			\
 		scsi_opcode_name(WRITE_SAME_16),		\
-		scsi_opcode_name(SERVICE_ACTION_IN),		\
+		scsi_opcode_name(SERVICE_ACTION_IN_16),		\
 		scsi_opcode_name(SAI_READ_CAPACITY_16),		\
 		scsi_opcode_name(SAI_GET_LBA_STATUS),		\
 		scsi_opcode_name(MI_REPORT_TARGET_PGS),		\
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index eda326f..c699f47 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -107,7 +107,7 @@ typedef unsigned int u32;
 #define VERIFY_16			0x8f
 #define SYNCHRONIZE_CACHE_16		0x91
 #define WRITE_SAME_16			0x93
-#define SERVICE_ACTION_IN		0x9e
+#define SERVICE_ACTION_IN_16		0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16		0x10
 #define SAI_GET_LBA_STATUS		0x12
@@ -393,7 +393,7 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_rw16(p, cdb, len);
 	case UNMAP:
 		return scsi_trace_unmap(p, cdb, len);
-	case SERVICE_ACTION_IN:
+	case SERVICE_ACTION_IN_16:
 		return scsi_trace_service_action_in(p, cdb, len);
 	case VARIABLE_LENGTH_CMD:
 		return scsi_trace_varlen(p, cdb, len);
-- 
1.8.5.2

