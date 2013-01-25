From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
Date: Fri, 25 Jan 2013 23:32:42 +0100
Message-ID: <5103080A.4090803@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com> <1359039649-17734-7-git-send-email-pbonzini@redhat.com> <20130124225555.GC2373@mtj.dyndns.org> <51024FB1.3000206@redhat.com> <20130125170434.GC3081@htj.dyndns.org> <5102BDD4.2020501@redhat.com> <20130125172805.GG3081@htj.dyndns.org> <5102C780.3090402@redhat.com> <20130125181326.GK3081@htj.dyndns.org> <5102D353.8010305@redhat.com> <20130125190154.GM3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130125190154.GM3081@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 25/01/2013 20:01, Tejun Heo ha scritto:
> Some did that at least in ATA.  It was mapping some command to
> firmware write.  Given how many USB devices implement SCSI these days,
> I wouldn't be too firm with "that doesn't happen".  How can such
> all-covering statement be asserted?

Of course it cannot be asserted.  In the same way as it cannot be
asserted that "no program will try to use a command".  It is just as
unsafe to keep a command in, as it is unsafe to keep a command out.

All you can do is use common sense, which says that if a command has
been in a standard, someone has likely used it.  Of course someone
_might_ have misused it too, but how likely is that?

To try and give an answer, I grepped the "unusual" drivers in
drivers/usb/storage.  All of them seem to use non-standard packets (i.e.
basically are not SCSI) for their strange stuff, except two:
initializers.c has one function that sends SCSI command 0xEC,
realtek_cr.c uses 0xF0, both vendor specific.  So USB firmware writers,
despite being known for tweaking SCSI standards in many ways, seem to be
sensible in this respect.

What about the likelihood that someone _used_ particular commands?  For
example, I know that REZERO UNIT (which has been obsolete for several
releases of the standard) is used in the wild because a patch to support
it was submitted to QEMU not long ago.  Some commands are indeed no-ops
or almost no-ops, or just too obscure to care (such as the two MMC
commands), so I wouldn't spend too much time to discuss them, but it
should be unnecessary if we stick to a principle that is logical and
generally applicable.  "Someone may have misused it" is not one.

>>> So, there are actual costs coming from exposing them, which is fine if
>>> the benefit can offset them enough, but what would be the benefit of
>>> exposing commands which aren't being used?
>>
>> If it is not used, nobody will use it and nothing will break.
> 
> I have to say that's an overly optimistic view of the world.  There
> are even devices puking on receiving SCSI commands in a slightly
> different sequence than windows sends them out and devices which lock
> up if you send them enough TURs.

If it is not used, nobody will use it and setting the bit is effectively
useless (but harmless too).

>>> , so that doesn't seem like
>>> that much of winning to me.  Discovering use cases is actually much
>>> easier than finding broken devices for some obscure commands.
>>
>> Not if many of your uses are proprietary (Windows, AIX on PPC, z/OS on
>> s390, Oracle, SAP, you name it).
> 
> You would get -EPERM/ACCES whatnot from base OS and you would know the
> command in use, no?

Yes, but I would like to avoid many iterations.  I don't have access
myself to all that software except Windows.

Paolo
