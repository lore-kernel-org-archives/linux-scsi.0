From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in
 NCR5380_select
Date: Fri, 3 Aug 2018 12:56:23 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1808031148320.16@nippy.intranet>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com> <c99a75a2905c1eef50f94ccc0871c36af431e21a.camel@wdc.com> <5B627E71.5020600@huawei.com> <928ae07a-8c4a-05fc-16af-48fb6e9c341d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <928ae07a-8c4a-05fc-16af-48fb6e9c341d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: zhong jiang <zhongjiang@huawei.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2 Aug 2018, Michael Schmitz wrote:

> 
> This redundant load of the ICR has been in the driver code for a long 
> time. There's a small chance it is intentional,

Actually, it is intentional.

> so at least minimal testing might be in order.
> 

Minimal testing is almost useless if you are trying to prove the absence 
of race conditions. SCSI arbitration is a race between targets by design; 
so a race between the CPU and the 5380 is going to be hard to observe.

> Finn - does the ICR_ARBITRATION_LOST bit have to be cleared by a write 
> to the mode register?
> 

Something like that: the write to the mode register does clear the 
ICR_ARBITRATION_LOST bit, because it clears the MR_ARBITRATE bit.

> In that case, the first load would have been redundant and can be 
> omitted without changing driver behaviour?

This code is a faithful rendition of the arbitration flow chart in the 
datasheet, so even if you are right, I wouldn't want to change the code.

Besides, I think your argument assumes that ICR and MR are synchronized, 
and also assumes that targets are obeying the spec.

-- 

> Cheers,
> 
> 	Michael
> 
> 
