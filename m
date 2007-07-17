From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Tue, 17 Jul 2007 03:40:58 +0200
Message-ID: <469C1E2A.8010508@googlemail.com>
References: <469BD9C8.4000808@googlemail.com>	<469C10F6.3050008@googlemail.com> <20070717100921W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:63373 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbXGQBlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 21:41:46 -0400
Received: by ug-out-1314.google.com with SMTP id j3so54001ugf
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2007 18:41:45 -0700 (PDT)
In-Reply-To: <20070717100921W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: Gabriel C <nix.or.die@googlemail.com>
> Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
> Date: Tue, 17 Jul 2007 02:44:38 +0200
>
>   
>> Gabriel C wrote:
>>     
>>> Hello,
>>>
>>> sdparm and hdparm are broken for me on git (
>>> abce891a10559343d8ac9f79b46d78afdba63a40 )
>>>
>>>
>>> ~$ sudo hdparm  /dev/sdc
>>>
>>> /dev/sdc:
>>>  BLKROGET failed: Inappropriate ioctl for device
>>>  BLKRAGET failed: Inappropriate ioctl for device
>>>  BLKGETSIZE failed: Inappropriate ioctl for device
>>>
>>>
>>> ~$ sudo sdparm  --all /dev/sdc
>>> unable to access /dev/sdc, ATA disk?
>>>
>>>   
>>>       
>> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.
>>     
>
> Can you check the major number of your /dev/sdc? I've seen that
> /dev/sd* is linked to bsg devices somehow.
>
>
>   

All my disks are doing this sdc was meant as example.

...

$ ls -la /dev/sd{a,b,c}
brw-r----- 1 root disk 8, 0 16. Jul 23:11 /dev/sda
brw-rw---- 1 root disk 8, 16 16. Jul 23:11 /dev/sdb
brw-r----- 1 root disk 8, 32 16. Jul 23:11 /dev/sdc

...

sd{a,b} are SCSI disks and sdc is an ATA disk.

You can get the used config from there :


http://194.231.229.228/2.6.22-gabce891a/config



Gabriel
