From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Tue, 29 Apr 2008 14:16:55 -0700
Message-ID: <20080429211655.GA72811@plap4.qlogic.org>
References: <4811ACAC.7060808@linpro.no> <20080425155018.GG8849@plap4> <48120F8B.7060005@linpro.no> <20080425171821.GK8849@plap4> <4815709C.3060502@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6419 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYD2VQ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 17:16:56 -0400
Content-Disposition: inline
In-Reply-To: <4815709C.3060502@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 28 Apr 2008, Tore Anderson wrote:

> * Andrew Vasquez
> 
> > Hmm, MSI is enabled:
> 
> Indeed - seems to be the default behaviour.
> 
> > could you try disabling MSI via 'pci=nomsi' (I believe), we've dealt 
> > with a large number of problem reports where customers reported 'odd'
> > behaviours (no interrupt routining) with several motherboard
> > chipsets. At least it could be another useful datapoint...
> 
> The system has now been up for 58 hours straight with MSI disabled per
> your suggestion.  This is almost a new record, usually it has crashed
> once per day or more.  I won't open the champagne before a week more has
> passed, but this looks _very_ promising!

That's good news...

> Thank you very much for your help in tracking this down!  Be sure to let
> me know if you want any more information and I'll see what I can do.
> The system isn't yet back in full production, so I have a small window
> of opportunity to reproduce the problem, test patches, and so on.

In general, most MSI/MSI-X machine/chipset quirks (global/bus-level
disabling) are handled by the PCI layer.  I'd be curious to see if any
of the 30+ updates to drivers/pci/quirk.c since 2.6.22 have addressed
this issue via DECLARE_PCI_FIXUP_FINAL()???

Could you send the output of 'lspci -vvx'?
