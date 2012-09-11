From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 23:50:38 +0200
Message-ID: <504FB22E.4090707@redhat.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com> <20120911182904.GS7677@google.com> <504F88CB.6030105@redhat.com> <20120911191325.GU7677@google.com> <504F8FF0.3000408@redhat.com> <20120911200150.GV7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120911200150.GV7677@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

[Al: you can jump down to "One problem:"]

Il 11/09/2012 22:01, Tejun Heo ha scritto:
> Hello, Paolo.
> 
> On Tue, Sep 11, 2012 at 09:24:32PM +0200, Paolo Bonzini wrote:
>>> Couldn't it intercept some of them - e.g. RWs and discards?
>>> What's the benifit / use case of doing pure bypass?
>>
>> Basically, using the same storage technology for bare metal and
>> virtualized systems.  IMHO losing sense data is a no-no, but the above
>> solution could be feasible too.
> 
> Either way, with or without virtualization, making detailed error
> information to userland is a valid goal.  I *think* we're finally
> getting there after years of talking via structured printk.  I don't
> know much about the details but heard about exposing sense data via
> printk.

Wait wait, there is already a perfectly 1:1 solution for this, and it's
SG_IO.

I think error processing falls roughly in two categories: "I need each
command's precise state" and "I need to know if/when something bad
happens".  Luckily, I/O also falls roughly in the same two categories:
"I need precise control of each commands" and "I just care of getting
this to disk".  The former can use SG_IO, the latter can use logs.

So, let's not complicate the problem further.  We have a perfectly sane
API that (with different names) is even provided by almost every
operating system in existence.  There's just this little detail of
filtering that is done for unprivileged processes; I hoped to fix 50% of
the problem with this 3-line patch but it's not the end of the world if
it's rejected constructively.

The solution I outlined in my previous email:

>> Enabling/disabling the filters from a privileged
>> program and passing the unfiltered fd via SCM_RIGHTS would be enough.

would entail some userland coding, but nothing paramount at all (and
closer to my usual territory :)).  And we would have to do it anyway for
the reservations case.

Basically it would be a ioctl(fd, SG_SET_FILTER_ENABLED, arg) where arg
can be:

-1 for "enable/disable based on CAP_SYS_RAWIO" (default)
0 for always enable filter
1 for always disable filter

And also a dual ioctl(fd, SG_GET_FILTER_ENABLED, arg).

One problem: to do this, I need to access some "struct file" member in
SG_IO, and thus change the ioctl member from block_device/fmode to
block_device/file.   This would partially undo the 2007 switch from
inode/file by Al Viro.  He was already asked about it in
https://lkml.org/lkml/2012/6/12/414, let's try again here.

>>> Can't you make use of the existing disk events mechanism for that?
>>> Block layer already knows how to watch readiness of a device and tell
>>> the userland about it via uevent.
>>
>> How?  But anyway i don't want to divert the discussion from the actual
>> topic...
> 
> Disk events mechanism is there to watch (either via async notification
> or polling) media change and device readiness and generates the usual
> uevents when it detects them.  For sd devices, it basically issues TUR
> periodically, so it's already doing pretty much what you need.

Ah, no, we can't do that because the device should be opened with
O_EXCL.  It is not right now, but it's a bug.  It's not very different
from burning a CD (in fact, it's absolutely the same if you burn a CD
inside a guest :)).

> I guess the repeating question is whether to solve the problem within
> the framework the underlying OS is providing or having direct access
> to the raw hardware.  I don't know the answer.
> 
> Accessing the "raw" hardware does have its advantages but managing
> multiple users

In this case, the constraints pretty much guarantee that you have only
one user.  To stick with everyday hardware, if you pass your CD drive to
a guest you can well expect that the host will not be able to use it.

Or, if you have more than one user, that they know what they are doing
(reservations, etc.).

> I personally hope "raw" to be strictly confined to specific areas
> where performance impact of having kernel inbetween is prohibitive but
> that's just me hoping.

Well, it's not just about performance but also about precision sometimes.

Paolo
