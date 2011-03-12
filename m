From: Arne Jansen <lists@die-jansens.de>
Subject: Re: reusing bios
Date: Sat, 12 Mar 2011 14:33:42 +0100
Message-ID: <4D7B7636.5010206@die-jansens.de>
References: <4D7B3CF0.5040102@die-jansens.de> <4D7B462D.5000305@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49990 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1CLNdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2011 08:33:42 -0500
In-Reply-To: <4D7B462D.5000305@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On 2011-03-12 10:29, Arne Jansen wrote:
>> Hi,
>>
>> I'm trying to re-use struct bio after completion, including the
>> allocated pages. Normally I re-initialize the fields bi_sector,
>> bi_size, bi_next, bi_flags, bi_comp_cpu and bi_bdev.
>> This works perfectly well, as long as no media errors are encountered.
>> After a media error, all subsequent reads with this bio fail. Are
>> there any more fields that need to get re-initialized? Or, better,
>> is there a function to reset the bio?
> 
> bio_init()? Sounds like you are not setting BIO_UPTODATE when resetting
> it.
> 

bio_init does way too much, as it discards the io_vec, refcnt, destructor,
private etc.
I set the flags to 1 << BIO_UPTODATE, but that proved to be fatal, too, as
it clobbers the POOL_FLAGS, which leads to an oops when the last reference
drops. These bio-beasts are just not made to be reused. One needs way too
much internal knowledge to reinitialize them properly.
Therefore, I'd really like to have a call like bio_reinit, which keeps the
io_vec and all the owners private information, but resets the parts that
get used by the stack like bi_next. Would that make sense?



