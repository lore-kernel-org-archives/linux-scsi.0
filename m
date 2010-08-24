From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/5] md: implment REQ_FLUSH/FUA support
Date: Tue, 24 Aug 2010 15:41:02 +1000
Message-ID: <20100824154102.7b68818b@notabene>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
	<1281977523-19335-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281977523-19335-5-git-send-email-tj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Tejun Heo <tj@kernle.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Aug 2010 18:52:02 +0200
Tejun Heo <tj@kernel.org> wrote:


Hi Tejun,
 thanks for doing this.
 It mostly looks good, especially ...


> * REQ_FLUSH/FUA failures are final and its users don't need retry
>   logic.  Retry logic is removed.

This bit - all that retry logic felt so clumsy :-)

Only change I would make is:

>  
> @@ -4083,7 +4089,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
>  			finish_wait(&conf->wait_for_overlap, &w);
>  			set_bit(STRIPE_HANDLE, &sh->state);
>  			clear_bit(STRIPE_DELAYED, &sh->state);
> -			if (mddev->barrier && 
> +			if (mddev->flush_bio &&
>  			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			release_stripe(sh);
> @@ -4106,7 +4112,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
>  		bio_endio(bi, 0);
>  	}
>  
> -	if (mddev->barrier) {
> +	if (mddev->flush_bio) {
>  		/* We need to wait for the stripes to all be handled.
>  		 * So: wait for preread_active_stripes to drop to 0.
>  		 */

These two in raid5.c aren't quite right.
The first should be changed to test
   bi->bi_rw & REQ_SYNC
rather than
   mddev->flush_bio.
(Assuming the REQ_SYNC means "don't bother waiting for more requests that
might combine with this one to make it all go faster" which I think it does.)

For the second we can just drop the whole if statement.
It was needed so that the all the writes would go done to the underlying
devices so that the null-barrier which would subsequently be passed to all
those devices would go *after* the writes for the barrier request.
As there is no longer a post-flush, that code can go.

Thanks a lot, and sorry for the delay in reviewing it.
NeilBrown


> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 0f86f5e..ff9cad2 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -275,6 +275,7 @@ struct r6_state {
>  				    * filling
>  				    */
>  #define R5_Wantdrain	13 /* dev->towrite needs to be drained */
> +#define R5_WantFUA	14	/* Write should be FUA */
>  /*
>   * Write method
>   */

