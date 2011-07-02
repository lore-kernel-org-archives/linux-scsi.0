From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 1 Jul 2011 22:03:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
References: <1309554818.2722.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309554818.2722.48.camel@mulgrave>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 1 Jul 2011, James Bottomley wrote:

> On Fri, 2011-07-01 at 17:04 -0400, Alan Stern wrote:
> > On Fri, 1 Jul 2011, James Bottomley wrote:
> > 
> > > On Fri, 2011-07-01 at 14:14 -0400, Dave Jones wrote:
> > > > On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:
> > > > 
> > > >  > I found I can reliably crash a 3.0 system by pulling the
> > > >  > USB cable of a mounted USB cdrom (or rather a USB device which
> > > >  > has a builtin fake CD-ROM) 
> > > >  > 
> > > >  > I suspect it's a regression too.
> > > > 
> > > > We've been seeing a lot of similar bugs in Fedora since we pushed
> > > > a 2.6.38.8 update.  Some of the traces are different, but some
> > > > look to be the same as yours. (here's one for eg: https://bugzilla.redhat.com/show_bug.cgi?id=712830)
> > > > 
> > > > The common cause seems to be 'device went away'. So USB CD drives,
> > > > USB memory sticks, and for some reason virtualbox shutdown.
> > > 
> > > I think it's something specific in the USB path.  I can't reproduce on
> > > 3.0-rc5 with a SATA DVD hot unplug.  USB cc's added.
> > 
> > I just took a look at the Red Hat bugzilla entry mentioned above.  It 
> > seems to be quite different from the issue addressed by the patch I 
> > just posted -- a crash with invalid memory access rather than a lockdep 
> > violation and hang of the khubd thread.
> > 
> > It's also notable that the stack dump in the bugzilla report doesn't 
> > contain any functions in the USB subsystem.  Of course this doesn't 
> > prove anything, but it is suggestive.
> > 
> > Evidently the sdev argument to scsi_prep_state_check() was NULL.  This
> > looks like the problem that cropped up before, where q->queuedata was
> > getting set to NULL while the queue was still in use.  I can't imagine
> > how anything in usb-storage could have caused that.
> 
> Right ... the device release function has already been called, so it's
> some type of refcounting cockup.  The fact that I can't reproduce with a
> SATA unplug is what makes me think it might be USB specific ... of
> course, that's not definitive.

I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
give the exact sequence of steps you went through to trigger the bug?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
