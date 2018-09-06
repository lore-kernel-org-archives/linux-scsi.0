From: Xuewei Zhang <xueweiz@google.com>
Subject: Re: [PATCH] scsi: sd: Contribute to randomness when running
 rotational device
Date: Thu, 6 Sep 2018 16:03:21 -0700
Message-ID: <CAPtwhKoFE-eZcRkvhpJgyutGK91ZouwSjTRb-cwHLQjBkriksw@mail.gmail.com>
References: <20180906203719.209399-1-xueweiz@google.com> <1536272873.26747.11.camel@acm.org>
 <20180906224210.GK5098@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906224210.GK5098@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, bvanassche@acm.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, ming.lei@redhat.com, hare@suse.de, hch@lst.de, pbonzini@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aditya Kali <adityakali@google.com>, groeck@chromium.org, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 6, 2018 at 3:42 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Thu, Sep 06, 2018 at 03:27:53PM -0700, Bart Van Assche wrote:
> >
> > Although this patch looks fine to me, seeing this patch makes me wonder
> > whether the default should be changed (QUEUE_FLAG_MQ_DEFAULT) instead of
> > modifying the sd driver. Can anyone remind me why QUEUE_FLAG_MQ_DEFAULT does
> > not include QUEUE_FLAG_ADD_RANDOM?

Besides Ted's point of "SSD users have no entropy", I think there are two more
reasons:
1. setting QUEUE_FLAG_ADD_RANDOM has a more visible performance hit
on SSD disks than rotational disks.
2. SSD disks provide less entropy than rotational disks.
I actually experimented on Container-Optimized OS, running on Google Compute
Engine with QUEUE_FLAG_ADD_RANDOM set.
Turns out the VM will have ~800 bit of entropy provided on boot on
rotational disk;
and will only have ~70 bit of entropy if running on SSD (and remember there are
~50 bit contributed from other sources).
(in the above experiment, both disks were virtualized disks)

>
> There was a discussion about a number of *years* ago; blk-mq has been
> baking for a very long time.  In the early days of block_mq, the
> overwhelming percentage of the users of blk-mq where those who were
> using PCIe attached flash.  So when, I raised this question, the
> argument was that SSD users have no entropy.  Which I agree with; but
> now that blk-mq is the default, and hard drives are using blk-mq, it's
> time for a patch like Xuewei's.
>
> Cheers,
>
>                                         - Ted
