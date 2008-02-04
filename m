From: David Brownell <david-b@pacbell.net>
Subject: Re: [Bug 9880] dma_free_coherent in arcmsr when calling areca tools
Date: Sun, 3 Feb 2008 20:36:30 -0800
Message-ID: <200802032036.31016.david-b@pacbell.net>
References: <20080204030037.6C061108018@picon.linux-foundation.org> <1202097337.3318.143.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:24999 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752464AbYBDEgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 23:36:33 -0500
In-Reply-To: <1202097337.3318.143.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: bugme-daemon@bugzilla.kernel.org, Russell King <rmk@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi@vger.kernel.org

On Sunday 03 February 2008, James Bottomley wrote:
> That's caused by this commit:
>=20
> commit aa24886e379d2b641c5117e178b15ce1d5d366ba
> Author: David Brownell <david-b@pacbell.net>
> Date: =A0 Fri Aug 10 13:10:27 2007 -0700
>=20
> =A0 =A0 dma_free_coherent() needs irqs enabled (sigh)
> =A0 =A0=20
> I've cc'd the people responsible for this apparent bit of idiocy. =A0=
Since
> the API addition to dma_alloc_coherent() was the GFP flags so you cou=
ld
> call it from interrupt context with GFP_ATOMIC if so desired,
> (pci_dma_alloc_consistent always has GFP_ATOMIC semantics), why on ea=
rth
> would the corresponding free routine require non-atomic semantics?

That was my reaction ... but I was told this would not be fixed.

See also 8a3c1f573c771e60f67ef172d2392d1a28385b4a ... several other
controller drivers needed similar logic at one point.  (I eventually
ripped that programming interface out, or *EVERY* driver would have
needed crap like that.  The interface was mostly misused anyway, so
it was no big loss.)


> Is it seriously true that you can call dma_alloc_coherent() from atom=
ic
> context on arm, but not dma_free_coherent()?

Lacking a tasklet in dma_free_coherent() analagous to that omap_udc com=
mit
I referenced ...



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
