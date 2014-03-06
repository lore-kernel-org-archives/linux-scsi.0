From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH RESEND] SCSI: sd: don't fail if the device doesn't
 recognize SYNCHRONIZE CACHE
Date: Thu, 6 Mar 2014 13:13:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1403061308350.961-100000@iolanthe.rowland.org>
References: <CAA9_cmffKCnam5n2U9y1NzJpBRVzLyb2F+m8F5e6eW2Hub-HTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmffKCnam5n2U9y1NzJpBRVzLyb2F+m8F5e6eW2Hub-HTA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Mack <zonque@gmail.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Oliver Neukum <oliver@neukum.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 5 Mar 2014, Dan Williams wrote:

> On Mon, Mar 3, 2014 at 1:25 PM, Daniel Mack <zonque@gmail.com> wrote:
> > From: Alan Stern <stern@rowland.harvard.edu>
> >
> > Evidently some wacky USB-ATA bridges don't recognize the SYNCHRONIZE
> > CACHE command, as shown in this email thread:
> >
> >         http://marc.info/?t=138978356200002&r=1&w=2
> >
> > The fact that we can't tell them to drain their caches shouldn't
> > prevent the system from going into suspend.  Therefore sd_sync_cache()
> > shouldn't return an error if the device replies with an Invalid
> > Command ASC.
> >
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > Reported-by: Sven Neumann <s.neumann@raumfeld.com>
> > Tested-by: Daniel Mack <zonque@gmail.com>
> > CC: Oliver Neukum <oliver@neukum.org>
> > CC: <stable@vger.kernel.org>
> > ---
> > Hi,
> >
> > this patch has been around for awhile, but hasn't gained much
> > attraction, and hasn't been merged anywhere yet. Which is sad,
> > as it fixes a bug on real hardware when going to suspend :)
> >
> > Could anyone from the SCSI people have a quick look maybe?
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> But I agree with Tejun [1], that this likely does not go far enough.
> We should also be looking to fail future writes to the device or
> disabling the cache.
> 
> Tejun's comment:
> "Ooh, yeah, flush failure is special.  That said, I think the right way
> to deal with that is marking the device as failed and fail writes /
> flushes afterwards instead of failing suspend.  It's hightly unlikely
> the device is in any useable state after failing flushes anyway and
> failing suspend has potential to lead to pretty dramatic failure
> conditions (device overheating in the bag would be a common one) too."

I disagree with part of Tejun's comment.  In the case of the bug report
leading to this patch, it is _not_ true that the device ends up in an
unusable state (as far as I know).  There's no reason to mark the
device as failed.

Alan Stern
