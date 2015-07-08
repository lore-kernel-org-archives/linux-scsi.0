From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v4 4/5] target: Use scsi helpers to build the sense data correctly
Date: Wed,  8 Jul 2015 17:58:53 +0300
Message-ID: <1436367534-15995-5-git-send-email-sagig@mellanox.com>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Instead of open coding the sense buffer construction, use
scsi scsi_build_sense_buffer() and scsi_set_sense_information()
helpers which moved to scsi_common.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_spc.c       | 31 +++++--------------------------
 drivers/target/target_core_transport.c | 21 ++++-----------------
 2 files changed, 9 insertions(+), 43 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index b074443..c43dcbf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1157,32 +1157,11 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	if (!rbuf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq)) {
-		/*
-		 * CURRENT ERROR, UNIT ATTENTION
-		 */
-		buf[0] = 0x70;
-		buf[SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
-
-		/*
-		 * The Additional Sense Code (ASC) from the UNIT ATTENTION
-		 */
-		buf[SPC_ASC_KEY_OFFSET] = ua_asc;
-		buf[SPC_ASCQ_KEY_OFFSET] = ua_ascq;
-		buf[7] = 0x0A;
-	} else {
-		/*
-		 * CURRENT ERROR, NO SENSE
-		 */
-		buf[0] = 0x70;
-		buf[SPC_SENSE_KEY_OFFSET] = NO_SENSE;
-
-		/*
-		 * NO ADDITIONAL SENSE INFORMATION
-		 */
-		buf[SPC_ASC_KEY_OFFSET] = 0x00;
-		buf[7] = 0x0A;
-	}
+	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))
+		scsi_build_sense_buffer(0, buf, UNIT_ATTENTION,
+					ua_asc, ua_ascq);
+	else
+		scsi_build_sense_buffer(0, buf, NO_SENSE, 0x0, 0x0);
 
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 31373f3..923e69d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -38,6 +38,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <scsi/scsi_proto.h>
+#include <scsi/scsi_common.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
@@ -2620,19 +2621,6 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);
 
-static
-void transport_err_sector_info(unsigned char *buffer, sector_t bad_sector)
-{
-	/* Place failed LBA in sense data information descriptor 0. */
-	buffer[SPC_ADD_SENSE_LEN_OFFSET] = 0xc;
-	buffer[SPC_DESC_TYPE_OFFSET] = 0; /* Information */
-	buffer[SPC_ADDITIONAL_DESC_LEN_OFFSET] = 0xa;
-	buffer[SPC_VALIDITY_OFFSET] = 0x80;
-
-	/* Descriptor Information: failing sector */
-	put_unaligned_be64(bad_sector, &buffer[12]);
-}
-
 struct sense_info {
 	u8 key;
 	u8 asc;
@@ -2759,7 +2747,6 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		si = &sense_info_table[(__force int)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
-	buffer[SPC_SENSE_KEY_OFFSET] = si->key;
 	if (reason == TCM_CHECK_CONDITION_UNIT_ATTENTION) {
 		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
 		WARN_ON_ONCE(asc == 0);
@@ -2771,10 +2758,10 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		asc = si->asc;
 		ascq = si->ascq;
 	}
-	buffer[SPC_ASC_KEY_OFFSET] = asc;
-	buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
+
+	scsi_build_sense_buffer(0, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
-		transport_err_sector_info(cmd->sense_buffer, cmd->bad_sector);
+		scsi_set_sense_information(buffer, cmd->bad_sector);
 }
 
 int
-- 
1.8.4.3
