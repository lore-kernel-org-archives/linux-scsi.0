From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 13:50:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0012AD911@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:55110 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S268060AbUIUUye convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 16:54:34 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>, Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>


On Tuesday, September 21, 2004 1:44 PM, Jeremy Higdon wrote:
> On Tue, Sep 21, 2004 at 05:25:35PM +0100, Matthew Wilcox wrote:
> > On Tue, Sep 21, 2004 at 08:58:23AM -0700, Andrew Vasquez wrote:
> > > From what I can gather from the hw engineers, the config-read
> > > will not guarantee a flush of posted writes.
> > 
> > I believe your hardware engineers to be mistaken.  See PCI 2.2,
> > Appendix E, section E.2: 
> > 
> > 2. Memory writes can be posted in both directions in a bridge. I/O
> > and Configuration writes are not posted. (I/O writes can be posted
> > in the Host Bridge, but some restrictions apply.) Read
> > transactions (Memory, I/O, or Configuration) are not posted.
> > 
> > 5. A read transaction must push ahead of it through the bridge any
> > posted writes originating on the same side of the bridge and
> > posted before the read. Before the read transaction can complete
> > on its originating bus, it must pull out of the bridge any posted
> > writes that originated on the opposite side and were posted before
> > the read command completes on the read-destination bus. 
> 
> 
> I would agree.  A config read should retire any posted I/O writes,
> whether Port or Memory Mapped.
> 
> So, unless the qla2xxx chips also do not respond to config reads
> after reset, the config read should be the answer . . .
> 

Yes, please see my earlier reply to Matthew:

	Hmm...adding more confusion to the mix.  I apologize -- my
	reply was not written correctly, yes, the config-read will
	flush any pending writes.  But, the same problem persists 
	- the RISC will still stop responding to requests (config
	or MMIO) during the soft-reset -- potentially resulting in
	a MAC (as seen by SGI).

> . . . unless there is some sort of random delay within the chip
> itself between a completion of the IO write on the PCI bus and the
> chip resetting itself.  That's not a problem, is it, Andrew?
>

The only requirement after reception of a soft-reset request (by PIO
or MMIO) by the RISC is for the driver to wait 16 PCI clocks before
issuing another request.  The problem of course is determining when to
start timing within the driver.

Regards,
Andrew Vasquez
