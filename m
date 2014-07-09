From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq V2
Date: Wed, 09 Jul 2014 21:38:12 +0200
Message-ID: <53BD9A24.7010203@kernel.dk>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:42567 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGITiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 15:38:15 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so7831038wev.34
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 12:38:14 -0700 (PDT)
In-Reply-To: <53BD7041.5010300@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2014-07-09 18:39, Douglas Gilbert wrote:
> On 14-07-08 10:48 AM, Christoph Hellwig wrote:
>> On Wed, Jun 25, 2014 at 06:51:47PM +0200, Christoph Hellwig wrote:
>>> Changes from V1:
>>>   - rebased on top of the core-for-3.17 branch, most notable the
>>>     scsi logging changes
>>>   - fixed handling of cmd_list to prevent crashes for some heavy
>>>     workloads
>>>   - fixed incorrect handling of !target->can_queue
>>>   - avoid scheduling a workqueue on I/O completions when no queues
>>>     are congested
>>>
>>> In addition to the patches in this thread there also is a git
>>> available at:
>>>
>>>     git://git.infradead.org/users/hch/scsi.git scsi-mq.2
>>
>>
>> I've pushed out a new scsi-mq.3 branch, which has been rebased on the
>> latest core-for-3.17 tree + the "RFC: clean up command setup" series
>> from June 29th.  Robert Elliot found a problem with not fully zeroed
>> out UNMAP CDBs, which is fixed by the saner discard handling in that
>> series.
>>
>> There is a new patch to factor the code from the above series for
>> blk-mq use, which I've attached below.  Besides that the only changes
>> are minor merge fixups in the main blk-mq usage patch.
>
> Be warned: both Rob Elliott and I can easily break
> the scsi-mq.3 branch. It seems as though a regression
> has slipped in. I notice that Christoph has added a
> new branch called "scsi-mq.3-no-rebase".

Rob/Doug, those issues look very much like problems in the aio code. Can 
either/both of you try with:

f8567a3845ac05bb28f3c1b478ef752762bd39ef
edfbbf388f293d70bf4b7c0bc38774d05e6f711a

reverted (in that order) and see if that changes anything.


-- 
Jens Axboe

