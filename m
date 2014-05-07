From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: How to get more sequential IO merged at elevator
Date: Wed, 7 May 2014 18:51:08 +0530
Message-ID: <608a6e2171083f267b5cfe6773b53cc3@mail.gmail.com>
References: <471cb78e78284a109ca9cc2571ebb9c6@BN1PR07MB247.namprd07.prod.outlook.com>
 <5368EED1.2030207@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og129.obsmtp.com ([64.18.2.122]:48976 "EHLO
	exprod7og129.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbaEGN2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 09:28:51 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so1361529lbi.15
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2014 06:28:49 -0700 (PDT)
In-Reply-To: <5368EED1.2030207@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, May 06, 2014 7:47 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: How to get more sequential IO merged at elevator
>
> On 05/06/2014 04:06 AM, Desai, Kashyap wrote:
> > I got some clue on what was going on while doing 4K sequential read
using
> fio.
> >
> > If I use ioengine in fio script as "libaio", I see " do_io_submit"
call
> plug/unplug the queue before submitting the IO.
> > It means after every IO, we expect to send IO immediately to the next
> layer. If at all there are any pending IO do merge.. but not due to
plugging.
> >
> > This is what happens on my test. Every time IO comes from application
> > with libaio engine, it send down to the elevator/io-scheduler because
> queue was unplugged in do_io_submit(). Moment I reduce the queue depth
> of the block device, merge start because of congestion at scsi mid
layer.
> >
> > If I use, mmap engine, I see merged IO coming to the device driver
> > because of plugging. I really don't know how it works, but gave a try
> > and found merge happen because of plugging. ( I confirm using
> > blktrace)
> >
> > Is there any ioengine in <fio> (or any other parameter setting), which
can
> use plugging mechanism of block layer to merge more IO other than mmap ?
>
> O_DIRECT IO is sync by nature, which is why it is sent off immediately
instead
> of held for potentially merging. mmap is not. You should be able to
provoke
> merging by submitting more than 1 IO at the time. See the iodepth_batch
> settings for fio.

Thanks Jens. I got your point about O_DIRECT IO. When I read <man> page of
<fio> it mentioned default iodepth_batch and iodepth_low will be same as
iodepth value.. but in my case I have to explicitly provide those
parameters. It looks like default value for ipdepth_bacch/low is 1.

Once I provide fio parameter "iodepth_batch=32" and "iodepth_low=32", I
see IO in batch before plug and after unplug from application.
I am able to get now max merged IO. Thanks for helping me on this.

~ Kashyap

>
> --
> Jens Axboe
>
