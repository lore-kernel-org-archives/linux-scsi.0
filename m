From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 12/30] Fix drivers/scsi/fdomain.c CONFIG_PCI=n warnings
Date: Wed, 15 Aug 2007 12:46:41 -0500
Message-ID: <1187200001.3327.33.camel@localhost.localdomain>
References: <200708102150.l7ALoe6g011351@imap1.linux-foundation.org>
	 <1187195749.3327.27.camel@localhost.localdomain>
	 <20070815103916.8e4367d2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52637 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934784AbXHORqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 13:46:43 -0400
In-Reply-To: <20070815103916.8e4367d2.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, nix.or.die@googlemail.com

On Wed, 2007-08-15 at 10:39 -0700, Andrew Morton wrote:
> On Wed, 15 Aug 2007 11:35:49 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Fri, 2007-08-10 at 14:50 -0700, akpm@linux-foundation.org wrote:
> > > From: Gabriel C <nix.or.die@googlemail.com>
> > > 
> > > I get this warnings on current git when CONFIG_PCI is not set :
> > > 
> > > drivers/scsi/fdomain.c:390: warning: 'PCI_dev' defined but not used
> > > drivers/scsi/fdomain.c:1768: warning: 'fdomain_pci_tbl' defined but not used
> > > 
> > > Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > This function looks decidedly dangerous since it references a
> > non-existent variable when CONFIG_PCI isn't set.  It seems to work
> > because pci_dev_put() is defined to a null macro, but it's not safe:
> > 
> > static int fdomain_16x0_release(struct Scsi_Host *shpnt)
> > {
> > 	if (shpnt->irq)
> > 		free_irq(shpnt->irq, shpnt);
> > 	if (shpnt->io_port && shpnt->n_io_port)
> > 		release_region(shpnt->io_port, shpnt->n_io_port);
> > 	if (PCI_bus)
> > 		pci_dev_put(PCI_dev);
> > 	return 0;
> > }
> > 
> 
> I expect that's why pci_dev_put() is still implemented as a macro.

It's not in my best practices book to refer to a non-existent variable
in the hope that the referring routine is an empty define ... at the
very least it will cause a bit of head scratching for anyone looking
over this driver in future.  Not to say this driver will break if
someone ever substitutes the #define for a static inline ...

James


