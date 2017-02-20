From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/5] block subsystem refcounter conversions
Date: Mon, 20 Feb 2017 09:24:06 -0800
Message-ID: <1487611446.2337.19.camel@HansenPartnership.com>
References: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
         <5fd906c2-61ba-319c-1bc2-cb48b2b378b4@kernel.dk>
         <1487605261.2337.4.camel@HansenPartnership.com>
         <20170220165639.GE6515@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20170220165639.GE6515@twins.programming.kicks-ass.net>
Sender: linux-btrfs-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Elena Reshetova <elena.reshetova@intel.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-02-20 at 17:56 +0100, Peter Zijlstra wrote:
> On Mon, Feb 20, 2017 at 07:41:01AM -0800, James Bottomley wrote:
> > On Mon, 2017-02-20 at 08:15 -0700, Jens Axboe wrote:
> > > On 02/20/2017 04:16 AM, Elena Reshetova wrote:
> > > > Now when new refcount_t type and API are finally merged
> > > > (see include/linux/refcount.h), the following
> > > > patches convert various refcounters in the block susystem from 
> > > > atomic_t to refcount_t. By doing this we prevent intentional or
> > > > accidental underflows or overflows that can led to use-after
> > > > -free vulnerabilities.
> > 
> > This description isn't right ... nothing is prevented; we get 
> > warnings on saturation and use after free with this.
> 
> The thing that is prevented is overflow and then a use-after-free by
> making it a leak.
> 
> Modular stuff, you put and free at: (n+1) mod n, by saturating at n-1
> we'll never get there.
> 
> So you loose use-after-free, you gain a resource leak. The general 
> idea being that use-after-free is a nice trampoline for exploits, 
> leaks are 'only' a DoS.

OK, I see the intention: it's protection from outside influence.  It
still doesn't prevent *us* from screwing up in the kernel and inducing
a use after free by doing too many puts (or too few gets) ... that's
what the message suggests to me (me coding wrongly is accidental
underflows or overflows as I read it).

James

