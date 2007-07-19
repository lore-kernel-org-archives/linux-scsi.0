From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Thu, 19 Jul 2007 02:48:30 +0200
Message-ID: <469EB4DE.7050602@googlemail.com>
References: <469C10F6.3050008@googlemail.com>	<20070717100921W.fujita.tomonori@lab.ntt.co.jp>	<469C1E2A.8010508@googlemail.com> <20070719082516W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fonzie.hosting9000.com ([85.214.50.12]:49750 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbXGSA5H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 20:57:07 -0400
In-Reply-To: <20070719082516W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

FUJITA Tomonori wrote:
> From: Gabriel C <nix.or.die@googlemail.com>
> Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
> Date: Tue, 17 Jul 2007 03:40:58 +0200
>
>   
>> FUJITA Tomonori wrote:
>>     
>>> From: Gabriel C <nix.or.die@googlemail.com>
>>> Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
>>> Date: Tue, 17 Jul 2007 02:44:38 +0200
>>>
>>>   
>>>       
>>>> Gabriel C wrote:
>>>>     
>>>>         
>>>>> Hello,
>>>>>
>>>>> sdparm and hdparm are broken for me on git (
>>>>> abce891a10559343d8ac9f79b46d78afdba63a40 )
>>>>>
>>>>>
>>>>> ~$ sudo hdparm  /dev/sdc
>>>>>
>>>>> /dev/sdc:
>>>>>  BLKROGET failed: Inappropriate ioctl for device
>>>>>  BLKRAGET failed: Inappropriate ioctl for device
>>>>>  BLKGETSIZE failed: Inappropriate ioctl for device
>>>>>
>>>>>
>>>>> ~$ sudo sdparm  --all /dev/sdc
>>>>> unable to access /dev/sdc, ATA disk?
>>>>>
>>>>>   
>>>>>       
>>>>>           
>>>> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.
>>>>         
>
> I've not tested this yet (need to find sata drives in my workplace),
> but James Bottomley told me that both works for him with bsg enabled.
> It might worth trying the latest git tree.
>
>   

Hi ,

I'm running current git head and this problem still exists.

crazy@lara:/work/crazy/linux-git/linux2.6$ git rev-parse --verify HEAD
5bae7ac9feba925fd0099057f6b23d7be80b7b41


With BLK_DEV_BSG=n


crazy@lara:/work/crazy/linux-git/linux2.6$ sudo sdparm /dev/sda
/dev/sda: SEAGATE ST318406LW 0109
Read write error recovery mode page:
AWRE 1 [cha: y, def: 1, sav: 1]
ARRE 1 [cha: y, def: 1, sav: 1]
PER 0 [cha: y, def: 0, sav: 0]
Caching (SBC) mode page:
WCE 1 [cha: y, def: 1, sav: 1]
RCD 0 [cha: y, def: 0, sav: 0]
Control mode page:
SWP 0 [cha: n, def: 0, sav: 0]
Informational exceptions control mode page:
EWASC 0 [cha: n, def: 0, sav: 0]
DEXCPT 0 [cha: y, def: 0, sav: 0]
MRIE 0 [cha: y, def: 0, sav: 0]
crazy@lara:/work/crazy/linux-git/linux2.6$ sudo sdparm /dev/sdb
/dev/sdb: FUJITSU MAH3182MP 0114
Read write error recovery mode page:
AWRE 0 [cha: y, def: 0, sav: 0]
ARRE 1 [cha: y, def: 1, sav: 1]
PER 0 [cha: y, def: 0, sav: 0]
Caching (SBC) mode page:
WCE 1 [cha: y, def: 1, sav: 1]
RCD 0 [cha: y, def: 0, sav: 0]
Control mode page:
SWP 0 [cha: n, def: 0, sav: 0]
Informational exceptions control mode page:
EWASC 1 [cha: y, def: 0, sav: 1]
DEXCPT 0 [cha: y, def: 1, sav: 0]
MRIE 6 [cha: y, def: 0, sav: 6]
crazy@lara:/work/crazy/linux-git/linux2.6$ sudo sdparm /dev/sdc
/dev/sdc: ATA SAMSUNG SP1203N TL10
Read write error recovery mode page:
AWRE 1
ARRE 1
PER 0
Caching (SBC) mode page:
WCE 1
RCD 0
Control mode page:
SWP 0


crazy@lara:/work/crazy/linux-git/linux2.6$ sudo hdparm /dev/sda

/dev/sda:
readonly = 0 (off)
readahead = 256 (on)
geometry = 2231/255/63, sectors = 35843670, start = 0
crazy@lara:/work/crazy/linux-git/linux2.6$ sudo hdparm /dev/sdb

/dev/sdb:
readonly = 0 (off)
readahead = 256 (on)
geometry = 2222/255/63, sectors = 35701260, start = 0
crazy@lara:/work/crazy/linux-git/linux2.6$ sudo hdparm /dev/sdc

/dev/sdc:
IO_support = 0 (default 16-bit)
readonly = 0 (off)
readahead = 256 (on)
geometry = 14596/255/63, sectors = 234493056, start = 0



And this when set to y


crazy@lara:~$ sudo hdparm /dev/sda

/dev/sda:
BLKROGET failed: Inappropriate ioctl for device
BLKRAGET failed: Inappropriate ioctl for device
BLKGETSIZE failed: Inappropriate ioctl for device
crazy@lara:~$ sudo hdparm /dev/sdb

/dev/sdb:
BLKROGET failed: Inappropriate ioctl for device
BLKRAGET failed: Inappropriate ioctl for device
BLKGETSIZE failed: Inappropriate ioctl for device
crazy@lara:~$ sudo hdparm /dev/sdc

/dev/sdc:
BLKROGET failed: Inappropriate ioctl for device
BLKRAGET failed: Inappropriate ioctl for device
BLKGETSIZE failed: Inappropriate ioctl for device
crazy@lara:~$ sudo sdparm /dev/sdc
unable to access /dev/sdc, ATA disk?
crazy@lara:~$ sudo sdparm /dev/sdb
unable to access /dev/sdb, ATA disk?
crazy@lara:~$ sudo sdparm /dev/sda
unable to access /dev/sda, ATA disk?
crazy@lara:~$ dmesg|grep bsg
[ 41.411171] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)



Smartd now spams the dmesg too with :

snip

....
[ 75.329927] program smartd is using a deprecated SCSI ioctl, please
convert it to SG_IO
[ 75.334267] program smartd is using a deprecated SCSI ioctl, please
convert it to SG_IO
[ 75.334396] program smartd is using a deprecated SCSI ioctl, please
convert it to SG_IO
[ 75.388284] program smartd is using a deprecated SCSI ioctl, please
convert it to SG_IO
[ 75.438146] program smartd is using a deprecated SCSI ioctl, please
convert it to SG_IO
....

dmesg|grep 'program smartd is using'|wc -l
42


Just stopped it for now :)

You can find the used config and dmesg there :

http://194.231.229.228/2.6.22-g5bae7ac9/


Gabriel


