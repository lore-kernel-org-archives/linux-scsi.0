From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: RE: DPC vs tasklet
Date: Thu, 20 May 2004 11:14:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E704E37AED@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2981 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S265191AbUETSRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 14:17:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Jeff Garzik' <jgarzik@pobox.com>, arjanv@redhat.com
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


FC discovery is a rare occurance and potentially pretty complex. Based on
the input from everyone I feel much more confident about making it a DPC.
Thanks.
Jon

-----Original Message-----
From: Jeff Garzik [mailto:jgarzik@pobox.com]
Sent: Thursday, May 20, 2004 10:58 AM
To: arjanv@redhat.com
Cc: Infante, Jon; 'Christoph Hellwig'; Smart, James;
'linux-scsi@vger.kernel.org'
Subject: Re: DPC vs tasklet


Arjan van de Ven wrote:
> well there's a few angles here:
> 1) For IO completion (eg the common, fastpath case), you don't want to
> use a tasklet OR kernel-thread, just do the completion right there and
> then in the ISR, since the scsi layer completion handler you call will
> queue it for real work, the final completion, by the scsi softirq
> already.

Agreed, presuming that the IO completion is fairly cheap.


> 2) For management work, I can see the point of doing it in a
> kernel-thread, since it's 1) rare (eg slowpath) 2) complex 3) code that
> might want long-ish delays or allocate memory, neither of which you want
> in irq context.

Agreed.

	Jeff


