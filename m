From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: 21 Sep 2004 13:56:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095789421.2467.414.camel@mulgrave>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk>
	<200409211303.19110.jbarnes@engr.sgi.com>
	<1095787216.2507.340.camel@mulgrave>
	<200409211346.58267.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22454 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267879AbUIUR6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 13:58:35 -0400
In-Reply-To: <200409211346.58267.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, 2004-09-21 at 13:46, Jesse Barnes wrote:
> > What ioflush() call?  There's no such thing in PCI; this is effectively
> > our problem.  If there were a nice flush instruction we wouldn't have to
> > worry about reading from somewhere on the device.  The problem is that
> > there's no a-priori way of knowing what read is safe to do, so there's
> > no generic way to extract a posting flush API.
> 
> The one I just added with this patch.  It takes a struct device and address 
> arguments, the latter is supposed to be a safe register, like config space.
> 
> I'm tying together the concepts of write posting and ordering intentionally, 
> but I wonder if that's a good idea.  On the one hand, we don't want to 
> introduce *two* new driver APIs, but on the other, ensuring ordering and 
> actually flushing writes out are two different things.  Maybe we just need to 
> tell people 

Really, I don't think this is a good idea.  If there were a way to
produce an api that was just ioflush(struct device *) then yes, since it
would reduce confusion.  However, since all your API does is hide the
fact that you're doing a MMIO read then the proposed API provides no
relief from the fact that the driver writer needs to understand
posting...all it does is add one extra function for them to misuse or
get confused about.

James


