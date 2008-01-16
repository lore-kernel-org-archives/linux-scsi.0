From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Actually using the sg table/chain code
Date: Wed, 16 Jan 2008 16:01:55 +0200
Message-ID: <478E0E53.2080900@panasas.com>
References: <1200412337.9273.28.camel@localhost.localdomain>	 <478CDABB.1080208@panasas.com> <1200415778.9273.32.camel@localhost.localdomain> <478CEED9.3080705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36175 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbYAPOCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jan 2008 09:02:35 -0500
In-Reply-To: <478CEED9.3080705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <Jens.Axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jan 15 2008 at 19:35 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Tue, Jan 15 2008 at 18:49 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> On Tue, 2008-01-15 at 18:09 +0200, Boaz Harrosh wrote:
>>> On Tue, Jan 15 2008 at 17:52 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>>> I thought, now we had this new shiny code to increase the scatterlist
>>>> table size I'd try it out.  It turns out there's a pretty vast block
>>>> conspiracy that prevents us going over 128 entries in a scatterlist.
>>>>
>>>> The first problems are in SCSI:  The host parameters sg_tablesize and
>>>> max_sectors are used to set the queue limits max_hw_segments and
>>>> max_sectors respectively (the former is the maximum number of entries
>>>> the HBA can tolerate in a scatterlist for each transaction, the latter
>>>> is a total transfer cap on the maxiumum number of 512 byte sectors).
>>>> The default settings, assuming the HBA doesn't vary them are
>>>> sg_tablesize at SG_ALL (255) and max_sectors at SCSI_DEFAULT_MAX_SECTORS
>>>> (1024).  A quick calculation shows the latter is actually 512k or 128
>>>> pages (at 4k pages), hence the persistent 128 entry limit.
>>>>
>>>> However, raising max_sectors and sg_tablesize together still doesn't
>>>> help:  There's actually an insidious limit sitting in the block layer as
>>>> well.  This is what blk_queue_max_sectors says:
>>>>
>>>> void blk_queue_max_sectors(struct request_queue *q, unsigned int
>>>> max_sectors)
>>>> {
>>>> 	if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
>>>> 		max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
>>>> 		printk("%s: set to minimum %d\n", __FUNCTION__, max_sectors);
>>>> 	}
>>>>
>>>> 	if (BLK_DEF_MAX_SECTORS > max_sectors)
>>>> 		q->max_hw_sectors = q->max_sectors = max_sectors;
>>>>  	else {
>>>> 		q->max_sectors = BLK_DEF_MAX_SECTORS;
>>>> 		q->max_hw_sectors = max_sectors;
>>>> 	}
>>>> }
>>>>
>>>> So it imposes a maximum possible setting of BLK_DEF_MAX_SECTORS which is
>>>> defined in blkdev.h to .... 1024, thus also forcing the queue down to
>>>> 128 scatterlist entries.
>>>>
>>>> Once I raised this limit as well, I was able to transfer over 128
>>>> scatterlist elements during benchmark test runs of normal I/O (actually
>>>> kernel compiles seem best, they hit 608 scatterlist entries).
>>>>
>>>> So my question, is there any reason not to raise this limit to something
>>>> large (like 65536) or even eliminate it altogether?
>>>>
>>>> James
>>>>
>>> I have an old branch here where I've swiped through the scsi drivers just
>>> to remove the SG_ALL limit. Unfortunately some drivers mean laterally
>>> 255 when using SG_ALL. So I passed driver by driver and carfully inspected
>>> the code to change it to something driver specific if they really meant
>>> 255.
>>>
>>> I have used sg_tablesize = ~0; to indicate, I don't care any will do,
>>> and some driver constant if there is a real limit. Though removing
>>> SG_ALL at the end.
>>>
>>> Should I freshen up this branch and send it.
>> By all means; however, I think having the defined constant SG_ALL is
>> useful (even if it is eventually just set to ~0) it means I can support
>> any scatterlist size.  Having the drivers set sg_tablesize correctly
>> that can't support SG_ALL is pretty vital.
>>
>> Thanks,
>>
>> James
> OK will do.
> 
> I have found the old branch and am looking. I agree with you about the 
> SG_ALL. I will fix it to have a patch per changed driver, with out changing
> SG_ALL, and then final patch to just change SG_ALL.
> 
> Boaz


James hi
reinspecting the code, what should I do with drivers that do not support chaining
do to SW that still do sglist++?

should I set their sg_tablesize to SG_MAX_SINGLE_ALLOC, or hard code to 128, and put
a FIXME: in the submit message?

or should we fix them first and serialize this effort on top of those fixes.
(also in light of the other email where you removed the chaining flag)

Boaz



