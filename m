From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: PATCH: exclude certain commands from
 emulated SCSI hosts
Date: Wed, 23 Apr 2003 16:22:05 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304231616300.1307-100000@ida.rowland.org>
References: <1051040463.1768.82.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:36100 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264252AbTDWUJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 16:09:58 -0400
In-Reply-To: <1051040463.1768.82.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, mike@hingston.demon.co.uk, steliam@popies.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

On 22 Apr 2003, James Bottomley wrote:

> On Tue, 2003-04-22 at 14:30, Andries.Brouwer@cwi.nl wrote:
> > That is a pity, because my 4 was arrived at by careful experimentation.
> > It may mean that there is no uniform length that works.
> > And no amount of filtering will work, unless we decide
> > not to use MODE_SENSE at all.
> 
> Well, actually, we could do the filter in the same place that converts
> the MODE SENSE(6) to MODE SENSE(10) (drivers/usb/storage/protocol.c). 
> If it just returns an error when len < 8 we will drop through to the 255
> byte request quickly which, on the 2.4 evidence, should work.
> 
> > But let us first confirm the theory.
> 
> Agreed.
> 
> James

One of the attachments for bug 510 contains a kernel log showing 
successful access under 2.4.21.  The MODE-SENSE command was:

> Mar 30 19:47:47 crusoe kernel: usb-storage: Command MODE_SENSE (6 bytes)
> Mar 30 19:47:47 crusoe kernel: usb-storage: 1a 00 3f 00 ff 00 00 00 00 00 14 c0

and it worked with no errors.  This seems to confirm the theory.

Comment #21 contains an explanation of the problem from Matt Dharm:

> The delays are being caused by the SCSI layers repeatedly issuing
> commands that the device does not understand.  I'm working with the SCSI
> group on a fix.

Alan Stern

