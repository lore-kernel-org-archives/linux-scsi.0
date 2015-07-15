From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] dm-mpath: always return reservation conflict
Date: Wed, 15 Jul 2015 14:35:08 +0300
Message-ID: <1436960108.31121.41.camel@HansenPartnership.com>
References: <1436959404-14035-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49525 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbbGOLfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2015 07:35:14 -0400
In-Reply-To: <1436959404-14035-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Wed, 2015-07-15 at 13:23 +0200, Hannes Reinecke wrote:
> If dm-mpath encounters an reservation conflict it should not
> fail the path (as communication with the target is not affected)
> but should rather retry on another path.
> However, in doing so we might be inducing a ping-pong between
> paths, with no guarantee of any forward progress.
> And arguably a reservation conflict is an unexpected error,
> so we should be passing it upwards to allow the application
> to take appropriate steps.

If I interpret the code correctly, you've changed the behaviour from the
current try all paths and fail them, ultimately passing the reservation
conflict up if all paths fail to return reservation conflict
immediately, keeping all paths running.  This assumes that the
reservation isn't path specific because if we encounter a path specific
reservation, you've altered the behaviour from route around to fail.

The case I think the original code was for is SAN Volume controllers
which use path specific SCSI-3 reservations effectively to do traffic
control and allow favoured paths.  Have you verified that nothing we
encounter in the enterprise uses path specific reservations for
multipath shaping any more?

James

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 5a67671..e65d266 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1269,7 +1269,16 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  	if (noretry_error(error))
>  		return error;
>  
> -	if (mpio->pgpath)
> +	/*
> +	 * EBADE signals an reservation conflict.
> +	 * We shouldn't fail the path here as we can communicate with
> +	 * the target. We should failover to the next path, but in
> +	 * doing so we might be causing a ping-pong between paths.
> +	 * So just return the reservation conflict error.
> +	 */
> +	if (error == -EBADE)
> +		r = error;
> +	else if (mpio->pgpath)
>  		fail_path(mpio->pgpath);
>  
>  	spin_lock_irqsave(&m->lock, flags);
> @@ -1277,9 +1286,6 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  		if (!m->queue_if_no_path) {
>  			if (!__must_push_back(m))
>  				r = -EIO;
> -		} else {
> -			if (error == -EBADE)
> -				r = error;
>  		}
>  	}
>  	spin_unlock_irqrestore(&m->lock, flags);



