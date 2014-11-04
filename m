From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/10] scsi: log request tag for scmd_printk()
Date: Tue,  4 Nov 2014 09:06:41 +0100
Message-ID: <1415088409-46590-3-git-send-email-hare@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaKDIGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:06:55 -0500
In-Reply-To: <1415088409-46590-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The request tag provides a concise identification of a SCSI
command, so we should be printing that out for scmd_printk().

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_logging.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 4a76796..dca45fe 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -109,6 +109,10 @@ int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
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

