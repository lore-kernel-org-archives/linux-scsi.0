From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] fcoe: Reduce max_sectors to 1024
Date: Wed,  9 Jul 2014 08:16:21 +0200
Message-ID: <1404886581-3218-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaGIGQ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 02:16:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Vasu Dev <vasu.dev@linux.intel.com>

The DDP offload on ixgbe is only capable of handling requests up
to 1024 sectors. So we should be exposing this to avoid spurious
messages about 'not enough user buffers'.

Cc: Vasu Dev <vasu.dev@linux.intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 00ee0ed..602bcc9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -287,7 +287,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = SG_ALL,
-	.max_sectors = 0xffff,
+	.max_sectors = 1024,
 };
 
 /**
-- 
1.7.12.4

