From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v4 5/5] target: Return ABORTED_COMMAND sense key for PI errors
Date: Wed,  8 Jul 2015 17:58:54 +0300
Message-ID: <1436367534-15995-6-git-send-email-sagig@mellanox.com>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:57010 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933814AbbGHO7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 10:59:45 -0400
In-Reply-To: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

PI errors were reported with ILLEGAL_REQUEST sense key but
there was actually no problem with the request. Target
detected PI errors should be reported with aborted command
sense key.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 923e69d..1847fdc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2705,19 +2705,19 @@ static const struct sense_info sense_info_table[] = {
 		.ascq = 0x00,
 	},
 	[TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED] = {
-		.key = ILLEGAL_REQUEST,
+		.key = ABORTED_COMMAND,
 		.asc = 0x10,
 		.ascq = 0x01, /* LOGICAL BLOCK GUARD CHECK FAILED */
 		.add_sector_info = true,
 	},
 	[TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED] = {
-		.key = ILLEGAL_REQUEST,
+		.key = ABORTED_COMMAND,
 		.asc = 0x10,
 		.ascq = 0x02, /* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
 		.add_sector_info = true,
 	},
 	[TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED] = {
-		.key = ILLEGAL_REQUEST,
+		.key = ABORTED_COMMAND,
 		.asc = 0x10,
 		.ascq = 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
 		.add_sector_info = true,
-- 
1.8.4.3

