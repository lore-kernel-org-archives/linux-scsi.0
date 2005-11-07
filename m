From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integratingSMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 10:53:00 -0800
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BF44@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:51816 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S964916AbVKGSxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 13:53:05 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>


> 
> Well, that might be a problem if it weren't for the fact that this
> LUN_INHIBIT flag was removed in 2002.  If it's taken three 
> years to find
> a device that has a problem with it, I don't really think it's a
> particularly widespread problem.  
>
> ...snip....
>
> James
> 

Just as an FYI to shed some light....

It took Western Digital 3 years to find the problem because September
(back when I started the other conversation about this topic) was the
first time we've tried to get access to a USB storage device under
Linux using a passthru CDB.  Maxtor and Seagate might be in a similar
boat (but obviously that's just speculation), and it's not like thumb
drives need ATA passthru support.

This also isn't the first time a kernel issue has been around for a
while, but nobody noticed. Fixed in 2.6.14 was a bug that existed for
(as far as I can tell) all of 2.6.x.  The kernel would oops on pio-out
HDIO_DRIVE_TASKFILE ioctls because of a null pointer.  The first
time I tried to do a pio-out command I hit it, yet nobody had
complained about it as far as I could tell.  The kernel 2.6.x series
has been out how long?  I was baffled and my only guess was that
even though the API was there for pio-out, nobody was using it.

I wonder if it's the same issue with vendor specific cdbs to USB
storage devices; nobody is really using it?

The cypress passthru CDB works fine under Windows, and since
most companies only care about Windows, they probably didn't
even try to get it to work under Linux.  For instance I wasn't
even told to support it under Linux until some people hit a 
Windows limitation they couldn't get around.

The other possibility is that for groups that do use vendor specific
CDBs and have never had this issue, they probably have CDBs that don't
stick meaningful bits where the LUN goes, so therefore it was never an
issue.  However, both the ATACB and the SAT passthru CDB have
meaningful bits there.


Regards,
Tim Thelin
