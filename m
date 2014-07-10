From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 15:39:57 +0200
Message-ID: <53BE97AD.9080306@kernel.dk>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com> <53BD9A24.7010203@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net> <20140710062040.GB20146@infradead.org> <20140710133609.GO12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:60001 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaGJNkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 09:40:00 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so9076854wes.40
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2014 06:39:59 -0700 (PDT)
In-Reply-To: <20140710133609.GO12478@kvack.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 2014-07-10 15:36, Benjamin LaHaise wrote:
> On Wed, Jul 09, 2014 at 11:20:40PM -0700, Christoph Hellwig wrote:
>> On Thu, Jul 10, 2014 at 12:53:36AM +0000, Elliott, Robert (Server Storage) wrote:
>>> the problem still occurs - fio results in low or 0 IOPS, with perf top
>>> reporting unusual amounts of time spent in do_io_submit and io_submit.
>>
>> The diff between the two version doesn't show too much other possible
>> interesting commits, the most interesting being some minor block
>> updates.
>>
>> I guess we'll have to a manual bisect, I've pushed out a
>> scsi-mq.3-bisect-1 branch that is rebased to just before the merge of
>> the block tree, and a scsi-mq.3-bisect-2 branch that is just after
>> the merge of the block tree to get started.
>
> There is one possible concern that could be exacerbated by other changes in
> the system: if the application is running close to the bare minimum number
> of requests allocated in io_setup(), the per cpu reference counters will
> have a hard time batching things.  It might be worth testing with an
> increased number of requests being allocated if this is the case.

That's how fio always runs, it sets up the context with the exact queue 
depth that it needs. Do we have a good enough understanding of other aio 
use cases to say that this isn't the norm? I would expect it to be, it's 
the way that the API would most obviously be used.

-- 
Jens Axboe

