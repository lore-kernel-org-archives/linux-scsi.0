From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/27] scsi: use shost argument in scsi_eh_prt_fail_stats
Date: Fri, 24 Oct 2014 14:27:03 +0200
Message-ID: <1414153627-2863-24-git-send-email-hare@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbaJXM1T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2014 08:27:19 -0400
In-Reply-To: <1414153627-2863-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The EH statistics are per host, so we should be using
shost_printk() here.

Suggested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d159f3f..5f2b40a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -355,7 +355,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 
 		if (cmd_cancel || cmd_failed) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				sdev_printk(KERN_INFO, sdev,
+				shost_printk(KERN_INFO, shost,
 					    "%s: cmds failed: %d, cancel: %d\n",
 					    __func__, cmd_failed,
 					    cmd_cancel));
-- 
1.8.5.2

