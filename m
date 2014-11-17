From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/10] scsi: log request tag for scmd_printk()
Date: Mon, 17 Nov 2014 14:25:22 +0100
Message-ID: <1416230728-66425-5-git-send-email-hare@suse.de>
References: <1416230728-66425-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaKQNZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 08:25:32 -0500
In-Reply-To: <1416230728-66425-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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
1.8.5.2

