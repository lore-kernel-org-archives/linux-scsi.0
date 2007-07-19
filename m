From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Date: Thu, 19 Jul 2007 11:39:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191137470.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.529280000@pademelon.sonytel.be> <20070718164351.a92ec032.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
 <20070719021752.35cb7daa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-336074560-1184837972=:8661"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41471 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932488AbXGSJje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 05:39:34 -0400
In-Reply-To: <20070719021752.35cb7daa.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-336074560-1184837972=:8661
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 19 Jul 2007, Andrew Morton wrote:
> On Thu, 19 Jul 2007 11:02:07 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > On Wed, 18 Jul 2007, Andrew Morton wrote:
> > > > +struct ps3rom_private {
> > > > +	struct ps3_storage_device *dev;
> > > > +	struct scsi_cmnd *curr_cmd;
> > > > +};
> > > > +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
> > > > +
> > > 
> > > Someone should invent a keyboard which delivers an electric shock when the
> > > operator types "#define".   In the meanwhile, I get to do the honours.
> > > 
> > > Please don't implement in a macro anything which can be implemented in C.
> > 
> > All I needed was a shorthand to access driver_data, for both read and write
> > access (you cannot do the latter with C, unless you decouple read and write).
> 
> Oh dear.
> 
> 	ps3rom_priv(dev) = host;
> 
> that's 'orrid.  We have an identifier pretending to be a function, only we
> go and treat it as an lvalue.
> 
> I mean, C code should look like C code, and the above just doesn't.
> 
> Sigh.

Do you prefer

static inline struct ps3rom_private *ps3rom_priv_get(struct ps3_storage_device
*dev)
{
	return dev->sbd.core.driver_data;
}

static inline void ps3rom_priv_set(struct ps3_storage_device *dev,
				   struct ps3rom_private *priv)
{
	dev->sbd.core.driver_data = priv;
}

instead?

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-336074560-1184837972=:8661--
