From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Weird I/O errors with USB Hard disk
Date: Sat, 10 May 2014 08:10:27 -0700
Message-ID: <1399734627.2528.2.camel@dabdike.int.hansenpartnership.com>
References: <CANudz+s6iyZtLLVcJ-tcZVRP1gAJOQzU4Spq23=yRd8PcvfK_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50443 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625AbaEJPK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 May 2014 11:10:29 -0400
In-Reply-To: <CANudz+s6iyZtLLVcJ-tcZVRP1gAJOQzU4Spq23=yRd8PcvfK_Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: linux-scsi@vger.kernel.org, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>

On Sat, 2014-05-10 at 22:38 +0800, loody wrote:
> hi all:
> I have a USB hard disk and when I play specific file.
> it will show below message
> ( I purpose enable usb/storage/transport.c debug message about urb debug)
> what makes me confused are
> 1. Does " Unhandled sense code" mean the " SCSI Request Sense" command?

Error handling couldn't correct the error so it was passed up.

> 2. if #1 is correct, there should be any error handling for not keep
> sending following commands. Why usb driver keep clear this halt
> enpoint?
> isn't there any timeout mechanism no matter in scsi layer or usb layer?
> 
> appreciate your help
> 
> 
> [22:06:48]clearing endpoint halt for pipe 0xc0008280
> [22:06:48]sd 0:0:0:0: [sda] Unhandled sense code
> [22:06:48]sd 0:0:0:0: [sda]  Result: hostbyte=0x10 driverbyte=0x08
> [22:06:48]sd 0:0:0:0: [sda]  Sense Key : 0x3 [current]
> [22:06:48]sd 0:0:0:0: [sda]  ASC=0x11 ASCQ=0x0
> [22:06:48]sd 0:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 24 42 22 00 00 f0 00
> [22:06:48]end_request: critical target error, dev sda, sector 2376226

If you compiled your kernel with SCSI messages it would tell you that
this is a medium error, unrecovered read error in sector 2376226

The device is failing and the sector cannot be recovered.

James


