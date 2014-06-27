From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi-mq V2
Date: Fri, 27 Jun 2014 16:42:23 +0200
Message-ID: <53AD82CF.4090701@acm.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <53ABA6A4.8090400@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958B4EFB4@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B4EFB4@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/27/14 00:07, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Wednesday, 25 June, 2014 11:51 PM
>> To: Christoph Hellwig; James Bottomley
>> Cc: Bart Van Assche; Elliott, Robert (Server Storage); linux-
>> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: scsi-mq V2
>>
>> On 2014-06-25 10:51, Christoph Hellwig wrote:
>>> This is the second post of the scsi-mq series.
>>>
> ...
>>>
>>> Changes from V1:
>>>   - rebased on top of the core-for-3.17 branch, most notable the
>>>     scsi logging changes
>>>   - fixed handling of cmd_list to prevent crashes for some heavy
>>>     workloads
>>>   - fixed incorrect handling of !target->can_queue
>>>   - avoid scheduling a workqueue on I/O completions when no queues
>>>     are congested
>>>
>>> In addition to the patches in this thread there also is a git available at:
>>>
>>> 	git://git.infradead.org/users/hch/scsi.git scsi-mq.2
>>
>> You can add my acked/reviewed-by to the series.
> 
> Since March 20th (circa LSF-MM 2014) we've run many hours of tests
> with hpsa and the scsi-mq tree.  We've also done a little bit of 
> testing with mpt3sas and, in the last few days, scsi_debug.
> 
> Although there are certainly more problems to find and improvements
> to be made, it's become quite stable.  It's even been used on the
> boot drives of our test servers.
> 
> For the patches in scsi-mq.2 you may add:
> Tested-by: Robert Elliott <elliott@hp.com>

Performance of scsi-mq-v2 looks even better than that of scsi-mq-v1. The
slight single-LUN regression is gone, peak IOPS with use_blk_mq=Y on my
test setup is now 3x the performance of use_blk_mq=N and latency has
been reduced further. I think this means reducing the number of context
switches did really help :-) Detailed measurement results can be found
on https://drive.google.com/file/d/0B1YQOreL3_FxWmZfbl8xSzRfdGM/.

If you want you may add to the scsi-mq-v2 patch series:

Tested-by: Bart Van Assche <bvanassche@acm.org>

Bart.
