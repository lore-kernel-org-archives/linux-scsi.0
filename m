From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/9] scsi: log request tag for scmd_printk()
Date: Thu,  8 Jan 2015 07:43:43 +0100
Message-ID: <1420699430-9492-3-git-send-email-hare@suse.de>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbbAHGoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 01:44:13 -0500
In-Reply-To: <1420699430-9492-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The request tag provides a concise identification of a SCSI
command, so we should be printing that out for scmd_printk().

Suggested-by: Christoph Hellwig <hch@lst.de>
Tested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_logging.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 09d65de..4d20132 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -114,6 +114,10 @@ int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	if (disk)
 		off += scnprintf(logbuf + off, logbuf_len - off,
 				 "[%s] ", disk->disk_name);
+
+	if (scmd->request->tag >= 0)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "tag#%d ", scmd->request->tag);
 	va_start(args, fmt);
 	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
 	va_end(args);
-- 
1.8.4.5

