From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: DPC vs tasklet
Date: Thu, 20 May 2004 13:57:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40ACF18B.60708@pobox.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com> <1085073616.2784.14.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9107 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265230AbUETR5r
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 13:57:47 -0400
In-Reply-To: <1085073616.2784.14.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: "Infante, Jon" <Jon.Infante@Emulex.Com>, 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

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



