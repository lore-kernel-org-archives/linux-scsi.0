From: Jack Byer <ojbyer@usa.net>
Subject: Re: Fw: legacy megaraid driver bug in mm-series
Date: Tue, 13 Sep 2005 06:17:39 -0400
Message-ID: <4326A743.3060808@usa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 69.37.187.190.adsl.snet.net ([69.37.187.190]:65165 "EHLO
	copper.fuckthenavy.net") by vger.kernel.org with ESMTP
	id S1750775AbVIMKRv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 06:17:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>



-------- Original Message --------
Subject: Re: Fw: legacy megaraid driver bug in mm-series
Date: Tue, 13 Sep 2005 06:06:29 -0400
From: Jack Byer <ojbyer@usa.net>
To: Christoph Hellwig <hch@infradead.org>
References: <20050907025258.35100c34.akpm@osdl.org>
<20050908143547.GA9741@infradead.org>
<20050909165817.1a8ad251.akpm@osdl.org> <432613BA.5060606@usa.net>
<20050913092359.GA29552@infradead.org>

Christoph Hellwig wrote:
> On Mon, Sep 12, 2005 at 07:48:10PM -0400, Jack Byer wrote:
> 
>>Andrew Morton wrote:
>>
>>>Christoph Hellwig <hch@infradead.org> wrote:
>>>
>>>
>>>>On Wed, Sep 07, 2005 at 02:52:58AM -0700, Andrew Morton wrote:
>>>>
>>>>
>>>>>Begin forwarded message:
>>>>
>>>>This looks preyyu much like a breakage because we're now always sending
>>>>S/G list down the scsi layer.
>>>>
>>>>The patch below brings over code to handle that case from the megaraid_mbox
>>>>driver.  It's still wrong for the case someone sends a MODE_SENSE from
>>>>highmem userspace, but it should at least boot with the patch applied.
>>>>
>>>
>>>
>>>Jack, have you had a chance to test this?
>>>
>>>Thanks.
>>>
>>
>>Sorry, I spent the weekend whitewater rafting :)  I will be able to test
>>this patch on Wednesday. Which kernel versions should I apply this patch to?
> 
> 
> I did it against the at that time latest scsi-misc tree.  The old megaraid
> driver hasn'tt changed much for a long time so it should apply against
> any recent-ish tree.
> 
> 

I tried the patch on a 2.6.13-mm1 tree. It applied cleanly, but produced
a few compiler warnings:


/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c: In function `issue_scb':
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1143: warning: passing
arg 2 of `writel' makes pointer from integer without a cast
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c: In function
`issue_scb_block':
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1206: warning: passing
arg 2 of `writel' makes pointer from integer without a cast
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1219: warning: passing
arg 2 of `writel' makes pointer from integer without a cast
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1221: warning: passing
arg 1 of `readl' makes pointer from integer without a cast
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c: In function
`megaraid_isr_memmapped':
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1351: warning: passing
arg 1 of `readl' makes pointer from integer without a cast
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1358: warning: passing
arg 2 of `writel' makes pointer from integer without a cast
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1377: warning: passing
arg 2 of `writel' makes pointer from integer without a cast
/usr/src/linux-2.6.13-mm1/drivers/scsi/megaraid.c:1381: warning: passing
arg 1 of `readl' makes pointer from integer without a cast

Booting the kernel resulted in the same symptoms as before (can not
mount root fs).

