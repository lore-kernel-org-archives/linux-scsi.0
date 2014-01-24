From: kai.makisara@kolumbus.fi
Subject: Re: Open/INQUIRY fails on RESERVE'd tape device
Date: Fri, 24 Jan 2014 10:35:22 +0200 (EET)
Message-ID: <11934060.3620421390552523314.JavaMail.kai.makisara@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; Charset=iso-8859-1; Format=Flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:34021 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaAXIpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 03:45:03 -0500
Received: from cfwo-22-2.mail.saunalahti.fi (cfwo-22.mail.saunalahti.fi [62.142.5.121])
	by gw02.mail.saunalahti.fi (Postfix) with ESMTP id 9C9461395E1
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2014 10:35:24 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
	by cfwo-22-2.mail.saunalahti.fi (Postfix) with ESMTP id E64BB2007E
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2014 10:35:23 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Eble <psychotrahe@gmail.com>, linux-scsi@vger.kernel.org

Matthias Eble [psychotrahe@gmail.com] kirjoitti: 
> Hi list,
> 
> When a tape device is reserved with old reserve/release commands,
> we see inquiry only works on the scsi generic device. For scsi tape devices
> open() fails already:
> 
> # lsscsi -g | grep st15
> [2:0:6:0]    tape    HP       Ultrium 5-SCSI   I5DZ  /dev/st15  /dev/sg17
> 
> # sg_vpd -vvv /dev/st15
>   open /dev/st15 with flags=0x800
>   error opening file: /dev/st15: Input/output error
> 
> # sg_vpd -vvv /dev/nst15
>   open /dev/nst15 with flags=0x800
>   error opening file: /dev/nst15: Input/output error
> 
> # sg_vpd -vvv /dev/sg17
> open /dev/sg17 with flags=0x800
> Supported VPD pages VPD page:
>     inquiry cdb: 12 01 00 00 fc 00
>       duration=2 ms
>     inquiry: requested 252 bytes but got 22 bytes
>    [PQual=0  Peripheral device type: tape]
>   Supported VPD pages [sv]
>   Unit serial number [sn]
>   ...
> 
> 
> So: should open() fail on a reserved tape device?
> SPC2 states that INQUIRY should never conflict.
> Or does that only apply to the generic device?
> Okay, it doesn't conflict, but open fails. A SunOS st man page I found
> states, INQUIRY shall be possible with reserved devices.
> 
Opening a st device does more than INQUIRY (TEST_UNIT_READY, READ_BLOCK_LIMITS,
MODE_SENSE). Can this explain what you see?

Kai


-- 



