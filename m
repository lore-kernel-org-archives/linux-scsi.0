From: Matthew Wilcox <willy@debian.org>
Subject: Re: Support for LSI 53C1010R
Date: Tue, 13 Apr 2004 16:09:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040413150908.GS18329@parcelfarce.linux.theplanet.co.uk>
References: <C18BA5DDB58DD511BD0700C0DF0DD45028B295@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47255 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263551AbUDMPJP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 11:09:15 -0400
Content-Disposition: inline
In-Reply-To: <C18BA5DDB58DD511BD0700C0DF0DD45028B295@NTSERVER4>
List-Id: linux-scsi@vger.kernel.org
To: Phil Thompson <philt@4bridgeworks.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Apr 13, 2004 at 02:21:13PM +0100, Phil Thompson wrote:
> I'm having problems with the Linux sym53c8xx_2 (sym-2.1.17a) driver on an
> embedded system with an LSI 53C1010R. Are there any issues with the driver
> and that revision of the chip - specifically the R suffix?

I don't have a 1010R myself, only the data sheet.

> The driver tries to do some things with the chip which (according to the
> datasheet) aren't supported. For example, the first problem is that it fails
> to determine the PCI clock frequency - it times out in sym_hipd.c:getfreq()
> waiting for the GEN flag (almost as if there is no SCSI clock). Just prior
> to this (in sym_getpciclock()) it tries to set the SCLK bit of STEST1 in
> order to use the PCI clock as the SCSI clock - but that bit is reserved
> according to the datasheet.

Yes.  It's reserved for the 1010 too, and this problem doesn't occur
there.  Does the problem go away if you stop setting that bit?  If so it
would be straightforward to conditionalise this setting on a feature bit.
My guess is that it's something else though.

> The same hardware seems to work with a much simpler, internally written,
> driver.

I'd like to simplify the sym2 driver; it's far too complicated.  It'll
take a while though.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
