From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 1/3] scsi: Fix wrong additional sense length in descriptor format
Date: Sun, 12 Jul 2015 13:37:01 +0300
Message-ID: <1436697423-20611-2-git-send-email-sagig@mellanox.com>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

The sense header additional sense length should be the accumulated
size of all the descriptors. Information descriptor size is 12 bytes.
When setting the additional sense length we should add 0xc instead of
0xa.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/scsi/scsi_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 8cfb7ee..fbf137b 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -260,7 +260,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
 		len = buf[7];
 		ucp = (char *)scsi_sense_desc_find(buf, len + 8, 0);
 		if (!ucp) {
-			buf[7] = len + 0xa;
+			buf[7] = len + 0xc;
 			ucp = buf + 8 + len;
 		}
 		ucp[0] = 0;
-- 
1.8.4.3
