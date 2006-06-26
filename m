From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 16:15:36 -0600
Message-ID: <20060626221536.GA1592@parisc-linux.org>
References: <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru> <20060601132315.GD32143@parisc-linux.org> <1151270127.3617.26.camel@mulgrave.il.steeleye.com> <20060625224631.GD1608@parisc-linux.org> <1151310285.3185.16.camel@laptopd505.fenrus.org> <20060626124001.GG1608@parisc-linux.org> <20060626144442.GA13319@one-eyed-alien.net> <20060626151828.GH1608@parisc-linux.org> <20060626210825.GB31085@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49610 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S933089AbWFZWPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 18:15:38 -0400
Content-Disposition: inline
In-Reply-To: <20060626210825.GB31085@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-hotplug-devel@lists.sourceforge.net, Patrick Mansfield <patmans@us.ibm.com>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, James Bottomley <James.Bottomley@SteelEye.com>

On Mon, Jun 26, 2006 at 02:08:25PM -0700, Matthew Dharm wrote:
> On Mon, Jun 26, 2006 at 09:18:28AM -0600, Matthew Wilcox wrote:
> > Do these devices stick to occupying only target IDs from 0-7?  If not,
> > you may wish to increase ->max_id for those devices.  I think it'd be worth
> > exporting scsi_scan_channel() from the midlayer (and rearranging it to have
> > __scsi_scan_channel() as was done with __scsi_scan_target) for USB's benefit.
> 
> These support target IDs to up 15.  But I see the point of limiting
> ->max_id for devices which do not have the SCM_MULT_TARG flag set.

Ever tried that?  ;-)

drivers/scsi/hosts.c sets max_id to 8 in scsi_host_alloc().  I don't see
anything in USB setting max_id to 16.

> > It's definitely possible to remove individual targets dynamically now;
> > Fibre Channel has sorted that out (and will complain loudly if it breaks).
> > The scsi core doesn't really have a channel object; channel is just an integer 
> > that describes a path to a target.  So I think there should be no problem in
> > converting USB to have one host and many channels.
> 
> Interesting.
> 
> What's the limit on the number of channels you can have?

Just an unsigned int, I think.

> How do I set up multiple channels in code?

Increase shost->max_channel each time you want to create a new one.
Then pass it to scsi_scan_target().

