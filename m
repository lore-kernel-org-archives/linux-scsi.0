From: Eddie <stunnel@attglobal.net>
Subject: Re: Should I be Worried: sda: p1 size .... limited to end of disk
Date: Tue, 13 Oct 2009 17:48:50 -0700
Message-ID: <4AD51FF2.50900@attglobal.net>
References: <4AD0E466.2070904@attglobal.net> <da824cf30910121204l4edd75e7pa05386732ccb7556@mail.gmail.com> <4AD38BEA.4090202@attglobal.net>
Reply-To: stunnel@attglobal.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kcout01.prserv.net ([12.154.55.31]:58234 "EHLO
	kcout01.prserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZJNAtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 20:49:33 -0400
In-Reply-To: <4AD38BEA.4090202@attglobal.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

Eddie wrote:
> The raw partition table entry is:
>
> 00 01 01 00 8E FE FF FF 3F 00 00 00 84 E4 A8 AE
>
> Active Flag = 00
> Starting Head = 01
> Starting Cylinder = 0001
> Partition Type = x'8E' - Linux LVM
> Ending Head = x'FE' - 254
> Ending Cylinder/Sector = x'FFFF' - LBA
> Offset to Start = x'0000003F' - 63
> # of Sectors = x'AEA8E484' - 2930304132 - Hmmmmmmm
>
> So, that looks like the culprit.  Now, how did it happen.  I know I 
> can, sort of safely, rebuild that, by running (c)fdisk and making sure 
> I start the partition at exactly the same point.  But all I did the 
> first time, was use cfdisk, and allocate the complete disk to the 1st 
> primary partition.
OK, I recreated the partition table, trying both fdisk and cfdisk.  I'm 
still not sure how the original had the wrong values in there.  I guess 
that will remain a mystery.


fdisk -l -u /dev/sda

Disk /dev/sda: 1499.9 GB, 1499999502336 bytes
255 heads, 63 sectors/track, 182364 cylinders, total 2929686528 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0x0003d809

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63  2929677659  1464838798+  8e  Linux LVM


OK, the total sectors seems to match the hardware scan -> sd 4:1:0:0: 
[sda] 2929686528 512-byte hardware sectors: (1.49 TB/1.36 TiB)

But 255 * 63 * 182364 = 2929677660.  What's this discrepancy due to.  
Does the drive report ALL sectors, even the ones used to replace "bad" ones.

However, 2929677660 does seem to tie up quite nicely with the "end 
sector", from the fdisk, so I'm assuming that everything is now correct.

Well, apart from the fact that LVM reports a Total PE allocation of 
357627 extents, which maps to 1464840192 Blocks, according to my maths 
anyway, which happens to be bigger than the "available" sectors on the 
disk.  I guess it's time to hit the LVM list, to see if there's any way 
I can safely correct this, before anything tries to use the "phantom" 
sectors.

Cheers,
Eddie



