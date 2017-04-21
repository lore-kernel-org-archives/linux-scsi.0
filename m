From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Fri, 21 Apr 2017 14:27:43 -0700
Message-ID: <1492810063.7079.56.camel@HansenPartnership.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
         <20170420135651.GA26595@infradead.org>
         <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
         <20170420183319.GB103004@gmail.com>
         <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
         <20170421195521.GE12755@gmail.com>
         <CAGXu5j+6Ffyx56j_ZmM0Y5j_A_TwssQdRVQ9hX=qTa482r1nvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+6Ffyx56j_ZmM0Y5j_A_TwssQdRVQ9hX=qTa482r1nvA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>, "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-04-21 at 13:22 -0700, Kees Cook wrote:
> On Fri, Apr 21, 2017 at 12:55 PM, Eric Biggers <ebiggers3@gmail.com> 
> wrote:
> > > > Of course, having extra checks behind a debug option is fine. 
> > > >  But they should not be part of the base feature; the base 
> > > > feature should just be mitigation of reference count
> > > > *overflows*.  It would be nice to do more, of
> > > > course; but when the extra stuff prevents people from using 
> > > > refcount_t for performance reasons, it defeats the point of the
> > > > feature in the first place.
> > > 
> > > Sure, but as I said above, I think the smaller tricks and fixes 
> > > won't be convincing enough, so their value is questionable.
> > 
> > This makes no sense, as the main point of the feature is supposed 
> > to be the security improvement.  As-is, the extra debugging stuff 
> > is actually preventing the security improvement from being adopted,
> > which is unfortunate.
> 
> We've been trying to handle the conflicting desires of those wanting
> very precise refcounting implementation and gaining the security
> protections. Ultimately, the best way forward seemed to be to first
> land the precise refcounting implementation, and start conversion
> until we ran into concerns over performance. Now, since we're here, 
> we can move forward with getting a fast implementation that provides 
> the desired security protections without too greatly messing with the
> refcount API.

But that's not what it really looks like.  What it looks like is
someone came up with a new API and is now intent on forcing it through
the kernel in about 500 patches using security as the hammer.

If we were really concerned about security first, we'd have fixed the
atomic overflow problem in the atomics and then built the precise
refcounting on that and tried to persuade people of the merits.

Why can't we still do this?  It looks like the overflow protection will
add only a couple of cycles to the atomics.  We can move the current
version to an unchecked variant which can be used either in truly
performance critical regions with no security implications or if
someone really needs the atomic to overflow.  From my point of view it
would give us the 90% case (security) and stop this endless argument
over the fast paths.  Subsystems which have already moved to refcount
would stay there and the rest get to evaluate a migration on the merits
of the operational utility.

James
