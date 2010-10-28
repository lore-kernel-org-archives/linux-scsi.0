From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v8] scsi: Push down host_lock into legacy LLD
	SHT->queuecommand()
Date: Thu, 28 Oct 2010 01:41:09 -0700
Message-ID: <1288255269.5169.250.camel@haakon2.linux-iscsi.org>
References: <1288249268-17734-1-git-send-email-nab@linux-iscsi.org>
	 <4CC9329F.40303@garzik.org>
	 <1288254332.5169.239.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288254332.5169.239.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-10-28 at 01:25 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2010-10-28 at 04:21 -0400, Jeff Garzik wrote:
> > On 10/28/2010 03:01 AM, Nicholas A. Bellinger wrote:
> > > Following yet another round of convincing discussions from jgarzik and jejb
> > > this afternoon, this RFCv8 patch series follows their recommendation and does a
> > > SCSI subsystem wide 'push down' of struct Scsi_Host->host_lock usage from
> > > scsi_dispatch_cmd() into legacy LLDs that require (or we are not sure about)
> > > the host_lock held while SHT->queuecommand() I/O dispatch occurs.
> > 
> > Great!
> > 
> > 
> > > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > > index d050e07..672a8c9 100644
> > > --- a/drivers/ata/libata-scsi.c
> > > +++ b/drivers/ata/libata-scsi.c
> > > @@ -3174,7 +3174,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
> > >    *	ATA and ATAPI devices appearing as SCSI devices.
> > >    *
> > >    *	LOCKING:
> > > - *	Releases scsi-layer-held lock, and obtains host lock.
> > > + *	None
> > >    *
> > >    *	RETURNS:
> > >    *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
> > > @@ -3190,7 +3190,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> > >
> > >   	ap = ata_shost_to_port(shost);
> > >
> > > -	spin_unlock(shost->host_lock);
> > >   	spin_lock(ap->lock);
> > >
> > >   	ata_scsi_dump_cdb(ap, cmd);
> > > @@ -3204,7 +3203,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> > >   	}
> > >
> > >   	spin_unlock(ap->lock);
> > > -	spin_lock(shost->host_lock);
> > >   	return rc;
> > >   }
> > >
> > 
> > This is not an equivalent transformation, because we just lost _irqsave 
> > and _irqstore.
> > 
> > You might want to double-check to ensure this problem is not replicated 
> > in other non-legacy drivers.
> 
> Understood, so for libata this will need to turn into the equivilent
> spin_lock_irqsave() + spin_unlock_irqrestore() for ap->lock, right..?
> 
> So apart from libata that leaves the following LLDs running in host_lock
> less mode:
> 
> drivers/infiniband/ulp/iser/iscsi_iser.c: Running in host_lock less mode (libiscsi)
> drivers/message/fusion/mptscsih.c: Running in host_lock less mode (internal)
> drivers/message/fusion/mptfc.c: Running in host_lock less mode (internal)
> drivers/message/fusion/mptsas.c: Running in host_lock less mode (internal)
> drivers/message/fusion/mptspi.c: Running in host_lock less mode (internal)
> drivers/scsi/aic94xx/aic94xx_init.c: Running in host_lock less mode (libsas)
> drivers/scsi/be2iscsi/be_main.c: Running in host_lock less mode (libiscsi)
> drivers/scsi/bnx2i/bnx2i_iscsi.c: Running in host_lock less mode (libiscsi)
> drivers/scsi/fnic/fnic_main.c: Running in host_lock less mode (internal)
> drivers/scsi/iscsi_tcp.c: Running in host_lock less mode (libiscsi)
> drivers/scsi/lpfc/lpfc_scsi.c: Running in host_lock less mode (internal)
> drivers/scsi/mpt2sas/mpt2sas_scsih.c: Running in host_lock less mode (internal)
> drivers/scsi/mvsas/mv_init.c: Running in host_lock less mode (libsas)
> drivers/scsi/pm8001/pm8001_init.c: Running in host_lock less mode (libsas)
> drivers/scsi/qla2xxx/qla_os.c: Running in host_lock less mode (internal)
> drivers/scsi/qla4xxx/ql4_os.c: Running in host_lock less mode (internal)
> drivers/scsi/scsi_debug.c: Running in host_lock less mode (internal)
> drivers/scsi/cxgbi/cxgb3i/cxgb3i.c: Running in host_lock less mode (libiscsi)
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c: Running in host_lock less mode (libiscsi)
> 
> I will take another look and make sure any LLD specific locks that are
> obtained in SHT->queuecommand() from the host_lock-less drivers are
> assuming they need to call internal locks with _irqsave + _irqrestore
> held and include these into lio-4.0.git/host_lock-less-for-37-v9.
> 

Ok, so originally libiscsi, fnic, and lpfc where using
spin_unlock(host->host_lock) -> spin_lock(host->host_lock)

And libsas, qla2xxx, qla4xxx where using
spin_unlock_irq(host->host_lock) -> spin_lock_irq(host->host_lock)

Just to verify, you are thinking that those *not* using spin_unlock_irq
+ spin_lock_irq() for the legacy optimization dispath should have their
per LLD host lock converted to spin_lock_irqsave() +
spin_unlock_irqrestore(), right..?

--nab
