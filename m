From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/5] block subsystem refcounter conversions
Date: Mon, 20 Feb 2017 07:41:01 -0800
Message-ID: <1487605261.2337.4.camel@HansenPartnership.com>
References: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
         <5fd906c2-61ba-319c-1bc2-cb48b2b378b4@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5fd906c2-61ba-319c-1bc2-cb48b2b378b4@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Elena Reshetova <elena.reshetova@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-02-20 at 08:15 -0700, Jens Axboe wrote:
> On 02/20/2017 04:16 AM, Elena Reshetova wrote:
> > Now when new refcount_t type and API are finally merged
> > (see include/linux/refcount.h), the following
> > patches convert various refcounters in the block susystem from 
> > atomic_t to refcount_t. By doing this we prevent intentional or 
> > accidental underflows or overflows that can led to use-after-free
> > vulnerabilities.

This description isn't right ... nothing is prevented; we get warnings
on saturation and use after free with this.

> > The below patches are fully independent and can be cherry-picked 
> > separately. Since we convert all kernel subsystems in the same 
> > fashion, resulting in about 300 patches, we have to group them for 
> > sending at least in some fashion to be manageable. Please excuse
> > the long cc list.
> > 
> > Elena Reshetova (5):
> >   block: convert bio.__bi_cnt from atomic_t to refcount_t
> >   block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
> >   block: convert blkcg_gq.refcnt from atomic_t to refcount_t
> >   block: convert io_context.active_ref from atomic_t to refcount_t
> >   block: convert bsg_device.ref_count from atomic_t to refcount_t
> 
> I went to look at the implementation, and the size of a refcount_t.
> But the code is not there?! You say it's finally merged, where is
> it merged? Don't send code like this without the necessary
> infrastructure being in mainline.

It's one of those no discussion except notice by tipbot things because
Ingo liked it.

The size is atomic_t, but the primitives check for overflow and check
inc from zero and things, so in a true refcounting situation we get
automatic warnings of problems inside the primitives.

That said, if we were going to convert the block layer to this
semantic, surely the benefit of the conversion would be getting rid of
the now unnecessary BUG_ON and WARN_ON in the code, which do exactly
the same thing the refcount primitives now do?

James
