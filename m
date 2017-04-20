From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Thu, 20 Apr 2017 11:33:19 -0700
Message-ID: <20170420183319.GB103004@gmail.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org>
 <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36194 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946266AbdDTSdX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 14:33:23 -0400
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>, "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>

Hi Elena,

On Thu, Apr 20, 2017 at 04:10:16PM +0000, Reshetova, Elena wrote:
> 
> > All the objections from DaveM on the amount of cycles spent on the
> > new refcount_t apply to the block layer fast path operations as well.
> 
> Ok, could you please indicate the correct way to measure the impact for the block layer? 
> We can do the measurements. 
> 
> Best Regards,
> Elena.
> 
> > 
> > Please don't send any more conversions until those have been resolved.

Like I suggested months ago, how about doing an efficient implementation of
refcount_t which doesn't use the bloated cmpxchg loop?  Then there would be no
need for endless performance arguments.  In fact, in PaX there are already
example implementations for several architectures.  It's unfortunate that
they're still being ignored for some reason.

At the very least, what is there now could probably be made about twice as fast
by removing the checks that don't actually help mitigate refcount overflow bugs,
specifically all the checks in refcount_dec(), and the part of refcount_inc()
where it doesn't allow incrementing a 0 refcount.  Hint: if a refcount is 0, the
object has already been freed, so the attacker will have had the opportunity to
allocate it with contents they control already.

Of course, having extra checks behind a debug option is fine.  But they should
not be part of the base feature; the base feature should just be mitigation of
reference count *overflows*.  It would be nice to do more, of course; but when
the extra stuff prevents people from using refcount_t for performance reasons,
it defeats the point of the feature in the first place.

I strongly encourage anyone who has been involved in refcount_t to experiment
with removing a reference count decrement somewhere in their kernel, then trying
to exploit it to gain code execution.  If you don't know what you're trying to
protect against, you will not know which defences work and which don't.

- Eric
