From: Greg KH <greg@kroah.com>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Tue, 20 May 2008 21:38:06 -0700
Message-ID: <20080521043806.GC8950@kroah.com>
References: <20080514162442.GO9324@parisc-linux.org> <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com> <20080515090101.GA2915@darkstar.te-china.tietoenator.com> <20080515115203.GH9921@parisc-linux.org> <a8e1da0805170314v4253d01agc0d6f77438e27989@mail.gmail.com> <a8e1da0805182220y23412047g4969e3906a4c5aca@mail.gmail.com> <20080519102343.GB2638@parisc-linux.org> <a8e1da0805191827s6222ec65k8521359b188e6345@mail.gmail.com> <20080520180704.GA19817@kroah.com> <a8e1da0805202020m3fbf179ct767b71c53a6ee685@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYEUEjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2008 00:39:37 -0400
Content-Disposition: inline
In-Reply-To: <a8e1da0805202020m3fbf179ct767b71c53a6ee685@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Wed, May 21, 2008 at 11:20:32AM +0800, Dave Young wrote:
> On Wed, May 21, 2008 at 2:07 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, May 20, 2008 at 09:27:59AM +0800, Dave Young wrote:
> >> On Mon, May 19, 2008 at 6:23 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> >> > On Mon, May 19, 2008 at 01:20:33PM +0800, Dave Young wrote:
> >> >> On Sat, May 17, 2008 at 6:14 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >> >> > On 5/15/08, Matthew Wilcox <matthew@wil.cx> wrote:
> >> >> >> On Thu, May 15, 2008 at 05:01:01PM +0800, Dave Young wrote:
> >> >> >>> > The classes are different here, first sdev_class, then sg_sysfs_class
> >> >> >>
> >> >> >> Oh ... right.  I misread scsi_register_interface as
> >> >> >> class_register_interface.
> >> >> >>
> >> >> >>> Greg, what about using mutex_lock_nested to silence lockdep? They are
> >> >> >>> the only usage of class->mutex out of class.c
> >> >> >>
> >> >> >> I don't see how we prove that, for example, you can never take the
> >> >> >> sg_sysfs_class mutex and then take the sdev_class mutex.
> >> >> >
> >> >> > Sorry for my delay. AFAIK, there's no this kind of use.
> >> >
> >> > The question isn't whether there is or isn't this kind of use right now.
> >> > The question is whether there might be this kind of use in the future,
> >> > and if there is, whether we'd like lockdep to warn us.
> >>
> >> In the future, IMHO, the class_interface should go away just as
> >> class_device. If that happened this problem would going away as well.
> >
> > Patches gladly accepted to do this, but what you will end up with is
> > something just called a different name, yet doing the same
> > functionality, so you are back at square one :(
> 
> Greg, do you have proposals about the class_interface removal before
> this thread? or ideas?

Nope, I'm not doing it :)

But, like I said, you are going to end up with the same functionality,
right?  So you will have the same problem.

thanks,

greg k-h
