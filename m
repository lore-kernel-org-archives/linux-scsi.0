From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: 04 Oct 2004 16:57:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096927040.2287.34.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5705262196@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:34793 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268697AbUJDV5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Oct 2004 17:57:48 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5705262196@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: Eric Dean Moore <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-10-04 at 16:33, Moore, Eric Dean wrote:
> Points:
> (1) We have three levels of DV(Domain Validation): none, basic, and
> enahanced.
> OEM Customers can set their own level of DV which is stored in nvram data,
> and
> passed to the driver and read thru config pages.

By basic and enhanced I presume you mean read only vs device write echo
buffer tests?

You can chose not to invoke spi_dv_device(), so we can do none and
enhanced (whether we do enhanced or basic depends on device support for
the echo buffer).

> (2) MPT driver is sending negotiation through firmware config device pages 0
> and 1.  Is there
> another way to send negotiation {sdtr and ppr } messages directly to scsi
> devices in
> a generic API?  I have not looked at the generic DV, so I'm not for sure how
> this would
> be handled.

No, the API assumes you supply the functions for setting and retrieving
the transport parameters.  How you implement this is at your option.

> (3) How will a generic negotiation be done for raid volumes?  The MPT driver
> supports RAID levels
> 0, 1, and 0+1.  The driver does DV via RAID passthru to the individual
> devices. 

As long as real scsi_device devices exist for the passthrough, it would
also be able to do dv for those.

> (4) The MPT driver has several work arounds in DV path to take advantage of
> the
> full inquiries that are passed as part of its alogirthm.  The problem in
> older kernels
> were some distro's such as SuSE was only sending 36 bytes of inquiry data
> during Scaning the bus,
> and we are needing 57 bytes to determine if device has IU and QAS set, as
> well as detecting 
> if the devices is a safte device.  In addition, with IU set or not, the
> driver will know whether 64 or 256 luns
> can be scanned for.

This is obsolete and needs removing ... the mid layer does a 2 phase
inquiry and sets the capability support based on this.  No device should
be doing inquiry snooping.

> (5) We only do DV for SCSI HBA's. DV is not done for Fiber or SAS, which is
> also handled by this driver.

DV is part of the SPI transport class only ... it's not an option for
the others.

> (6) DV algorithm works, and well tested, and accepted by our OEMS. Nothing
> is broke. Why break it?    

Because sharing code and thus increasing its usage is good.

James

