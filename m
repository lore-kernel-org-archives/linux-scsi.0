From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 07:21:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <9B540282-15E4-11D8-9DF1-0050E416C45B@ieee.org>
Mime-Version: 1.0 (Apple Message framework v552)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rly-ip04.mx.aol.com ([64.12.138.8]:51106 "EHLO
	rly-ip04.mx.aol.com") by vger.kernel.org with ESMTP id S264300AbTKMOWb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 09:22:31 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: p.lavarre@ieee.org, mdharm-scsi@one-eyed-alien.net

 > This is a terrible idea.
 > There is a large number of devices
 > which choke if those two values do not match.

Did I miss our record of the search for plscsi parameters that Sony's 
USB mass storage would accept?

I remember seeing we did try mode sense of header and whole page, but 
not being convinced we had tried every reasonably variation of that.

 > > should not affect other devices since
 > > we are not changing the requested length,
 > > just the size of the receive
 > > buffer.

Sorry.  The size of the receive buffer crosses the bus at least to USB 
and to FireWire devices.  Assaulting devices with noise then finds 
hits, yes.

Also in a robust SCSI over whatever host, the bytes per buffer 
parameter also alters the behaviour of ATAPI PIO drivers, though I do 
not yet know myself if Linux ATAPI is robust in that way.

 > > Can we use a minium buffer length of 12 for
 > > any requests of less than 13 bytes?
 >
 > You can try.... I don't know if it will work.

Me neither.

A device refusing to agree to copy as few bytes as a header is a device 
telling us we're not talking like Windows.  From the thread "usb 
storage traces" we know Windows does sometimes fetch header, calculate 
available length, fetch whole ... but apparently not for mode page x08 
from this Sony device.

 > > Else, I give up ...

We can give up on PDT x00 HDD/Flash that is writable except when the 
write-protect tab is flipped ... without necessarily giving up on the 
PDT x05 DVD/CD where those "usb storage traces" show us Windows 
actually bothering to try the politically correct speech we see 
implicitly blessed at t10.org.

Pat LaVarre

P.S. If this mail appears in the correct thread and appears labelled 
"Pat LaVarre" rather than "Steve Jobs", I will have achieved a new high 
in my understanding of `nslookup -q=mx $domain` etc.

