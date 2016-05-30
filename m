From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Mon, 30 May 2016 15:27:27 +0800
Message-ID: <574BEB5F.5090509@huawei.com>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
 <20160529065452.GA21677@infradead.org>
 <1464536473.2287.6.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1464536473.2287.6.camel@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>
Cc: tj@kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi James, Christoph,

On 2016/5/29 23:41, James Bottomley wrote:
> On Sat, 2016-05-28 at 23:54 -0700, Christoph Hellwig wrote:
>> On Sat, May 28, 2016 at 11:51:11AM +0800, Wei Fang wrote:
>>> async_sas_ata_eh(), which will call scsi_eh_finish_cmd() in some 
>>> case, would be performed simultaneously in 
>>> sas_ata_strategy_handler(). In this case, ->host_failed may be 
>>> decreased simultaneously in scsi_eh_finish_cmd() on different CPUs,
>>> and become abnormal.
>>>
>>> It will lead to permanently inequal between ->host_failed and
>>>  ->host_busy. Then SCSI error handler thread won't become running,
>>> SCSI errors after that won't be handled forever.
>>>
>>> Use atomic type for ->host_failed to fix this race.
>>
>> Looks fine,
> 
> Actually, it doesn't look fine at all.  The same mechanism that's
> supposed to protect the host_failed decrement is also supposed to
> protect the list_move_tail().  If there's a problem with the former
> then we're also in danger of corrupting the list.

Scmd is moved to local eh_done_q list here, and I checked that the
list won't be touched concurrently.

> Can we go back to the theory of what the problem is, since it's not
> spelled out very clearly in the change log.  Our usual reason for not
> requiring locking in eh routines is that the eh is single threaded on
> the eh thread per host, so any host manipulations can't have
> concurrency problems.  In this case, the sas_ata routines are trying to
> be clever and use asynchronous workqueues for the port error handler
> and you theorise that these can execute concurrently on two CPUs, thus
> causing the problem?

Yes, it's the case. The works of the port error handler are added to
system_unbound_wq, and will be performed concurrently on different CPUs.
We have already met that problem on our machine.

Thanks,
Wei

> James
> 
> 
> 
> .
> 

