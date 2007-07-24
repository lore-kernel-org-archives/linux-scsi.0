From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: Re: QLGC,ISP SCSI driver not finding attached devices
Date: Tue, 24 Jul 2007 18:46:06 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707241758020.17959@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
 <1184941136.3455.8.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
 <1184950646.3455.45.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
 <Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
 <1185238223.3417.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:3395 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbXGXRqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 13:46:13 -0400
In-Reply-To: <1185238223.3417.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

Hi all,

Timing does not apear to be an issue. I have checked all the udelay/msleep 
calls I could find and thoes that get called are delaying by the correct 
delay (4 to 7us > specified value).

I have added some more debugging info and it looks like somthing is 
getting corrupted in the INQUIRY command as it is returning:

   Sense Key : Illegal Request [current]
   Add. Sense: Invalid field in cdb

According a of the SCSI2 Std that I have, this equates to one of the 
following:

 	EVPD set and Vital Product Data not supported
 	EVPD clear and Page Code non-zero
 	Control Field Flag set and Link not set

Looking into the issue a bit further, it turns out the the Sparc32 memset 
is broaken - it does not always set the last byte. As a result, the 
Control Field is set to random value (0xE0 in this case). This explains 
all sorts of odd issues. Next step is to fix memset. I will try again once 
I am sure memset is working.

Regards
 	Mark Fortescue.

On Mon, 23 Jul 2007, James Bottomley wrote:

> On Mon, 2007-07-23 at 23:41 +0100, Mark Fortescue wrote:
>> Hi James,
>>
>> Can you point me in the direction of any documentation to aid me in
>> identifing what debugging I need to work out what is going on?
>
> they're all in include/scsi/scsi.h
>
> The code is divided into four bytes (from LSB): status, message, host
> and driver.  The status is what the SCSI command actually returned (if
> anything) the message is what the transport said (least used of the
> status codes).  The host byte signals an error condition with the card
> and the driver byte with the driver (plus an optional suggestion of what
> to do about it).
>
>> For targets without any connected disk, I get scan responses of:
>>      scsi scan: INQUIRY failed with code 0x40000
>> after app 417ms.
>
> That's host byte 0x04 which is DID_BAD_TARGET.
>
>> For targets with a disk connected, I get scan responses of:
>>      scsi scan: INQUIRY failed with code 0x8000002
>> after app 170ms.
>
> Thats SCSI status 0x02 (which is CHECK_CONDITION) and driver byte of
> 0x08, which is DRIVER_SENSE (as in the device returned a sense code).
> This is really strange, because the INQUIRY command isn't supposed to be
> allowed to return a sense code for precisely this initial scan reason.
> This tends to point to a device failure.
>
> James
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
