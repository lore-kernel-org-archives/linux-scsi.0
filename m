From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
Date: Sat, 26 Jan 2013 00:32:36 +0100
Message-ID: <51031614.8000609@redhat.com>
References: <20130124225555.GC2373@mtj.dyndns.org> <51024FB1.3000206@redhat.com> <20130125170434.GC3081@htj.dyndns.org> <5102BDD4.2020501@redhat.com> <20130125172805.GG3081@htj.dyndns.org> <5102C780.3090402@redhat.com> <20130125181326.GK3081@htj.dyndns.org> <5102D353.8010305@redhat.com> <20130125190154.GM3081@htj.dyndns.org> <5103080A.4090803@redhat.com> <20130125224159.GQ3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130125224159.GQ3081@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 25/01/2013 23:41, Tejun Heo ha scritto:
> Hello, Paolo.
> 
> On Fri, Jan 25, 2013 at 11:32:42PM +0100, Paolo Bonzini wrote:
>> All you can do is use common sense, which says that if a command has
>> been in a standard, someone has likely used it.  Of course someone
>> _might_ have misused it too, but how likely is that?
> 
> So, that's where we differ, I guess.  When it comes to hardware
> devices, especially the ones as widely and cheaply deployed as SCSI or
> ATA, my common sense screams to stick to what's known to work and
> don't venture outside unnecessarily.

I understand, but you should also consider the likelihood of the various
choices.  We do have a list of quirks, and they all seem to be about
regular stuff like off-by-one errors with weird outcomes, not about "the
firmware writer gave random meanings to known commands".

You're also missing another point I made.  Userspace is explicitly
asking for trouble in using SG_IO, and must deal with the consequences.
 If the trouble is big, we should work around it anyway.  If the trouble
is small, we need not worry about it.

Check how many "quirks" are in a typical burning program.  Does that
mean that we should remove burning commands from the whitelist?  Of
course not.

>> To try and give an answer, I grepped the "unusual" drivers in
>> drivers/usb/storage.  All of them seem to use non-standard packets (i.e.
>> basically are not SCSI) for their strange stuff, except two:
>> initializers.c has one function that sends SCSI command 0xEC,
>> realtek_cr.c uses 0xF0, both vendor specific.  So USB firmware writers,
>> despite being known for tweaking SCSI standards in many ways, seem to be
>> sensible in this respect.
> 
> You're grepping for known irregularities which need to be used to make
> the device work.

Of course I did, you were talking about "weird init code to select some
mode" and I went looking for how they look like in the real world.

> Just read through, say, sd driver code and see how
> hard it tries to stick to what's known to work rather than venturing
> out to the space allowed by the spec.

That's a different story, once userspace uses SG_IO it takes the burden
of doing this.

> The default approach in this area definitely is and should be
> conservative in general.

Userspace of course must be written with care, too.

>> If it is not used, nobody will use it and setting the bit is effectively
>> useless (but harmless too).
> 
> No, we don't know it's gonna be harmless.  How do we *know* that
> outside of the naive expectation that devices are gonna safely and
> sanely ignore things that they don't understand?

First of all, we have a misunderstanding.  I wrote "it is not used", and
I included _everything_ in that, even malware.  In that case, it's a
tautology that it's useless and harmless.

Now, nobody asked about sane error handling.  I have a USB pen drive
that returns a Unit Attention code for any command it does not
recognize.  Does the existence of that USB pen drive mean that we should
remove MODE SENSE from the whitelist?  Of course not.  We just pass the
errors to userspace, and userspace deals with them.

In fact, even for safety we can only go so far.  Other firmwares crash
if you read/write a block that is out of range.  Should we remove
READ/WRITE from the whitelist?  Of course not.  We handle that as a
quirk in the USB driver.

I think the latter case can be generalized.  Let's assume that there is
a bad guy that goes around and wants to brick your disk.  It would not
be a very smart thing to do, just like Ebola is not a very smart virus,
but the world is full of strange people and he is just one of them.

If a particular firmware can brick a device from userspace with a
particular sequence of innocuous-looking (and non-vendor-specific)
commands, I believe that the kernel should have a workaround to protect
against that, independent of the privileges needed to send the commands
to begin with.  This means that it is irrelevant to use these cases to
exclude commands from a whitelist.  Independent of the fact that neither
the weird guy nor the weird firmwares have been shown to exist.

>>> You would get -EPERM/ACCES whatnot from base OS and you would know the
>>> command in use, no?
>>
>> Yes, but I would like to avoid many iterations.  I don't have access
>> myself to all that software except Windows.
> 
> I don't think it's gonna be that many iterations and would much prefer
> doing several iterations and having the backing data for each command
> added.

If I make a whitelist with all the commands that Linux sends, I'll have
many new commands in the whitelist and no old commands.  The new
commands didn't exist when old drives were sold, so they are "dangerous"
in your opinion.  At that point I might as well keep the whitelist
empty, no?

(Which BTW is what James proposed and I wrote the patch for, but you
rejected: make the whitelist entirely configurable in userspace, and add
a Kconfig option that makes the default whitelist very very small).

Paolo
