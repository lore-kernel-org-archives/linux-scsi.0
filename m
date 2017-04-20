From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/23] block: add a error_count field to struct request
Date: Thu, 20 Apr 2017 16:03:11 +0200
Message-ID: <20170420140316.6546-19-hch@lst.de>
References: <20170420140316.6546-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170420140316.6546-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

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
index e2064ed3c703..a3dcee624de3 100644
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
