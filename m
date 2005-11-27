From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Removing BROKEN scsi drivers
Date: Sun, 27 Nov 2005 11:47:18 -0500
Message-ID: <1133110038.3331.20.camel@mulgrave>
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
	 <1132695837.8928.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58305 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751109AbVK0Qrf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Nov 2005 11:47:35 -0500
In-Reply-To: <1132695837.8928.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Ingo Juergensmann <ij@2005.bluespice.org>, Richard Hirst <rhirst@levanta.com>

On Tue, 2005-11-22 at 22:43 +0100, Kars de Jong wrote:
> I don't really understand the current mechanism. It seems to result in
> different behaviour for BE systems depending on the definition of
> CONFIG_53C700_LE_ON_BE.
> 
> I would have expected the behaviour on BE systems without defining
> CONFIG_53C700_LE_ON_BE to be the same as on BE systems with
> CONFIG_53C700_LE_ON_BE defined but with hostdata->force_le_on_be set to
> 0.
> 
> Was this driver ever used on BE systems without CONFIG_53C700_LE_ON_BE
> being defined?
> 
> For reference:
> 
> BE with CONFIG_53C700_LE_ON_BE defined but hostdata->force_le_on_be set
> to 0:
> 
> /* This is terrible, but there's no raw version of ioread32.  That means
>  * that on a be board we swap twice (once in ioread32 and once again to
>  * get the value correct) */
> #define bS_to_io(x)     ((hostdata->force_le_on_be) ? (x) : cpu_to_le32(x))
> 
> evaluates to
>                                       0   ---------->       cpu_to_le32(x)
> 
> And without CONFIG_53C700_LE_ON_BE defined:
> 
> #define bS_to_io(x)     (x)
> 
> I think this last define should be cpu_to_le32() as well, then the
> driver would work on m68k out-of-the-box.
> 
> James, can you comment on this?

OK, let me try to explain.

ioread/write32 came with a slight design flaw in that it *always*
converts to LE.  By and large, no-one notices this because almost every
platform has the PCI bus, which is LE.  However, PA also has the GSC
bus, which is BE.  We already introduced the ioread/write<n>be macros
which work for a BE bus.  You're right, the only current BE consumer of
the driver is PA-RISC, which has a cockup on one of the 53c700 chips
which is wired in LE mode on the BE GSC bus, so we need that flag.

I assume your problems is also that the 53c7x0 chip on the MAC is also
on a BE bus, so I think what you want is another flag:

53c700_BE_BUS

which causes all the io macros to be ioread/write<n>be.  Which will
avoid the nasty double swap we do on PA.

James


