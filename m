From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Wed, 14 Jul 2010 21:44:09 -0700
Message-ID: <20100715044409.GA3456@suse.de>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> <m1zkxtinlw.fsf@fess.ebiederm.org> <20100715041613.GB2583@suse.de> <m1aaptcqpq.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m1aaptcqpq.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, Jens Axboe <axboe@kernel.dk>, Stephen Hemminger <shemminger@vyatta.com>, Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells <dhowells@redhat.com>, Dave Airlie <airlied@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2010 at 09:29:53PM -0700, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Wed, Jul 14, 2010 at 05:40:27PM -0700, Eric W. Biederman wrote:
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >> 
> >> > On Fri, 9 Jul 2010 11:54:50 -0700
> >> > Greg Kroah-Hartman <gregkh@suse.de> wrote:
> >> >
> >> >> This is no longer needed by any userspace tools, so it's safe to
> >> >> remove.
> >> >
> >> > Makes my FC6 test box not boot - can't find /dev/root.  Then when I go
> >> > back to plain old mainline (2.6.35-rc5) and run `make oldconfig', the
> >> > .config change sticks:
> >> >
> >> > @@ -106,8 +106,7 @@
> >> >  CONFIG_LOG_BUF_SHIFT=17
> >> >  CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> >> >  # CONFIG_CGROUPS is not set
> >> > -CONFIG_SYSFS_DEPRECATED=y
> >> > -CONFIG_SYSFS_DEPRECATED_V2=y
> >> > +# CONFIG_SYSFS_DEPRECATED_V2 is not set
> >> >  CONFIG_RELAY=y
> >> >  CONFIG_NAMESPACES=y
> >> >  # CONFIG_UTS_NS is not set
> >> >
> >> > and the box still won't boot.
> >> 
> >> The reason FC6 doesn't boot is there is a userspace tool
> >> I believe in the initrd that cares about symlinks when it should
> >> not.
> >
> > Anyone happen to know which tool it is?  I remember we had had issues
> > with FC3 around this area, but I thought we resolved them, so it's
> > supprising to me that FC6 has issues.
> 
> It was something in the initrd, that didn't like the symlinks.  It
> has been a year or more since I looked at it.  At that point I just
> enabled SYSFS_DEPRECATED and moved on.

If it was just the symlinks for the block devices, we might be able to
reduce the amount of code hanging around.  When I return from Europe
next week, I'll try to dig into this.

> >> What is more interesting is that currently there is a bug in
> >> 2.6.35-rc5 where rmmod <netdriver> modprobe <netdriver> will in fact
> >> fail.  There was an inadvertent regression and no one has noticed or
> >> complained.  I spotted it by code review just a little bit ago and I
> >> haven't had a chance to write and test the fix yet.
> >> 
> >> If the code is going to start bitrotting and no one is going to
> >> notice or care simply removing the code instead of subjecting users
> >> to weird unexpected breakage seems like a responsible thing to do.
> >
> > Yeah, that's what prompted this removal.  After the s390 guys said that
> > they were all good to go, I figured no one else would have problems with
> > it :)
> >
> > If it turns out there still are issues with older userspaces like FC6
> > that we can't resolve, I have no problem dropping this patch and then we
> > will have to fix up the regression.
> 
> I still have to test it but it looks like a one liner.  Actually two lines
> now that I have to fix the error in symlink creation as well.

Ah, that's good to hear, as I'm sure .35 will need this fix :)

thanks,

greg k-h
