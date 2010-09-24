From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v3 01/15] scsi: Drop struct Scsi_Host->host_lock usage in
	scsi_dispatch_cmd()
Date: Fri, 24 Sep 2010 13:44:00 -0700
Message-ID: <1285361040.1849.235.camel@haakon2.linux-iscsi.org>
References: <1285285052-16351-1-git-send-email-nab@linux-iscsi.org>
	 <4C9CAA80.1030702@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C9CAA80.1030702@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-09-24 at 08:41 -0500, Brian King wrote:
> On 09/23/2010 06:37 PM, Nicholas A. Bellinger wrote:
> > @@ -651,7 +655,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
> >  int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> >  {
> >  	struct Scsi_Host *host = cmd->device->host;
> > -	unsigned long flags = 0;
> >  	unsigned long timeout;
> >  	int rtn = 0;
> > 
> > @@ -736,15 +739,11 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> >  		scsi_done(cmd);
> >  		goto out;
> >  	}
> > -
> > -	spin_lock_irqsave(host->host_lock, flags);
> >  	/*
> > -	 * AK: unlikely race here: for some reason the timer could
> > -	 * expire before the serial number is set up below.
> > -	 *
> > -	 * TODO: kill serial or move to blk layer
> > +	 * Note that scsi_cmd_get_serial() used to be called here, but
> > +	 * now we expect the legacy SCSI LLDs that actually need this
> > +	 * to call it directly within their SHT->queuecommand() caller.
> >  	 */
> > -	scsi_cmd_get_serial(host, cmd); 
> > 
> >  	if (unlikely(host->shost_state == SHOST_DEL)) {
> >  		cmd->result = (DID_NO_CONNECT << 16);
> > @@ -753,7 +752,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> >  		trace_scsi_dispatch_cmd_start(cmd);
> >  		rtn = host->hostt->queuecommand(cmd, scsi_done);
> >  	}
> > -	spin_unlock_irqrestore(host->host_lock, flags);
> > +
> >  	if (rtn) {
> >  		trace_scsi_dispatch_cmd_error(cmd, rtn);
> >  		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
> 
> Are you planning a future revision that moves the acquiring of the host lock
> into the LLDD's queuecommand for all the other drivers you don't currently
> touch in this patch set?
> 

Hi Brian,

I was under the impression that this would be unnecessary for the vast
majority of existing LLD drivers, but if you are aware of specific LLDs
that would still need the struct Scsi_Host->host_lock held in their
SHT->queuecommand() for whaterver reason please let me know and I would
be happy to include this into an RFCv4.

Thanks for your comments!

--nab
