From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 03:27:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFE94EA.7030909@pobox.com>
References: <3EFE8784.4000101@pobox.com> <20030628233824.H26995@one-eyed-alien.net> <3EFE8B7B.2000109@pobox.com> <20030628235413.I26995@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:32647 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265591AbTF2HNb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 03:13:31 -0400
In-Reply-To: <20030628235413.I26995@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: linux-scsi@vger.kernel.org

Matthew Dharm wrote:
> I'm somewhat concerned that, just as we're finding something that works,
> we're going to go off in another direction.
> 
> I certainly wouldn't mind removing the code that manipulates the SCSI
> revision number.

I'm talking about code in the scsi core that does stuff like ("if 
scsi_level <= 2" ...), which is wrong for MMC, where version==0 is a 
valid value on modern atapi and usb devices.


> But, the 6-to-10 conversion code (at least for USB) is all about to go
> away, once we settle on how sr.c (and friends) should handle use_10_for_ms
> -- so one of your reasons to change all this is already moot.

Not really, see below.


> I guess, in part, I'm hesitant to rely on fields in the INQUIRY data that
> nobody has checked to verify that they are actually useful.  Most USB
> devices are made on ultra-low testing, and commonly have bad bits in any
> field that isn't used by Windows or MacOS.

MMC-4 is the culmination of the stuff that's in the field now.

Really, sr wants to know "are you mmc-compliant?"

If the answer is yes, it should only use MMC-defined commands (mode 
sense 10, etc.).

use_10_for_ms is a subset of that.

	Jeff



