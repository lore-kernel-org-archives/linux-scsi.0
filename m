From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 21:59:36 +0200
Message-ID: <53BEF0A8.7010608@kernel.dk>
References: <1403715121-1201-1-git-send-email-hch@lst.de>	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>	<53BD9A24.7010203@kernel.dk>	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>	<20140710062040.GB20146@infradead.org>	<20140710133609.GO12478@kvack.org>	<20140710135051.GA28227@infradead.org> <53BE9AB1.6090603@kernel.dk>	<94D0CD8314A33A4D9D801C0FE68B402958B96CF0@G9W0745.americas.hpqcorp.net>	<20140710144539.GU12478@kvack.org> <x49k37l1c6p.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51734 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaGJT7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 15:59:41 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so71529wgh.20
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2014 12:59:38 -0700 (PDT)
In-Reply-To: <x49k37l1c6p.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Christoph Hellwig <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 2014-07-10 17:11, Jeff Moyer wrote:
> Benjamin LaHaise <bcrl@kvack.org> writes:
>
>>>
>>> [  186.339064] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>> [  186.339065] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>> [  186.339067] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>> [  186.339068] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>> [  186.339069] ioctx_alloc: nr_events=-2 aio_max_nr=65536
>>
>> Something is horribly wrong here.  There is no way that value for nr_events
>> should be passed in to ioctx_alloc().  This implies that userland is calling
>> io_setup() with an impossibly large value for nr_events.  Can you post the
>> actual diff for your fs/aio.c relative to linus' tree?
>>
>
> fio does exactly this!  it passes INT_MAX.

That's correct, I had actually forgotten about this. It was a change 
made a few years back, in correlation with the aio optimizations posted 
then, basically telling aio to ignore that silly (and broken) user ring.

-- 
Jens Axboe

