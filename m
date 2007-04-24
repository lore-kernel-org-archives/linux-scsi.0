From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 1/7] libata: check for AN support
Date: Tue, 24 Apr 2007 11:29:21 -0700
Message-ID: <20070424112921.c451d64a.kristen.c.accardi@intel.com>
References: <20070424074856.005152262@intel.com>
	<20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
	<20070424090713.65657495@the-village.bc.nu>
	<20070424102304.GA58841@dspnet.fr.eu.org>
	<20070424084904.61932994.kristen.c.accardi@intel.com>
	<20070424180552.GA17319@dspnet.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422996AbXDXSb7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 14:31:59 -0400
In-Reply-To: <20070424180552.GA17319@dspnet.fr.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olivier Galibert <galibert@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

On Tue, 24 Apr 2007 20:05:52 +0200
Olivier Galibert <galibert@pobox.com> wrote:

> On Tue, Apr 24, 2007 at 08:49:04AM -0700, Kristen Carlson Accardi wrote:
> > On Tue, 24 Apr 2007 12:23:04 +0200
> > Olivier Galibert <galibert@pobox.com> wrote:
> > 
> > > Sorry for replying to Alan's reply, I missed the original mail.
> > > 
> > > > > +#define ata_id_has_AN(id)	\
> > > > > +	((id[76] && (~id[76])) & ((id)[78] & (1 << 5)))
> > > 
> > > (a && ~a) & (b & 32)
> > > 
> > > I don't think that does what you think it does, because at that point
> > > it's a funny way to write 0 ((0 or 1) binary-and (0 or 32)).
> > > 
> > > I'm not even sure what it is you want.  If for the first part you
> > > wanted (id[76] != 0x00 && id[76] != 0xff), please write just that,
> > > thanks :-)
> > > 
> > >   OG.
> > > 
> > 
> > >From the serial ata spec, we have:
> > 
> > 13.2.1.18        Word 78: Serial ATA features supported
> > If Word 76 is not 0000h or FFFFh, Word 78 reports the optional features 
> > supported by the device.  Support for this word is optional and if not 
> > supported the word shall be zero indicating the device has no support for new 
> > Serial ATA capabilities.
> > 
> > so, basically yes, I'm really testing to make sure that word 76 isn't 0 or all
> > one then using that value & with value of bit in work 78 to determine AN
> > support - if you think this is really obfuscated, I've got no problem changing 
> > it - there's obviously many ways to mess around with bits.
> 
> & is not &&, so right now it's really incorrect.  1 & 32 is 0.

ah - ok, gotcha, thanks.

> 
> ((id)[76] != 0x0000 && (id)[76] != 0xffff && ((id)[78] & (1 << 5)))
> 
> The implicit typing of id looks dangerous to me, but you're not the
> one who has started it.
> 
>   OG.
> 
