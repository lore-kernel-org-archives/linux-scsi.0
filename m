From: loody <miloody@gmail.com>
Subject: Re: Weird I/O errors with USB Hard disk
Date: Sun, 11 May 2014 00:43:31 +0800
Message-ID: <CANudz+v6w4M5K-MET0qSWVKK1H9xfCOYjUDWNtX-h96h3xTd6w@mail.gmail.com>
References: <CANudz+s6iyZtLLVcJ-tcZVRP1gAJOQzU4Spq23=yRd8PcvfK_Q@mail.gmail.com>
	<1399734627.2528.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60808 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEJQnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 May 2014 12:43:32 -0400
In-Reply-To: <1399734627.2528.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>

hi James:


2014-05-10 23:10 GMT+08:00 James Bottomley
<James.Bottomley@hansenpartnership.com>:
> On Sat, 2014-05-10 at 22:38 +0800, loody wrote:
>> hi all:
>> I have a USB hard disk and when I play specific file.
>> it will show below message
>> ( I purpose enable usb/storage/transport.c debug message about urb debug)
>> what makes me confused are
>> 1. Does " Unhandled sense code" mean the " SCSI Request Sense" command?
>
> Error handling couldn't correct the error so it was passed up.
>
>> 2. if #1 is correct, there should be any error handling for not keep
>> sending following commands. Why usb driver keep clear this halt
>> enpoint?
>> isn't there any timeout mechanism no matter in scsi layer or usb layer?
>>
>> appreciate your help
>>
>>
>> [22:06:48]clearing endpoint halt for pipe 0xc0008280
>> [22:06:48]sd 0:0:0:0: [sda] Unhandled sense code
>> [22:06:48]sd 0:0:0:0: [sda]  Result: hostbyte=0x10 driverbyte=0x08
>> [22:06:48]sd 0:0:0:0: [sda]  Sense Key : 0x3 [current]
>> [22:06:48]sd 0:0:0:0: [sda]  ASC=0x11 ASCQ=0x0
>> [22:06:48]sd 0:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 24 42 22 00 00 f0 00
>> [22:06:48]end_request: critical target error, dev sda, sector 2376226
>
> If you compiled your kernel with SCSI messages it would tell you that
> this is a medium error, unrecovered read error in sector 2376226
>
> The device is failing and the sector cannot be recovered.
in my opinion, the OS will not hang up when this problem happen, right?
But my platform is always trying to clear halt endpoint, and it seems
Block or File system layer still try to access this sector.

is that related to file node open method or file read method?
such that read bad sector will hang up the OS.

-- 
Appreciate your help,
