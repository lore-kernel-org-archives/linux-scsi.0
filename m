From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] scsi: always zero sshdr in scsi_normalize_sense
Date: Tue, 14 Feb 2017 20:15:55 +0100
Message-ID: <20170214191600.17480-2-hch@lst.de>
References: <20170214191600.17480-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170214191600.17480-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This gives us a clear state even if a command didn't return sense data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index b1383a71400e..a75673bb82b3 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -137,11 +137,11 @@ EXPORT_SYMBOL(int_to_scsilun);
 bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 			  struct scsi_sense_hdr *sshdr)
 {
+	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
+
 	if (!sense_buffer || !sb_len)
 		return false;
 
-	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
-
 	sshdr->response_code = (sense_buffer[0] & 0x7f);
 
 	if (!scsi_sense_valid(sshdr))
-- 
2.11.0
