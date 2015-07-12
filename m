From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 3/3] target: Return descriptor format sense data
Date: Sun, 12 Jul 2015 13:37:03 +0300
Message-ID: <1436697423-20611-4-git-send-email-sagig@mellanox.com>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:35845 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbbGLKhq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 06:37:46 -0400
In-Reply-To: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Fixed size sense data information field is only 32 bits which
means the sector (64 bits) information will be truncated.

Move to descriptor format sense data to correctly report full
sector information.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_spc.c       | 11 ++++++++---
 drivers/target/target_core_transport.c |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c43dcbf..2899675 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -761,7 +761,12 @@ static int spc_modesense_control(struct se_cmd *cmd, u8 pc, u8 *p)
 	if (pc == 1)
 		goto out;
 
-	p[2] = 2;
+	/*
+	 * GLTSD:   No implicit save of log parameters
+	 * D_SENSE: Descriptor format sense data
+	 */
+	p[2] = (1 << 1 | 1 << 2);
+
 	/*
 	 * From spc4r23, 7.4.7 Control mode page
 	 *
@@ -1158,10 +1163,10 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))
-		scsi_build_sense_buffer(0, buf, UNIT_ATTENTION,
+		scsi_build_sense_buffer(1, buf, UNIT_ATTENTION,
 					ua_asc, ua_ascq);
 	else
-		scsi_build_sense_buffer(0, buf, NO_SENSE, 0x0, 0x0);
+		scsi_build_sense_buffer(1, buf, NO_SENSE, 0x0, 0x0);
 
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7fb031b..935296c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2754,7 +2754,7 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		ascq = si->ascq;
 	}
 
-	scsi_build_sense_buffer(0, buffer, si->key, asc, ascq);
+	scsi_build_sense_buffer(1, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
 		return scsi_set_sense_information(buffer,
 						  cmd->scsi_sense_length,
-- 
1.8.4.3

