From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: I/O write ordering
Date: Thu, 23 Sep 2004 13:40:02 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095910802.21753.1.camel@gaston>
References: <20040922025805.GA148414@sgi.com>
	 <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
	 <1095864485.2143.1.camel@mulgrave> <1095864709.6297.5.camel@gaston>
	 <1095865892.1715.5.camel@mulgrave> <1095865863.6340.7.camel@gaston>
	 <1095866530.2295.8.camel@mulgrave> <1095866930.6340.11.camel@gaston>
	 <1095867824.2295.13.camel@mulgrave> <1095898796.6359.18.camel@gaston>
	 <20040923015819.GU16153@parcelfarce.linux.theplanet.co.uk>
	 <1095908479.2295.53.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:3032 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S268235AbUIWDoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 23:44:08 -0400
In-Reply-To: <1095908479.2295.53.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Thu, 2004-09-23 at 13:01, James Bottomley wrote:

> The ownership model for consistent memory solves this.
> 
> Think of it this way: writes to consistent memory are normal memory
> writes (they don't trigger actions in the device), it's the writes to
> the device space that trigger actions.  All you want to ensure is that
> all the consistent memory writes are issued before the device is
> triggered into action.
> 
> So, in the ownership model you transfer the ownership of the consistent
> memory area to the device (which would be the heavyweight barrier on
> ppc) then write to the device space to trigger it.
> 
> synchronisation of consistent memory accesses can be done via normal
> spin locks; synchronisation of device space needs the the iomb() to
> prevent reordering leaks around the spinlock.

Sounds good, though may be a bit tricky to deal with for things where
both the kernel and the device are fiddling at the same time, like
the USB OHCI shared area, or ethernet descriptors... But it makes
sense. Could probably be built on top of the dma_consistent_sync... &
friends actually if driver used the properly (which they don't as
nobody really understand their semantics).

Ben.

