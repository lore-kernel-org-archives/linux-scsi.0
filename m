From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/23] block: add a error_count field to struct request
Date: Wed, 19 Apr 2017 21:27:03 +0200
Message-ID: <20170419192708.22098-19-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934210AbdDST2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 15:28:11 -0400
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

This is for the legacy floppy and ataflop drivers that currently abuse
->errors for this purpose.  It's stashed away in a union to not grow
the struct size, the other fields are either used by modern drivers
for different purposes or the I/O scheduler before queing the I/O
to drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d8bcd51b8a47..e8006abce8b6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -175,6 +175,7 @@ struct request {
 		struct rb_node rb_node;	/* sort/lookup */
 		struct bio_vec special_vec;
 		void *completion_data;
+		int error_count; /* for legacy drivers, don't use */
 	};
 
 	/*
-- 
2.11.0
