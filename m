From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI errors
Date: Mon,  6 Jul 2015 16:15:08 +0300
Message-ID: <1436188508-1539-6-git-send-email-sagig@mellanox.com>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:53560 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755260AbbGFNP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 09:15:58 -0400
In-Reply-To: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

PI errors should be reported in a descriptor format sense data.
Fix that by adding a desc_format flag to struct sense_info and pass
it to scsi_build_sense_buffer() to do the right thing.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_transport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0181f8b..79bb8d1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2625,6 +2625,7 @@ struct sense_info {
 	u8 asc;
 	u8 ascq;
 	bool add_sector_info;
+	int desc_format;
 };
 
 static const struct sense_info sense_info_table[] = {
@@ -2708,18 +2709,21 @@ static const struct sense_info sense_info_table[] = {
 		.asc = 0x10,
 		.ascq = 0x01, /* LOGICAL BLOCK GUARD CHECK FAILED */
 		.add_sector_info = true,
+		.desc_format = 1,
 	},
 	[TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED] = {
 		.key = ILLEGAL_REQUEST,
 		.asc = 0x10,
 		.ascq = 0x02, /* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
 		.add_sector_info = true,
+		.desc_format = 1,
 	},
 	[TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED] = {
 		.key = ILLEGAL_REQUEST,
 		.asc = 0x10,
 		.ascq = 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
 		.add_sector_info = true,
+		.desc_format = 1,
 	},
 	[TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE] = {
 		/*
@@ -2758,7 +2762,7 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		ascq = si->ascq;
 	}
 
-	scsi_build_sense_buffer(0, buffer, si->key, asc, ascq);
+	scsi_build_sense_buffer(si->desc_format, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
 		scsi_set_sense_information(buffer, cmd->bad_sector);
 }
-- 
1.8.4.3

