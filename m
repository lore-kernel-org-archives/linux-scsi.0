From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: Mon, 4 Oct 2004 17:33:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5705262196@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29140 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268591AbUJDVeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2004 17:34:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Saturday, October 02, 2004 8:50 AM, Christoph Hellwig wrote:
> On Sat, Oct 02, 2004 at 02:39:15PM +0100, Matthew Wilcox wrote:
> > Of course, at some point, Fusion should be switched over to use the
> > scsi_transport_spi domain validation code ... not urgent, just an
> > item for the long-term todo list.
> 
> absolutely.  Also the dv threaad handling in fusion is rather bogus,
> and moving to the genric one would fix that nicely.
>


I don't recommend removing the domain validation code in place of the
generic.

Points:
(1) We have three levels of DV(Domain Validation): none, basic, and
enahanced.
OEM Customers can set their own level of DV which is stored in nvram data,
and
passed to the driver and read thru config pages.

(2) MPT driver is sending negotiation through firmware config device pages 0
and 1.  Is there
another way to send negotiation {sdtr and ppr } messages directly to scsi
devices in
a generic API?  I have not looked at the generic DV, so I'm not for sure how
this would
be handled.

(3) How will a generic negotiation be done for raid volumes?  The MPT driver
supports RAID levels
0, 1, and 0+1.  The driver does DV via RAID passthru to the individual
devices. 

(4) The MPT driver has several work arounds in DV path to take advantage of
the
full inquiries that are passed as part of its alogirthm.  The problem in
older kernels
were some distro's such as SuSE was only sending 36 bytes of inquiry data
during Scaning the bus,
and we are needing 57 bytes to determine if device has IU and QAS set, as
well as detecting 
if the devices is a safte device.  In addition, with IU set or not, the
driver will know whether 64 or 256 luns
can be scanned for.

(5) We only do DV for SCSI HBA's. DV is not done for Fiber or SAS, which is
also handled by this driver.

(6) DV algorithm works, and well tested, and accepted by our OEMS. Nothing
is broke. Why break it?    

Eric Moore
LSI Logic
