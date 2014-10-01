From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/24] scsi: use shost argument in scsi_eh_prt_fail_stats
Date: Wed,  1 Oct 2014 08:22:59 +0200
Message-ID: <1412144580-72880-24-git-send-email-hare@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaJAGXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 02:23:09 -0400
In-Reply-To: <1412144580-72880-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

The EH statistics are per host, so we should be using
shost_printk() here.

Suggested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7e1e190..a41ef5b 100644
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

