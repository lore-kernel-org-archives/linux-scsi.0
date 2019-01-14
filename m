From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: wd719x Replace GFP_KERNEL with GFP_ATOMIC in
 wd719x_chip_init
Date: Mon, 14 Jan 2019 11:31:21 -0500
Message-ID: <e7ed2d3c-26f4-1b43-ecfe-2e77d94372b1@interlog.com>
References: <1547479489-11560-1-git-send-email-wdjjwb@163.com>
 <20190114152943.GA10454@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190114152943.GA10454@infradead.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, wangbo <wdjjwb@163.com>
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wang.bo116@zte.com.cn, Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

On 2019-01-14 10:29 a.m., Christoph Hellwig wrote:
> On Mon, Jan 14, 2019 at 11:24:49PM +0800, wangbo wrote:
>> wd719x_host_reset get spinlock first then call wd719x_chip_init,
>> so replace GFP_KERNEL with GFP_ATOMIC in wd719x_chip_init.
> 
> Please move the allocation outside the lock instead.  GFP_ATOMIC
> DMA allocations are generally a bad idea and should be avoided where
> we can.
> 
> More importantly we should never actually trigger the allocation
> under the lock as far as fw_virt will always be set already
> in that case.
> 
> So I think you can safely move the request firmware + allocation
> + memcpy from wd719x_chip_init to wd719x_board_found, but I'd rather
> have Ondrej review that plan.

Further to this, the result of holding a lock (probably with _irqsave()
tacked onto it) during a GFP_KERNEL is a message like this in the log:
    hrtimer: interrupt took 1084 ns

It is not always easy to find since it is a "_once" message. The sg v3
driver (the one in production) produces these. I have been able to stamp
them out by taking care in the sg v4 driver (in testing) around
allocations. It also meant adding a new state in my state machine to
fend off "bad things" happening to that object while it is unlocked.
So there may be a cost to dropping the lock.

Doug Gilbert
