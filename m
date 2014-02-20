From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: loading scsi_debug with data integrity hits BUG_ON
Date: Thu, 20 Feb 2014 11:28:12 -0800
Message-ID: <1392924492.29525.22.camel@haakon3.risingtidesystems.com>
References: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
	 <1392858619.22195.24.camel@haakon3.risingtidesystems.com>
	 <yq1wqgpk325.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56211 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaBTTZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 14:25:03 -0500
In-Reply-To: <yq1wqgpk325.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, kmo@daterainc.com

On Thu, 2014-02-20 at 14:16 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> nab> Given that there is no (easy) way to ascertain what the original
> nab> value of bio_integrity->bip_iter.bi_size was post
> nab> bio_integrity_advance(), dropping this BUG_ON() probably makes the
> nab> most sense.
> 
> nab> MKP + Jens, care to ACK + pickup..?
> 
> Please remove total as suggested by Akinobu.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

Thanks.  Here's an updated patch for Jen's to pickup.

--nab

>From 6bd5636cd46fe8e11de9bdecc26acac14a494f18 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 20 Feb 2014 00:52:01 +0000
Subject: [PATCH] bio-integrity: Drop bio_integrity_verify BUG_ON in post
 bip->bip_iter world

Given that bip->bip_iter.bi_size is decremented after bio_advance() ->
bio_integrity_advance() is called, the BUG_ON() in bio_integrity_verify()
ends up tripping in v3.14-rc1 code with the advent of immutable biovecs
in:

commit d57a5f7c6605f15f3b5134837e68b448a7cea88e
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Sat Nov 23 17:20:16 2013 -0800

    bio-integrity: Convert to bvec_iter

Given that there is no easy way to ascertain the original bi_size
value, go ahead and drop this BUG_ON().

Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 fs/bio-integrity.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 0bad24d..76e0116 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -449,11 +449,10 @@ static int bio_integrity_verify(struct bio *bio)
 	struct blk_integrity_exchg bix;
 	struct bio_vec *bv;
 	sector_t sector = bio->bi_integrity->bip_iter.bi_sector;
-	unsigned int sectors, total, ret;
+	unsigned int sectors, ret = 0;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 	int i;
 
-	ret = total = 0;
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
@@ -475,8 +474,6 @@ static int bio_integrity_verify(struct bio *bio)
 		sectors = bv->bv_len / bi->sector_size;
 		sector += sectors;
 		prot_buf += sectors * bi->tuple_size;
-		total += sectors * bi->tuple_size;
-		BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
 
 		kunmap_atomic(kaddr);
 	}
-- 
1.7.10.4

