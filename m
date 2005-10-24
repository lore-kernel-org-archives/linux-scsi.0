From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally	attached
 PHYs)
Date: Mon, 24 Oct 2005 11:18:22 -0400
Message-ID: <435CFB3E.7040902@adaptec.com>
References: <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com>	 <435959BE.5040101@pobox.com> <43595CA6.9010802@adaptec.com>	 <43596070.3090902@pobox.com> <43596859.3020801@adaptec.com>	 <43596F16.7000606@pobox.com> <435A1793.1050805@s5r6.in-berlin.de>	 <20051022105815.GB3027@infradead.org>	 <1129994910.6286.21.camel@sipan.sipan.org>	 <20051022171943.GA7546@infradead.org> <1130002704.8775.12.camel@sipan.sipan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:50637 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751088AbVJXPS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 11:18:29 -0400
In-Reply-To: <1130002704.8775.12.camel@sipan.sipan.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Panov <sipan@sipan.org>
Cc: Christoph Hellwig <hch@infradead.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

On 10/22/05 13:38, Sergey Panov wrote:
>   I just was trying to point out that Luben's transport "layers" in
> place of transport "modules-appendages" simplifies that
> migration/evolution.

True. "modules-appendages" just makes everything messy.  There is
so much SPI in the host template... Take for example recovery,
or as Linux SCSI calls it Error Handling (EH).

EH in Linux SCSI is SPI.  This is a fact, and anyone can look at the
code to convince themselves.

In order to properly get rid ourselves of HCIL, recovery should
be offloaded to the transport _layer_ which communicates with
the transport/interconnect to get things going, as shown in the SAS
Transport Stack at the link in my signature, USB* or SBP subsystems.

* I've been asking Alan to properly implement USB recovery
in the USB Storage subsystem...  Maybe one day...

That is, the layer above knows nothing of the layer below, but
each layer provides well defined functionality, and they all
work in tandem.  This is exactly what allows for quick growth
and rich future (of a design).

In such a design, SCSI Core would be very small and the task
paths would be very straightforward as shown in the SAS Transport
Stack in the link in my signature, USB or SBP subsystems.

BTW, "modules-appendages" very truly describes the current state
of Linux SCSI and this can be seen from, for example the scsi host
structure, where those "modules-appendages" are "hooked".

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
