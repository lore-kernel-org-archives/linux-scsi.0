From: "goggin, edward" <egoggin@emc.com>
Subject: RE: [RFC PATCH 2/4] convert dm to blkerr error values
Date: Fri, 16 Sep 2005 16:56:31 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ACB7@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:8069 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP
	id S1750860AbVIPU4w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 16:56:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, axboe@suse.de, dm-devel@redhat.com

Mike,

Can't dec_pending now see different error values for the
possibly multiple bio clones of a single original bio?
How should it decide which error gets propagated up to
the original bio?

Looks like the old code and your new code just take the error
value from the last completed bio which has an error.  While
this was probably OK when the only error value was -ENXIO, we
may now need some logic in dec_pending to decide which error
value has more significance.

Ed

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
> Sent: Wednesday, August 24, 2005 5:04 AM
> To: linux-scsi@vger.kernel.org; axboe@suse.de; dm-devel@redhat.com
> Subject: [RFC PATCH 2/4] convert dm to blkerr error values
> 
> Convert dm and dm-targets (excpet dm-multipath) to
> BLKERR values.
> 
> Some temporary crap I will fix is the dec_pending fucntions.
> Becuase dec_pending() used to get -Exyz values from target map
> functions I just added a switch statement to convert the Exyz
> value to a BLKERR one. I need to spend more time looking at
> some of them to make sure I do the right thing. I will convert
> the target's map functions in the next round - unless you are
> fine with that conversion code in dec_pending. I had to play
> similar tricks for the other target's dec_pending/count functions.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -436,8 +436,8 @@ static void dec_pending(struct crypt_io 
>  {
>  	struct crypt_config *cc = (struct crypt_config *) 
> io->target->private;
>  
> -	if (error < 0)
> -		io->error = error;
> +	if (error && io->error != BLK_SUCCESS)
> +		io->error = BLKERR_IO;
>  
>  	if (!atomic_dec_and_test(&io->pending))
>  		return;
> @@ -726,7 +726,10 @@ static int crypt_endio(struct bio *bio, 
>  	}
>  
>  	if (bio->bi_size)
> -		return 1;
> +		return -1;
> +
> +	if (error != BLK_SUCCESS)
> +		io->error = error;
>  
>  	bio_put(bio);
>  
> @@ -804,7 +807,7 @@ static int crypt_map(struct dm_target *t
>  	io->target = ti;
>  	io->bio = bio;
>  	io->first_clone = NULL;
> -	io->error = 0;
> +	io->error = BLK_SUCCESS;
>  	atomic_set(&io->pending, 1); /* hold a reference */
>  
>  	if (bio_data_dir(bio) == WRITE)
> diff --git a/drivers/md/dm-emc.c b/drivers/md/dm-emc.c
> --- a/drivers/md/dm-emc.c
> +++ b/drivers/md/dm-emc.c
> @@ -48,7 +48,7 @@ static int emc_endio(struct bio *bio, un
>  	 *
>  	 * For now simple logic: either it works or it doesn't.
>  	 */
> -	if (error)
> +	if (error != BLK_SUCCESS)
>  		dm_pg_init_complete(path, MP_FAIL_PATH);
>  	else
>  		dm_pg_init_complete(path, 0);
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -115,7 +115,7 @@ static inline unsigned bio_get_region(st
>   *---------------------------------------------------------------*/
>  static void dec_count(struct io *io, unsigned int region, int error)
>  {
> -	if (error)
> +	if (error != BLK_SUCCESS)
>  		set_bit(region, &io->error);
>  
>  	if (atomic_dec_and_test(&io->count)) {
> @@ -141,7 +141,7 @@ static int endio(struct bio *bio, unsign
>  	if (bio->bi_size)
>  		return 1;
>  
> -	if (error && bio_data_dir(bio) == READ)
> +	if (error != BLK_SUCCESS && bio_data_dir(bio) == READ)
>  		zero_fill_bio(bio);
>  
>  	dec_count(io, bio_get_region(bio), error);
> @@ -308,7 +308,7 @@ static void dispatch_io(int rw, unsigned
>  	 * Drop the extra refence that we were holding to avoid
>  	 * the io being completed too early.
>  	 */
> -	dec_count(io, 0, 0);
> +	dec_count(io, 0, BLK_SUCCESS);
>  }
>  
>  static int sync_io(unsigned int num_regions, struct io_region *where,
> diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
> --- a/drivers/md/dm-zero.c
> +++ b/drivers/md/dm-zero.c
> @@ -41,7 +41,7 @@ static int zero_map(struct dm_target *ti
>  		break;
>  	}
>  
> -	bio_endio(bio, bio->bi_size, 0);
> +	bio_endio(bio, bio->bi_size, BLK_SUCCESS);
>  
>  	/* accepted bio, don't make new request */
>  	return 0;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -294,8 +294,25 @@ struct dm_table *dm_get_table(struct map
>   */
>  static inline void dec_pending(struct dm_io *io, int error)
>  {
> -	if (error)
> -		io->error = error;
> +	/*
> +	 * When called from the endio functions io->error will
> +	 * have been set or we will be passed a BLKERR value.
> +	 * If this is called from the mapping functions then will get
> +	 * a old error value because we have not converted them yet
> +	 */
> +	if (error && io->error == BLK_SUCCESS) {
> +		switch (error) {
> +			case -EWOULDBLOCK:
> +				io->error = BLKERR_WOULDBLOCK;
> +				break;
> +			case -EOPNOTSUPP:
> +				io->error = BLKERR_NOTSUPP;
> +				break;
> +			default:
> +				io->error = BLKERR_IO;
> +				break;
> +		}
> +	}
>  
>  	if (atomic_dec_and_test(&io->io_count)) {
>  		if (atomic_dec_and_test(&io->md->pending))
> @@ -317,19 +334,22 @@ static int clone_endio(struct bio *bio, 
>  	if (bio->bi_size)
>  		return 1;
>  
> -	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
> -		error = -EIO;
> +	if (!bio_flagged(bio, BIO_UPTODATE) && error == BLK_SUCCESS)
> +		error = BLKERR_IO;
>  
>  	if (endio) {
>  		r = endio(tio->ti, bio, error, &tio->info);
> -		if (r < 0)
> +		if (r >= 0)
>  			error = r;
>  
> -		else if (r > 0)
> +		else if (r < 0)
>  			/* the target wants another shot at the io */
>  			return 1;
>  	}
>  
> +	if (error != BLK_SUCCESS)
> +		io->error = error;
> +
>  	free_tio(io->md, tio);
>  	dec_pending(io, error);
>  	bio_put(bio);
> @@ -539,7 +559,7 @@ static void __split_bio(struct mapped_de
>  	ci.md = md;
>  	ci.bio = bio;
>  	ci.io = alloc_io(md);
> -	ci.io->error = 0;
> +	ci.io->error = BLK_SUCCESS;
>  	atomic_set(&ci.io->io_count, 1);
>  	ci.io->bio = bio;
>  	ci.io->md = md;
> @@ -552,7 +572,7 @@ static void __split_bio(struct mapped_de
>  		__clone_and_map(&ci);
>  
>  	/* drop the extra reference count */
> -	dec_pending(ci.io, 0);
> +	dec_pending(ci.io, BLK_SUCCESS);
>  	dm_table_put(ci.map);
>  }
>  /*-----------------------------------------------------------------
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
