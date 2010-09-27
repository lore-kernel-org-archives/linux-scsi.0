From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v3 01/15] scsi: Drop struct Scsi_Host->host_lock usage in
	scsi_dispatch_cmd()
Date: Mon, 27 Sep 2010 16:15:10 -0700
Message-ID: <1285629310.8880.78.camel@haakon2.linux-iscsi.org>
References: <1285285052-16351-1-git-send-email-nab@linux-iscsi.org>
	 <4C9CAA80.1030702@linux.vnet.ibm.com>
	 <1285361040.1849.235.camel@haakon2.linux-iscsi.org>
	 <20100927141923.GC8473@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100927141923.GC8473@schmichrtp.mainz.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-09-27 at 16:19 +0200, Christof Schmitt wrote:
> On Fri, Sep 24, 2010 at 01:44:00PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2010-09-24 at 08:41 -0500, Brian King wrote:
> > > On 09/23/2010 06:37 PM, Nicholas A. Bellinger wrote:
> > > > @@ -651,7 +655,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
> > > >  int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> > > >  {
> > > >  	struct Scsi_Host *host = cmd->device->host;
> > > > -	unsigned long flags = 0;
> > > >  	unsigned long timeout;
> > > >  	int rtn = 0;
> > > > 
> > > > @@ -736,15 +739,11 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> > > >  		scsi_done(cmd);
> > > >  		goto out;
> > > >  	}
> > > > -
> > > > -	spin_lock_irqsave(host->host_lock, flags);
> > > >  	/*
> > > > -	 * AK: unlikely race here: for some reason the timer could
> > > > -	 * expire before the serial number is set up below.
> > > > -	 *
> > > > -	 * TODO: kill serial or move to blk layer
> > > > +	 * Note that scsi_cmd_get_serial() used to be called here, but
> > > > +	 * now we expect the legacy SCSI LLDs that actually need this
> > > > +	 * to call it directly within their SHT->queuecommand() caller.
> > > >  	 */
> > > > -	scsi_cmd_get_serial(host, cmd); 
> > > > 
> > > >  	if (unlikely(host->shost_state == SHOST_DEL)) {
> > > >  		cmd->result = (DID_NO_CONNECT << 16);
> > > > @@ -753,7 +752,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> > > >  		trace_scsi_dispatch_cmd_start(cmd);
> > > >  		rtn = host->hostt->queuecommand(cmd, scsi_done);
> > > >  	}
> > > > -	spin_unlock_irqrestore(host->host_lock, flags);
> > > > +
> > > >  	if (rtn) {
> > > >  		trace_scsi_dispatch_cmd_error(cmd, rtn);
> > > >  		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
> > > 
> > > Are you planning a future revision that moves the acquiring of the host lock
> > > into the LLDD's queuecommand for all the other drivers you don't currently
> > > touch in this patch set?
> > > 
> > 
> > Hi Brian,
> > 
> > I was under the impression that this would be unnecessary for the vast
> > majority of existing LLD drivers, but if you are aware of specific LLDs
> > that would still need the struct Scsi_Host->host_lock held in their
> > SHT->queuecommand() for whaterver reason please let me know and I would
> > be happy to include this into an RFCv4.
> > 
> > Thanks for your comments!
> 
> zfcp relies on having the interrupts disabled when calling
> queuecommand. Without the spin_lock_irqsave in scsi_dispatch_cmd, the
> locking in zfcp_fsf_send_fcp_command_task has to be changed from
> spin_lock(&qdio->req_q_lock) to spin_lock_irqsave. It is a simple
> change, but other drivers might have similar requirements.
> 

Very good to know, thanks for this useful bit of knowledge Christof.

So my next steps for an RFC v4 of this series is to:

*) Create a seperate scsi_legacy_dispatch_cmd() that still uses
host_lock for SHT->queuecommand(), and enable this by default for all
the LLDs not included in the RFCv3 series to drop their historical
'->queuecommand() unlock -> do_work() -> lock' optimization and that we
know are 100% sure we can run w/o host_lock being held.  Also note that
MPT/Fusion and mpt2sas will do not require host_lock as Tim Chen has
demonstrated with his testing.  (Any LSI folks comments here..?)

*) Following Mike Anderson's comments wrt to the signaling
scsi_try_to_abort_cmd() callpath for block softirq completion w/o struct
scsi_cmnd->serial_number, and how it currently breaks scsi_unjam_host ->
scsi_eh_abort_cmds -> scsi_try_to_abort_cmd().

I don't for see any particular issues with the former at this point, and
I will be reposting with these changes soon.  For the latter it appears
we need a seperate struct request->atomic_flags bit for signaling the
call from block softirq context, so that the scsi_try_to_abort_cmd() can
still complete the outstanding struct scsi_cmnd descriptor in the EH
scsi_unjam_host() path.  Any other comments on this particular item from
Intel, IBM and other distro kernel folks would be apperciated.

Thanks for your comments!

--nab
	 
