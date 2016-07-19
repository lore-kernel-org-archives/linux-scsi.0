From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] sd: enable single-threaded I/O submission for zoned devices
Date: Tue, 19 Jul 2016 16:02:57 +0200
Message-ID: <1468936978-9124-3-git-send-email-hare@suse.de>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbcGSODF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 10:03:05 -0400
In-Reply-To: <1468936978-9124-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel-redhat.com@suse.de, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>

zoned devices require single-thread I/O submission to guarantee
sequential I/O, so enable the block layer flag for it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4b704b0..44960fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2154,6 +2154,7 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 				logical_to_sectors(sdkp->device, zone_len));
 	sd_config_discard(sdkp, SD_ZBC_RESET_WP);
+	queue_flag_set_unlocked(QUEUE_FLAG_SINGLE, sdkp->disk->queue);
 
 	sd_zbc_setup(sdkp, buffer, SD_BUF_SIZE);
 }
-- 
1.8.5.6

