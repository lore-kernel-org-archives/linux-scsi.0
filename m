From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/2] mpt2sas: Remove acquisition of host_lock
Date: Sun, 10 Apr 2011 16:01:49 -0600
Message-ID: <4565AEA676113A449269C2F3A549520F809562FB@cosmail03.lsi.com>
References: <20110405214355.GQ4183@linux.intel.com>
 <20110406134555.GA21729@infradead.org>
 <20110407053058.GC4673@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:60379 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab1DJWAa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2011 18:00:30 -0400
In-Reply-To: <20110407053058.GC4673@linux.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On Wednesday, April 06, 2011 11:31 PM, Matthew Wilcox wrote: 
> On Wed, Apr 06, 2011 at 09:45:55AM -0400, Christoph Hellwig wrote:
> > On Tue, Apr 05, 2011 at 05:43:55PM -0400, Matthew Wilcox wrote:
> > >
> > > We can eliminate the use of the scsi command serial_number, as the race
> > > that the driver is checking for cannot happen.
> > >
> > > Then the driver no longer needs to use the DEF_SCSI_QCMD() macro and no
> > > longer acquires the host_lock.  This improves performance substantially
> > > on high-IOPS workloads.
> >
> > Looks fine.  Note that this somehow clashes with my patch to simply
> > remove the serial_number check from mpt2sas.  We could just drop my
> > smaller patch if this one gets in in a timely fashion.
> 
> We should probably split this patch apart into the serial_number removal
> and then the host_lock removal anyway.
> 
> But I don't think your patch is correct:
> 
> -               if (scmd_lookup && (scmd_lookup->serial_number ==
> -                   scmd->serial_number))
> +               if (scmd_lookup)
>                         rc = FAILED;
>                 else
>                         rc = SUCCESS;
> 
> The second part of the conditional is always false (right?  because that
> command can't be in flight).
> 
> So that's (scmd_lookup && 0), which is if (0), so we can just state rc
> = SUCCESS.  Or is my reasoning faulty somewhere?


The patch that Christoph provided is correct.   We are doing this check following the task management completion. The purpose of this check is to determine whether the outstanding IO was completed.   For whatever reason, if the scmd_lookup is non-zero, it means the IO is still in driver queue. It's not guaranteed that the IO is returned by the task abort.  So we need to return FAILED status if the scmd_lookup is non-zero.  

The serial_number check is there if IO is resent while error recovery is going on, it appears I merged that in from the older generation mptsas driver. It's not needed since unjam host locks down the IO queues.


  

