From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Recent removal of bsg read/write support
Date: Sun, 2 Sep 2018 21:16:10 +0200
Message-ID: <6b907fed-d83f-de75-bde4-11270a0b1b0b@interlog.com>
References: <CAOuWhkaGjX8Q_xghkFVTqzZkDrUv-sdH=VbS7hvnqFWrT+3eOQ@mail.gmail.com>
 <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>, drorl@infinidat.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On 2018-09-02 01:44 PM, Richard Weinberger wrote:
> CC'ing relevant people. Otherwise your mail might get lost.
> 
> On Sun, Sep 2, 2018 at 1:37 PM Dror Levin <drorl@infinidat.com> wrote:
>>
>> Note: I am not subscribed to LKML so please CC replies to this email.
>>
>> Hi,
>>
>> We have an internal tool that uses the bsg read/write interface to
>> issue SCSI commands as part of a test suite for a storage device.
>>
>> After recently reading on LWN that this interface is to be removed we
>> tried porting our code to use sg instead. However, that raises new
>> issues - mainly getting ENOMEM over iSCSI for unknown reasons.
>>
>> Because of this we would like to continue using the bsg interface,
>> even if some changes are required to meet security concerns.
>>
>> Is there any chance for this removal to be reverted? I saw it was
>> already included in 4.19-rc1.

Hi,
Both bsg and sg are relatively thin shims over the same block layer
pass-through calls. And neither driver will themselves generate ENOMEM
unless the CPU is running low of memory.

In my experience, the main reason for unexpected ENOMEMs *** is from
blk_rq_map_user_iov() in block/blk_map.c called from both drivers.
That is a particular resource shortage rather than memory in general.
I do notice the blk_rq_map_user_iov() is/was called with GFP_KERNEL
in bsg and GFP_ATOMIC by sg. That suggests when you call write() on
a sg device and get ENOMEM, then wait a little (depends on your app)
and try again.

Could you share a test program that illustrates the problem with us?

One way of limiting user space programs that used bsg's write()/read()
interface (via the sg v4 interface), from needing a significant rewrite
would be to implement the sg_v4 interface in the sg driver. Currently the
sg driver supports the sg v1 (sort of), sg v2 and sg v3 (typically used)
interfaces.

Doug Gilbert


*** Prior to around February this year, that block layer resource
shortage resulted in a EINVAL being returned to the sg driver. That
had perplexed me for some time, as it happened only under heavy
testing, typically with the same SCSI command being repeated
(e.g. REQUEST SENSE). It was really a ENOMEM error that was being
inadvertently overwritten.
