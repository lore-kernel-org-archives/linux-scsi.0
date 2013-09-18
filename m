From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Bypass block layer and Fill SCSI lower layer driver queue
Date: Wed, 18 Sep 2013 14:00:44 -0700
Message-ID: <1379538044.32763.651.camel@haakon3.risingtidesystems.com>
References: <CAB-428mCM-4c1hWaEJicB8Uz_4DCo7MsH-ZcXHrDkN=Wc5AhVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47464 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3IRUxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 16:53:00 -0400
In-Reply-To: <CAB-428mCM-4c1hWaEJicB8Uz_4DCo7MsH-ZcXHrDkN=Wc5AhVA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, Jerry Fredin <jerry.fredin@netapp.com>

On Wed, 2013-09-18 at 01:41 -0500, Alireza Haghdoost wrote:
> Hi
> 
> I am working on a high throughput and low latency application which
> does not tolerate block layer overhead to send IO request directly to
> fiber channel lower layer SCSI driver. I used to work with libaio but
> currently I am looking for a way to by pass the block layer and send
> SCSI commands from the application layer directly to the SCSI driver
> using /dev/sgX device and ioctl() system call.
>
> I have noticed that sending IO request through sg device even with
> nonblocking and direct IO flags is quite slow and does not fill up
> lower layer SCSI driver TCQ queue. i.e IO depth or
> /sys/block/sdX/in_flight is always ZERO. Therefore the application
> throughput is even lower that sending IO request through block layer
> with libaio and io_submit() system call. In both cases I used only one
> IO context (or fd) and single threaded.
> 
> I have noticed that some well known benchmarking tools like fio does
> not support IO depth for sg devices as well. Therefore, I was
> wondering if it is feasible to bypass block layer and achieve higher
> throughput and lower latency (for sending IO request only).
> 
> 
> Any comment on my issue is highly appreciated.
> 
> 

FYI, you've got things backward as to where the real overhead is being
introduced.

The block layer / aio overhead is minimal compared to the overhead
introduced by the existing scsi_request_fn() logic, and extreme locking
contention between request_queue->queue_lock and scsi_host->host_lock
that are accessed/released multiple times per struct scsi_cmnd dispatch.

This locking contention and other memory allocations currently limit per
struct scsi_device performance with small block random IOPs to ~250K vs.
~1M with raw block drivers providing their own make_request() function.

FYI, there is an early alpha scsi-mq prototype that bypasses the
scsi_request_fn() junk all together, that is able to reach small block
IOPs + latency that is comparable to raw block drivers.

Only a handful of LLDs have been converted to run with full scsi-mq
pre-allocation thus far, and the code is considered early, early
alpha.  

It's the only real option for SCSI to get anywhere near raw block driver
performance + latency, but is still quite a ways off mainline.

--nab

