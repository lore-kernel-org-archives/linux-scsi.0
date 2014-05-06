From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to get more sequential IO merged at elevator
Date: Tue, 06 May 2014 08:16:49 -0600
Message-ID: <5368EED1.2030207@kernel.dk>
References: <471cb78e78284a109ca9cc2571ebb9c6@BN1PR07MB247.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:32792 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaEFOQp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2014 10:16:45 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz1so563472pad.30
        for <linux-scsi@vger.kernel.org>; Tue, 06 May 2014 07:16:44 -0700 (PDT)
In-Reply-To: <471cb78e78284a109ca9cc2571ebb9c6@BN1PR07MB247.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/06/2014 04:06 AM, Desai, Kashyap wrote:
> I got some clue on what was going on while doing 4K sequential read using fio.
> 
> If I use ioengine in fio script as "libaio", I see " do_io_submit" call plug/unplug the queue before submitting the IO.
> It means after every IO, we expect to send IO immediately to the next layer. If at all there are any pending IO do merge.. but not due to plugging.
> 
> This is what happens on my test. Every time IO comes from application with libaio engine, it send down to the elevator/io-scheduler because queue was unplugged in 
> do_io_submit(). Moment I reduce the queue depth of the block device, merge start because of congestion at scsi mid layer.
> 
> If I use, mmap engine, I see merged IO coming to the device driver because of plugging. I really don't know how it works, but gave a try and found merge happen because of plugging. ( I confirm using blktrace)
> 
> Is there any ioengine in <fio> (or any other parameter setting), which can use plugging mechanism of block layer to merge more IO other than mmap ?

O_DIRECT IO is sync by nature, which is why it is sent off immediately
instead of held for potentially merging. mmap is not. You should be able
to provoke merging by submitting more than 1 IO at the time. See the
iodepth_batch settings for fio.

-- 
Jens Axboe

