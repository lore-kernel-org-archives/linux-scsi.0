From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger
 receive buffer
Date: Fri, 14 Nov 2003 11:14:08 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311141058290.1090-100000@ida.rowland.org>
References: <1068767049.2851.166.camel@patrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:14852 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262762AbTKNQOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 11:14:09 -0500
In-Reply-To: <1068767049.2851.166.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On 13 Nov 2003, Pat LaVarre wrote:

> I mean to be saying sd.c should by default send the CDB's associated
> with buffer lengths that produce the same BBB CBW's as Windows XP/2K,
> and then determine the read/write status and cache-type from that info
> alone.
> 
> Do you agree that works for generic USB storage i.e. bInterfaceClass
> ...SubClass ...Protocol = x 08 (02|05|06) 50?
> 
> Do you disagree that is what we should do in sd for generic USB storage?
> 
> I'm confident Win XP/2K sometimes sends mode select to PDT x00
> HDD/Flash, because I remember some months back a friend fixed some
> firmware that didn't interpret mode select like Win wants nowadays.
> 
> I imagine that means Win sends mode sense too.
> 
> I haven't yet seen a trace of Win XP/2K.

Trying to rely too heavily on Talk Like Windows may be a mistake, since 
Windows itself seems to use different dialects in its different versions.
It reminds me of the mess Microsoft had with their SMB file-sharing 
network protocol; different versions of Windows were so incompatible they 
often couldn't communicate among themselves.

CDs, DVDs, etc. present their own set of problems.  For the moment I'm
just concerned about disk-type devices, and the only reliable way I can
see to deal with them is to avoid sending any MODE-SENSE commands over
USB.

Unfortunately that does mean we lose the ability to tell if a compliant
device/media is write-protected.  You suggested allowing MODE-SENSE
commands for devices that present certain standard SubClass and Protocol
values, or disallowing them only for devices that present vendor-specific
values.  I'm not so sure that will work -- I haven't kept good records of
users' reports, but it wouldn't be at all surprising to find that some
apparently-compliant devices (bInterfaceSubClass = x06, Protocol = x50)
still have problems with MODE-SENSE.

Alan Stern

