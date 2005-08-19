From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o pci_driver model
Date: Fri, 19 Aug 2005 11:05:41 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0177C1BF@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:50658 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964918AbVHSPFs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 11:05:48 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The sysinit structure is supposed to be a complete list of all peered
i2o adapters. The current driver structure issued the sysinit command
after all adapters were discovered rather than re-issuing as each was
added.

The structure still must be global, but I will look into moving the
instantiation.

Sincerely -- Mark Salyzyn


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Friday, August 19, 2005 10:59 AM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] dpt_i2o pci_driver model


On Wed, Aug 17, 2005 at 01:04:05PM -0400, Salyzyn, Mark wrote:
> Christoph Hellwig [mailto:hch@infradead.org] writes:
> > ... update the driver to use the pci_driver model ...
> 
> The patch applies to the scsi-misc-2.6 git tree. The moving of 
> adpt_install_hba to the near bottom of the dpt_i2o.c file creates a 
> dirty context diff in that region which is hard to inspect from within

> the patch. No coding style changes were made when moving content from 
> the original initialization code to the module_init and module_exit 
> functions to aid before and after comparisons for inspection; even 
> despite the fact C++ style comments are used in these sections. We 
> expect such style cleanup to occur either on any necessary follow-up 
> rewrites after basic functional approval, or as a follow-up cleanup 
> patch.

This looks wrong to me.  It's still walking a lot of driver-global hba
lists in the init routine.  All hba initialization should happen in the
->probe callback, and there should be very little global initialization.
There shouldn't really be any global list of hbas.

