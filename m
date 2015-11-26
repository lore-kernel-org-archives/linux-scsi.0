From: Hannes Reinecke <hare@suse.de>
Subject: QUEUE_FLAG_NO_SG_MERGE and non-block-mq
Date: Thu, 26 Nov 2015 09:13:25 +0100
Message-ID: <5656BF25.3000407@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Ming Lei <ming.lei@canonical.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

while investigating the crash in scsi_lib.c I found a rather curious
behaviour for QUEUE_FLAG_NO_SG_MERGE.

While the flag is evaluated in blk_recalc_rq_segments and
blk_recount_segments (resulting in nr_phys_segments being
computed based on that flag) it is completely ignored
during blk_rq_map_sg() or the actual merging itself.

This typically shouldn't be an issue, seeing that with
QUEUE_FLAG_NO_SG_MERGE nr_phys_segments will always be
larger than the actual segment count.

However, it still makes me wonder:
What is the point of having a QUEUE_FLAG_NO_SG_MERGE
which doesn't work as advertised?
Or, to be precise, which only works for blk-mq?
Should we make it work for non-block-mq, too?


Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
