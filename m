From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/1] random: export add_disk_randomness
Date: Fri, 25 Apr 2014 00:36:37 -0700
Message-ID: <20140425073637.GB2143@infradead.org>
References: <20140425073610.GA2143@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140425073610.GA2143@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This will be needed for pending changes to the scsi midlayer that now calls
lower level block APIs, as well as any blk-mq driver that wants to contribute
to the random pool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6b75713..0a19d86 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -902,6 +902,7 @@ void add_disk_randomness(struct gendisk *disk)
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
 	trace_add_disk_randomness(disk_devt(disk), ENTROPY_BITS(&input_pool));
 }
+EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
 
 /*********************************************************************
-- 
1.7.10.4
