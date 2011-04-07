From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/2] mpt2sas: Remove acquisition of host_lock
Date: Thu, 7 Apr 2011 01:30:58 -0400
Message-ID: <20110407053058.GC4673@linux.intel.com>
References: <20110405214355.GQ4183@linux.intel.com>
 <20110406134555.GA21729@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56181 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab1DGFa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2011 01:30:59 -0400
Content-Disposition: inline
In-Reply-To: <20110406134555.GA21729@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Wed, Apr 06, 2011 at 09:45:55AM -0400, Christoph Hellwig wrote:
> On Tue, Apr 05, 2011 at 05:43:55PM -0400, Matthew Wilcox wrote:
> > 
> > We can eliminate the use of the scsi command serial_number, as the race
> > that the driver is checking for cannot happen.
> > 
> > Then the driver no longer needs to use the DEF_SCSI_QCMD() macro and no
> > longer acquires the host_lock.  This improves performance substantially
> > on high-IOPS workloads.
> 
> Looks fine.  Note that this somehow clashes with my patch to simply
> remove the serial_number check from mpt2sas.  We could just drop my
> smaller patch if this one gets in in a timely fashion.

We should probably split this patch apart into the serial_number removal
and then the host_lock removal anyway.

But I don't think your patch is correct:

-               if (scmd_lookup && (scmd_lookup->serial_number ==
-                   scmd->serial_number))
+               if (scmd_lookup)
                        rc = FAILED;
                else
                        rc = SUCCESS;

The second part of the conditional is always false (right?  because that
command can't be in flight).

So that's (scmd_lookup && 0), which is if (0), so we can just state rc
= SUCCESS.  Or is my reasoning faulty somewhere?
