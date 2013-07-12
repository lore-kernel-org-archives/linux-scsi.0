From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [RFC/RFT PATCH 3/5] scsi: Use dma_max_pfn(dev) helper for bounce_limit
 calculations
Date: Sat, 13 Jul 2013 03:08:27 +0400
Message-ID: <51E08C6B.2080802@cogentembedded.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <1373665694-7580-4-git-send-email-santosh.shilimkar@ti.com> <51E07B6E.5090900@cogentembedded.com> <20130712222506.GI24642@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:41085 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3GLXIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jul 2013 19:08:32 -0400
Received: by mail-la0-f45.google.com with SMTP id fr10so8137758lab.32
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2013 16:08:31 -0700 (PDT)
In-Reply-To: <20130712222506.GI24642@n2100.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org

Hello.

On 07/13/2013 02:25 AM, Russell King - ARM Linux wrote:

>>> DMA bounce limit is the maximum direct DMA'able memory beyond which
>>> bounce buffers has to be used to perform dma operations. SCSI driver
>>> relies on dma_mask but its calculation is based on max_*pfn which
>>> don't have uniform meaning across architectures. So make use of
>>> dma_max_pfn() which is expected to return the DMAable maximum pfn
>>> value across architectures.

>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: linux-scsi@vger.kernel.org

>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> ---
>>>    drivers/scsi/scsi_lib.c |    2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)

>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 86d5220..e8275fa 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1668,7 +1668,7 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
>>>
>>>    	host_dev = scsi_get_device(shost);
>>>    	if (host_dev && host_dev->dma_mask)
>>> -		bounce_limit = *host_dev->dma_mask;
>>> +		bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;

>>     You definitely forgot -1 here.

> Please explain your point.

    Previously, 'bounce_limit' would look like 0xffffffff (unless I'm 
mistaken), now it would look like 0xfffff000 which is hardly what we're 
looking for, no?

WBR, Sergei

