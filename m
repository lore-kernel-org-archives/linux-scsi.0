From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4] scsi_debugfs: fix crash in scsi_show_rq()
Date: Wed, 15 Nov 2017 18:09:51 +0800
Message-ID: <20171115100949.GC908@ming.t460p>
References: <20171110090144.11791-1-ming.lei@redhat.com>
 <1510332718.3095.2.camel@HansenPartnership.com>
 <20171111024337.GB20382@ming.t460p>
 <1510599352.3336.20.camel@HansenPartnership.com>
 <20171114005544.GA20889@ming.t460p>
 <1510683292.3077.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510683292.3077.3.camel@HansenPartnership.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 14, 2017 at 10:14:52AM -0800, James Bottomley wrote:
> On Tue, 2017-11-14 at 08:55 +0800, Ming Lei wrote:
> > Hi James,
> > 
> > On Mon, Nov 13, 2017 at 10:55:52AM -0800, James Bottomley wrote:
> > > 
> > > On Sat, 2017-11-11 at 10:43 +0800, Ming Lei wrote:
> > > > 
> > > > So from CPU1's review, cmd->cmnd is in a remote NUMA node,
> > > > __scsi_format_command() is executed much slower than
> > > > mempool_free().
> > > > So when mempool_free() returns, __scsi_format_command() may not
> > > > fetched the buffer in L1 cache yet, then use-after-free
> > > > is still triggered.
> > > > 
> > > > That is why I say this use-after-free is inevitable no matter
> > > > 'setting SCpnt->cmnd to NULL before calling mempool_free()' or
> > > > not.
> > > 
> > > The bottom line is that there are several creative ways around this
> > > but the proposed code is currently broken and simply putting a
> > > comment in saying so doesn't make it acceptable.
> > 
> > As I explained above, I didn't see one really workable way. Or please
> > correct it if I am wrong.
> 
> I simply can't believe it's beyond the wit of man to solve a use after
> free race.  About 40% of kernel techniques are devoted to this.  All I
> really care about is not losing the PI information we previously had.
>  I agree with Bart that NULL cmnd is a good indicator, so it seems
> reasonable to use it.  If you have another mechanism, feel free to
> propose it.

Hi James,

This patch is my proposal, no others thought of yet.

We can fix the use-after-free easily via lock, rcu and ..., but some cost
has to pay. In this case, we can't wait too long in show_rq(), otherwise
we may lose important debug info, so I do not have better way.

IMO this use-after-free is actually no harm, I don't think we have to fix
it, but it should be better to not let utility warn on this case.


Thanks,
Ming
