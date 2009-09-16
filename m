From: Eddie <stunnel@attglobal.net>
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Wed, 16 Sep 2009 09:54:54 -0700
Message-ID: <4AB1185E.1050208@attglobal.net>
References: <4AB10FC2.1080900@attglobal.net> <1253118717.4842.13.camel@mulgrave.site>
Reply-To: stunnel@attglobal.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kcout01.prserv.net ([12.154.55.31]:46322 "EHLO
	kcout01.prserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZIPQzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2009 12:55:07 -0400
In-Reply-To: <1253118717.4842.13.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-09-16 at 09:18 -0700, Eddie wrote:
>   
>> I've done a quick search of the archives, and didn't find anything 
>> relevant, or I missed it.  :(
>>
>> I've just installed the latest Slackware release, 13.0, in 64-bit mode, 
>> that uses kernel 2.6.29.6.  Previously, I was running 12.2, in 32-bit, 
>> which used kernel 2.6.27.31.  After booting, I noticed that the drives 
>> on the raid had not been mounted.  Checking through dmesg, I noticed 
>> that the "drive" attached to the card had not been correctly 
>> recognised.  Here's the relevant messages, about the card, and the 
>> drive, from dmesg:
>>
>> megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
>>
>> megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
>> megaraid: probe new device 0x101e:0x1960:0x101e:0x0511: bus 1:slot 4:func 0
>>
>> megaraid 0000:01:04.0: PCI INT A -> Link[LNK1] -> GSI 19 (level, high) 
>> -> IRQ 19
>> megaraid: fw version:[N661] bios version:[1.01]
>> scsi4 : LSI Logic MegaRAID driver
>> scsi[4]: scanning scsi channel 0 [Phy 0] for non-raid devices
>>
>> scsi[4]: scanning scsi channel 1 [Phy 1] for non-raid devices
>> scsi[4]: scanning scsi channel 2 [Phy 2] for non-raid devices
>> scsi[4]: scanning scsi channel 3 [Phy 3] for non-raid devices
>> scsi[4]: scanning scsi channel 4 [virtual] for logical drives
>> scsi scan: INQUIRY result too short (5), using 36
>> scsi 4:4:0:0: Direct-Access                                    PQ: 0 ANSI: 0
>> sd 4:4:0:0: [sda] Sector size 0 reported, assuming 512.
>> sd 4:4:0:0: [sda] 1 512-byte hardware sectors: (512 B/512 B)
>> sd 4:4:0:0: [sda] Write Protect is off
>> sd 4:4:0:0: [sda] Mode Sense: 00 00 00 00
>> sd 4:4:0:0: [sda] Asking for cache data failed
>> sd 4:4:0:0: [sda] Assuming drive cache: write through
>> sd 4:4:0:0: [sda] Sector size 0 reported, assuming 512.
>> sd 4:4:0:0: [sda] 1 512-byte hardware sectors: (512 B/512 B)
>> sd 4:4:0:0: [sda] Write Protect is off
>> sd 4:4:0:0: [sda] Mode Sense: 00 00 00 00
>> sd 4:4:0:0: [sda] Asking for cache data failed
>> sd 4:4:0:0: [sda] Assuming drive cache: write through
>>  sda: unknown partition table
>> sd 4:4:0:0: [sda] Attached SCSI disk
>> sd 4:4:0:0: Attached scsi generic sg1 type 0
>>
>>
>> Obviously, it's this "scsi scan: INQUIRY result too short (5), using 
>> 36", causing the drive not to be correctly recognised.  Normally, I'd 
>> expect to get:
>>
>> scsi 4:4:0:0: Direct-Access     MegaRAID LD 0 RAID5 1430G N661 PQ: 0 ANSI: 2
>> sd 4:4:0:0: [sda] 2930307072 512-byte hardware sectors (1500317 MB)
>>
>> In order to eliminate either the change in kernel version, or the change 
>> in architecture, as the culprit, I booted the machine, from both the 
>> 32-bit, and 64-bit, DVDs from Slack.  With the 32-bit kernel, the drive 
>> was correctly recognised, but not with the 64-bit.  So, it's definitely 
>> the change in architecture causing this, not the change in kernel version.
>>
>> The full dmesg can be found here:  ftp.BogoLinux.net/pub together with 
>> the dmesg from the 32-bit system, with kernel 2.6.27.31.
>>     
>
> How much memory does your system have?
>
> Best guess in the 64 bit case is that the physical memory the kernel is
> doing DMA to isn't within the range of the card.  You might be able to
> test this by booting with the max_addr=4G parameter in the 64 bit case.
>
> If it is, we'll have to get the DMA mask for this thing set up
> correctly.
>
> James
>   

James,

It's got 8Gig.

I'll try your suggestion tonight, when I get home.

Cheers,
Eddie
