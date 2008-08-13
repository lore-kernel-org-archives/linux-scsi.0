From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Wed, 13 Aug 2008 10:50:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808131036310.2455-100000@iolanthe.rowland.org>
References: <48A2C1F5.6000708@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48A2C1F5.6000708-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 13 Aug 2008, Boaz Harrosh wrote:

> But now that I stared at the code harder. Current code is a complete bug.
> the: "this_count = scsi_bufflen()" Has nothing to do with anything. 
> Maybe it was meant to be: "this_count = scsi_bufflen() - good_bytes"
> That is the count left over after the first complete. But after we
> have completed good_bytes, the second complete is never scsi_bufflen().
> (It used to work because most of the times it is bigger then the reminder
> but then we can just use: "this_count = ~0")
> 
> Also what you did is not enough. What if the error is one of the known cases
> above, where the "complete and return" is inside the case. They will hang also. 
> Here is what I think should be:
> 
> ---
> git diff --stat -p drivers/scsi/
>  drivers/scsi/scsi_lib.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ff5d56b..36995e5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -852,7 +852,7 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  {
>  	int result = cmd->result;
> -	int this_count = scsi_bufflen(cmd);
> +	int this_count;
>  	struct request_queue *q = cmd->device->request_queue;
>  	struct request *req = cmd->request;
>  	int error = 0;
> @@ -909,9 +909,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>  		return;
>  
> -	/* good_bytes = 0, or (inclusive) there were leftovers and
> -	 * result = 0, so scsi_end_request couldn't retry.
> -	 */
> +	this_count = blk_rq_bytes(req);
> +
>  	if (sense_valid && !sense_deferred) {
>  		switch (sshdr.sense_key) {
>  		case UNIT_ATTENTION:

Is this really right?  Consider the subcases that follow.  For example, 
in the UNIT ATTENTION case we have

			scsi_end_request(cmd, -EIO, this_count, 1);

With this_count equal to blk_rq_bytes(req), there will be no leftovers 
and so nothing will be requeued.  Shouldn't it really be

			scsi_end_request(cmd, -EIO, 0, 1);

The same holds for all the other places scsi_end_request() is called 
with requeue equal to 1, including the final call (if result == 0).  
This suggests that this_count should be eliminated entirely and each 
of those calls be replaced by either

			goto retry;
or
			goto fail;

together with:

 retry:
	scsi_end_request(cmd, -EIO, 0, 1);
	return;
 fail:
	scsi_end_request(cmd, -EIO, blk_rq_bytes(req), 0);
	return;

Alan Stern

PS: In my copy of the code, scsi_end_request() doesn't use
blk_rq_bytes().  Has this been updated in the SCSI development tree?

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
