From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 3 May 2009 14:37:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905031135020.17195-100000@netrider.rowland.org>
References: <20090503152408.GT8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:42122 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752801AbZECSh0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 14:37:26 -0400
In-Reply-To: <20090503152408.GT8822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, ?ric Piel <eric.piel@tremplin-utc.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Sun, 3 May 2009, Matthew Wilcox wrote:

> > The problem is we don't trust USB manufacturers with standards
> > compliance any further than they could spit a rat, so we assume when
> > they say they conform to SCSI-3 or above that they must have got it
> > wrong and push it back down to SCSI-2.

Indeed, we have run across a number of USB devices which claim to be 
SCSI-3 compliant and then crash when they receive a REPORT LUNS 
command.

> > Because of this, no-one actually knows how many working SCSI-3 USB
> > devices we might have supported.
> 
> This is true.  Suggestions for a better way to handle USB devices ... ?

Is there any reason usb-storage shouldn't set the FORCELUNS flag for 
all devices not known to have only one LUN?

Eric is trying to address two separate issues.  One is bad or outdated 
wording of the Kconfig help text for SCSI_MULTI_LUN.  The other is the 
fact that some USB devices can't be used to their full extent when the 
option isn't set, and people rolling their own configs (as opposed to 
using a distro kernel) tend not to enable it.  Maybe changing the help 
text will be enough for both problems.

As for future treatment of USB devices claiming SCSI-3 compliance (or 
above), I don't know.  Keep the field unchanged but set a flag to rule 
out the use of REPORT LUNS?

Alan Stern

