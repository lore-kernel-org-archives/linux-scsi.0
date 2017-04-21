From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Fri, 21 Apr 2017 12:55:21 -0700
Message-ID: <20170421195521.GE12755@gmail.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org>
 <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
 <20170420183319.GB103004@gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>, "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

Hi Elena,

On Fri, Apr 21, 2017 at 10:55:29AM +0000, Reshetova, Elena wrote:
> > 
> > At the very least, what is there now could probably be made about twice as fast
> > by removing the checks that don't actually help mitigate refcount overflow bugs,
> > specifically all the checks in refcount_dec(), and the part of refcount_inc()
> > where it doesn't allow incrementing a 0 refcount.  Hint: if a refcount is 0, the
> > object has already been freed, so the attacker will have had the opportunity to
> > allocate it with contents they control already.
> 
> refcount_dec() is used very little through the code actually, it is more like an exception
> case since in order to use it one must really be sure that refcounter doesn't drop to zero.
> Removing the warn around it wouldn't likely affect much overall and thus it is better to
> stay to discourage people of API itself :)
> 
> refcount_inc() is of course a different story, it is extensively used. I guess the perf issue
> on checking increment from zero might only come from WARNs being printed,
> but not really from an additional check here for zero since it is trivial and part of
> the needed loop anyway. So, I think only removing the
> WARNs might have any visible impact, but even this is probably not really that big. 
> 
> So, I think these changes won't really help adoption of interface if arguments against
> is performance. If we do have a performance issue, I think arch. specific implementation
> is likely the only way to considerably speed it up. 

I should have used refcount_dec_and_test() as the example, as the same applies
to both refcount_dec() and refcount_dec_and_test().  There is negligible
security benefit to have these refcount release operations checked vs. just
calling through to atomic_dec() and atomic_dec_and_test().  It's unfortunate,
but there is no known way to detect ahead of time (i.e. before exploitation) if
there are too many refcount releases, only too many refcount acquires.

The WARN is only executed if there is a bug, so naturally it's only a problem if
the functions are to be inlined, creating bloat.  The actual performance problem
is the overhead associated with using comparisons and cmpxchg's to avoid
changing a refcount that is 0 or UINT_MAX.  The more efficient approach would be
to (a) drop the check for 0, and (b) don't require full operation to be atomic,
but rather do something like "lock incl %[counter]; js <handle_error>".  Yes
it's not "atomic", and people have complained about this, but there is no
technical reason why it needs to be atomic.  Attackers do *not* care whether
your exploit mitigation is theoretically "atomic" or not, they only care whether
it works or not.  And besides, it's not even "atomic_t" anymore, it's
"refcount_t".  

> > Of course, having extra checks behind a debug option is fine.  But they should
> > not be part of the base feature; the base feature should just be mitigation of
> > reference count *overflows*.  It would be nice to do more, of course; but when
> > the extra stuff prevents people from using refcount_t for performance reasons,
> > it defeats the point of the feature in the first place.
> 
> Sure, but as I said above, I think the smaller tricks and fixes won't be convincing enough,
> so their value is questionable. 

This makes no sense, as the main point of the feature is supposed to be the
security improvement.  As-is, the extra debugging stuff is actually preventing
the security improvement from being adopted, which is unfortunate.

- Eric
