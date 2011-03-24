From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Wed, 23 Mar 2011 17:07:49 -0700
Message-ID: <AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	<20110207003455.27040.94947.stgit@localhost6.localdomain6>
	<20110318161852.GA19008@infradead.org>
	<AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
	<20110323084054.GA11533@infradead.org>
	<AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
	<20110323090824.GA14536@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61354 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab1CXAHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 20:07:50 -0400
Received: by fxm17 with SMTP id 17so7828678fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2011 17:07:49 -0700 (PDT)
In-Reply-To: <20110323090824.GA14536@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Wed, Mar 23, 2011 at 2:08 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
> On Wed, Mar 23, 2011 at 02:04:28AM -0700, Dan Williams wrote:
>> Not much beyond the defined semantics of cancel_delayed_work and
>> delayed_work_pending. =A0I was looking to eliminate the current open
>> coded equivalent functionality.
>
> What's the problem with del_timer_sync and timer_pending?

Actually none.  I mistakenly thought delayed_work_pending would return
true for executing work as well... so the only remaining benefit of
delayed_work over the timer api is flush_workqueue().

One of the fixes I made in that interim timer api cleanup (8d32e5b2)
was to use del_timer_sync on all pre-allocated timers to make sure
nothing fired or was in the process of firing as the driver was
brought down (unlikely).  The core runs under
spin_lock_irqsave(ihost->scic_lock) context, and the expectation is
that all these timeout callbacks are done in that context.  As a
result we can't call del_timer_sync from the core to cancel a timer
because that might deadlock on a timer event that is spinning on the
lock.  Instead we need to set a "cancelled" flag that the timer
callback will evaluate while holding the lock to check if it was
cancelled while wait to acquire.  I was thinking
"!delayed_work_pending()" could stand-in for "cancelled", but it
can't.

So we need a different "flush all pending events" mechanism once the
timers are no longer globally allocated, and that's why I suggested
delayed_work.  The core will have called cancel_delayed_work on all
pending items.

>> I also want to get rid of the pre-allocation, which I assume was the
>> reason for the original comment?
>
> The preallocation is even more pointless. =A0Just embedd the struct
> timer_list where the code currently has a pointer to the timer object=
=2E

Exactly.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
