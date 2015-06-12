From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: retry MODE SENSE on unit attention
Date: Fri, 12 Jun 2015 16:12:48 +0200
Message-ID: <1434118368-100564-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbbFLOMv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 10:12:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

The 'sd' driver is calling scsi_mode_sense() to figure out
internal details. But scsi_mode_sense() never checks for
any pending unit attentions, so we're getting annoying error
messages like:

MODE SENSE: unimplemented page/subpage: 0x00/0x00

and a possible wrong decision for device cache handling.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f04be65..b66652d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2423,7 +2423,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result;
+	int result, retry_count = retries;
 	struct scsi_sense_hdr my_sshdr;
 
 	memset(data, 0, sizeof(*data));
@@ -2502,6 +2502,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			data->block_descriptor_length = buffer[3];
 		}
 		data->header_length = header_length;
+	} else if ((status_byte(result) == CHECK_CONDITION) &&
+		   scsi_sense_valid(sshdr) &&
+		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
+		retry_count--;
+		goto retry;
 	}
 
 	return result;
-- 
1.8.5.2

