From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] block subsystem refcounter conversions
Date: Mon, 20 Feb 2017 08:15:21 -0700
Message-ID: <5fd906c2-61ba-319c-1bc2-cb48b2b378b4@kernel.dk>
References: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Elena Reshetova <elena.reshetova@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com
List-Id: linux-scsi@vger.kernel.org

On 02/20/2017 04:16 AM, Elena Reshetova wrote:
> Now when new refcount_t type and API are finally merged
> (see include/linux/refcount.h), the following
> patches convert various refcounters in the block susystem from atomic_t
> to refcount_t. By doing this we prevent intentional or accidental
> underflows or overflows that can led to use-after-free vulnerabilities.
> 
> The below patches are fully independent and can be cherry-picked separately.
> Since we convert all kernel subsystems in the same fashion, resulting
> in about 300 patches, we have to group them for sending at least in some
> fashion to be manageable. Please excuse the long cc list.
> 
> Elena Reshetova (5):
>   block: convert bio.__bi_cnt from atomic_t to refcount_t
>   block: convert blk_queue_tag.refcnt from atomic_t to refcount_t
>   block: convert blkcg_gq.refcnt from atomic_t to refcount_t
>   block: convert io_context.active_ref from atomic_t to refcount_t
>   block: convert bsg_device.ref_count from atomic_t to refcount_t

I went to look at the implementation, and the size of a refcount_t.
But the code is not there?! You say it's finally merged, where is
it merged? Don't send code like this without the necessary
infrastructure being in mainline.

-- 
Jens Axboe
