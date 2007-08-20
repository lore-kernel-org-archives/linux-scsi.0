From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch] plug async scan race at 1st node scan
Date: Mon, 20 Aug 2007 08:32:43 -0600
Message-ID: <20070820143243.GF30019@parisc-linux.org>
References: <1187615436.3897.5.camel@localhost.localdomain> <20070820134918.GC30019@parisc-linux.org> <46C99F05.7070404@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46925 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXHTOcp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 10:32:45 -0400
Content-Disposition: inline
In-Reply-To: <46C99F05.7070404@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, tore@linpro.no

On Mon, Aug 20, 2007 at 10:02:45AM -0400, James Smart wrote:
> Well - depends on what the semantics of scan_start are.... to date, there
> really are none....  and what does requiring it mean ?

OK, and to make this discussion exceptionally useful, all comments are
to be made in the context of modifications to the documentation:

        /*
         * If the host wants to be called before the scan starts, but
         * after the midlayer has set up ready for the scan, it can fill
         * in this function.
         */

When I say "require it", I mean that currently we have the code:

        if (shost->hostt->scan_finished) {
                unsigned long start = jiffies;
                if (shost->hostt->scan_start)
                        shost->hostt->scan_start(shost);

I propose removing that second 'if':

        if (shost->hostt->scan_finished) {
                unsigned long start = jiffies;
		shost->hostt->scan_start(shost);

And here's my proposal for new documentation for scan_start():

	/*
	 * If the host fills in scan_finished, above, it must also fill in
	 * scan_start.  scan_start will be called by the midlayer to inform
	 * the host that it is now ready to receive requests to scan targets.
	 */

> What's implied is that you want "bring up link" to be enabled in 
> scan_start().

That's certainly one obvious way to do it.  Another way would be to have
a flag in the driver blocking calls to the midlayer ... I think you have
that already?

> Doable, but the code paths weren't put together expecting this, so it may be
> a bit of work. I'll have to look at it.   Also, you're asking me to fix one
> driver, without thinking about the structure in others.... I'd rather the
> api itself locked down state/behavior, not simply the LLD coding.

I think other drivers already do this.  We only have three drivers
currently using this API -- lpfc, qla2xxx and aic94xx.  asd_scan_start()
enables the PHYs.  qla2xxx_scan_start sets some bits, but I'm not quite
sure of their effect.

> Before starting, I'd rather we setting on what the semantics of the api is.
> To the uninitiated, requiring a driver to call scsi_scan_host(), when the
> transport drives all discovery, and where the scan_host really has nothing
> to do with scanning, but rather creates a firewall delay to hold off 
> serializing
> of device enumerations - is all very confusing.  I'd rather we had a 
> different
> entry point for those things that supply start/finish routines and it was
> named more in line with "start discovery delay".

The name certainly isn't great, but I thought we agreed that having a
common entry point for all SCSI hosts was a good idea.

> Adding the notion of scan_start bringing up the link sounds reasonable. 
> However,
> how does this translate to other bus types ?

It works for SAS and FC ... I don't see why it wouldn't work for other
bus types.  Obviously, we don't call it for SPI.

> -- james s
> 
> Matthew Wilcox wrote:
> >On Mon, Aug 20, 2007 at 09:10:35AM -0400, James Smart wrote:
> >>In testing 2.6.23-rc3, there is a small window where the async-per-target
> >>scan of the transport can beat the call from the LLDD to scsi_scan_host().
> >
> >I'd assumed that events wouldn't come in until ->scan_start was called.
> >I see lpfc doesn't have one; is it possible to restructure it to have one?
> >
> >(In any case, good job tracking this down; it was really annoying me.)
> >
> >Possibly we should be less forgiving, and require drivers to have a
> >scan_start, otherwise they can't avoid this race.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
