From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Wed, 29 Oct 2014 14:13:46 -0600
Message-ID: <54514A7A.8050008@kernel.dk>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee> <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee> <545102FE.3010003@kernel.dk> <20141029183828.GA31689@infradead.org> <alpine.LRH.2.11.1410292205060.16678@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44602 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaJ2UNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 16:13:47 -0400
Received: by mail-pa0-f51.google.com with SMTP id kq14so3841399pab.24
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 13:13:46 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1410292205060.16678@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On 10/29/2014 02:06 PM, Meelis Roos wrote:
>> On Wed, Oct 29, 2014 at 09:08:46AM -0600, Jens Axboe wrote:
>>>> Another test server with MPT SCSI RAID has similar problem,
>>>> scsi_mode.use_blk_mq=0 cures it but I can not get good trace (no serail
>>>> console). 3.18.0-rc2-00043-gf7e87a4 was tested there.
>>>
>>> The first issue looks like scsi cdrom and error handling, it must be leaking
>>> requests hence we hang on allocation of a new one. cciss doesn't use blk_mq
>>> regardless of the scsi setting. Does the mpt box also have a libata driven
>>> cdrom?
>>
>> cciss does use scsi for CDROMs and other external devices, it is a bit
>> of a mess.
>>
>> Meelis, did you also test scsi-mq on 3.17 and this is a regression, or
>> was 3.18-rc2 the first kernel you tested?
> 
> Both machines ran 3.17 successfully. I turned on scsi-mq option as soon 
> as it appeared in Kconfig as a new option. But I am not sure whan the 
> option appeared, before or after 3.17 release.

So just to be fully clear, you never enabled scsi-mq on 3.17? To do
that, you would have had to add a scsi_mod.use_blk_mq=1 boot parameter.
The scsi-mq kconfig option did not show up until after 3.17 release.


-- 
Jens Axboe

