From: "David S. Miller" <davem@davemloft.net>
Subject: Re: iomapping a big endian area
Date: Sat, 2 Apr 2005 18:38:05 -0800
Message-ID: <20050402183805.20a0cf49.davem@davemloft.net>
References: <1112475134.5786.29.camel@mulgrave>
	<20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-174.sfo1.dsl.speakeasy.net ([216.27.180.174]:49095
	"EHLO cheetah.davemloft.net") by vger.kernel.org with ESMTP
	id S261439AbVDCCia (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2005 21:38:30 -0500
In-Reply-To: <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 3 Apr 2005 02:37:57 +0100
Matthew Wilcox <matthew@wil.cx> wrote:

> My thought on this is that we should encode the endianness of the
> registers in the ioremap cookie.  Some architectures (sparc, I think?) can
> do this in their PTEs.  The rest of us can do it in our ioread/writeN
> methods.  I've planned for this in the parisc iomap implementation but
> not actually implemented it.

SPARC64 can do it in the PTEs, but we just use raw physical
addresses in our I/O accessors, and in those load/store instructions
we can specify the endianness.

Be careful though.  Endianness can be dealt with on a hardware
level.  Consider a byte access to a 32-bit word sized config space
datum, the PCI controller on a big-endian system will likely byte-twist
the data lanes in order for this to work properly.

It's a subtle issue, and it's explained pretty well in some of the
UltraSPARC PCI controller docs at:

	http://www.sun.com/processors/documentation.html

In particular, "U2P UPA to PCI User's Manual", chapter 10
"Little-Endian Support", has some informative diagrams.

