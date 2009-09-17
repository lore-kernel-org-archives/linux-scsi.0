From: Eddie <stunnel@attglobal.net>
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Wed, 16 Sep 2009 19:59:22 -0700
Message-ID: <4AB1A60A.5080702@attglobal.net>
References: <4AB10FC2.1080900@attglobal.net> <1253118717.4842.13.camel@mulgrave.site> <4AB1185E.1050208@attglobal.net>
Reply-To: stunnel@attglobal.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kcout02.prserv.net ([12.154.55.32]:62697 "EHLO
	kcout02.prserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZIQC7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2009 22:59:34 -0400
In-Reply-To: <4AB1185E.1050208@attglobal.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

>
>> How much memory does your system have?
>>
>> Best guess in the 64 bit case is that the physical memory the kernel is
>> doing DMA to isn't within the range of the card.  You might be able to
>> test this by booting with the max_addr=4G parameter in the 64 bit case.
>>
>> If it is, we'll have to get the DMA mask for this thing set up
>> correctly.
>>
>> James
>>   
>
> James,
>
> It's got 8Gig.
>
> I'll try your suggestion tonight, when I get home.
>
> Cheers,
> Eddie
>
OK, adding addappend = " max_addr=4G" to my lilo.conf made no 
difference.  It still booted with all 8G.  :(

But, changing it to addappend = " mem=4G" seemed to do the trick.

And, your guess might be correct.  I now see the correct messages for 
the MegaRAID:

scsi 4:4:0:0: Direct-Access     MegaRAID LD 0 RAID5 1430G N661 PQ: 0 ANSI: 2
sd 4:4:0:0: [sda] 2930307072 512-byte hardware sectors: (1.50 TB/1.36 TiB)
sd 4:4:0:0: [sda] Write Protect is off
sd 4:4:0:0: [sda] Mode Sense: 00 00 00 00
sd 4:4:0:0: [sda] Asking for cache data failed
sd 4:4:0:0: [sda] Assuming drive cache: write through
sd 4:4:0:0: [sda] 2930307072 512-byte hardware sectors: (1.50 TB/1.36 TiB)
sd 4:4:0:0: [sda] Write Protect is off
sd 4:4:0:0: [sda] Mode Sense: 00 00 00 00
sd 4:4:0:0: [sda] Asking for cache data failed
sd 4:4:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 4:4:0:0: [sda] Attached SCSI disk
sd 4:4:0:0: Attached scsi generic sg1 type 0

Cheers,
Eddie
