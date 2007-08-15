From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 12/30] Fix drivers/scsi/fdomain.c CONFIG_PCI=n warnings
Date: Wed, 15 Aug 2007 10:39:16 -0700
Message-ID: <20070815103916.8e4367d2.akpm@linux-foundation.org>
References: <200708102150.l7ALoe6g011351@imap1.linux-foundation.org>
	<1187195749.3327.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759283AbXHORkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 13:40:20 -0400
In-Reply-To: <1187195749.3327.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, nix.or.die@googlemail.com

On Wed, 15 Aug 2007 11:35:49 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Fri, 2007-08-10 at 14:50 -0700, akpm@linux-foundation.org wrote:
> > From: Gabriel C <nix.or.die@googlemail.com>
> > 
> > I get this warnings on current git when CONFIG_PCI is not set :
> > 
> > drivers/scsi/fdomain.c:390: warning: 'PCI_dev' defined but not used
> > drivers/scsi/fdomain.c:1768: warning: 'fdomain_pci_tbl' defined but not used
> > 
> > Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> This function looks decidedly dangerous since it references a
> non-existent variable when CONFIG_PCI isn't set.  It seems to work
> because pci_dev_put() is defined to a null macro, but it's not safe:
> 
> static int fdomain_16x0_release(struct Scsi_Host *shpnt)
> {
> 	if (shpnt->irq)
> 		free_irq(shpnt->irq, shpnt);
> 	if (shpnt->io_port && shpnt->n_io_port)
> 		release_region(shpnt->io_port, shpnt->n_io_port);
> 	if (PCI_bus)
> 		pci_dev_put(PCI_dev);
> 	return 0;
> }
> 

I expect that's why pci_dev_put() is still implemented as a macro.
