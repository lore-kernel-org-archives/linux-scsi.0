From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.0-test1: random errors for USB disk
Date: Thu, 17 Jul 2003 15:34:40 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307171520390.1251-100000@ida.rowland.org>
References: <3F16D933.2080607@Synopsys.COM>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:18692 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268102AbTGQTTq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 15:19:46 -0400
In-Reply-To: <3F16D933.2080607@Synopsys.COM>
List-Id: linux-scsi@vger.kernel.org
To: Harald Dunkel <harri@synopsys.COM>
Cc: David Brownell <david-b@pacbell.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 17 Jul 2003, Harald Dunkel wrote:

> Harald Dunkel wrote:
> > Alan Stern wrote:
> > 
> >>
> >> Did you say that this worked correctly under 2.4.22?  If it does, 
> >> could you send the equivalent system log (with usb-storage debugging 
> >> enabled) showing what happens when you create a filesystem and 
> >> everything works right?
> >>
> > The rebuild is running. But the last working version I have is 2.4.21
> > plus the USB patches of June 20th. Is it OK to start with this version?
> > 
> 
> See attachment.

The information in your system logs is very clear.  Your USB drive worked 
just great until it received a big data transfer.

Under 2.4, the largest WRITE transfer was 130048 bytes and it worked fine.  
Under 2.6, the largest attempted WRITE transfer was 524288 bytes and it
crashed the drive.  The two commands were otherwise identical.

Presumably differences in the block I/O systems account for the difference
in buffer sizes.  But I don't know of any way to tell Linux that the drive
is unable to accept data transfers larger than some fixed limit.

Can anyone else suggest a way to solve this?

Alan Stern

