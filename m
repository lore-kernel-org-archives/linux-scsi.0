From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Mon, 19 May 2008 04:23:44 -0600
Message-ID: <20080519102343.GB2638@parisc-linux.org>
References: <20080514000933.56adc131.akpm@linux-foundation.org> <20080514155639.GB28594@kroah.com> <20080514162442.GO9324@parisc-linux.org> <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com> <20080515090101.GA2915@darkstar.te-china.tietoenator.com> <20080515115203.GH9921@parisc-linux.org> <a8e1da0805170314v4253d01agc0d6f77438e27989@mail.gmail.com> <a8e1da0805182220y23412047g4969e3906a4c5aca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47452 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbYESKXp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:23:45 -0400
Content-Disposition: inline
In-Reply-To: <a8e1da0805182220y23412047g4969e3906a4c5aca@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Mon, May 19, 2008 at 01:20:33PM +0800, Dave Young wrote:
> On Sat, May 17, 2008 at 6:14 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On 5/15/08, Matthew Wilcox <matthew@wil.cx> wrote:
> >> On Thu, May 15, 2008 at 05:01:01PM +0800, Dave Young wrote:
> >>> > The classes are different here, first sdev_class, then sg_sysfs_class
> >>
> >> Oh ... right.  I misread scsi_register_interface as
> >> class_register_interface.
> >>
> >>> Greg, what about using mutex_lock_nested to silence lockdep? They are
> >>> the only usage of class->mutex out of class.c
> >>
> >> I don't see how we prove that, for example, you can never take the
> >> sg_sysfs_class mutex and then take the sdev_class mutex.
> >
> > Sorry for my delay. AFAIK, there's no this kind of use.

The question isn't whether there is or isn't this kind of use right now.
The question is whether there might be this kind of use in the future,
and if there is, whether we'd like lockdep to warn us.

> I rechecked the class_interface use, the users are scsi and pcmcia.
> 
> The two classes could call device_add/del while doing
> class_interface_register/unregister is :
> sg_sysfs_class
> pcmcia_socket_class
> 
> So is it possible to reset their lock_class instead of do __mutex_init
> for all classes?

Again, it's not about current usage, it's about future usage.  Why do
you want all sysfs classes to have the same lockdep class?  There can
be good reasons.  For example, if two locks are conceptually the same,
keeping them in the same class helps you find AB-BA problems earlier.

Is there a reason you don't like my idea?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
