From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] libata: fixup oops in ata_eh_link_report()
Date: Mon, 19 Jan 2015 16:55:38 +0100
Message-ID: <1421682938-14073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbbASPzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 10:55:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Hannes Reinecke <hare@suse.de>

We should only try to evaluate the cdb if this is an ATAPI
device, for any other device the 'cdb' field and the cdb_len
has no meaning.

Fixes: cbba5b0ee4c6c2fc8b78a21d0900099d480cf2e9
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tejun Heo <tj@kernel.org>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/ata/libata-eh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 9179f11..665fd2b 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2481,8 +2481,6 @@ static void ata_eh_link_report(struct ata_link *link)
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 		struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
-		const u8 *cdb = qc->cdb;
-		size_t cdb_len = qc->dev->cdb_len;
 		char data_buf[20] = "";
 		char cdb_buf[70] = "";
 
@@ -2510,6 +2508,9 @@ static void ata_eh_link_report(struct ata_link *link)
 		}
 
 		if (ata_is_atapi(qc->tf.protocol)) {
+			const u8 *cdb = qc->cdb;
+			size_t cdb_len = qc->dev->cdb_len;
+
 			if (qc->scsicmd) {
 				cdb = qc->scsicmd->cmnd;
 				cdb_len = qc->scsicmd->cmd_len;
-- 
1.8.5.2

