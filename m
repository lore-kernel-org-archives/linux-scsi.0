From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Tue, 12 Aug 2008 19:33:53 +0300
Message-ID: <48A1BB71.5050905@panasas.com>
References: <Pine.LNX.4.44L0.0808121120130.2248-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0808121120130.2248-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Tue, 12 Aug 2008, Alan Jenkins wrote:
> 
>>> This suggests that we need to change the call to scsi_end_request() at 
>>> the end of scsi_io_completion().  If result is nonzero then nothing 
>>> will be requeued, so this_count should be replaced with the total 
>>> number of bytes remaining in the request.  Does that sound reasonable?
> 
>> It sounds a bit like the hangs that happened with my buggy card reader. 
>> My card reader returned errors because of the IO patterns from the first
>> version of the last_sector_bug flag.  But instead of reads returning
>> with errors, I just ended up with hung processes.
>>
>> It's great to see this tracked down.  Keep me CC'd and I'll test
>> whatever patch you come up with.  I can simulate the old last_sector_bug
>> behaviour by changing SD_LAST_BUGGY_SECTORS to 1 (instead of 8).
> 
> Well, here's a patch that fixes the problem.  However I'm not certain
> it's the right thing to do.  (The first hunk has nothing to do with
> this; it is just a comment change.  I simply can't stand the existing
> comment -- it is wrong in at least three respects.)
> 
> James, what do you think?
> 
> Alan Stern
> 
> 
> 
> Index: usb-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> +++ usb-2.6/drivers/scsi/scsi_lib.c
> @@ -909,8 +909,8 @@ void scsi_io_completion(struct scsi_cmnd
>  	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
>  		return;
>  
> -	/* good_bytes = 0, or (inclusive) there were leftovers and
> -	 * result = 0, so scsi_end_request couldn't retry.
> +	/* There are leftovers and result != 0, so scsi_end_request couldn't
> +	 * requeue the remainder and we have to retry it.
>  	 */
>  	if (sense_valid && !sense_deferred) {
>  		switch (sshdr.sense_key) {
> @@ -1015,6 +1015,10 @@ void scsi_io_completion(struct scsi_cmnd
>  			if (driver_byte(result) & DRIVER_SENSE)
>  				scsi_print_sense("", cmd);
>  		}
> +
> +		/* Fail the entire remainder of the request. */
> +		this_count = (blk_pc_request(req) ? req->data_len :
> +				(req->hard_nr_sectors << 9));
This one has an export
+		this_count = blk_rq_bytes(req);
>  	}
>  	scsi_end_request(cmd, -EIO, this_count, !result);
>  }
> 

What you are doing here is changing the semantics of what used to
work. Now I'm not saying it's a bad thing, but You must audit all
scsi ULDs to make sure they are not now broken because of  the new
assumptions. Let me explain.

This is what happens now (before the patch):
A request comes in with some size. And gets prepared by ULD.
If the ULD does not like the size for some reason it will
chunk off scsi_bufflen and will submit the command with
bufflen != req->size. The midlayer and drivers will only
respond to bufflen. Until ...

Until this loop magic in scsi_io_completion(). Since the
request is not done it will be requeued, the ULD will inspect
new size, adjust scsi_bufflen and so on until done.

In case of an error the request goes back to the ULD and the ULD
should decide what to do with the reminder. scsi-ml until now
did not see any-other size but scsi_bufflen. So in theory it is
sd.c job to check for errors on split up requests and decide if
to complete the reminder or re-submit. The scsi-ml did not make
that policy.

If scsi-ml decides that it wants to set a new error policy here, then
you should audit other ULDs to make sure they did not rely on the
old behavior.

sd could check for errors in it's drv->done(cmd) function. and return
the reminder of the request size in case of error. look at
scsi.c::scsi_finish_command(). ULD has control here.

my $0.017
Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
