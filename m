From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: loading scsi_debug with data integrity hits BUG_ON
Date: Mon, 24 Feb 2014 14:15:42 -0800
Message-ID: <CAFR8uef7u668JPUNzVcq-0Zpx8VnZpByDKXO0r+e18iXUzpMyw@mail.gmail.com>
References: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
	<1392858619.22195.24.camel@haakon3.risingtidesystems.com>
	<yq1wqgpk325.fsf@sermon.lab.mkp.net>
	<1392924492.29525.22.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51208 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaBXWPn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2014 17:15:43 -0500
Received: by mail-pd0-f173.google.com with SMTP id z10so1680573pdj.32
        for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2014 14:15:42 -0800 (PST)
In-Reply-To: <1392924492.29525.22.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Kent Overstreet <kmo@daterainc.com>

NAB,

On Thu, Feb 20, 2014 at 11:28 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Thu, 2014-02-20 at 14:16 -0500, Martin K. Petersen wrote:
>> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
>>
>> nab> Given that there is no (easy) way to ascertain what the original
>> nab> value of bio_integrity->bip_iter.bi_size was post
>> nab> bio_integrity_advance(), dropping this BUG_ON() probably makes the
>> nab> most sense.
>>
>> nab> MKP + Jens, care to ACK + pickup..?
>>
>> Please remove total as suggested by Akinobu.
>>
>> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
>>
>
> Thanks.  Here's an updated patch for Jen's to pickup.
>
> --nab
>
> From 6bd5636cd46fe8e11de9bdecc26acac14a494f18 Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Thu, 20 Feb 2014 00:52:01 +0000
> Subject: [PATCH] bio-integrity: Drop bio_integrity_verify BUG_ON in post
>  bip->bip_iter world
>
> Given that bip->bip_iter.bi_size is decremented after bio_advance() ->
> bio_integrity_advance() is called, the BUG_ON() in bio_integrity_verify()
> ends up tripping in v3.14-rc1 code with the advent of immutable biovecs
> in:
>
> commit d57a5f7c6605f15f3b5134837e68b448a7cea88e
> Author: Kent Overstreet <kmo@daterainc.com>
> Date:   Sat Nov 23 17:20:16 2013 -0800
>
>     bio-integrity: Convert to bvec_iter
>
> Given that there is no easy way to ascertain the original bi_size
> value, go ahead and drop this BUG_ON().
>
> Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  fs/bio-integrity.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index 0bad24d..76e0116 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -449,11 +449,10 @@ static int bio_integrity_verify(struct bio *bio)
>         struct blk_integrity_exchg bix;
>         struct bio_vec *bv;
>         sector_t sector = bio->bi_integrity->bip_iter.bi_sector;
> -       unsigned int sectors, total, ret;
> +       unsigned int sectors, ret = 0;
>         void *prot_buf = bio->bi_integrity->bip_buf;
>         int i;
>
> -       ret = total = 0;


Here you removed "ret = 0" as well. So if bio_for_each_segment_all()
is not entered, then we return junk from bio_integrity_verify().

Regards,
Muthu


>         bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
>         bix.sector_size = bi->sector_size;
>
> @@ -475,8 +474,6 @@ static int bio_integrity_verify(struct bio *bio)
>                 sectors = bv->bv_len / bi->sector_size;
>                 sector += sectors;
>                 prot_buf += sectors * bi->tuple_size;
> -               total += sectors * bi->tuple_size;
> -               BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
>
>                 kunmap_atomic(kaddr);
>         }
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
