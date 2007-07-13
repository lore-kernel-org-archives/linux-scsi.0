From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 15:25:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707131518120.18802@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <20070704132346.591348000@pademelon.sonytel.be> <1184331741.3402.13.camel@localhost.localdomain>
 <20070713130508.GQ5328@kernel.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1348962474-1184333137=:18802"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48273 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755142AbXGMNZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jul 2007 09:25:39 -0400
In-Reply-To: <20070713130508.GQ5328@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Paul Mackerras <paulus@samba.org>, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1348962474-1184333137=:18802
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, Jens Axboe wrote:
> On Fri, Jul 13 2007, James Bottomley wrote:
> > On Wed, 2007-07-04 at 15:22 +0200, Geert Uytterhoeven wrote:
> > > +                       kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> > > +                       if (!kaddr)
> > > +                               return -1;
> > > +                       len = sgpnt->length;
> > > +                       if ((req_len + len) > buflen) {
> > > +                               active = 0;
> > > +                               len = buflen - req_len;
> > > +                       }
> > > +                       memcpy(kaddr + sgpnt->offset, buf + req_len,
> > > len);
> > > +                       kunmap_atomic(kaddr, KM_USER0);
> > 
> > This isn't a SCSI objection, but this sequence appears several times in
> > this driver.  It's wrong for a non-PIPT architecture (and I believe the
> > PS3 is VIPT) because you copy into the kernel alias for the page, which
> > dirties the line in the cache of that alias (the user alias cache line
> > was already invalidated).  However, unless you flush the kernel alias to
> > main memory, the user could read stale data.  The way this is supposed
> > to be done is to do a 
> > 
> > flush_kernel_dcache_page(kaddr)
> > 
> > before doing the kunmap.
> > 
> > Otherwise it looks OK from the SCSI point of view.

kmap() just returns page_address() on ppc64, as there's no highmem.
kunmap() is a no-op.

So technically I could just use page_address() directly, but Christoph wanted
me to keep the kmap()/kunmap() sequence because it's considered a good
practice.

> Well, even worse is that fact that it's using KM_USER0 from interrupt
> context.

So should I replace it by e.g. KM_IRQ0?
I'm not so familiar with these parts, and I couldn't find what these values
really mean.

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
---584337861-1348962474-1184333137=:18802--
