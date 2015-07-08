From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] scsi: Fix sense information setting in fixed sized format
Date: Wed,  8 Jul 2015 18:00:03 +0300
Message-ID: <1436367603-16456-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:57099 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933722AbbGHPAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 11:00:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

In fixed size sense format the information field is a four byte
field.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/scsi/scsi_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 41432c1..8cfb7ee 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -270,7 +270,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
 		put_unaligned_be64(info, &ucp[4]);
 	} else if ((buf[0] & 0x7f) == 0x70) {
 		buf[0] |= 0x80;
-		put_unaligned_be64(info, &buf[3]);
+		put_unaligned_be32(info, &buf[3]);
 	}
 }
 EXPORT_SYMBOL(scsi_set_sense_information);
-- 
1.8.4.3

