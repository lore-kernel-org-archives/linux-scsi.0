From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Thu, 15 May 2008 05:52:04 -0600
Message-ID: <20080515115203.GH9921@parisc-linux.org>
References: <20080514000933.56adc131.akpm@linux-foundation.org> <20080514155639.GB28594@kroah.com> <20080514162442.GO9324@parisc-linux.org> <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com> <20080515090101.GA2915@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55413 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbYEOLwU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2008 07:52:20 -0400
Content-Disposition: inline
In-Reply-To: <20080515090101.GA2915@darkstar.te-china.tietoenator.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Thu, May 15, 2008 at 05:01:01PM +0800, Dave Young wrote:
> > The classes are different here, first sdev_class, then sg_sysfs_class

Oh ... right.  I misread scsi_register_interface as
class_register_interface.

> Greg, what about using mutex_lock_nested to silence lockdep? They are
> the only usage of class->mutex out of class.c

I don't see how we prove that, for example, you can never take the
sg_sysfs_class mutex and then take the sdev_class mutex.

There aren't /that/ many classes in the kernel (my laptop has 33 in
/sys/class).  How about we make each (sysfs) class its own (lockdep)
class?  That way we let lockdep do its job rather than telling it "nah,
you're all right, this is good".

I don't have a copy of the sem->mutex conversion to hand, but I imagine
you want to do something like:

 - Add a struct lock_class_key to struct class
 - In drivers/base/class.c use __mutex_init instead of mutex_init

I think that should be enough ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
