From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Sun, 29 May 2016 08:41:13 -0700
Message-ID: <1464536473.2287.6.camel@linux.vnet.ibm.com>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
	 <20160529065452.GA21677@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160529065452.GA21677@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Wei Fang <fangwei1@huawei.com>
Cc: tj@kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-05-28 at 23:54 -0700, Christoph Hellwig wrote:
> On Sat, May 28, 2016 at 11:51:11AM +0800, Wei Fang wrote:
> > async_sas_ata_eh(), which will call scsi_eh_finish_cmd() in some 
> > case, would be performed simultaneously in 
> > sas_ata_strategy_handler(). In this case, ->host_failed may be 
> > decreased simultaneously in scsi_eh_finish_cmd() on different CPUs,
> > and become abnormal.
> > 
> > It will lead to permanently inequal between ->host_failed and
> >  ->host_busy. Then SCSI error handler thread won't become running,
> > SCSI errors after that won't be handled forever.
> > 
> > Use atomic type for ->host_failed to fix this race.
> 
> Looks fine,

Actually, it doesn't look fine at all.  The same mechanism that's
supposed to protect the host_failed decrement is also supposed to
protect the list_move_tail().  If there's a problem with the former
then we're also in danger of corrupting the list.

Can we go back to the theory of what the problem is, since it's not
spelled out very clearly in the change log.  Our usual reason for not
requiring locking in eh routines is that the eh is single threaded on
the eh thread per host, so any host manipulations can't have
concurrency problems.  In this case, the sas_ata routines are trying to
be clever and use asynchronous workqueues for the port error handler
and you theorise that these can execute concurrently on two CPUs, thus
causing the problem?

James


