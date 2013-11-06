From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Date: Wed, 06 Nov 2013 14:30:40 -0500
Message-ID: <527A98E0.20601@interlog.com>
References: <52718713.7050906@interlog.com> <20131031155653.GA16944@infradead.org> <5272AD80.90203@interlog.com> <20131106155044.GA9323@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131106155044.GA9323@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, vaughan <vaughan.cao@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 13-11-06 10:50 AM, Christoph Hellwig wrote:
> On Thu, Oct 31, 2013 at 03:20:32PM -0400, Douglas Gilbert wrote:
>> Yes, it is being used as a mutex. However looking at
>> their semantics (mutex.h versus semaphore.h), a mutex
>> takes into account the task owner. If the user space
>> wants to pass around a sg file descriptor in a Unix
>> domain socket (see TLPI, Kerrisk) I don't see why the
>> sg driver should object (and pay the small performance
>> hit for each check).
>
> The sg driver won't object.  The lock is taken again and released
> during sg_open and sg_release, which are guranteed not to migrate
> to a different process during their run time.

True. What I stated would be a problem if a mutex tried
to do something similar to Vaughan's patch that was
reverted just before lk 3.12.0. That held a read or write
semaphore between a sg_open() and sg_release().

But your point begs the question why should any driver
pay the extra cost and usability restrictions of a kernel
mutex over a semaphore without good reason:

struct mutex {
         /* 1: unlocked, 0: locked, negative: locked, possible waiters */
         atomic_t                count;
         spinlock_t              wait_lock;
         struct list_head        wait_list;
#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
         struct task_struct      *owner;
#endif
         ....
};

struct semaphore {
         raw_spinlock_t          lock;
         unsigned int            count;
         struct list_head        wait_list;
};

Even the rw_semaphore structure is simpler than struct mutex.

Everything from smart phones up will have CONFIG_SMP set.

>> section) but why bother. Give me a simple mutex and
>> I'll use it.
>
> mutex_init/mutex_lock/mutex_unlock from <linux/mutex.h>

This from mutex.h :

  * - only one task can hold the mutex at a time
  * - only the owner can unlock the mutex
  * - multiple unlocks are not permitted
  * - recursive locking is not permitted
  * - a mutex object must be initialized via the API
  * - a mutex object must not be initialized via memset or copying
  * - task may not exit with mutex held
  * - memory areas where held locks reside must not be freed
  * - held mutexes must not be reinitialized
  * - mutexes may not be used in hardware or software interrupt
  *   contexts such as tasklets and timers

So what contexts can mutexes be used in? I wish the third
last item would not use the term "locks" when talking about
a mutex. If we switch or_sem to a mutex then memory areas
where the mutexes reside will be freed (but that mutex will
not be held at the time).

Also, which one in the above list tells me that sg_open()
cannot return to the caller with a mutex held? Given
the special relationship guaranteed by the OS (POSIX)
between sg_open() and sg_release() *** for the same file
handle, if this is not allowed, why?
The above question, only answered by kernel lock debugging
code complaints, is one reason why Vaugan's patch was
reverted prior to lk 3.12.0 .

And the other reason was that if his read-write semaphore
blocked a subsequent open() then that wait was not
interruptible. Well that is kernel flaw, where is the !@#$
down_interruptible(rw_sem) call??


The reported bugs against Vaughan's lk 3.12-rc patch are
interesting to analyse. The non-interruptible blocking
of sg_open() is the semantic change that caused real world
apps to fail IMO. That is a bit subtle for the testers
who turned on kernel lock debugging and concluded that
holding the read-write semaphore was wrong (because the
kernel debug complained about it).

One of those testers confirmed that my patch (an earlier
version of what is presented here) made his problem go
away.

>> Not (usually) in this case. The sdp->sfds list can only
>> be expanded by another sg_open(same_dev) but this has
>> been excluded by taking down(&sdp->or_sem) prior to that
>> call. The sdp->sfds list is only normally decreased by
>> sg_release() which is also excluded by down(&sdp->or_sem).
>
>> The abnormal case is device removal (detaching). Now an
>> open(same_dev, O_EXCL) may start waiting just after a
>> detach but miss the wake up on open_wait. That suggests
>> the wake_up(open_wait) in sg_remove() should also
>> take the sdp->or_sem semaphore.
>> Ah, and if sg_remove() can be called from an interrupt
>> context then that takes out using mutexes :-)
>
> I don't think that sg_remove can be called from irq context.
> It always is called through the class interface remove_dev
> method, which always is called under a lock.

This is an important piece of extra information. Does that
mean sg_add() and sg_remove() can't wait on anything? I note
that sg_add() calls sg_alloc() which immediately does:
   sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);


Here is the class_interface object for sg:

static struct class_interface sg_interface = {
         .add_dev        = sg_add,
         .remove_dev     = sg_remove,
};

Where are the preconditions from the scsi subsystem to a ULD
stating:
   - that sg_remove() and sg_add() are called from a non-interrupt,
     non tasklet and non timer context?
   - invocations of sg_add() and sg_remove() are paired in a
     similar fashion as sg_open() and sg_release()

By the second point I mean, for example, that sg_remove()
cannot be called twice for the same device without a sg_add()
between them to add (back) that device.

Thinking about sg_remove() I suspect it can be called from the:
   - user space: echo 1 > .../scsi_device/<hctl>/device/delete
   - the transport in the HBA unable to talk to the LU
   - a switch (e.g. SAS expander) via the transport in the HBA
   - the EH infrastructure
Shouldn't be any races there ...

>> The two level of locks in sg_remove() is already making me
>> uncomfortable, adding the sdp->or_sem semaphore to the
>> mix calls for more analysis.
>
> I would suggest to remove the list lock and only use the or_sem
> replacement.
>
>> IMO that is a bug in scsi_block_when_processing_errors()
>> and the down() is placed lower than it should be in
>> sg_open() to account for that bug.
>
> How about we get that fixed first?

Well we have a short window to get this into the lk 3.13
merge window after:
   - just missing the lk 3.11 merge window due to testing
     issues
   - getting into the lk 3.12 merge window only to be reverted
     at the death because patches to fix discovered problems
     were deemed too late

I now have some pretty thorough test programs (sg_tst_excl*)
available to anyone who wants to test this. This patch
passes so far (but I should try harder to break the detach
case). These tests demonstrate as far as O_EXCL is concerned:
   - the existing sg driver is broken (and slow in handling
     O_EXCL cases)
   - the bsg driver simply ignores O_EXCL so it works or is
     broken depending on your POV
   - the block layer is broken (e.g. on /dev/sda) with O_EXCL
     allowed to come in over non-O_EXCL open()s in some paths

Should I be looking at fixing the bsg and the block layer as well?
Speaking of the bsg driver does anyone know if Tomo is still
active, because the bsg driver has a pretty serious problem:
lack of file handle context.

Doug Gilbert


*** the OS (POSIX) guarantees that sg_release() will be called
     on all open file handles before a (user space) process is
     removed. This means that the mutex condition "task may not
     exit with mutex held" should not be violated as long as
     sg_release() takes the "hold" off that mutex which of course
     is what it would (should) do.
