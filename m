From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Thu, 14 Feb 2008 01:51:01 -0500
Message-ID: <20080214065101.GA19294@infradead.org>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com> <47B1DA2A.1060904@panasas.com> <1202917468.3109.5.camel@localhost.localdomain> <47B312B3.3010200@panasas.com> <47B31BDE.2030408@panasas.com> <1202921122.3109.31.camel@localhost.localdomain> <47B31FC2.4040206@panasas.com> <1202922226.3109.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYBNGvN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 01:51:13 -0500
Content-Disposition: inline
In-Reply-To: <1202922226.3109.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Sven K?hler <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Wed, Feb 13, 2008 at 11:03:45AM -0600, James Bottomley wrote:
> > I don't understand please explain. 
> > What does a driver need to do if it needs a consistent shutdown retine?
> > module or built in? unload or shutdown?
> 
> It needs to register a reboot notifier, which gdth does.

Well, for crappy legacy driver that's the way, but it's not really
recommended.  As soon as a driver uses the proper driver models,
e.g. gdth for pci using Jeff's pci hotplug patches it can just
implement the ->shutdown method that is called before shutdown/kexec
and can do the right thing.

