From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] convert scsi core to use module_param interfaces
Date: Fri, 6 Jun 2003 07:37:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606073732.B13259@infradead.org>
References: <20030604145717.A8394@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:29447 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265341AbTFFGYA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 02:24:00 -0400
Content-Disposition: inline
In-Reply-To: <20030604145717.A8394@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Jun 04, 2003 at 02:57:17PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Wed, Jun 04, 2003 at 02:57:17PM -0700, Patrick Mansfield wrote:
> This patch converts scsi core to use the module_param interfaces
> (except for the hosts.c scsihosts usage).
> 
> With this applied, boot time (non-module) command line setting of scsi
> parameters must be prefixed by what the scsi module name would be
> (scsi_mod), for example:
> 
> 	scsi_mod.scsi_logging_level=0x180 scsi_mod.scsi_default_dev_flags=0x1
> 	scsi_mod.max_scsi_luns=5
> 
> Usage of scsi_mod as above is a bit ugly and long - if this patch is
> applied, we should consider renaming scsi.c to scsi_main.c or similiar,
> and scsi_mod.o to scsi.o. Or, somehow get our prefix set to "scsi".

I don't think we can just change the name of the scsi core module -
to much userspace stuff is relying on that.  Changing the prefix would
be nice but I have no idea how we can do that.

We should also kill the scsi substrings in the individual options now
that we have a regular prefix, I'll submit a patch.

