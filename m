From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Fri, 16 May 2003 17:23:59 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305161715250.1555-100000@ida.rowland.org>
References: <20030516190414.GD11884@iucha.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:46084 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264609AbTEPVLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 17:11:07 -0400
In-Reply-To: <20030516190414.GD11884@iucha.net>
List-Id: linux-scsi@vger.kernel.org
To: Florin Iucha <florin@iucha.net>
Cc: David Brownell <david-b@pacbell.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Fri, 16 May 2003, Florin Iucha wrote:

> On Fri, May 16, 2003 at 02:54:00PM -0400, Alan Stern wrote:
> > 
> > The logs you posted did not include the usb-storage debugging output.  
> > Either you didn't configure it in your kernel, or you had the console 
> > logging level set too low to capture debug-priority messages.
> > 
> > Maybe David Brownell will be able to learn something from the ehci log
> > messages.
> 
> D'oh! I have attached the respective kern.log. 

Good.  This clearly shows the problem.  It's an error in the SCSI driver.  
It has shown up before and been discussed at length a few weeks ago.  The
problem is that a MODE-SENSE(6) command is requesting a transfer of 3
bytes, which is smaller than the minimum of 4 bytes for that command.  
The device doesn't like it and crashes.

The SCSI people are supposed to be working on this.  First, we should be 
using MODE-SENSE(10) by default rather than MODE-SENSE(6).  Second, we 
should never request a transfer smaller than the minimum allowed size.  
When these changes are ready you shouldn't have any more trouble.

The OOPS you got originally was caused by the lack of proper 
hot-unplugging cooperation between usb-storage and the SCSI driver.

Alan Stern

