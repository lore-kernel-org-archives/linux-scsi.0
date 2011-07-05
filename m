From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] mpt2sas: Remove queuecommand wrapper
Date: Tue, 5 Jul 2011 16:24:53 -0400
Message-ID: <20110705202453.GC4061@linux.intel.com>
References: <20110704192713.GZ4061@linux.intel.com>
 <B2FD678A64EAAD45B089B123FDFC3ED70157FE25D8@inbmail01.lsi.com>
 <20110705141434.GB389@parisc-linux.org>
 <B2FD678A64EAAD45B089B123FDFC3ED70157E70F4A@inbmail01.lsi.com>
 <20110705152143.GB4061@linux.intel.com>
 <B2FD678A64EAAD45B089B123FDFC3ED70157FE2667@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9484 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab1GEUYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2011 16:24:55 -0400
Content-Disposition: inline
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70157FE2667@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Doug Gilbert <dgilbert@interlog.com>

On Tue, Jul 05, 2011 at 10:48:00PM +0530, Desai, Kashyap wrote:
> > -----Original Message-----
> > From: Matthew Wilcox [mailto:willy@linux.intel.com]
> > Sent: Tuesday, July 05, 2011 8:52 PM
> > To: Desai, Kashyap
> > Cc: Matthew Wilcox; linux-scsi@vger.kernel.org; DL-MPT Fusion Linux;
> > nab@linux-iscsi.org
> > Subject: Re: [PATCH] mpt2sas: Remove queuecommand wrapper

> > void scsi_eh_wakeup(struct Scsi_Host *shost)
> > {
> >         if (shost->host_busy == shost->host_failed) {
> 
> I think you are right here. 
> 
> I did below experiment.  
> Since now host_lock is removed from dispatch() callback.
> I added sleep() inside scsih_qcmd().. Just to mimic preemption. And called Host reset using
> "Sg_reset -h" at the sametime when driver is sleeping inside qcmd(). I see the kernel crash due to invalid scsi command pointer access after driver comes out from sleep().

OK, but I don't think we've introduced a new race here, just expanded
the window.

If you follow the path down from userspace, we get to
scsi_nonblockable_ioctl() (doesn't take the host_lock), then
scsi_reset_provider (which takes and releases the host_lock to
set tmf_in_progress), then scsi_try_host_reset() which calls
eh_host_reset_handler() without holding the host_lock.

So it's entirely possible to hit the same race on an SMP machine already
as there's nothing to synchronise the eh_host_reset_handler call with
queuecommand.

I think someone who uses sg_reset ought to be aware of the possibility
that they can trash their system.  Doug, what do you think?

> As you said, due to actual Error handling will not wake up, but if user/customer do testing using sg_tools
> They can kick off Host reset on demand.
> 
> What is your input on my above test case/observation ?
> 
> >                 trace_scsi_eh_wakeup(shost);
> >                 wake_up_process(shost->ehandler);
> > 
> > So the SCSI error handler doesn't run until host_busy == host_failed.
> > host_busy is incremented in scsi_request_fn() (before scsi_dispatch_cmd
> > is called).  host_failed is incremented in scsi_eh_scmd_add().  So after
> > a command has been issued, it prevents the EH from running until it
> > too fails.  That means queuecommand cannot be running at the same time
> > as the EH.
> > 
> > That's documented in Documentation/scsi/scsi_eh.txt section [1-3].
