From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/9] block: update chunk_sectors in blk_stack_limits()
Date: Mon,  4 Apr 2016 12:00:13 +0200
Message-ID: <1459764020-126038-3-git-send-email-hare@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbcDDKAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 06:00:46 -0400
In-Reply-To: <1459764020-126038-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-settings.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c7bb666..29fa900 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -630,6 +630,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			t->discard_granularity;
 	}
 
+	if (b->chunk_sectors)
+		t->chunk_sectors = max(t->chunk_sectors, b->chunk_sectors);
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
-- 
1.8.5.6

