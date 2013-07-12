From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC/RFT PATCH 3/5] scsi: Use dma_max_pfn(dev) helper for
	bounce_limit calculations
Date: Sat, 13 Jul 2013 00:57:11 +0100
Message-ID: <20130712235711.GK24642@n2100.arm.linux.org.uk>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <1373665694-7580-4-git-send-email-santosh.shilimkar@ti.com> <51E07B6E.5090900@cogentembedded.com> <20130712222506.GI24642@n2100.arm.linux.org.uk> <51E08C6B.2080802@cogentembedded.com> <51E0947F.1040800@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51E0947F.1040800@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 13, 2013 at 03:42:55AM +0400, Sergei Shtylyov wrote:
>>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>>> index 86d5220..e8275fa 100644
>>>>> --- a/drivers/scsi/scsi_lib.c
>>>>> +++ b/drivers/scsi/scsi_lib.c
>>>>> @@ -1668,7 +1668,7 @@ u64 scsi_calculate_bounce_limit(struct
>>>>> Scsi_Host *shost)
>>>>>
>>>>>        host_dev = scsi_get_device(shost);
>>>>>        if (host_dev && host_dev->dma_mask)
>>>>> -        bounce_limit = *host_dev->dma_mask;
>>>>> +        bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;
>
>>>>     You definitely forgot -1 here.
>
>>> Please explain your point.
>
>>     Previously, 'bounce_limit' would look like 0xffffffff (unless I'm
>> mistaken), now it would look like 0xfffff000 which is hardly what we're
>> looking for, no?
>
>    Although, -1 won't give us the correct result in this case, it's more 
> like + PAGE_SIZE - 1.

And where it's used is blk_bounce_limit(), the first which that does
is convert it back to a PFN, losing the bottom bits again...

I'm tempted to suggest converting the whole thing to just deal with
PFNs rather than bytes since we only deal with "can we DMA to this"
on a per-page basis.
