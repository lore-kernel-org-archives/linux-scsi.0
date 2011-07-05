From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] mpt2sas: Remove queuecommand wrapper
Date: Tue, 5 Jul 2011 11:21:43 -0400
Message-ID: <20110705152143.GB4061@linux.intel.com>
References: <20110704192713.GZ4061@linux.intel.com>
 <B2FD678A64EAAD45B089B123FDFC3ED70157FE25D8@inbmail01.lsi.com>
 <20110705141434.GB389@parisc-linux.org>
 <B2FD678A64EAAD45B089B123FDFC3ED70157E70F4A@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51188 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab1GEPVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2011 11:21:50 -0400
Content-Disposition: inline
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70157E70F4A@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>

On Tue, Jul 05, 2011 at 08:25:43PM +0530, Desai, Kashyap wrote:
> > > e.a if scsih_qcmd_xxx has executed half of the code and (due to preemption is not \
> > > disable for the same CPU), Scheduler can execute any other process on the SAME cpu \
> > > (Though IRQ is disable). Consider Error handling is kicked off on the same CPU and as \
> > > part of EH, it executed HBA reset. As part of HBA reset Driver has return back all \
> > > pending Scsi command to mid-layer, and once control come back to original \
> > > scsih_qcmd_xxx LLD drive will see bad results (Kernel crash/Data corruption/h/w hung \
> > > or anything critical.....)
> > 
> > I don't believe this scenario can happen.  Error handling will not
> > commence until all commands are returned to the midlayer, which requires
> > that queuecommand is no longer running.
> 
> I was able to see this scenario when I intially started doing code review. Since host_lock is removed Error handling can remove code from queuecommand anytime ( I asssume preemption is not disable, only IRQ is disable).. I am almost sure if we are planning to remove host_lock from SML, we at least need irq and preemption disable for mpt2sas and mptfusion to work properly.

I'm pretty sure that can't happen.  Look:

void scsi_eh_wakeup(struct Scsi_Host *shost)
{
        if (shost->host_busy == shost->host_failed) {
                trace_scsi_eh_wakeup(shost);
                wake_up_process(shost->ehandler);

So the SCSI error handler doesn't run until host_busy == host_failed.
host_busy is incremented in scsi_request_fn() (before scsi_dispatch_cmd
is called).  host_failed is incremented in scsi_eh_scmd_add().  So after
a command has been issued, it prevents the EH from running until it
too fails.  That means queuecommand cannot be running at the same time
as the EH.

That's documented in Documentation/scsi/scsi_eh.txt section [1-3].
