From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Bypass block layer and Fill SCSI lower layer driver queue
Date: Wed, 18 Sep 2013 17:31:10 +0300
Message-ID: <5239B92E.6000103@panasas.com>
References: <CAB-428mCM-4c1hWaEJicB8Uz_4DCo7MsH-ZcXHrDkN=Wc5AhVA@mail.gmail.com> <52395D14.6010103@gmail.com> <5239B3B9.8050209@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:54617 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3IRObY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 10:31:24 -0400
In-Reply-To: <5239B3B9.8050209@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Jack Wang <xjtuwjp@gmail.com>, Alireza Haghdoost <alireza@cs.umn.edu>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, Jerry Fredin <jerry.fredin@netapp.com>

On 09/18/2013 05:07 PM, Douglas Gilbert wrote:
> On 13-09-18 03:58 AM, Jack Wang wrote:
>> On 09/18/2013 08:41 AM, Alireza Haghdoost wrote:
>>> Hi
>>>
>>> I am working on a high throughput and low latency application which
>>> does not tolerate block layer overhead to send IO request directly to
>>> fiber channel lower layer SCSI driver. I used to work with libaio but
>>> currently I am looking for a way to by pass the block layer and send
>>> SCSI commands from the application layer directly to the SCSI driver
>>> using /dev/sgX device and ioctl() system call.
>>>
>>> I have noticed that sending IO request through sg device even with
>>> nonblocking and direct IO flags is quite slow and does not fill up
>>> lower layer SCSI driver TCQ queue. i.e IO depth or
>>> /sys/block/sdX/in_flight is always ZERO. Therefore the application
>>> throughput is even lower that sending IO request through block layer
>>> with libaio and io_submit() system call. In both cases I used only one
>>> IO context (or fd) and single threaded.
>>>
>> Hi Alireza,
>>
>> I think what you want is in_flight command scsi dispatch to low level
>> device.
>> I submit a simple patch to export device_busy
>>
>> http://www.spinics.net/lists/linux-scsi/msg68697.html
>>
>> I also notice fio sg engine will not fill queue properly, but haven't
>> look into deeper.
>>
>> Cheers
>> Jack
>>
>>> I have noticed that some well known benchmarking tools like fio does
>>> not support IO depth for sg devices as well. Therefore, I was
>>> wondering if it is feasible to bypass block layer and achieve higher
>>> throughput and lower latency (for sending IO request only).
>>>
>>>
>>> Any comment on my issue is highly appreciated.
> 
> I'm not sure if this is relevant to your problem but by
> default both the bsg and sg drivers "queue at head"
> when they inject SCSI commands into the block layer.
> 
> The bsg driver has a BSG_FLAG_Q_AT_TAIL flag to change
> that queueing to what may be preferable for your purposes.
> The sg driver could, but does not, support that flag.
> 

Yes!

The current best bet for keeping the queues full are with libaio
and direct + asynchronous IO. It should not be significantly slower than
bsg. (Believe me, with direct IO Block-Device cache is bypassed and
the only difference is in who prepares the struct requests for submission)

As Doug said sg can not do it. Also with bsg and above BSG_FLAG_Q_AT_TAIL
You will need to use the write() option and not the ioctl() because the
later is synchronous and you want an asynchronous submit of commands
and background completion of them. (Which is what libaio does with async IO)

With bsg you achieve that with using write() in combination of read() to
receive the completions.

> Doug Gilbert
> 

Cheers
Boaz

