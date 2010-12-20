From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 06/11] mpt2sas: Convert to host_lock less w/ interrupts
	disabled externally
Date: Mon, 20 Dec 2010 20:34:40 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70916A016@inbmail01.lsi.com>
References: <1290032349-4959-1-git-send-email-nab@linux-iscsi.org>
	 <4CE4FCB8.20608@panasas.com>
 <1290121071.31890.135.camel@haakon2.linux-iscsi.org>
 <B2FD678A64EAAD45B089B123FDFC3ED709047ABA@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:55463 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757740Ab0LTPEr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2010 10:04:47 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED709047ABA@inbmail01.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Vasu Dev <vasu.dev@linux.intel.com>, Tejun Heo <tj@kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Nicholas,

I have gone through another round of code walkthrough (for mpt2sas and mptfusion) to find out dependency w.r.t new host lock less mode.
In my opinion, w/ interrupts disable is a good ideal. (Earlier, I mentioned that mpt2sas is safe even if interrupts are enabled) 
In real scenario, *preemption* disable is more IMP for mpt2sas/mptfusion driver than interrupts disable.

e.a if scsih_qcmd_xxx has executed half of the code and (due to preemption is not disable for the same CPU), Scheduler can execute any other process on the SAME cpu (Though IRQ is disable). Consider Error handling is kicked off on the same CPU and as part of EH, it executed HBA reset.
As part of HBA reset Driver has return back all pending Scsi command to mid-layer, and once control come back to original scsih_qcmd_xxx LLD drive will see bad results (Kernel crash/Data corruption/h/w hung or anything critical.....)


So I would suggest to disable preemption also in your macro " IRQ_DISABLE_SCSI_QCMD " as below two level of prevention.
        local_irq_save(flags);
        preempt_disable();


mpt2sas parameters checks like ioc_link_reset_in_process,
tm_busy, scs_priv_target_data->deleted  are mainly to communicate device/IOC state of the firmware so there is no hard dependency w.r.t host_lock.


Thanks, Kashyap




> -----Original Message-----
> From: Desai, Kashyap
> Sent: Friday, November 19, 2010 4:33 PM
> To: Nicholas A. Bellinger; Boaz Harrosh
> Cc: linux-scsi; Jeff Garzik; James Bottomley; Christoph Hellwig; Mike
> Christie; Vasu Dev; Tejun Heo; DL-MPT Fusion Linux
> Subject: RE: [PATCH 06/11] mpt2sas: Convert to host_lock less w/
> interrupts disabled externally
> 
> 
> 
> > -----Original Message-----
> > From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org]
> > Sent: Friday, November 19, 2010 4:28 AM
> > To: Boaz Harrosh
> > Cc: linux-scsi; Jeff Garzik; James Bottomley; Christoph Hellwig; Mike
> > Christie; Vasu Dev; Tejun Heo; DL-MPT Fusion Linux; Desai, Kashyap
> > Subject: Re: [PATCH 06/11] mpt2sas: Convert to host_lock less w/
> > interrupts disabled externally
> >
> > <Trimming CC list>
> >
> > On Thu, 2010-11-18 at 12:15 +0200, Boaz Harrosh wrote:
> > > On 11/18/2010 12:19 AM, Nicholas A. Bellinger wrote:
> > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > >
> > > > This patch converts the mpt2sas driver to run in host_lock less
> > mode
> > > > with the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts
> while
> > > > calling ->queuecommand() dispatch
> > > >
> > > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > > > ---
> > > >  drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
> > > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > > > index 1a96a00..e564fe7 100644
> > > > --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > > > +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > > > @@ -3304,7 +3304,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd
> > *scmd, u16 ioc_status)
> > > >  }
> > > >
> > > >  /**
> > > > - * _scsih_qcmd - main scsi request entry point
> > > > + * _scsih_qcmd_irq_disable - main scsi request entry point
> > > >   * @scmd: pointer to scsi command object
> > > >   * @done: function pointer to be invoked on completion
> > > >   *
> > > > @@ -3315,7 +3315,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd
> > *scmd, u16 ioc_status)
> > > >   * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
> > > >   */
> > > >  static int
> > > > -_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct
> > scsi_cmnd *))
> > > > +_scsih_qcmd_irq_disable(struct scsi_cmnd *scmd, void
> > (*done)(struct scsi_cmnd *))
> > > >  {
> > > >  	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device-
> >host);
> > > >  	struct MPT2SAS_DEVICE *sas_device_priv_data;
> > > > @@ -3441,7 +3441,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd,
> void
> > (*done)(struct scsi_cmnd *))
> > > >  	return SCSI_MLQUEUE_HOST_BUSY;
> > > >  }
> > > >
> > > > -static DEF_SCSI_QCMD(_scsih_qcmd)
> > > > +static IRQ_DISABLE_SCSI_QCMD(_scsih_qcmd)
> > > >
> > >
> > > How can this (and other in the patchset) can be correct? I mean I
> > expect
> > > that if you remove the lock,xx_qcmd_lck,unlock then inside the
> > xx_qcmd_lck
> > > there was an unlock,do123,lock and that driver was effectively
> > running lockless
> > > before. (like in iscsi). But here this is new behaviour. If it is
> > correct
> > > I would like to see a statement from you that:
> > > 	"I have audited this driver, and all shared resources are
> > protected by
> > >          XYZ so ..."
> > >
> > > Otherwise how can I know this is correct? I have never audited this
> > driver myself
> > >
> >
> > So for this specific mpt2sas case, Vasu Dev had been testing the
> > lock_less case w/o disabling interrupts for his original
> > SHT->unlocked_qcmd=1 patch, and from his comments this mode was
> stable
> > during his JBOD lock_less small block IOP performance test.
> >
> Nicholas, mpt2sas driver is safe even if in lock less condition.
> I have tested mpt2sas driver available in 2.6.37-rc2 where I have seen
> host lock push down code is available for mpt2sas driver
> I have seen static DEF_SCSI_QCMD(_scsih_qcmd) is available for mpt2sas
> driver. I also did testing removing that particular macro and making
> Mpt2sas driver in actual host lock less mode. Below observation is
> after removing static DEF_SCSI_QCMD(_scsih_qcmd) from mpt2sas (that is
> what I refer as actual host lock less mode)
> 
> I have tested stability of the driver and I/O integrity. Things were
> fine. I am not seeing any need for even going for
> IRQ_DISABLE_SCSI_QCMD() patch too.
> Mpt2sas driver is able to handle host lock less mode seamlessly, since
> we have all required (racy) places under spinlocks.
> 
> I do not see any solid need for this patch. Please correct me if I am
> missing anything here.
> 
> ~ Kashyap
> 
> > This patch currently includes IRQ_DISABLE_SCSI_QCMD() usage which I
> am
> > not even sure is needed (according to Vasu's original findings), but
> I
> > decided to err on the conservative side until we can get some
> feedback
> > from the the mpt2sas maintainer (Kashyap @ LSI CC'ed).
> >
> > --nab
> >

