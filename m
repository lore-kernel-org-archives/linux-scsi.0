From: Alan Stern <stern@rowland.harvard.edu>
Subject: When should we avoid auto-sense? [was: USB 2.0 external hard drive
 problem]
Date: Fri, 6 Feb 2004 10:36:09 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402061029100.617-100000@ida.rowland.org>
References: <200402061510.i16FAxbX002025@burner.fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2052 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265479AbUBFPgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2004 10:36:10 -0500
In-Reply-To: <200402061510.i16FAxbX002025@burner.fokus.fraunhofer.de>
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <schilling@fokus.fraunhofer.de>
Cc: mdharm-usb@one-eyed-alien.net, appro@fy.chalmers.se, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, magliery@csb.yale.edu

On Fri, 6 Feb 2004, Joerg Schilling wrote:

> >Who says it's wrong to retrieve sense information when there is an
> >underrun but not Check Condition?  Can you provide a reference to a
> >published (or draft) document that states this?
> 
> The SCSI standard says that the sense data should retrieved when the 
> CHECK CONDITION bit is set. ATAPI drives use a bit in the ATA Status
> for this purpose.
> 
> Read the SCSI CAM standard to see more on this topic.

I have checked the standards.  They say that under certain circumstances
the driver must perform auto-sense.  As far as I can see they don't
mention any circumstances under which the driver _must not_ auto-sense.


> >Bear in mind that there are some transports which do not provide any
> >status at all.  The _only_ way for a driver to determine whether an
> >error occurred is to get the sense data.
> 
> Let us asume such transport does not exist, unless you name at least a
> single transport that has no bit that means "CHECK CONDITION".

The USB Control-Bulk transport does not include a status phase.  This
transport isn't used with CDs or DVDs; it's pretty much confined to USB
floppy disk drives and digital cameras.


> If you retrive sense data without reason, you may "read away" a senseful
> error status that is related to a different command. 

That's a good point.  Although for USB it's not so important, since there 
can only be one command running at a time.

I'd like to hear what Matt Dharm and the people on the SCSI development
mailing list have to say about that.

Alan Stern


