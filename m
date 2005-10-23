From: Douglas Gilbert <dougg@torque.net>
Subject: max_sectors [was Re: [PATCH RFC] yet more struct scsi_lun]
Date: Mon, 24 Oct 2005 00:27:33 +1000
Message-ID: <435B9DD5.5040907@torque.net>
References: <20051023043301.GA22615@havoc.gtf.org>	 <20051023070011.GA26569@havoc.gtf.org>  <435B6A62.8070306@torque.net> <1130068390.2775.6.camel@laptopd505.fenrus.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:56801 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750722AbVJWO0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 10:26:37 -0400
In-Reply-To: <1130068390.2775.6.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, michaelc@cs.wisc.edu, Kai.Makisara@kolumbus.fi

Arjan van de Ven wrote:
>>Which in turn makes me think of applying the same idea
>>to max_sectors
>>
>>        shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;
>>
>>which would be the default unless the HBA (RAID controller
>>or whatever) really does have a (practical) limit. If a
>>device beyond the target has a limit, then that is not the
>>LLD's concern.
> 
> 
> this is a bit of a problem since we don't know all the limits. We do
> know that Microsoft Windows at least used to have a 64Kb limit, and that
> that limit is "safe" in the sense that all hw was tested/designed for
> that. So setting the default safe, and overriding it per driver sounds
> best. It only really matters for a handful of drivers anyway, and those
> either already set something or ought to.

I would be very surprised if Microsoft limited their
SCSI or ATA pass through to 64 KB per command. It would
make sending microcode to a device (WRITE BUFFER in
SCSI command sets, DOWNLOAD MICROCODE in ATA) a real pain.
WRITE BUFFER can send smaller amounts with offsets but not
all devices support that. Why needlessly widen the window
on a process that if it fails may trash the device.

As I have pointed out before, the SBC-2 Block Limits VPD
page has both optimal and maximum values. I see no reason
why normal VFS reads and writes would need to be above
the optimal value (which the SCSI mid level could default
in the absence of that page to say 64 KB). The maximum
value is another matter. A REQ_SPECIAL conveys
layered errors back to the invoker; so the block layer
shouldn't "block" such requests on suspicion; if something
lower down doesn't like it then it can complain.

Does anyone know a PCI HBA produced in the last 6 years
that can't DMA at least 16 MB?

Mike Christie has done some good work on both sg and st
to make them use common code to build scatter gather lists.
However, while max_sectors is in place with its current
semantics that work can go no further.


Doug Gilbert

