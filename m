From: Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 18:34:33 +0100
Message-ID: <20110117173433.GM16039@MAIL.13thfloor.at>
References: <20110113192558.GE16039@MAIL.13thfloor.at> <20110114142018.GA978@htj.dyndns.org> <20110114165957.GH16039@MAIL.13thfloor.at> <20110114170407.GE978@htj.dyndns.org> <20110114173759.GI16039@MAIL.13thfloor.at> <20110117154042.GG27123@htj.dyndns.org> <1295281131.3015.44.camel@mulgrave.site> <20110117171312.GL16039@MAIL.13thfloor.at> <20110117172054.GJ27123@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from MAIL.13thfloor.at ([213.145.232.33]:38072 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1AQRef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 12:34:35 -0500
Content-Disposition: inline
In-Reply-To: <20110117172054.GJ27123@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jan 17, 2011 at 06:20:54PM +0100, Tejun Heo wrote:
> On Mon, Jan 17, 2011 at 06:13:12PM +0100, Herbert Poetzl wrote:
> > > So perhaps it should be. If you look at the equivalent topology on
> > > SAS, our expanders have a bsg device node precisely so that we can do
> > > this.
> > 
> > I agree, the PMP should get a device or at least some kind of
> > interface to address them, especially as the SATA topology can
> > get quite complicated too, for example it seems that PMPs can
> > be daisy chained in an infinite sequence like this
> > 
> >        /      /      /
> >  --[PM]---[PM]---[PM]-- - -
> >        \      \      \
> 
> Oh, no, that's not allowed.  You can't address destinations that way.
> PMP is primarily a switch, not a router.

hmm, haven't had the time to dig through the specs yet, but
at least addonics seems to disagree here:

http://www.addonics.com/products/host_controller/tutorial_pm.asp

but maybe that's just a marketing page with no relation
to reality ....

> > > Sure, as long as it speaks standard ses-2, there shouldn't be a
> > > protocol problem. The main problem is recognition: ses has to bind
> > > to an enclosure device. It can bind either to an explicit device
> > > (about all the enclosures I've seen so far) where the ses device has
> > > a separate address in the SCSI topology or an implicit device (where
> > > another SCSI device indicates it has an enclosure port embedded in
> > > it). As currently coded, our ses driver only does the former probably
> > > the best way is to expose the ses device via libata and we'll simply
> > > bind to it.
> > 
> > so AHCI em_messages use standard ses-2 or did I misinterpret
> > this (for me cryptical) information?
> 
> AFAIK, it just doesn't care.  It could be ses-2 or whatever else.  It
> just transmits the binary blob it receives via sysfs and vice-versa.

the interesting part here is, that the AHCI host controller
my PMP is connected to recognizes the PMP perfectly fine
(i.e. more than one drive works just as expected), but doesn't
seem to allow for the em_message part (despite the fact that
the attached PMP seems to be SEMB/SEP capable) ...

maybe this is just a bug in the kernel code, maybe the AHCI
implementation doesn't allow a PMP to receive enclosure
management messages at all ...

best,
Herbert

> Thanks.
> 
> -- 
> tejun
