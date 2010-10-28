From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v8] scsi: Push down host_lock into legacy LLD
	SHT->queuecommand()
Date: Thu, 28 Oct 2010 01:17:57 -0700
Message-ID: <1288253877.5169.232.camel@haakon2.linux-iscsi.org>
References: <1288249268-17734-1-git-send-email-nab@linux-iscsi.org>
	 <20101028080950.GA3290@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101028080950.GA3290@schmichrtp.mainz.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, "Love, Robert W" <robert.w.love@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-10-28 at 10:09 +0200, Christof Schmitt wrote:
> On Thu, Oct 28, 2010 at 12:01:08AM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Following yet another round of convincing discussions from jgarzik and jejb
> > this afternoon, this RFCv8 patch series follows their recommendation and does a
> > SCSI subsystem wide 'push down' of struct Scsi_Host->host_lock usage from
> > scsi_dispatch_cmd() into legacy LLDs that require (or we are not sure about)
> > the host_lock held while SHT->queuecommand() I/O dispatch occurs.
> > 
> > This patch still calls scsi_cmd_get_serial() for all LLDs within scsi_dispatch_cmd()
> > to perform struct scsi_cmnd->serial_number assignment using the new atomic_t
> > struct Scsi_Host->cmd_serial_number counter.  This counter follows a recommedation by
> > Joe Eykholt to increment each serial_number by 2 so that the serial is odd, and wraps
> > to 1 instead of 0.
> > 
> > Finally this patch also changes modern LLDs originally using the SHT->queuecommand() ->
> > unlock() -> do_some_lld_work() -> lock() -> return from lld_queuecommand()
> > optimization to now run by default in the 'host_lock-less' mode.  This also
> > includes a handful of other LLDs that folks have tested in unlocked mode and
> > appear to be functioning as expected.
> [...]
> > diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> > index 50286d8..0ca1bd3 100644
> > --- a/drivers/s390/scsi/zfcp_scsi.c
> > +++ b/drivers/s390/scsi/zfcp_scsi.c
> > @@ -82,8 +82,11 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
> >  	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> >  	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> >  	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
> > +	unsigned long hflags;
> >  	int    status, scsi_result, ret;
> > 
> > +	spin_lock_irqsave(scpnt->device->host->host_lock, hflags);
> > +
> >  	/* reset the status for this request */
> >  	scpnt->result = 0;
> >  	scpnt->host_scribble = NULL;
> > @@ -94,6 +97,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
> >  		scpnt->result = scsi_result;
> >  		zfcp_dbf_scsi_fail_send(adapter->dbf, scpnt);
> >  		scpnt->scsi_done(scpnt);
> > +		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
> >  		return 0;
> >  	}
> > 
> > @@ -104,6 +108,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
> >  		/* only LUN access denied, but port is good
> >  		 * not covered by FC transport, have to fail here */
> >  		zfcp_scsi_command_fail(scpnt, DID_ERROR);
> > +		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
> >  		return 0;
> >  	}
> > 
> > @@ -115,15 +120,20 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
> >  		 * 	fc_remote_port_chkready until rport is BLOCKED
> >  		 */
> >  		zfcp_scsi_command_fail(scpnt, DID_IMM_RETRY);
> > +		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
> >  		return 0;
> >  	}
> > 
> >  	ret = zfcp_fsf_fcp_cmnd(scpnt);
> > -	if (unlikely(ret == -EBUSY))
> > +	if (unlikely(ret == -EBUSY)) {
> > +		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
> >  		return SCSI_MLQUEUE_DEVICE_BUSY;
> > -	else if (unlikely(ret < 0))
> > +	} else if (unlikely(ret < 0)) {
> > +		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
> >  		return SCSI_MLQUEUE_HOST_BUSY;
> > +	}
> > 
> > +	spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
> >  	return ret;
> >  }
> > 
> 
> For the zfcp part:
> Acked-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> 

Added to forthcoming lio-4.0.git/host_lock-less-for-37-v9

> What is now the strategy for fc_remote_port_chkready? This function
> requires the host_lock to be held for protecting the
> rport->port_state.  I am working on a patch to reduce the time where
> the host_lock is being held in the zfcp driver. But it looks like the
> FC LLDs have to keep something like this for now:
> 
> spin_lock_irqsave(scpnt->device->host->host_lock, hflags);
> scsi_result = fc_remote_port_chkready(rport);
> spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
> 
> Are there any plans to change this for the rport->port_state?
> 

This was an item that Mike Christie had originally mentioned, with the
current status being we are 'not sure' and awaiting a deeper review from
James Smart, Joe Eykholt, Robert Love, or someone else fimilar with the
libfc -> fcoe usage of rport w/ the legacy host_lock held.

So libfc folks, please let me know if what needs to be changed in order
to enable host_lock-less operation for libfc -> fcoe code for this round
of if we will need to defer for .38.

Thank you for your comments Christof!

--nab
