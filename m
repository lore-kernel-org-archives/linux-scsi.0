From: David Brownell <david-b@pacbell.net>
Subject: Re: gdth new set of patches for 2.6.24 stable
Date: Mon, 18 Feb 2008 12:27:42 -0800
Message-ID: <200802181227.43166.david-b@pacbell.net>
References: <47B48CAE.2020705@panasas.com> <47B864CB.4040604@panasas.com> <20080218045736.d35d5408.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:37479 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753526AbYBRVAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 16:00:09 -0500
In-Reply-To: <20080218045736.d35d5408.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, Russell King <rmk@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>

On Monday 18 February 2008, Andrew Morton wrote:
> Russell, Ralf: is there something we can do here to relax this requir=
ement?
>=20
> I'm thinking that perhaps we can do some rcu/refcounting tricks: laun=
ch the
> IPI from within dma_free_coherent(), but don't wait for it to complet=
e.=20
> When all CPUs have handled the IPI then (and only then) the virtual a=
ddress
> becomes recyclable, or something like that?

Or the trick some drivers had to do:  just defer the actual work of
dma_free_coherent() into a tasklet.  Better have one such tasklet in
arch code than N of them in drivers.

To be clear:  I never thought that API restriction was a good idea.

(Although this discussion now seems moot for the gdth driver.)


> <double-checks>
>=20
> Actually I think David might have been wrong about mips. =A0afaict it=
s
> dma_free_coherent() is callable under local_irq_disable(), so ARM SMP=
 is
> the sole exception? =A0

All I recall at this point was getting some arch-specific patches in th=
at
area; I thought it was MIPS, maybe it was PPC.  The arch code may have
changed since then too.

- Dave
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
