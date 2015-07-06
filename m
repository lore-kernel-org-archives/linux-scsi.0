From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v3 4/5] target: Use scsi helpers to build the sense data correctly
Date: Mon,  6 Jul 2015 16:15:07 +0300
Message-ID: <1436188508-1539-5-git-send-email-sagig@mellanox.com>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:53564 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755264AbbGFNP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 09:15:58 -0400
In-Reply-To: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Instead of open coding the sense buffer construction, use
scsi scsi_build_sense_buffer() and scsi_set_sense_information()
helpers which moved to scsi_common.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_spc.c       | 31 +++++--------------------------
 drivers/target/target_core_transport.c | 20 +++-----------------
 include/target/target_core_base.h      |  1 +
 3 files changed, 9 insertions(+), 43 deletions(-)

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
index fb134d9..0181f8b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2620,19 +2620,6 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
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
@@ -2759,7 +2746,6 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		si = &sense_info_table[(__force int)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
-	buffer[SPC_SENSE_KEY_OFFSET] = si->key;
 	if (r == (__force int)TCM_CHECK_CONDITION_UNIT_ATTENTION) {
 		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
 		WARN_ON_ONCE(asc == 0);
@@ -2771,10 +2757,10 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
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
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a681644..47dea1b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -7,6 +7,7 @@
 #include <linux/blkdev.h>
 #include <linux/percpu_ida.h>
 #include <linux/t10-pi.h>
+#include <scsi/scsi_common.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 
-- 
1.8.4.3

