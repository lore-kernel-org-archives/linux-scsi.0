From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 22 Nov 2005 22:43:56 +0100
Message-ID: <1132695837.8928.11.camel@localhost.localdomain>
References: <20051005123220.GB6490@levanta.com>
	 <1128519034.5063.10.camel@laptop-lcs.localdomain>
	 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <1132056707.6134.11.camel@localhost.localdomain>
	 <20051122083631.GA21523@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41953 "EHLO
	smtpq1.tilbu1.nb.home.nl") by vger.kernel.org with ESMTP
	id S965063AbVKVVoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2005 16:44:05 -0500
In-Reply-To: <20051122083631.GA21523@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Ingo Juergensmann <ij@2005.bluespice.org>, Richard Hirst <rhirst@levanta.com>

On di, 2005-11-22 at 08:36 +0000, Christoph Hellwig wrote: 
> The 53c700 already has a rather awkward mechanism to deal with different
> bus byte orders, I'd suggest you use that now and switch the driver to
> use ioread*be later, without introducing arch-specific config symbols.

I don't really understand the current mechanism. It seems to result in
different behaviour for BE systems depending on the definition of
CONFIG_53C700_LE_ON_BE.

I would have expected the behaviour on BE systems without defining
CONFIG_53C700_LE_ON_BE to be the same as on BE systems with
CONFIG_53C700_LE_ON_BE defined but with hostdata->force_le_on_be set to
0.

Was this driver ever used on BE systems without CONFIG_53C700_LE_ON_BE
being defined?

For reference:

BE with CONFIG_53C700_LE_ON_BE defined but hostdata->force_le_on_be set
to 0:

/* This is terrible, but there's no raw version of ioread32.  That means
 * that on a be board we swap twice (once in ioread32 and once again to
 * get the value correct) */
#define bS_to_io(x)     ((hostdata->force_le_on_be) ? (x) : cpu_to_le32(x))

evaluates to
                                      0   ---------->       cpu_to_le32(x)

And without CONFIG_53C700_LE_ON_BE defined:

#define bS_to_io(x)     (x)

I think this last define should be cpu_to_le32() as well, then the
driver would work on m68k out-of-the-box.

James, can you comment on this?

> Anyway, could you folks please submit what you have now? The 53c7xx hasn't
> worked ever in 2.6.x, and we're gonna remove it for 2.6.16.  It would be
> nice to keep the m68k glue drivers switched over to use 53c700 even if there's
> still some odd hacks required to actually make it work - we'll surely sort
> them out once the basics are in.

They wouldn't compile, because I'm not going to submit Romans DMA patch
myself.


Kind regards,

Kars.


