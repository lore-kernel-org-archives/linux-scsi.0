From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Sat, 17 May 2008 18:14:36 +0800
Message-ID: <a8e1da0805170314v4253d01agc0d6f77438e27989@mail.gmail.com>
References: <20080514000933.56adc131.akpm@linux-foundation.org>
	 <20080514155639.GB28594@kroah.com>
	 <20080514162442.GO9324@parisc-linux.org>
	 <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com>
	 <20080515090101.GA2915@darkstar.te-china.tietoenator.com>
	 <20080515115203.GH9921@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:49749 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYEQKOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 May 2008 06:14:42 -0400
Received: by ti-out-0910.google.com with SMTP id b6so522683tic.23
        for <linux-scsi@vger.kernel.org>; Sat, 17 May 2008 03:14:36 -0700 (PDT)
In-Reply-To: <20080515115203.GH9921@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On 5/15/08, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, May 15, 2008 at 05:01:01PM +0800, Dave Young wrote:
>> > The classes are different here, first sdev_class, then sg_sysfs_class
>
> Oh ... right.  I misread scsi_register_interface as
> class_register_interface.
>
>> Greg, what about using mutex_lock_nested to silence lockdep? They are
>> the only usage of class->mutex out of class.c
>
> I don't see how we prove that, for example, you can never take the
> sg_sysfs_class mutex and then take the sdev_class mutex.

Sorry for my delay. AFAIK, there's no this kind of use.
>
> There aren't /that/ many classes in the kernel (my laptop has 33 in
> /sys/class).  How about we make each (sysfs) class its own (lockdep)
> class?  That way we let lockdep do its job rather than telling it "nah,
> you're all right, this is good".
>
> I don't have a copy of the sem->mutex conversion to hand, but I imagine
> you want to do something like:
>
>  - Add a struct lock_class_key to struct class
>  - In drivers/base/class.c use __mutex_init instead of mutex_init
>
> I think that should be enough ...

Yes, it's safer than mutex_lock_nested.  If you all have no objection
I can do the fix like this.

Thanks.
