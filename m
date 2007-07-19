From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Thu, 19 Jul 2007 16:31:00 +0200
Message-ID: <469F75A4.8050301@googlemail.com>
References: <469C10F6.3050008@googlemail.com>	 <20070717100921W.fujita.tomonori@lab.ntt.co.jp>	 <469C1E2A.8010508@googlemail.com>	 <20070719082516W.fujita.tomonori@lab.ntt.co.jp> <1184853770.3464.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fonzie.hosting9000.com ([85.214.50.12]:50147 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937839AbXGSOc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 10:32:29 -0400
In-Reply-To: <1184853770.3464.85.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-07-19 at 08:25 +0900, FUJITA Tomonori wrote:
>   
>> From: Gabriel C <nix.or.die@googlemail.com>
>> Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
>> Date: Tue, 17 Jul 2007 03:40:58 +0200
>>
>>     
>>> FUJITA Tomonori wrote:
>>>       
>>>> From: Gabriel C <nix.or.die@googlemail.com>
>>>> Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
>>>> Date: Tue, 17 Jul 2007 02:44:38 +0200
>>>>
>>>>   
>>>>         
>>>>> Gabriel C wrote:
>>>>>     
>>>>>           
>>>>>> Hello,
>>>>>>
>>>>>> sdparm and hdparm are broken for me on git (
>>>>>> abce891a10559343d8ac9f79b46d78afdba63a40 )
>>>>>>
>>>>>>
>>>>>> ~$ sudo hdparm  /dev/sdc
>>>>>>
>>>>>> /dev/sdc:
>>>>>>  BLKROGET failed: Inappropriate ioctl for device
>>>>>>  BLKRAGET failed: Inappropriate ioctl for device
>>>>>>  BLKGETSIZE failed: Inappropriate ioctl for device
>>>>>>
>>>>>>
>>>>>> ~$ sudo sdparm  --all /dev/sdc
>>>>>> unable to access /dev/sdc, ATA disk?
>>>>>>
>>>>>>   
>>>>>>       
>>>>>>             
>>>>> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.
>>>>>           
>> I've not tested this yet (need to find sata drives in my workplace),
>> but James Bottomley told me that both works for him with bsg enabled.
>> It might worth trying the latest git tree.
>>     
>
> It certainly does work for me.  However, my ATA devices are connected to
> an aic94xx SAS controller.  Although this uses libata, the ioctl path is
> probably slightly different from the libata one. I assume you're using a
> SATA controller?  Unfortunately I have no ability to test on a SATA
> controller, but I'd suggest looking at the ioctl and REQ_BLOCK_PC paths
> in libata for clues.
>   

No is not an SATA controller.

sda and sdb are SCSI disks connected to an Adaptec AIC-7892P U160/m
controller using the aic7xxx driver.

sdc is an ATA-7 disk connected to an IDE controller ( 82801BA IDE U100
)  using libata and the ata_piix driver.


$ lspci -nn 
00:00.0 Host bridge [0600]: Intel Corporation 82860 860 (Wombat) Chipset
Host Bridge (MCH) [8086:2531] (rev 04)
00:01.0 PCI bridge [0604]: Intel Corporation 82850 850 (Tehama) Chipset
AGP Bridge [8086:2532] (rev 04)
00:02.0 PCI bridge [0604]: Intel Corporation 82860 860 (Wombat) Chipset
AGP Bridge [8086:2533] (rev 04)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge
[8086:244e] (rev 04)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801BA ISA Bridge (LPC)
[8086:2440] (rev 04)
00:1f.1 IDE interface [0101]: Intel Corporation 82801BA IDE U100
Controller [8086:244b] (rev 04)
00:1f.2 USB Controller [0c03]: Intel Corporation 82801BA/BAM USB
Controller #1 [8086:2442] (rev 04)
00:1f.3 SMBus [0c05]: Intel Corporation 82801BA/BAM SMBus Controller
[8086:2443] (rev 04)
00:1f.4 USB Controller [0c03]: Intel Corporation 82801BA/BAM USB
Controller #1 [8086:2444] (rev 04)
00:1f.5 Multimedia audio controller [0401]: Intel Corporation
82801BA/BAM AC'97 Audio Controller [8086:2445] (rev 04)
01:00.0 VGA compatible controller [0300]: nVidia Corporation NV11
[GeForce2 MX/MX 400] [10de:0110] (rev a1)
02:1f.0 PCI bridge [0604]: Intel Corporation 82806AA PCI64 Hub PCI
Bridge [8086:1360] (rev 03)
03:00.0 PIC [0800]: Intel Corporation 82806AA PCI64 Hub Advanced
Programmable Interrupt Controller [8086:1161] (rev 01)
03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7892P U160/m
[9005:008f] (rev 02)
04:0b.0 Ethernet controller [0200]: 3Com Corporation 3c905C-TX/TX-M
[Tornado] [10b7:9200] (rev 78)
04:0c.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB12LV26
IEEE-1394 Controller (Link) [104c:8020]
04:0f.0 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 41)
04:0f.1 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 41)
04:0f.2 USB Controller [0c03]: NEC Corporation USB 2.0 [1033:00e0] (rev 02)


> James
>
>   


Gabriel
