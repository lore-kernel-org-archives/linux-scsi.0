From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sat, 20 Sep 2008 13:06:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809201241160.13839-100000@netrider.rowland.org>
References: <1221870710.3428.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2376 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750851AbYITRGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Sep 2008 13:06:02 -0400
In-Reply-To: <1221870710.3428.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 20 Sep 2008, James Bottomley wrote:

> OK, I looked at it.  Sorry about the delay; I wanted to audit the users
> to make sure we didn't over complete.  There's lots more than just the
> last sector bug that relies on partial completions doing request
> chunking.  I don't like your bytes == 0 micro optimisation, but other
> than that, it looks fine.

I'm perfectly happy to remove that micro optimization.  Also it would 
be good to break all the code motion out into a separate preliminary 
patch, apart from the functional changes.  (The code motion in itself 
is a worthwhile cleanup, IMO.)

> However, there's too much code movement in this for a bug fix that has
> to go into a late -rc and the stable series.  I think the patch below
> represents the smallest and simplest (and thus least error prone) fix,
> doesn't it (the rest can go into scsi-misc as an enhancement)?

Your patch doesn't seem quite right.  Comments below.

As regards too much change for this late in -rc...  This bug affects 
only a handful of devices, so far as we've seen.  It wouldn't hurt to 
delay the fix until 2.6.27.stable.

> With regard to what the mid-layer is doing, for the error cases where we
> send enough bytes to complete the request fully, I think the requeue
> looks superfluous (it's never going to get into that code in
> scsi_end_request),

Agreed.

> The other strange bit is that I can't find any error
> cases where we don't complete everything ... i.e. the partial complete
> and requeue never applies, so we should probably just be using
> end_dequeued_request().

These cases can arise from the "last-sector bug" stuff.  As an example,
suppose a program tries to read the last 2 sectors of the device.  The
"last-sector bug" code breaks the request in two; the first command
will read only the second-to-last sector.  If this command fails with
an error, you're in exactly this case -- an error in which less than
the entire request has been completed.  Depending on the exact nature 
of the error, we will choose between failing the entire request or 
failing just the second-to-last sector (and requeuing the command in 
order to try reading the last sector).

>  I also think we could junk scsi_end_request()
> in faviour of blk_end_request and do the blk_noretry_request() check
> inline in scsi_io_completion, after we try to complete but before we
> might retry.

Possibly.  With the patch in place, scsi_end_request() gets called in 
only three places, one of which doesn't attempt to do any retries.  But 
that still leaves two places which might attempt it, so the retry logic 
would have to be inlined twice.

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
> @@ -908,6 +908,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	 */
>  	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>  		return;
> +	this_count = blk_rq_bytes(req);
>  
>  	/* good_bytes = 0, or (inclusive) there were leftovers and
>  	 * result = 0, so scsi_end_request couldn't retry.

The problem is what happens in all the "retry" paths that follow.  
They end up doing this:

		scsi_end_request(cmd, -EIO, this_count, 1);

when in fact they should do this:

		scsi_end_request(cmd, -EIO, 0, 1);

(where the -EIO value is ignored).

By passing this_count as the third argument, they are telling the block
layer that the entire remainder of the request completed with an error.  
Hence blk_end_request() will return 0, scsi_end_request() won't take
its "blocks left over at the end" pathway, and nothing will be
requeued.

Alan Stern

