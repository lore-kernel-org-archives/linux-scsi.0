From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Mon, 21 Sep 2009 09:37:32 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C5124FF@cosmail02.lsi.com>
References: <4AB48254.4000404@attglobal.net>
	 <20090919165404D.fujita.tomonori@lab.ntt.co.jp>
	 <4AB4F792.8020308@attglobal.net>
	 <20090921225015B.fujita.tomonori@lab.ntt.co.jp>
 <1253547244.4579.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:58787 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbZIUPhq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2009 11:37:46 -0400
In-Reply-To: <1253547244.4579.4.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "stunnel@attglobal.net" <stunnel@attglobal.net>, "matthew@wil.cx" <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I am checking with our FW team...

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Monday, September 21, 2009 11:34 AM
To: FUJITA Tomonori
Cc: stunnel@attglobal.net; matthew@wil.cx; linux-scsi@vger.kernel.org; Yang, Bo
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit. 2.6.29.6

On Mon, 2009-09-21 at 22:51 +0900, FUJITA Tomonori wrote:
> On Sat, 19 Sep 2009 08:24:02 -0700
> Eddie <stunnel@attglobal.net> wrote:
> 
> > FUJITA Tomonori wrote:
> > > Thanks, now the problem is clear; the driver uses 64bit dma_mask but
> > > the hardware is not capable of 64bit dma according to James. Seems
> > > that hardware lies about the dma capability.
> > >
> > > Can you try the following patch?
> > >
> > >
> > > diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> > > index 234f0b7..9ead856 100644
> > > --- a/drivers/scsi/megaraid/megaraid_mbox.c
> > > +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> > > @@ -888,6 +888,8 @@ megaraid_init_mbox(adapter_t *adapter)
> > >  	if (((magic64 == HBA_SIGNATURE_64_BIT) &&
> > >  		((adapter->pdev->subsystem_device !=
> > >  		PCI_SUBSYS_ID_MEGARAID_SATA_150_6) &&
> > > +		(adapter->pdev->device !=
> > > +		PCI_DEVICE_ID_AMI_MEGARAID3) &&
> > >  		(adapter->pdev->subsystem_device !=
> > >  		PCI_SUBSYS_ID_MEGARAID_SATA_150_4))) ||
> > >  		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC &&
> > >
> > >   
> > OK, that appears to have done the trick.
> 
> Thanks for the confirmation.
> 
> James, here's a patch in the proper format.

Got it ... I'd like to wait on confirmation from LSI on this ... I
actually said the Megaraid3 wasn't 64 bit based on the 64 bit exception
table, but if it really has the firmware marker that says it's 64 bit,
we should make sure the manufacturers agree that it needs to be added to
the exception table.

James


