From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: iomapping a big endian area
Date: Tue, 05 Apr 2005 09:43:39 +1000
Message-ID: <1112658219.26086.110.camel@gaston>
References: <1112475134.5786.29.camel@mulgrave>
	 <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk>
	 <20050402183805.20a0cf49.davem@davemloft.net>
	 <20050403031000.GC24234@parcelfarce.linux.theplanet.co.uk>
	 <1112499639.5786.34.camel@mulgrave>
	 <20050402200858.37347bec.davem@davemloft.net>
	 <1112502477.5786.38.camel@mulgrave>  <1112601039.26086.49.camel@gaston>
	 <1112623143.5813.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261528AbVDDXt6@vger.kernel.org>
In-Reply-To: <1112623143.5813.5.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "David S. Miller" <davem@davemloft.net>, matthew@wil.cx, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-04-04 at 08:59 -0500, James Bottomley wrote:
> On Mon, 2005-04-04 at 17:50 +1000, Benjamin Herrenschmidt wrote:
> > I disagree. The driver will never "know" ...
> 
> ? the driver has to know.  Look at the 53c700 to see exactly how awful
> it is.  This beast has byte and word registers.  When used BE, all the
> byte registers alter their position (to both inb and readb).

What I mean is that the driver doesn't have "know" whatever CPU/bus
combo endianness will require it to use "native" or "swapped" access.
What the driver knows is wether the device it tries to access need BE or
LE accessors.

> > I don't think it's sane. You know that your device is BE or LE and use
> > the appropriate interface. "native" doesn't make sense to me in this
> > context.
> 
> Well ... it's like this. Native means "pass through without swapping"
> and has an easy implementation on both BE and LE platforms.  Logically
> io{read,write}{16,32}be would have to do byte swaps on LE platforms.
> Being lazy, I'm opposed to doing the work if there's no actual use for
> it, so can you provide an example of a BE bus (or device) used on a LE
> platform that would actually benefit from this abstraction?

I don't think drivers will benefit from "native" vs. "swapping". Taht
means that pretty much all drivers that care will end up with #ifdef
crap to pick up the right one based on the CPU endian, and some wil get
it wrong of course. No, I _do_ thing that this should be hidden in the
implementation, and we should provide "le" and "be" accessors (le beeing
the current ones, be new ones). Which one swap or not is in the
implementation of those accessors for the architecture, but the driver
shouldn't have to care.

Ben.
