From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Mon, 19 Dec 2011 14:27:38 -0600
Message-ID: <1324326458.5123.14.camel@dabdike.int.hansenpartnership.com>
References: <4EE9B375.4020606@linutronix.de> <20111215211201.GA6482@xanatos>
	 <20111216144724.GC19563@linutronix.de>
	 <20111216201236.GE19563@linutronix.de>
	 <20111216203146.GN14291@linux.intel.com>
	 <20111216204241.GA30915@linutronix.de> <20111216213628.GA5509@xanatos>
	 <1324072059.10429.27.camel@dabdike>
	 <20111219161225.GO14291@linux.intel.com>
	 <1324314850.5123.12.camel@dabdike.int.hansenpartnership.com>
	 <20111219183633.GP14291@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55651 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131Ab1LSU1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 15:27:41 -0500
In-Reply-To: <20111219183633.GP14291@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Mon, 2011-12-19 at 13:36 -0500, Matthew Wilcox wrote:
> On Mon, Dec 19, 2011 at 11:14:10AM -0600, James Bottomley wrote:
> > On Mon, 2011-12-19 at 11:12 -0500, Matthew Wilcox wrote:
> > > By the way, the same verbiage about tags being shared across LUNs is also
> > > present in the SAS spec (and various other specs last time I looked,
> > > which wasn't recently).
> > 
> > I don't think so: The SAS spec still (as of 2.1) has the nexus being
> > I_T_L_Q.  That means a unique combination of initiator port, target
> > port, lun and tag identify a nexus.  To have the nexus be blind to the
> > Lun (i.e. tags shared across LUNs) it would have to be identified by
> > I_T_Q, which I haven't actually seen in any standard.
> 
> sas2r14:
> 
> 10.2.3 Device server error handling
> If the SCSI target device performs tag checking and an SSP target port calls SCSI Command Received () with
> a tag already in use by another SCSI command (i.e., an overlapped command) in any logical unit, the task
> router and device server(s) shall abort all task management functions received on that I_T nexus and shall
> respond to the overlapped command as defined in SAM-4.
> 
> > I'm not even sure a transport would be allowed to override this; SAM is
> > pretty clear (s 4.12 The Nexus Object) that a nexus is either I_T, I_T_L
> > or I_T_L_Q.  I_T_Q isn't listed as being allowable for a nexus.
> 
> sam4r13f:
> 
> 4.7.2 Command identifier
> 
> A command identifier (i.e., the Q in an I_T_L_Q nexus) is assigned by a
> SCSI initiator device to uniquely identify one command in the context of a
> particular I_T_L nexus, allowing more than one command to be outstanding
> for that I_T_L nexus at the same time. Each SCSI transport protocol
> defines the size of the command identifier, up to a maximum of 64 bytes,
> to be used by SCSI ports that support that SCSI transport protocol.
> 
> SCSI transport protocols may define additional restrictions on command
> identifier assignments (e.g., requiring command identifiers to be unique
> per I_T nexus or per I_T_L nexus, or sharing command identifier values
> with other uses such as task management functions).

Hm, OK, that was actually something added to SAM-4.  It's not present in
SAM-3.  However, it does look like SAS always tried to get away with
this, notably by deciding in SAS-1 (which was SAM-3 based) that the
Frame tag wasn't the same thing as a SAM-3 Q.

James


