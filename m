From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Thu, 24 Mar 2011 17:57:17 -0700
Message-ID: <AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	<20110207003455.27040.94947.stgit@localhost6.localdomain6>
	<20110318161852.GA19008@infradead.org>
	<AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
	<20110323084054.GA11533@infradead.org>
	<AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
	<20110323090824.GA14536@infradead.org>
	<AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
	<20110324062646.GA27051@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47003 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1CYA5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2011 20:57:19 -0400
Received: by fxm17 with SMTP id 17so613899fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2011 17:57:18 -0700 (PDT)
In-Reply-To: <20110324062646.GA27051@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Wed, Mar 23, 2011 at 11:26 PM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> On Wed, Mar 23, 2011 at 05:07:49PM -0700, Dan Williams wrote:
>> One of the fixes I made in that interim timer api cleanup (8d32e5b2)
>> was to use del_timer_sync on all pre-allocated timers to make sure
>> nothing fired or was in the process of firing as the driver was
>> brought down (unlikely). =A0The core runs under
>> spin_lock_irqsave(ihost->scic_lock) context, and the expectation is
>> that all these timeout callbacks are done in that context.
>
> I'm afraid that you'll have to fix that design mistake first. =A0Runn=
ing
> large amounts of code under a spinlock just is not a good idea for
> a wide range of reasons.

I have been waiting for this issue to be raised.  This was one of the
first items brought up in our internal reviews of the Linux driver.
Why does it still exist and what is the rationale for addressing it
incrementally?:

Starting with simple locking and then scaling it is arguably easier
than unwinding a more complex locking scheme implemented too early in
the design phase.  The lock synchronizes i/o submission against the
completion/event-queue.  When the event queue runs the state of the
world might change (phy, port, task context, remote node context), so
the lock is ensuring a self consistent view of the state machines for
new submissions.  Now that the core is a slower moving target (in
terms of code changes) we are incrementally peeling back / minimizing
the code run under the lock where it is found to be problematic.

I will say that in terms of lock overhead investigations one of things
that makes this lock heavier than it needs to be (irqs disabled) is
libata's need to hold host_lock over submissions.  That situation is
problematic for other reasons [1], and is something that has been in
the back of my mind since first evaluating isci locking.  I expect our
fast path locking overhead is on par with mvsas which holds an
irqs-disabled lock across the interrupt handler, and the entire
lldd_execute_task path.  The higher touch slow path cases, like SATA
exception / PIO handling, probably have similar overhead to libata's
locking, but yes this needs to quantified and addressed.

--
Dan

[1]: http://marc.info/?l=3Dlinux-scsi&m=3D129791105419577&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
