From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/9] libata: use __scsi_format_command()
Date: Thu,  8 Jan 2015 07:43:45 +0100
Message-ID: <1420699430-9492-5-git-send-email-hare@suse.de>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbbAHGoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 01:44:13 -0500
In-Reply-To: <1420699430-9492-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

libata already uses an internal buffer, so we should be using
__scsi_format_command() here.

Tested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 3dbec89..9179f11 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2482,6 +2482,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 		struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
 		const u8 *cdb = qc->cdb;
+		size_t cdb_len = qc->dev->cdb_len;
 		char data_buf[20] = "";
 		char cdb_buf[70] = "";
 
@@ -2509,16 +2510,12 @@ static void ata_eh_link_report(struct ata_link *link)
 		}
 
 		if (ata_is_atapi(qc->tf.protocol)) {
-			if (qc->scsicmd)
-				scsi_print_command(qc->scsicmd);
-			else
-				snprintf(cdb_buf, sizeof(cdb_buf),
-				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
-				 cdb[0], cdb[1], cdb[2], cdb[3],
-				 cdb[4], cdb[5], cdb[6], cdb[7],
-				 cdb[8], cdb[9], cdb[10], cdb[11],
-				 cdb[12], cdb[13], cdb[14], cdb[15]);
+			if (qc->scsicmd) {
+				cdb = qc->scsicmd->cmnd;
+				cdb_len = qc->scsicmd->cmd_len;
+			}
+			__scsi_format_command(cdb_buf, sizeof(cdb_buf),
+					      cdb, cdb_len);
 		} else {
 			const char *descr = ata_get_cmd_descript(cmd->command);
 			if (descr)
-- 
1.8.4.5

