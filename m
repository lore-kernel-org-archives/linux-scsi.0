From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/23] scsi: use shost argument in scsi_eh_prt_fail_stats
Date: Tue, 30 Sep 2014 13:50:51 +0200
Message-ID: <1412077852-40893-23-git-send-email-hare@suse.de>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaI3LvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:51:07 -0400
In-Reply-To: <1412077852-40893-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

The EH statistics are per host, so we should be using
shost_printk() here.

Suggested-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4d3f55c..9daaf2a 100644
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

