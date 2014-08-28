From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/22] libata: use __scsi_print_command()
Date: Thu, 28 Aug 2014 19:33:30 +0200
Message-ID: <1409247216-76074-17-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaH1Rdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:43 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

libata already uses an internal buffer, so we should be using
__scsi_print_command() here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index dad83df..acf06ba 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2509,15 +2509,11 @@ static void ata_eh_link_report(struct ata_link *link)
 
 		if (ata_is_atapi(qc->tf.protocol)) {
 			if (qc->scsicmd)
-				scsi_print_command(qc->scsicmd);
+				__scsi_print_command(qc->scsicmd->cmnd,
+						     cdb_buf, sizeof(cdb_buf));
 			else
-				snprintf(cdb_buf, sizeof(cdb_buf),
-				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
-				 cdb[0], cdb[1], cdb[2], cdb[3],
-				 cdb[4], cdb[5], cdb[6], cdb[7],
-				 cdb[8], cdb[9], cdb[10], cdb[11],
-				 cdb[12], cdb[13], cdb[14], cdb[15]);
+				__scsi_print_command((unsigned char *)cdb,
+						     cdb_buf, sizeof(cdb_buf));
 		} else {
 			const char *descr = ata_get_cmd_descript(cmd->command);
 			if (descr)
-- 
1.8.5.2

