From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Asynchronous scsi scanning
Date: Wed, 16 May 2007 04:57:52 +0530
Message-ID: <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
	 <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
	 <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
	 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <17841.simon.1179228389@5ec7c279.invalid>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:11018 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbXEOX1y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 19:27:54 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1698355uga
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2007 16:27:52 -0700 (PDT)
In-Reply-To: <20070515172905.GJ10562@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

Hi,

[ I appreciate you forked the thread and gave it a better subject name,
it would be better still if you could maintain the original CC list, thanks. ]

On Tue, May 15, 2007 at 12:26:29PM +0100, Simon Arlott wrote:
> I've already suggested a sysfs attribute - or something equivalent - would
> be much better. It's just one function that a user might want to run multiple
> times (e.g. after adding scsi devices?) - why should loading a module be used
> for this?

I have to agree with Simon that ...

static int __init wait_scan_init(void)
{
	scsi_complete_async_scans();
	return 0;
/* BTW this could've been return scsi_complete_async_scans();
 * I see scsi_complete_async_scans() never fails, but still. */
}
late_initcall(wait_scan_init);

... does _not_ deserve to be a module, and writing/building a module
for something like this (just to run a function in some kernel subsytem)
does not seem to be the proper way to solve the problem either. And
IMHO sysfs attribute for this is a good (well, better than this module
thing, at least) suggestion -- I hope you'd take it more seriously.

On 5/15/07, Matthew Wilcox <matthew@wil.cx> wrote:
> > >It's easy to suggest a sysfs attribute.  What you've failed to do is
> > >suggest the pathname of the sysfs attribute,

/sys/module/scsi_mod/parameters/wait_for_async_scans (?)
Doesn't really matter, but perhaps who created the sysfs namespace
for scsi in /sys/module/scsi_mod/... could be the best person to suggest.

> > >the contents of it, or the

Merely needs to be a "echo 1 > " kind of attribute. Whenever a
store_ happens on that attribute (and it's "1"), we just call
scsi_complete_async_scans(). Then we reset the attribute itself back
to 0. Also we could introduce a lock on wait_for_async_scans so that
we don't call scsi_complete_async_scans() twice if someone
accidentally "echo 1 > "'s to it more than once (if that would really be
a bad thing, otherwise it's fine). Also, something like ... if you read the
attribute _during_ the scsi_complete_async_scans(), then you get to
see "1".

All this is doesn't really matter, anyway, all that we really care about
is that: scsi_complete_async_scans() should run whenever something
gets written to this attribute, isn't it?

> > >semantics of it (read-only?  read-write?  write-only?

Well, it _has_ to be write, don't really care if it's read-write or
write-only. I would still prefer read-write, but we can go ahead with
write-only too. It doesn't really matter, does it?

> > >blocking?)

Why, blocking, of course. scsi_complete_async_scans() by definition
is supposed to _wait_ for async scans to complete, after all? And I
see a wait_for_completion() in their which means the current method
will also block during insmod time anyway, so we'll only be
maintaining present behaviour.

> > >I'd *really* like to hear from distro people.  What is the most
> > >convenient way for you to implement "load all the scsi modules, then
> > >wait until all devices are found"?

What do the distro people really care?

It's either going to be a:

modprobe scsi_wait_scan

versus a:

echo 1 > /sys/module/scsi_mod/.../wait_for_async_scans

somewhere in some script. In fact, the latter method seems simpler,
saner, better (in every which way)!

> > >James and I had thought that loading
> > >a new module would be the easiest way for you, but it seems inconvenient
> > >for you.

It's not _inconvenient_. Just that writing/building a module for accomplishing
something like that ... is just not _right_.

> > It's inconvenient for people who *don't* use it to be unable to stop the
> > module being built and installed.

Yes.

> Why?  You're not forced to load the module.  In what way does it
> inconvenience you?  Nobody's making you run 'make modules_install'.
> I often forget to myself.

OK, I'll get really silly here myself. I don't want even that half a second of
overhead when that module is being _built_ (during make modules), not
the overhead of copying / installing at modules_install time.

I apologize if I sounded impolite, and I certainly don't want to act
demanding / difficult or anything, but it's just that doing this via a sysfs
attribute (or hey, anything else!) sounds a better way to tackle this than
this module thing. IMHO, at least.

Satyam
