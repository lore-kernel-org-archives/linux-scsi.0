From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Fri, 21 Apr 2017 10:55:29 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org>
 <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
 <20170420183319.GB103004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20170420183319.GB103004@gmail.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>, "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

> Hi Elena,
> 
> On Thu, Apr 20, 2017 at 04:10:16PM +0000, Reshetova, Elena wrote:
> >
> > > All the objections from DaveM on the amount of cycles spent on the
> > > new refcount_t apply to the block layer fast path operations as well.
> >
> > Ok, could you please indicate the correct way to measure the impact for the
> block layer?
> > We can do the measurements.
> >
> > Best Regards,
> > Elena.
> >
> > >
> > > Please don't send any more conversions until those have been resolved.
> 
> Like I suggested months ago, how about doing an efficient implementation of
> refcount_t which doesn't use the bloated cmpxchg loop?  Then there would be
> no
> need for endless performance arguments.  In fact, in PaX there are already
> example implementations for several architectures.  It's unfortunate that
> they're still being ignored for some reason.

Providing efficient arch. specific implementation for refcount_t is likely the next step
to make performance-sensitive places happy. However, in order to do it, we will need
to measure for each subsystem a) current atomic_t usage - base measurement 
b) pure refcount_t usage impact
c) arch. specific refcount_t impact 

Otherwise I have a chicken and egg problem here: people want better performance
and want to see arch. specific code for this, but in order to convince maintainer
in need of arch. specific code, I need to show that we do have indeed a performance issue. 

So, that's why I was endlessly asking for each subsystem that said that pointed out 
performance reasons to give hints on what should be measured. 
This way we can come back with real numbers (including for arch. specific implement) and
then decide what makes the most sense. 

> 
> At the very least, what is there now could probably be made about twice as fast
> by removing the checks that don't actually help mitigate refcount overflow bugs,
> specifically all the checks in refcount_dec(), and the part of refcount_inc()
> where it doesn't allow incrementing a 0 refcount.  Hint: if a refcount is 0, the
> object has already been freed, so the attacker will have had the opportunity to
> allocate it with contents they control already.

refcount_dec() is used very little through the code actually, it is more like an exception
case since in order to use it one must really be sure that refcounter doesn't drop to zero.
Removing the warn around it wouldn't likely affect much overall and thus it is better to
stay to discourage people of API itself :)

refcount_inc() is of course a different story, it is extensively used. I guess the perf issue
on checking increment from zero might only come from WARNs being printed,
but not really from an additional check here for zero since it is trivial and part of
the needed loop anyway. So, I think only removing the
WARNs might have any visible impact, but even this is probably not really that big. 

So, I think these changes won't really help adoption of interface if arguments against
is performance. If we do have a performance issue, I think arch. specific implementation
is likely the only way to considerably speed it up. 

> 
> Of course, having extra checks behind a debug option is fine.  But they should
> not be part of the base feature; the base feature should just be mitigation of
> reference count *overflows*.  It would be nice to do more, of course; but when
> the extra stuff prevents people from using refcount_t for performance reasons,
> it defeats the point of the feature in the first place.

Sure, but as I said above, I think the smaller tricks and fixes won't be convincing enough,
so their value is questionable. 

> 
> I strongly encourage anyone who has been involved in refcount_t to experiment
> with removing a reference count decrement somewhere in their kernel, then
> trying
> to exploit it to gain code execution.  If you don't know what you're trying to
> protect against, you will not know which defences work and which don't.

Well, we had successful CVEs and even exploits on this in the past. 
@Kees, do you store a list of them in the project?

What do you actually want to verify? The fact that if you manage to create use-after-free
situation, you are able to take advantage of it? 

Best Regards,
Elena.

> 
> - Eric
