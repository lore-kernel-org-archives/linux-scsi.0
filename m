From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Fri, 21 Apr 2017 10:11:45 -0700
Message-ID: <CAGXu5jLZPZTykVd4VOgU1d+BpUCnnDC9gYdF6mbnRp+9b4ZMPg@mail.gmail.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org> <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
 <20170420183319.GB103004@gmail.com> <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "peterz@infradead.org" <peterz@infradead.org>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>, "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 21, 2017 at 3:55 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> On Thu, Apr 20, 2017 at 11:33 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
>> Of course, having extra checks behind a debug option is fine.  But they should
>> not be part of the base feature; the base feature should just be mitigation of
>> reference count *overflows*.  It would be nice to do more, of course; but when
>> the extra stuff prevents people from using refcount_t for performance reasons,
>> it defeats the point of the feature in the first place.
>
> Sure, but as I said above, I think the smaller tricks and fixes won't be convincing enough,
> so their value is questionable.
>
>> I strongly encourage anyone who has been involved in refcount_t to experiment
>> with removing a reference count decrement somewhere in their kernel, then trying
>> to exploit it to gain code execution.  If you don't know what you're trying to
>> protect against, you will not know which defences work and which don't.
>
> Well, we had successful CVEs and even exploits on this in the past.
> @Kees, do you store a list of them in the project?

Here are two from last year:
http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/
http://cyseclabs.com/page?n=02012016

I don't disagree with Eric on the threat model: the primary concern
for reference count protection is the overflow condition. Detecting a
prior use-after-free is certainly nice to have, but the more important
case is the initial overflow.

How about we introduce something like CONFIG_HAVE_ARCH_FAST_REFCOUNT_T
for per-arch implementations and CONFIG_FAST_REFCOUNT_T that trades
coverage for speed, and checks only the overflow condition. This gets
us the critical coverage without the changes in performance. This is
basically what PaX/grsecurity already did: there is a tiny change to
the atomic inc functions to detect the wrap.

-Kees

-- 
Kees Cook
Pixel Security
