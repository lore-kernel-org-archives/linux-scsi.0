From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] SCSI: don't do bogus retries
Date: Tue, 30 Sep 2008 10:14:18 -0400 (EDT)
Message-ID: <20080930.101418.74753689.k-ueda@ct.jp.nec.com>
References: <Pine.LNX.4.44L0.0809291711440.4420-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbYI3OQj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 10:16:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809291711440.4420-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, k-ueda@ct.jp.nec.com

Hi Alan,

On Mon, 29 Sep 2008 17:12:28 -0400 (EDT), Alan Stern wrote:
> The patch also changes the "failure" path; now instead of calling
> scsi_end_request() it directly calls end_dequeued_request() followed
> by scsi_next_command().
...
> @@ -908,7 +907,6 @@ void scsi_io_completion(struct scsi_cmnd
>  	 */
>  	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>  		return;
> -	this_count = blk_rq_bytes(req);
>  
>  	if (sense_valid && !sense_deferred) {
>  		switch (sshdr.sense_key) {
...
> @@ -1002,14 +1000,10 @@ void scsi_io_completion(struct scsi_cmnd
>  			if (driver_byte(result) & DRIVER_SENSE)
>  				scsi_print_sense("", cmd);
>  		}
> -		goto fail;
>  	}
> -
> - retry2:
> -	scsi_end_request(cmd, -EIO, this_count, 1);
> -	return;
>   fail:
> -	scsi_end_request(cmd, -EIO, this_count, 0);
> +	end_dequeued_request(req, -EIO);
> +	scsi_next_command(cmd);
>  	return;
>   requeue:
>  	scsi_requeue_command(q, cmd);

I think you should use blk_end_request(req, -EIO, blk_rq_bytes(rq))
here instead of end_dequeued_request(req, -EIO).

end_dequeued_request() needs to be called with queue lock held,
but I can't see any queue lock in your patches.
Also, if you add the queue lock and still use end_dequeued_request(),
__end_that_request_first(), which completes BIOs in the request,
is called with the queue lock held, though it doesn't require queue
lock actually.  So that might cause some performance regressions.

Thanks,
Kiyoshi Ueda
