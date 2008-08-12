From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Tue, 12 Aug 2008 17:00:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808121648190.3153-100000@iolanthe.rowland.org>
References: <48A1BB71.5050905@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48A1BB71.5050905-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Aug 2008, Boaz Harrosh wrote:

> What you are doing here is changing the semantics of what used to
> work.

Yes, and I don't want to do that unless the current code is truly
wrong.  That's why I wasn't certain this was the right thing to do.

>  Now I'm not saying it's a bad thing, but You must audit all
> scsi ULDs to make sure they are not now broken because of  the new
> assumptions. Let me explain.
> 
> This is what happens now (before the patch):
> A request comes in with some size. And gets prepared by ULD.
> If the ULD does not like the size for some reason it will
> chunk off scsi_bufflen and will submit the command with
> bufflen != req->size. The midlayer and drivers will only
> respond to bufflen. Until ...
> 
> Until this loop magic in scsi_io_completion(). Since the
> request is not done it will be requeued, the ULD will inspect
> new size, adjust scsi_bufflen and so on until done.
> 
> In case of an error the request goes back to the ULD and the ULD
> should decide what to do with the reminder.

I don't understand this point.  _Every_ non-BLOCK_PC request
automatically goes back to the ULD via the ->done callback, not only
those which get an error.  This callback does not get to decide what to
do with the remainder of the request, as far as I can tell; all it can
do is return the number of bytes actually handled.

> scsi-ml until now
> did not see any-other size but scsi_bufflen. So in theory it is
> sd.c job to check for errors on split up requests and decide if
> to complete the reminder or re-submit. The scsi-ml did not make
> that policy.

How can sd.c decide whether or not to resubmit?  It doesn't know 
whether scsi_io_completion() will go ahead and requeue the request 
anyway.  And besides, you can't resubmit the request until the current 
portion has been sent back to the block layer, which doesn't happen 
until after ->done returns.

> If scsi-ml decides that it wants to set a new error policy here, then
> you should audit other ULDs to make sure they did not rely on the
> old behavior.
> 
> sd could check for errors in it's drv->done(cmd) function. and return
> the reminder of the request size in case of error. look at
> scsi.c::scsi_finish_command(). ULD has control here.

The ->done function does not return the remainder of the request size; 
it returns good_bytes, which is the number of bytes that were handled.

I agree that since the decision to split the request up into multiple 
commands was made in sd.c, the decision of what to do about the 
remainder should also be made in sd.c.  However the current structure 
of the code doesn't seem to allow this to happen.  Requeue decisions 
are all made in scsi_io_completion() or scsi_end_request().

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
