From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
Date: Mon, 16 Aug 2010 15:02:03 -0400
Message-ID: <20100816190203.GA22299@redhat.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
 <1281977523-19335-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281977523-19335-6-git-send-email-tj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Tejun Heo <tj@kernle.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 16 2010 at 12:52pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> From: Tejun Heo <tj@kernle.org>
> 
> This patch converts dm to support REQ_FLUSH/FUA instead of now
> deprecated REQ_HARDBARRIER.

What tree does this patch apply to?  I know it doesn't apply to
v2.6.36-rc1, e.g.: http://git.kernel.org/linus/708e929513502fb0

> For bio-based dm,
...
> * -EOPNOTSUPP retry logic dropped.

That logic wasn't just about retries (at least not in the latest
kernel).  With commit 708e929513502fb0 the -EOPNOTSUPP checking also
serves to optimize the barrier+discard case (when discards aren't
supported).

> For request-based dm,
> 
> * Nothing much changes.  It just needs to handle FLUSH requests as
>   before.  It would be beneficial to advertise FUA capability so that
>   it can propagate FUA flags down to member request_queues instead of
>   sequencing it as WRITE + FLUSH at the top queue.

Can you expand on that TODO a bit?  What is the mechanism to propagate
FUA down to a DM device's members?  I'm only aware of propagating member
devices' features up to the top-level DM device's request-queue (not the
opposite).

Are you saying that establishing the FUA capability on the top-level DM
device's request_queue is sufficient?  If so then why not make the
change?

> Lightly tested linear, stripe, raid1, snap and crypt targets.  Please
> proceed with caution as I'm not familiar with the code base.

This is concerning... if we're to offer more comprehensive review I
think we need more detail on what guided your changes rather than
details of what the resulting changes are.

Mike
