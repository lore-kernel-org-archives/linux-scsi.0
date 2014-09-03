From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/20] libata: use __scsi_print_command()
Date: Wed,  3 Sep 2014 12:06:10 +0200
Message-ID: <1409738775-80876-16-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbaICKGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:31 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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

