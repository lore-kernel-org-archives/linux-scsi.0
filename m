From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 02:47:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFE8B7B.2000109@pobox.com>
References: <3EFE8784.4000101@pobox.com> <20030628233824.H26995@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13702 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265592AbTF2GdQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 02:33:16 -0400
In-Reply-To: <20030628233824.H26995@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: linux-scsi@vger.kernel.org

Matthew Dharm wrote:
> On Sun, Jun 29, 2003 at 02:30:28AM -0400, Jeff Garzik wrote:
> 
>>I was reading the specs just now, and I see that the inquiry page 
>>defines how ATAPI and USB devices indicate they are compliant with MMC-4.
> 
> 
> It does?  I guess I've missed that.

I'm looking at MMC-4 revision 2a (whatever was on t10.org tonight).

Immediately after table 286 (standard inquiry data format), it describes 
the information I believe we can use to determine that 10-byte commands 
(only) need to be sent.  peripheral qualifier, peripheral device type, 
version, and interface dependent field #1.

These fields can be used to differentiate atapi/usb devices from older 
scsi devices.  One concrete example is that atapi reports zero in the 
version field, even though it's mmc-4 compliant.  But the Linux scsi 
stack treats that instead as the most ancient of ancient scsi devices :) 
  So, to counteract this, the ide-scsi module and other places will 
patch the inquiry page data to indicate a higher scsi revision.

Other examples are several places where 6-byte commands are converted 
into 10-byte commands.  The right answer is to simply know when to send 
10-byte commands in the first place, thus eliminating the need for any 
translation.


> If you're talking about the INQUIRY command, the data better be within the
> first 36 bytes, or it's likely to not actually be there.

Certainly.

	Jeff




