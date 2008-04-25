From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] new mac_scsi driver
Date: Fri, 25 Apr 2008 10:03:10 -0500
Message-ID: <1209135790.3087.8.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0804231833210.12067@loopy.telegraphics.com.au>
	 <Pine.LNX.4.64.0804242307370.21224@anakin>
	 <1209072808.3121.22.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0804251054200.2578@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41152 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbYDYPDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 11:03:14 -0400
In-Reply-To: <Pine.LNX.4.64.0804251054200.2578@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, David Miller <davem@davemloft.net>, Roman Zippel <zippel@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Fri, 2008-04-25 at 11:06 +1000, Finn Thain wrote:
> 
> On Thu, 24 Apr 2008, James Bottomley wrote:
> 
> > On Thu, 2008-04-24 at 23:08 +0200, Geert Uytterhoeven wrote:
> > > On Thu, 24 Apr 2008, Finn Thain wrote:
> > > > Replace the mac_esp driver with a new one based on the esp_scsi 
> > > > core.
> > > > 
> > > > For esp_scsi: add support for sync transfers for the PIO mode, add a 
> > > > new esp_driver_ops method to get the maximum dma transfer size (like 
> > > > the old NCR53C9x driver), and some cleanups.
> > > 
> > > Thanks!
> > > 
> > > I added this patch to my series, after fixing the few checkpatch.pl 
> > > issues and adding a test for MACH_IS_MAC() to esp_mac_probe().
> > 
> > I got the tabs and spaces thing.  I'm not too concerned about the 
> > assignment in conditional, but I'm happy to go whichever way the author 
> > does.
> 
> FWIW, I happen to disagree with checkpatch about the spaces following tabs 
> thing but I'm happy to follow convention. It did pick up on some other 
> things that I overlooked (Geert has fixed them).
> 
> > 
> > Could you repost please because I already have this queued, so I need a 
> > replacement (assuming everyone agrees).
> 
> Geert's version is fine with me:
> 
> http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-patches-2.6/m68k-new-mac_esp-driver.diff

It's a lot less easy to review stuff over the web (mainly, I'm afraid,
because people are lazy).

However, this:


> +static int __devinit esp_mac_probe(struct platform_device *dev)
> +{
> +	struct scsi_host_template *tpnt = &scsi_esp_template;
> +	struct Scsi_Host *host;
> +	struct esp *esp;
> +	int err;
> +	int chips_present;
> +	struct mac_esp_priv *mep;
> +
> +	if (!MACH_IS_MAC)
> +		return -ENODEV;

Looks strange ... it seems you have to do this because macintosh_config
which is used later can be uninitialised (i.e. pointing to rubbish) if
it's not set?

James


