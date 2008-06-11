From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4 of 7] block: bio data integrity support
Date: Wed, 11 Jun 2008 00:05:29 -0400
Message-ID: <yq1r6b4mx9y.fsf@sermon.lab.mkp.net>
References: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net>
	<x491w359fne.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:59354 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbYFKEGM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2008 00:06:12 -0400
In-Reply-To: <x491w359fne.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's message of "Tue\, 10 Jun 2008 16\:52\:20 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

>> + memset(bip, 0, sizeof(*bip)); 
>> + idx = 0;

Jeff> That assignment isn't necessary.

Zap!


Jeff>         nr_sectors = (len + bi->tag_size - 1) / bi->tag_size;

Jeff> why not simply use DIV_ROUND_UP?

Fixed.


Jeff> set_tag and get_tag are almost identical.  Any chance you want
Jeff> to factor out that code?

Done.


Jeff> Hmm, up until this point you use bi to mean bio_integrity, but
Jeff> now it means blk_integrity.  Confusion will ensue.  ;)

Err, uhm.  There is no bio_integrity.  There's the bio integrity
payload which I always refer to as struct bip *bip.  And struct
blk_integrity which is always bi.  I'm also anal about using bv for
the data bio_vec and iv for the integrity bio_vec.  I can't see any
place where I'm inconsistent.


Jeff> struct blk_integrity_exchg is not yet defined in your patch set,
Jeff> so this will likely break git bisect.

bio-integrity.patch and blk-integrity.patch are artificially split up
to ease the review process.  They are not meant to be separate
changesets.


>> + buf = kzalloc(len, GFP_NOIO | q->bounce_gfp);

Jeff> Does this actually need to be zeroed?

Nope.


>> +void bio_integrity_advance(struct bio *bio, unsigned int
> +void bio_integrity_trim(struct bio *bio, unsigned int offset, unsigned int sectors)

Jeff> The above two loops look pretty much the same to me.  Can you
Jeff> factor that out to a helper?

I've created helpers for marking head and tail of the ivec.

-- 
Martin K. Petersen	Oracle Linux Engineering
