From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Date: Sat, 02 Nov 2013 14:22:27 -0400
Message-ID: <527542E3.7090809@interlog.com>
References: <52718713.7050906@interlog.com> <20131031155653.GA16944@infradead.org> <5272AD80.90203@interlog.com> <5273391C.2010705@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5273391C.2010705@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-kernel <linux-kernel@vger.kernel.org>, =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
List-Id: linux-scsi@vger.kernel.org

On 13-11-01 01:16 AM, vaughan wrote:
> On 11/01/2013 03:20 AM, Douglas Gilbert wrote:
>> On 13-10-31 11:56 AM, Christoph Hellwig wrote:
>>>> +    struct semaphore or_sem;  /* protect co-incident opens and
>>>> releases */
>>>
>>> Seems like this should be a mutex.
>>
>> Yes, it is being used as a mutex. However looking at
>> their semantics (mutex.h versus semaphore.h), a mutex
>> takes into account the task owner. If the user space
>> wants to pass around a sg file descriptor in a Unix
>> domain socket (see TLPI, Kerrisk) I don't see why the
>> sg driver should object (and pay the small performance
>> hit for each check).
>>
>> A nasty side effect of a mutex taking into account the
>> task owner is that it can't be used in interrupt
>> context. My patch does not try to do that yet (see next
>> section) but why bother. Give me a simple mutex and
>> I'll use it.
>>
>>>> sfds_list_empty(Sg_device *sdp)
>>>>    {
>>>>        unsigned long flags;
>>>>        int ret;
>>>>
>>>> +    spin_lock_irqsave(&sdp->sfd_lock, flags);
>>>> +    ret =3D list_empty(&sdp->sfds);
>>>> +    spin_unlock_irqrestore(&sdp->sfd_lock, flags);
>>>>        return ret;
>>>
>>> Protecting just a list_empty check with a local will give you racy
>>> results.  Seems like you should take the look over the check and th=
e
>>> resulting action that modifies the list.  That'd also mean replacin=
g the
>>> wait_event* calls with open coded prepare_wait / finish_wait loops.
>>
>> Not (usually) in this case. The sdp->sfds list can only
>> be expanded by another sg_open(same_dev) but this has
>> been excluded by taking down(&sdp->or_sem) prior to that
>> call. The sdp->sfds list is only normally decreased by
>> sg_release() which is also excluded by down(&sdp->or_sem).
>>
>> The abnormal case is device removal (detaching). Now an
>> open(same_dev, O_EXCL) may start waiting just after a
>> detach but miss the wake up on open_wait. That suggests
>> the wake_up(open_wait) in sg_remove() should also
>> take the sdp->or_sem semaphore.
>> Ah, and if sg_remove() can be called from an interrupt
>> context then that takes out using mutexes :-)
>>
>> The two level of locks in sg_remove() is already making me
>> uncomfortable, adding the sdp->or_sem semaphore to the
>> mix calls for more analysis.
> CCed to J=C3=B6rn Engel.
>
> I feel the same regarding the many locks. After reviewing patches I
> wrote these days, I suppose the version 2
> (https://lkml.org/lkml/2013/6/17/319) may worth a re-consideration so=
mehow.
> The purpose of or_sem is to mutex co-incident open and allow only one
> thread to be processing since it completes checking condition to real=
ly
> linking a new sfd into sfd_siblings list. My v2 re-implement a sem us=
ing
> sfd_lock and toopen. But as J=C3=B6rn pointed out in the following ma=
il, what
> I implemented is a rw_sem and that is weird and made him "having trou=
ble
> wrapping my head around the semantics of this variable"...
> With wait_event involved, it's indeed no sense to use a rw_sem here.
> However, if we restrict toopen in [0, 1], not [0, INT_MAX] as I did i=
n
> v2, it will act in the same way as or_sem does. Beside the same affec=
t
> as or_sem, this implement avoids the problem using in interrupt conte=
xt
> and more readable for me, rather than twisting my head among many
> spinlocks and semaphores.
> Although v2 seems attractive to me, things would be more complicated
> when detached comes in...
>
> The following is a thought I presented previously:
> Is it possible to split the sg_add_sfp() into two
> functions, sg_init_sfp() and sg_add_sfp2(). We can do all initialize
> work in sg_init_sfp()
> without any lock and let sg_add_sfp2() only serve lock-check-add in o=
ne
> place. It is less flaky.

I do not follow the last point but that is not important.


=46or reasons that I listed in a private post I think
that my patch presented in this thread is closer to
our goals than your patch (2013/6/17/319). Timing is
important as well since we are approaching the lk 3.13
merge window. Regressions are what will set us back.


The remaining flaws are in the detach device area
which always seems to be the last one worked on,
probably because it is uncommon and the hardest :-)
My test code hasn't broken this area with my latest
patch (but that may be just luck or not good enough
test strategies).

Also the ULDs should get some basic guarantees from
the mid-level about the attach and remove/detach
device functions. I was thinking along the lines of
"called once and only once" per removed device; won't
overlap with an attach for the same device; may be
called from an interrupt context; should not wait,
etc.

>> Also note that sdp->detached is only protected by a
>> volatile type modifier and checks on it are sprinkled
>> around the code in a rather unscientific way.
>>
>> As you are no doubt aware, handling the "surprise" device
>> removal case safely is hard, very hard. And I have tried
>> to test this, loading up 4 processes with 100 tasks each,
>> some with asynchronous queueing requests but most hanging
>> on an open_wait then remove the device. So far I have not
>> seen a hang. Again, somebody with a big machine and
>> patience might like to try a scaled up device removal test
>> to see what breaks.
>>
>>>> +    down(&sdp->or_sem);
>>>> +    alone =3D sfds_list_empty(sdp);
>>>> +    if ((flags & O_EXCL) && (O_RDONLY =3D=3D (flags & O_ACCMODE))=
) {
>>>> +        retval =3D -EPERM; /* Don't allow O_EXCL with read only
>>>> access */
>>>> +        goto error_out;
>>>> +    }
>>>
>>> Seems like the pure flags check should move to the beginning of the
>>> function before taking any locks.
>>
>> As Vaughan pointed out, just prior to that down() is a call
>> scsi_block_when_processing_errors() for blocking open()s.
>
> Douglas,
> What Christoph points out is a sanity check for the input parameter
> flags, not the scsi_block_when_processing_errors issue.
> I guess you misread that:)

Yes, you are correct I misread the above. That test can go
to the top of sg_open() without harm and make the critical
code sections easier to follow. IMO not a show stopper.

Doug Gilbert
