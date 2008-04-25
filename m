From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] new mac_scsi driver
Date: Fri, 25 Apr 2008 21:43:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0804252141310.9235@anakin>
References: <Pine.LNX.4.64.0804231833210.12067@loopy.telegraphics.com.au>
 <Pine.LNX.4.64.0804242307370.21224@anakin> <1209072808.3121.22.camel@localhost.localdomain>
 <Pine.LNX.4.64.0804251054200.2578@loopy.telegraphics.com.au>
 <1209135790.3087.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from winston.telenet-ops.be ([195.130.137.75]:54457 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762848AbYDYToB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2008 15:44:01 -0400
In-Reply-To: <1209135790.3087.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, David Miller <davem@davemloft.net>, Roman Zippel <zippel@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Fri, 25 Apr 2008, James Bottomley wrote:
> On Fri, 2008-04-25 at 11:06 +1000, Finn Thain wrote:
> > On Thu, 24 Apr 2008, James Bottomley wrote:
> > > On Thu, 2008-04-24 at 23:08 +0200, Geert Uytterhoeven wrote:
> > > > On Thu, 24 Apr 2008, Finn Thain wrote:
> > > > > Replace the mac_esp driver with a new one based on the esp_scsi 
> > > > > core.
> > > > > 
> > > > > For esp_scsi: add support for sync transfers for the PIO mode, add a 
> > > > > new esp_driver_ops method to get the maximum dma transfer size (like 
> > > > > the old NCR53C9x driver), and some cleanups.
> > > > 
> > > > Thanks!
> > > > 
> > > > I added this patch to my series, after fixing the few checkpatch.pl 
> > > > issues and adding a test for MACH_IS_MAC() to esp_mac_probe().

> However, this:
> 
> 
> > +static int __devinit esp_mac_probe(struct platform_device *dev)
> > +{
> > +	struct scsi_host_template *tpnt = &scsi_esp_template;
> > +	struct Scsi_Host *host;
> > +	struct esp *esp;
> > +	int err;
> > +	int chips_present;
> > +	struct mac_esp_priv *mep;
> > +
> > +	if (!MACH_IS_MAC)
> > +		return -ENODEV;
> 
> Looks strange ... it seems you have to do this because macintosh_config
> which is used later can be uninitialised (i.e. pointing to rubbish) if
> it's not set?

Yep. A multi-platform kernel may even not be running on a Mac at all.

The proper fix is to add the platform device in the Mac setup code only when
running on a Mac where the actual SCSI hardware is present, but that's
currently not done for any of the m68k platform drivers.
Also cfr. http://lkml.org/lkml/2008/4/24/366.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
