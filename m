From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: loading scsi_debug with data integrity hits BUG_ON
Date: Thu, 20 Feb 2014 11:20:04 -0800
Message-ID: <1392924004.29525.19.camel@haakon3.risingtidesystems.com>
References: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
	 <1392858619.22195.24.camel@haakon3.risingtidesystems.com>
	 <CAC5umyhLpEPxYCYNOP-=Zt_-RbTd1zory2RG+x=oCCWp4qNewg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58948 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaBTTQz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 14:16:55 -0500
In-Reply-To: <CAC5umyhLpEPxYCYNOP-=Zt_-RbTd1zory2RG+x=oCCWp4qNewg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, kmo@daterainc.com

On Thu, 2014-02-20 at 22:44 +0900, Akinobu Mita wrote:
> Thanks for the patch.  I have just one nitpicking.
> 
> > diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> > index 0bad24d..47ed160 100644
> > --- a/fs/bio-integrity.c
> > +++ b/fs/bio-integrity.c
> > @@ -476,7 +476,6 @@ static int bio_integrity_verify(struct bio *bio)
> >                 sector += sectors;
> >                 prot_buf += sectors * bi->tuple_size;
> >                 total += sectors * bi->tuple_size;
> > -               BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
> 
> The variable 'total' is only used for the BUG_ON.  So it can be removed.

Duh, yes of course..

MKP + Jens, any concerns wrt dropping this BUG_ON for v3.14-rc code..?

--nab

