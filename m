From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Tue, 20 May 2008 09:27:59 +0800
Message-ID: <a8e1da0805191827s6222ec65k8521359b188e6345@mail.gmail.com>
References: <20080514000933.56adc131.akpm@linux-foundation.org>
	 <20080514155639.GB28594@kroah.com>
	 <20080514162442.GO9324@parisc-linux.org>
	 <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com>
	 <20080515090101.GA2915@darkstar.te-china.tietoenator.com>
	 <20080515115203.GH9921@parisc-linux.org>
	 <a8e1da0805170314v4253d01agc0d6f77438e27989@mail.gmail.com>
	 <a8e1da0805182220y23412047g4969e3906a4c5aca@mail.gmail.com>
	 <20080519102343.GB2638@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:33961 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbYETB2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 21:28:03 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1029121tic.23
        for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 18:27:59 -0700 (PDT)
In-Reply-To: <20080519102343.GB2638@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Mon, May 19, 2008 at 6:23 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Mon, May 19, 2008 at 01:20:33PM +0800, Dave Young wrote:
>> On Sat, May 17, 2008 at 6:14 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> > On 5/15/08, Matthew Wilcox <matthew@wil.cx> wrote:
>> >> On Thu, May 15, 2008 at 05:01:01PM +0800, Dave Young wrote:
>> >>> > The classes are different here, first sdev_class, then sg_sysfs_class
>> >>
>> >> Oh ... right.  I misread scsi_register_interface as
>> >> class_register_interface.
>> >>
>> >>> Greg, what about using mutex_lock_nested to silence lockdep? They are
>> >>> the only usage of class->mutex out of class.c
>> >>
>> >> I don't see how we prove that, for example, you can never take the
>> >> sg_sysfs_class mutex and then take the sdev_class mutex.
>> >
>> > Sorry for my delay. AFAIK, there's no this kind of use.
>
> The question isn't whether there is or isn't this kind of use right now.
> The question is whether there might be this kind of use in the future,
> and if there is, whether we'd like lockdep to warn us.

In the future, IMHO, the class_interface should go away just as
class_device. If that happened this problem would going away as well.

>
>> I rechecked the class_interface use, the users are scsi and pcmcia.
>>
>> The two classes could call device_add/del while doing
>> class_interface_register/unregister is :
>> sg_sysfs_class
>> pcmcia_socket_class
>>
>> So is it possible to reset their lock_class instead of do __mutex_init
>> for all classes?
>
> Again, it's not about current usage, it's about future usage.  Why do
> you want all sysfs classes to have the same lockdep class?  There can
> be good reasons.  For example, if two locks are conceptually the same,
> keeping them in the same class helps you find AB-BA problems earlier.
>
> Is there a reason you don't like my idea?

Your idea is good. But as I said above, for current situation there's
no potential problems except class_interface usage, and the
class_interface will go away
 in the future.

So IMO It's not necessary to do this for all classes.

Regards
dave
