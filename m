From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: loading scsi_debug with data integrity hits BUG_ON
Date: Wed, 19 Feb 2014 17:10:19 -0800
Message-ID: <1392858619.22195.24.camel@haakon3.risingtidesystems.com>
References: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55165 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaBTBHO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2014 20:07:14 -0500
In-Reply-To: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, kmo@daterainc.com

Hi Akinobu,

On Wed, 2014-02-19 at 22:22 +0900, Akinobu Mita wrote:
> After commit 5837c80e870b ("bio-integrity: Fix bio_integrity_verify
> segment start bug"), loading scsi_debug with data integrity enabled
> (for example modprobe scsi_debug dif=1 dix=1) starts hitting BUG_ON()
> at bio_integrity_verify():
> 
>         BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
> 
> Because bip_iter.bi_size has already been set to zero at this point
> as a result of consuming bip_iter.
> 
> I can resolve this issue by removing the BUG_ON().  But I would like
> to ask whether we should preserve an alternative assert, or not
> before submitting the patch that simply removing the line.

So commit 5837c80e870b just allowed bio_integrity_verify() to actually
process protection information for READs again, which had been broken
since v3.10 code.

The bug your hitting is specific to v3.14-rc1, and was introduced with
the following change to support immutable biovecs:

commit d57a5f7c6605f15f3b5134837e68b448a7cea88e
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Sat Nov 23 17:20:16 2013 -0800

    bio-integrity: Convert to bvec_iter

Given that there is no (easy) way to ascertain what the original value
of bio_integrity->bip_iter.bi_size was post bio_integrity_advance(),
dropping this BUG_ON() probably makes the most sense.

MKP + Jens, care to ACK + pickup..?

--nab

>From 847ab029fe0d5ed9b54a1f1507c46025f6c3f9e0 Mon Sep 17 00:00:00 2001
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
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 fs/bio-integrity.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 0bad24d..47ed160 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -476,7 +476,6 @@ static int bio_integrity_verify(struct bio *bio)
 		sector += sectors;
 		prot_buf += sectors * bi->tuple_size;
 		total += sectors * bi->tuple_size;
-		BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
 
 		kunmap_atomic(kaddr);
 	}
-- 
1.7.10.4

