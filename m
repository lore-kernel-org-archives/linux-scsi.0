From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Tue, 13 Sep 2005 08:41:35 -0400
Message-ID: <4326C8FF.8050400@adaptec.com>
References: <20050910041218.29183.qmail@web51612.mail.yahoo.com> <Pine.LNX.4.63.0509101028510.4630@cuia.boston.redhat.com> <1126383605.30449.12.camel@localhost.localdomain> <20050911094007.GB5429@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51345 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932470AbVIMMln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 08:41:43 -0400
In-Reply-To: <20050911094007.GB5429@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/11/05 05:40, Christoph Hellwig wrote:
> 
> Yes, absolutely.  This discussion is driving far off right now, no one
> is asking Adaptec to add support for competing products here, we're just
> asking to not declare the host_template in the common code, and supporting
> limited controllers is one of the reasons.

Hi Christoph,

I cannot make something to be, something that it is not.

That is, the SAS LLDD is not a "scsi host" and it will never be,
because it is just not a "scsi host".

What it is, is an access point to the transport, this is its
sole function and existance.  E.g. it doesn't know about max_luns,
etc, which are purely SCSI Core-into-scsi_host concepts.
It does know about Execute Command SCSI RPC and TMFs.

The "scsi_host" template is a SCSI Core concept, which
mixes a software component (what it is) and a hardware component
(what you're talking about).

Now, see the layering infrastructure: SATA support:
The sas_sata_host.c file would also declare a scsi_host, where
it will define its own queuecommand(), eh_timed_out(),
eh_strategy_handler(), etc. and do the _protocol_ part,
whereby the SAS LLDD does the transport part.

	Luben





