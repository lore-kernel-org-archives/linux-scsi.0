From: Christoph Hellwig <hch@infradead.org>
Subject: Re: iomapping a big endian area
Date: Mon, 4 Apr 2005 15:16:16 +0100
Message-ID: <20050404141616.GA10384@infradead.org>
References: <1112475134.5786.29.camel@mulgrave> <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk> <20050402183805.20a0cf49.davem@davemloft.net> <20050403031000.GC24234@parcelfarce.linux.theplanet.co.uk> <1112499639.5786.34.camel@mulgrave> <20050402200858.37347bec.davem@davemloft.net> <1112502477.5786.38.camel@mulgrave> <1112601039.26086.49.camel@gaston> <1112623143.5813.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57801 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261225AbVDDOQR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2005 10:16:17 -0400
Content-Disposition: inline
In-Reply-To: <1112623143.5813.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "David S. Miller" <davem@davemloft.net>, matthew@wil.cx, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>

On Mon, Apr 04, 2005 at 08:59:03AM -0500, James Bottomley wrote:
> Well ... it's like this. Native means "pass through without swapping"
> and has an easy implementation on both BE and LE platforms.  Logically
> io{read,write}{16,32}be would have to do byte swaps on LE platforms.
> Being lazy, I'm opposed to doing the work if there's no actual use for
> it, so can you provide an example of a BE bus (or device) used on a LE
> platform that would actually benefit from this abstraction?

The IOC4 device that provides IDE, serial ports and external interrupts
on Altix systems has a big endian register layour, and the PCI-X bridge
in those Altix systems can do the swapping if a special bit is set.

In older kernels that bit was set from the driver through a special API,
but it seems the firmware does that automatically now.

