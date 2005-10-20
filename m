From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 12:51:15 -0400
Message-ID: <4357CB03.4020400@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <20051020160155.GA14296@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:4778 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932486AbVJTQvV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 12:51:21 -0400
In-Reply-To: <20051020160155.GA14296@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 12:01, Christoph Hellwig wrote:
> 
> As you mentioned doing link reset and reporting stats on expanders
> is done using SMP, and thus totally independent of the driver used.

Not quite. "Dispatching to" would be driver dependent.  If you implement
sdi_register_provider(struct ...); then you can make everyone happy
in the _shortest_ amount of time.

I'd suggest a reading of the SDI, SAS and SAM specs for an insight
of how it all ties together.

> It should be either implemented in the transport class or in userland.
> Doing it in the transport class has the advantage of a unified interface
> for hba phys and expander phys, doing it in userland has the advantage
> of less kernel bloat.

You already know the answer to that.

"customers" and "customer satisfaction" is a foreign
concept with the community, being the nature of Linux as it is,
but what you should want to is:
	- make less applications (which you may not know of)
	  break,
	- make less assumptions already taken break.

Those applications are already using SDI and only the interface
would change ("/dev/sg") if you were to implement
drivers/scsi/sdi.c.

> I've done a prototype using an SG_IO interface, but I'm not totally
> happy about.

Care to say why?

> I've also seen lubens interface and I'm not totally
> happy about it either.

Care to say why?

> Getting the interface right for SMP passthru is very hard.

1) You have the SDI spec which _tells you_ how to do it.
2) There are (HP) applications which already use that (1).

You have to stay focused on _what is required_.

Why are you trying to reinvent "SMP passthrough"?
Why not just make the customers happy?

If you implement drivers/scsi/sdi.c, as:

int  sdi_register_provider(struct sdi_provider_struct *sdi_prov);
void sdi_unregister_provider(struct sdi_provider_struct *sdi_prov);

everyone will be _more than happy_ to plug right into it.
And those are the only 2 functions you need to EXPORT_SYMBOL_GPL.

Everything else (SDI_ functions) would be in the struct as stubs
and the provider would set them if they implement them.

LSI/HP can plug right into it with *minimum of overhead*,
testing etc, both from their application side and from kernel
side.  And this is important to both customers and companies.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
