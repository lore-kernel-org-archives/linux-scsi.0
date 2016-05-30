From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Mon, 30 May 2016 09:04:58 -0700
Message-ID: <1464624298.2287.54.camel@linux.vnet.ibm.com>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
	 <20160529065452.GA21677@infradead.org>
	 <1464536473.2287.6.camel@linux.vnet.ibm.com> <574BEB5F.5090509@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <574BEB5F.5090509@huawei.com>
Sender: linux-ide-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, Christoph Hellwig <hch@infradead.org>
Cc: tj@kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-05-30 at 15:27 +0800, Wei Fang wrote:
> Hi James, Christoph,
> 
> On 2016/5/29 23:41, James Bottomley wrote:
> > On Sat, 2016-05-28 at 23:54 -0700, Christoph Hellwig wrote:
> > > On Sat, May 28, 2016 at 11:51:11AM +0800, Wei Fang wrote:
> > > > async_sas_ata_eh(), which will call scsi_eh_finish_cmd() in 
> > > > some case, would be performed simultaneously in
> > > > sas_ata_strategy_handler(). In this case, ->host_failed may be 
> > > > decreased simultaneously in scsi_eh_finish_cmd() on different 
> > > > CPUs, and become abnormal.
> > > > 
> > > > It will lead to permanently inequal between ->host_failed and
> > > >  ->host_busy. Then SCSI error handler thread won't become 
> > > > running, SCSI errors after that won't be handled forever.
> > > > 
> > > > Use atomic type for ->host_failed to fix this race.
> > > 
> > > Looks fine,
> > 
> > Actually, it doesn't look fine at all.  The same mechanism that's
> > supposed to protect the host_failed decrement is also supposed to
> > protect the list_move_tail().  If there's a problem with the former
> > then we're also in danger of corrupting the list.
> 
> Scmd is moved to local eh_done_q list here, and I checked that the
> list won't be touched concurrently.
>
> > Can we go back to the theory of what the problem is, since it's not
> > spelled out very clearly in the change log.  Our usual reason for 
> > not requiring locking in eh routines is that the eh is single 
> > threaded on the eh thread per host, so any host manipulations can't 
> > have concurrency problems.  In this case, the sas_ata routines are
> > trying to be clever and use asynchronous workqueues for the port 
> > error handler and you theorise that these can execute concurrently 
> > on two CPUs, thus causing the problem?
> 
> Yes, it's the case. The works of the port error handler are added to
> system_unbound_wq, and will be performed concurrently on different 
> CPUs. We have already met that problem on our machine.

OK, add that to the changelog and also that this fixes

commit 50824d6c5657ce340e3911171865a8d99fdd8eba
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Dec 4 01:06:24 2011 -0800

    [SCSI] libsas: async ata-eh

Because that's where the concurrency rules weren't verified when this
async threading was added.

One final thing is that we don't need this replaced by atomics.  The
only atomic check we need is the up count, which is already serialised
by the host lock.  Nothing actually ever bothers with the down count,
so it can just be eliminated and host_failed set to zero after the
strategy handle is complete (but before scsi_restart_operations) in the
eh_thread.

Once this change is made, scsi_eh_finish_cmd() and
scsi_eh_flush_done_q() are safe provided the done_q list is not
modifiable by any other thread.

As Christoph said, the documentation needs updating to reflect these
new concurrency rules.

James

