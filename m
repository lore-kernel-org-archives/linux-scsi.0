From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 17:28:49 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310281724430.6912-100000@ida.rowland.org>
References: <1067374593.7040.84.camel@patehci2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:29956 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261787AbTJ1W2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 17:28:52 -0500
In-Reply-To: <1067374593.7040.84.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: ronald@kuetemeier.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

On 28 Oct 2003, Pat LaVarre wrote:

> > > ... not clear to me what is the best way to take care of the devices that 
> > > choke on page 3F ...
> > Some of us have suggested substituting:
> > -y "5A 00 08:00:00:00 00 00:1C 00" -i x1C // Mode Sense 10 of SBC/MMC
> > Page x08 Cacheing for 8 byte header, optional 8 byte block descriptor,
> > and xC byte standard page x08 length
> 
> >From a contemporaneous thread:
> 
>   - Host requests MODE_SENSE_10 and request 28 bytes
>   - But the device only has 20 bytes, so it
> 
> Translating, we see that the terms 20 28 here mean what more bus traces
> show as x14 x1C.  That again suggests talk-like-Windows might be:
> 
> -y "5A 00 08:00:00:00 00 00:1C 00" -i x1C
> 
> Those devices that only agree to copy in x14 = 20 bytes may be omitting
> the optional 8 byte block descriptor, in accord with what I think I
> remember MMC requires, though simultaneously in discord with what I'm
> almost sure I remember SBC recommends.
> 
> Pat LaVarre

Pat, I think maybe you're misunderstanding the reason behind this thread.  
The device in question wasn't failing the MODE-SENSE(10) for page x08 
(determine cache-type); it was failing the MODE-SENSE(10) for page x3F 
(where only the first 4 bytes are read to determine write-enable).

The code that does this is in 
drivers/scsi/sd.c:sd_read_write_protect_flag().

Alan Stern

