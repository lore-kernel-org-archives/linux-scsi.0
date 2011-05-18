From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Date: Wed, 18 May 2011 15:45:43 +1000
Message-ID: <1305697543.2781.28.camel@pasglop>
References: <20110504115324.GE17855@lsi.com>
	 <1305616571.6008.23.camel@mulgrave.site>
	 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	 <20110518041551.GL15227@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:36133 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1ERFqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 01:46:03 -0400
In-Reply-To: <20110518041551.GL15227@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, paulus@samba.org, linuxppc-dev@lists.ozlabs.org, Matthew Wilcox <matthew@wil.cx>


> > > Cc: stable@kernle.org
> > > Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> > > ---
> > > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > > index efa0255..5778334 100644
> > > --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > > @@ -1558,7 +1558,6 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> > >   * care of 32 bit environment where its not quarenteed to send the entire word
> > >   * in one transfer.
> > >   */
> > > -#ifndef writeq
> > 
> > Why not make this #ifndef CONFIG_64BIT?  You know that all 64 bit
> > systems have writeq implemented correctly; you suspect 32 bit systems
> > don't.
> > 
> > James
> > 
> > James, This issue was observed on PPC64 system. So what you have
> suggested will not solve this issue.
> > If we are sure that writeq() is atomic across all architecture, we
> can use it safely. As we have seen issue on ppc64, we are not
> confident to use
> > "writeq" call.
> 
> So have you told the powerpc people that they have a broken writeq?
> And why do you obfuscate your report by talking about i386 when it's
> really about powerpc64?

Well, our writeq isn't supposed to be broken :-)

It's defined as an std instruction (and "ld" for readq) so that's
perfectly atomic ... provided your access is aligned. Is it ?

Cheers,
Be

