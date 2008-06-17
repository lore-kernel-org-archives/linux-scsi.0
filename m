From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2 of 3] block: Block layer data integrity support
Date: Tue, 17 Jun 2008 00:54:19 -0400
Message-ID: <yq1zlpkd5l0.fsf@sermon.lab.mkp.net>
References: <patchbomb.1213589417@sermon.lab.mkp.net>
	<91ceabd365c3e718425d.1213589419@sermon.lab.mkp.net>
	<20080616192104.GV20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:35977 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYFQEy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2008 00:54:29 -0400
In-Reply-To: <20080616192104.GV20851@kernel.dk> (Jens Axboe's message of "Mon\, 16 Jun 2008 21\:21\:04 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens,

I've fixed pretty much everything you pointed out.  So unless
otherwise noted it's an ACK.

> +	if (bi->sector_size == 4096)
> +		sectors >>= 3;

Jens> This could do with a comment on why it's only 512b or 4kb.

Ok, I've fanned all occurrences of these into a helper function that
explains the "block layer" sector to hardware sector conversion.


> +	/* Allocate kernel buffer for protection data */
> +	len = sectors * blk_integrity_tuple_size(bi);
> +	buf = kmalloc(len, GFP_NOIO | q->bounce_gfp);
> +	if (unlikely(buf == NULL)) {
> +		printk(KERN_ERR "could not allocate integrity buffer\n");
> +		return -EIO;
> +	}

Jens> Is that good enough, don't you want to handle this error
Jens> condition? IOW, doesn't this allocation want mempool backing or
Jens> similar?

When I originally wrote this I had a couple of mempools that worked
well with ext2/3 because they blow everything into 4KB (or 1KB)
atoms. Due to the problems with ext2/3 modifying pages in flight I've
mostly used XFS and btrfs for development.  And they both generate a
much more varied set of bio sizes that in turn will require a whole
whack of different sized integrity pools.

I did gather quite a bit of statistics from runs with different
filesystems a few months ago.  kmalloc provided a good set of pre-made
sizes and I felt it was an overkill to replicate that.  But you are
right that we should probably be more conservative in terms of failing
the I/O.  I'll look at it again.


>  struct bio_pair {
>  	struct bio	bio1, bio2;
>  	struct bio_vec	bv1, bv2;
> +#if defined(CONFIG_BLK_DEV_INTEGRITY)
> +	struct bip	bip1, bip2;
> +	struct bio_vec	iv1, iv2;
> +#endif
>  	atomic_t	cnt;
>  	int		error;
>  };

Jens> That's somewhat of a shame, it makes bio_pair a LOT bigger. bio
Jens> grows a pointer if CONFIG_BLK_DEV_INTEGRITY, that we can live
Jens> with. In reality, very few people will use this stuff so adding
Jens> a sizable chunk of data to struct bio_pair is somewhat of a
Jens> bother.

Yeah, well.  Wasn't sure what else to do.  But the pool is tiny (2
entries by default) and only pktdvd and raid 0/10 actually use
bio_pairs.  I figured if you had CONFIG_BLK_DEV_INTEGRITY on you'd
probably want to use integrity it on your MD disks anyway.  And on
your desktop box with pktdvd integrity wasn't likely to be compiled
in.

Dynamic allocation would defeat the purpose of the pool.  But I guess
I could make another dedicated bio_integrity_pair pool and wire the
integrity portion into bio_pair using pointers.  What do you think?

-- 
Martin K. Petersen	Oracle Linux Engineering
