From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] USB floppy drive no longer works under 2.6.15-rc6
Date: Tue, 10 Jan 2006 10:50:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0601101034590.5060-100000@iolanthe.rowland.org>
References: <20060110051516.GA20407@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:28586 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751131AbWAJPuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 10:50:18 -0500
In-Reply-To: <20060110051516.GA20407@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Phil Dibowitz <phil@ipom.com>, Jan De Luyck <lkml@kcore.org>, SCSI development list <linux-scsi@vger.kernel.org>

[Moved to linux-scsi]

On Mon, 9 Jan 2006, Matthew Dharm wrote:

> A long time ago, I noticed a quirk of the UFI specification in regards to
> one of the options for how to indicate a LUN isn't there.  Something about
> a special PDT, I think, in the INQUIRY respose.  I don't recall the
> details, but I do recall thinking something along the lines of "that's
> odd.. and it's going to confuse the SCSI core."
> 
> If I can find some time to search for that oddity of spec, then modify the
> UFI protocol handler to translate that oddity into a result code the SCSI
> core can understand, you can close the #2 case.

I see what you mean.  The UFI spec requires a device to return 0x1f in the
first byte of the INQUIRY response if no device is present at the LUN.  
That's Peripheral Qualifier = 0 and PDT = 0x1f (unknown or no device).  
Now SCSI-2 requires the value to be 0x7f to indicate no device, but UFI
also requires the returned SCSI level to be 0, and I don't know what
SCSI-0 says about reporting no device at a LUN.

Does anybody among the SCSI developers have the answer?  Should 
scsi_probe_and_add_lun() check for (result[0] & 0x1f) == 0x1f whenever 
(result[2] & 0x07) == 0?

If not, perhaps usb-storage should alter the returned value and max_lun
for a UFI device whenever we see 0x1f.

Alan Stern

