From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: loading scsi_debug with data integrity hits BUG_ON
Date: Thu, 20 Feb 2014 22:44:21 +0900
Message-ID: <CAC5umyhLpEPxYCYNOP-=Zt_-RbTd1zory2RG+x=oCCWp4qNewg@mail.gmail.com>
References: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
	<1392858619.22195.24.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46092 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaBTNoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 08:44:23 -0500
Received: by mail-ob0-f171.google.com with SMTP id vb8so1702976obc.30
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 05:44:22 -0800 (PST)
In-Reply-To: <1392858619.22195.24.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, kmo@daterainc.com

Thanks for the patch.  I have just one nitpicking.

> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index 0bad24d..47ed160 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -476,7 +476,6 @@ static int bio_integrity_verify(struct bio *bio)
>                 sector += sectors;
>                 prot_buf += sectors * bi->tuple_size;
>                 total += sectors * bi->tuple_size;
> -               BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);

The variable 'total' is only used for the BUG_ON.  So it can be removed.
