From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 3/4] target: Return descriptor format sense data in case the LU spans 64bit sectors
Date: Thu, 16 Jul 2015 10:28:05 +0300
Message-ID: <1437031685-22403-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:38180 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752346AbbGPH20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2015 03:28:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

In case a LU spans 64bit sectors, fixed size sense data information
field is only 32 bits which means the sector information will be truncated.

Thus, if the LU spans 64bit sectors, use descriptor format sense data to
correctly report sector information.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_hba.c       |  5 +++++
 drivers/target/target_core_spc.c       | 12 +++++++++---
 drivers/target/target_core_transport.c |  3 ++-
 include/target/target_core_backend.h   |  2 ++
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 62ea4e8..d746a3a 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -176,3 +176,8 @@ core_delete_hba(struct se_hba *hba)
 	kfree(hba);
 	return 0;
 }
+
+bool target_sense_desc_format(struct se_device *dev)
+{
+	return dev->transport->get_blocks(dev) > U32_MAX;
+}
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c43dcbf..b949d33 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -761,7 +761,12 @@ static int spc_modesense_control(struct se_cmd *cmd, u8 pc, u8 *p)
 	if (pc == 1)
 		goto out;
 
-	p[2] = 2;
+	/* GLTSD: No implicit save of log parameters */
+	p[2] = (1 << 1);
+	if (target_sense_desc_format(dev))
+		/* D_SENSE: Descriptor format sense data for 64bit sectors */
+		p[2] |= (1 << 2);
+
 	/*
 	 * From spc4r23, 7.4.7 Control mode page
 	 *
@@ -1144,6 +1149,7 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	unsigned char *rbuf;
 	u8 ua_asc = 0, ua_ascq = 0;
 	unsigned char buf[SE_SENSE_BUF];
+	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
 	memset(buf, 0, SE_SENSE_BUF);
 
@@ -1158,10 +1164,10 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))
-		scsi_build_sense_buffer(0, buf, UNIT_ATTENTION,
+		scsi_build_sense_buffer(desc_format, buf, UNIT_ATTENTION,
 					ua_asc, ua_ascq);
 	else
-		scsi_build_sense_buffer(0, buf, NO_SENSE, 0x0, 0x0);
+		scsi_build_sense_buffer(desc_format, buf, NO_SENSE, 0x0, 0x0);
 
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7fb031b..98155db 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2735,6 +2735,7 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	u8 *buffer = cmd->sense_buffer;
 	int r = (__force int)reason;
 	u8 asc, ascq;
+	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
 	if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
 		si = &sense_info_table[r];
@@ -2754,7 +2755,7 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		ascq = si->ascq;
 	}
 
-	scsi_build_sense_buffer(0, buffer, si->key, asc, ascq);
+	scsi_build_sense_buffer(desc_format, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
 		return scsi_set_sense_information(buffer,
 						  cmd->scsi_sense_length,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1e5c8f9..56cf8e4 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -93,4 +93,6 @@ bool	target_lun_is_rdonly(struct se_cmd *);
 sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 	sense_reason_t (*exec_cmd)(struct se_cmd *cmd));
 
+bool target_sense_desc_format(struct se_device *dev);
+
 #endif /* TARGET_CORE_BACKEND_H */
-- 
1.8.4.3

