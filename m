From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Mon, 19 May 2008 15:56:28 +0800
Message-ID: <a8e1da0805190056r1f1e8462rabee33e56c72722@mail.gmail.com>
References: <20080514000933.56adc131.akpm@linux-foundation.org>
	 <20080514155639.GB28594@kroah.com>
	 <20080514162442.GO9324@parisc-linux.org>
	 <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com>
	 <20080515090101.GA2915@darkstar.te-china.tietoenator.com>
	 <20080515115203.GH9921@parisc-linux.org>
	 <a8e1da0805170314v4253d01agc0d6f77438e27989@mail.gmail.com>
	 <a8e1da0805182220y23412047g4969e3906a4c5aca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:62880 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYESH4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 03:56:30 -0400
Received: by ti-out-0910.google.com with SMTP id b6so750777tic.23
        for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 00:56:28 -0700 (PDT)
In-Reply-To: <a8e1da0805182220y23412047g4969e3906a4c5aca@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Mon, May 19, 2008 at 1:20 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Sat, May 17, 2008 at 6:14 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> On 5/15/08, Matthew Wilcox <matthew@wil.cx> wrote:
>>> On Thu, May 15, 2008 at 05:01:01PM +0800, Dave Young wrote:
>>>> > The classes are different here, first sdev_class, then sg_sysfs_class
>>>
>>> Oh ... right.  I misread scsi_register_interface as
>>> class_register_interface.
>>>
>>>> Greg, what about using mutex_lock_nested to silence lockdep? They are
>>>> the only usage of class->mutex out of class.c
>>>
>>> I don't see how we prove that, for example, you can never take the
>>> sg_sysfs_class mutex and then take the sdev_class mutex.
>>
>> Sorry for my delay. AFAIK, there's no this kind of use.
>>>
>>> There aren't /that/ many classes in the kernel (my laptop has 33 in
>>> /sys/class).  How about we make each (sysfs) class its own (lockdep)
>>> class?  That way we let lockdep do its job rather than telling it "nah,
>>> you're all right, this is good".
>>>
>>> I don't have a copy of the sem->mutex conversion to hand, but I imagine
>>> you want to do something like:
>>>
>>>  - Add a struct lock_class_key to struct class
>>>  - In drivers/base/class.c use __mutex_init instead of mutex_init
>>>
>>> I think that should be enough ...
>>
>> Yes, it's safer than mutex_lock_nested.  If you all have no objection
>> I can do the fix like this.
>>
>
> I rechecked the class_interface use, the users are scsi and pcmcia.
>
> The two classes could call device_add/del while doing
> class_interface_register/unregister is :
> sg_sysfs_class
> pcmcia_socket_class
>
> So is it possible to reset their lock_class instead of do __mutex_init
> for all classes?
>

Like this?

1) Add macro :
+#define class_reclassify(class) \
+do { \
+       static struct lock_class_key    class_key; \
+       lockdep_set_class_and_name(&(class)->mutex, &class_key, \
+                                (class)->name); \
+} while (0)

2) Then in sg.c:
 class_reclassify(sg_sysfs_class);

3) And in pcmcia/cs.c
class_reclassify(&pcmcia_socket_class);

I have built and boot tested the patch, but due to connecting gmail
smtp failed so I cant send it via mutt today.
