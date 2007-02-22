From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
Date: Thu, 22 Feb 2007 16:38:50 -0600
Message-ID: <20070222223850.GD14162@beardog.cca.cpqcorp.net>
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net> <1172180978.3378.35.camel@mulgrave.il.steeleye.com> <20070222215501.GA21037@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel11.hp.com ([156.153.255.246]:34026 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbXBVWix (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 17:38:53 -0500
Content-Disposition: inline
In-Reply-To: <20070222215501.GA21037@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Thu, Feb 22, 2007 at 09:55:01PM +0000, Christoph Hellwig wrote:
> On Thu, Feb 22, 2007 at 03:49:38PM -0600, James Bottomley wrote:
> > On Thu, 2007-02-22 at 15:38 -0600, Mike Miller (OS Dev) wrote:
> > >         .remove = __devexit_p(cciss_remove_one),
> > >         .id_table = cciss_pci_device_id,        /* id_table */
> > > +       .shutdown = cciss_remove_one,
> > 
> > You need a __devexit_p() wrapper for this one too.
> 
> No.  We want to call this even in the non-modular, non-hotplug
> case.  So we should remove __devexit from cciss_remove_one.  Or
> alternatively implement a separate cciss_shutdown that just does
> the nessecary cache flushing, like most other drivers do.

So if I remove __devexit from cciss_init_one do I also remove the __devexit_p wrapper
from the remove method?

-- mikem
