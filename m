From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 06/11] mpt2sas: Convert to host_lock less w/ interrupts
 disabled externally
Date: Sat, 20 Nov 2010 10:14:02 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED709047B08@inbmail01.lsi.com>
References: <1290032349-4959-1-git-send-email-nab@linux-iscsi.org>
 <4CE4FCB8.20608@panasas.com>
 <1290121071.31890.135.camel@haakon2.linux-iscsi.org>
 <B2FD678A64EAAD45B089B123FDFC3ED709047ABA@inbmail01.lsi.com>
 <4CE6A81C.3050302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:58281 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932257Ab0KTEoZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 23:44:25 -0500
In-Reply-To: <4CE6A81C.3050302@garzik.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Vasu Dev <vasu.dev@linux.intel.com>, Tejun Heo <tj@kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>



> -----Original Message-----
> From: Jeff Garzik [mailto:jgpobox@gmail.com] On Behalf Of Jeff Garzik
> Sent: Friday, November 19, 2010 10:09 PM
> To: Desai, Kashyap
> Cc: Nicholas A. Bellinger; Boaz Harrosh; linux-scsi; James Bottomley;
> Christoph Hellwig; Mike Christie; Vasu Dev; Tejun Heo; DL-MPT Fusion
> Linux
> Subject: Re: [PATCH 06/11] mpt2sas: Convert to host_lock less w/
> interrupts disabled externally
> 
> On 11/19/2010 06:02 AM, Desai, Kashyap wrote:
> >
> >
> >> -----Original Message-----
> >> From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org]
> >> Sent: Friday, November 19, 2010 4:28 AM
> >> To: Boaz Harrosh
> >> Cc: linux-scsi; Jeff Garzik; James Bottomley; Christoph Hellwig;
> Mike
> >> Christie; Vasu Dev; Tejun Heo; DL-MPT Fusion Linux; Desai, Kashyap
> >> Subject: Re: [PATCH 06/11] mpt2sas: Convert to host_lock less w/
> >> interrupts disabled externally
> >>
> >> <Trimming CC list>
> >>
> >> On Thu, 2010-11-18 at 12:15 +0200, Boaz Harrosh wrote:
> >>> On 11/18/2010 12:19 AM, Nicholas A. Bellinger wrote:
> >>>> From: Nicholas Bellinger<nab@linux-iscsi.org>
> >>>>
> >>>> This patch converts the mpt2sas driver to run in host_lock less
> >> mode
> >>>> with the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts
> while
> >>>> calling ->queuecommand() dispatch
> >>>>
> >>>> Signed-off-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
> >>>> ---
> >>>>   drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
> >>>>   1 files changed, 3 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> >> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> >>>> index 1a96a00..e564fe7 100644
> >>>> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> >>>> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> >>>> @@ -3304,7 +3304,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd
> >> *scmd, u16 ioc_status)
> >>>>   }
> >>>>
> >>>>   /**
> >>>> - * _scsih_qcmd - main scsi request entry point
> >>>> + * _scsih_qcmd_irq_disable - main scsi request entry point
> >>>>    * @scmd: pointer to scsi command object
> >>>>    * @done: function pointer to be invoked on completion
> >>>>    *
> >>>> @@ -3315,7 +3315,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd
> >> *scmd, u16 ioc_status)
> >>>>    * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
> >>>>    */
> >>>>   static int
> >>>> -_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct
> >> scsi_cmnd *))
> >>>> +_scsih_qcmd_irq_disable(struct scsi_cmnd *scmd, void
> >> (*done)(struct scsi_cmnd *))
> >>>>   {
> >>>>   	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device-
> >host);
> >>>>   	struct MPT2SAS_DEVICE *sas_device_priv_data;
> >>>> @@ -3441,7 +3441,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void
> >> (*done)(struct scsi_cmnd *))
> >>>>   	return SCSI_MLQUEUE_HOST_BUSY;
> >>>>   }
> >>>>
> >>>> -static DEF_SCSI_QCMD(_scsih_qcmd)
> >>>> +static IRQ_DISABLE_SCSI_QCMD(_scsih_qcmd)
> >>>>
> >>>
> >>> How can this (and other in the patchset) can be correct? I mean I
> >> expect
> >>> that if you remove the lock,xx_qcmd_lck,unlock then inside the
> >> xx_qcmd_lck
> >>> there was an unlock,do123,lock and that driver was effectively
> >> running lockless
> >>> before. (like in iscsi). But here this is new behaviour. If it is
> >> correct
> >>> I would like to see a statement from you that:
> >>> 	"I have audited this driver, and all shared resources are
> >> protected by
> >>>           XYZ so ..."
> >>>
> >>> Otherwise how can I know this is correct? I have never audited this
> >> driver myself
> >>>
> >>
> >> So for this specific mpt2sas case, Vasu Dev had been testing the
> >> lock_less case w/o disabling interrupts for his original
> >> SHT->unlocked_qcmd=1 patch, and from his comments this mode was
> stable
> >> during his JBOD lock_less small block IOP performance test.
> >>
> > Nicholas, mpt2sas driver is safe even if in lock less condition.
> > I have tested mpt2sas driver available in 2.6.37-rc2 where I have
> seen host lock push down code is available for mpt2sas driver
> > I have seen static DEF_SCSI_QCMD(_scsih_qcmd) is available for
> mpt2sas driver. I also did testing removing that particular macro and
> making
> > Mpt2sas driver in actual host lock less mode. Below observation is
> after removing static DEF_SCSI_QCMD(_scsih_qcmd) from mpt2sas (that is
> what I refer as actual host lock less mode)
> >
> > I have tested stability of the driver and I/O integrity. Things were
> fine. I am not seeing any need for even going for
> IRQ_DISABLE_SCSI_QCMD() patch too.
> > Mpt2sas driver is able to handle host lock less mode seamlessly,
> since we have all required (racy) places under spinlocks.
> >
> > I do not see any solid need for this patch. Please correct me if I am
> missing anything here.
> 
> Which locks are held when setting or testing sas_target_priv_data-
> >tm_busy?
> ioc->ioc_link_reset_in_progress?
> sas_target_priv_data->deleted?
> 
Jeff, tm_busy, ioc_link_reset_in_process and deleted field of respective data structure are not so critical. They are not exactly real-time, since they all are representing firmware state for the Host and Target. (It means there is always some open window when firmware state and driver data structure will not match)
e.a 
tm_busy is getting set to 1 when firmware sends "MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET". Even if we secure tm_busy read/write using some spinlock, it will not give any benefit, since there is already some delay when driver sets tm_busy and there is already some window in which few IOs will be sent to firmware.
But main reason for driver is to stop sending IOs to firmware when firmware is doing Task management. There is no harm if few commands go to firmware when task mangagement is running by firmware. (This is also unavoidable to not send single IO to firmware immediately after it sends MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET)

So my call is all three field of relative structure are not having any dependency with host_lock. They are additional sanity check before sending IOs to firmware and even if we sends few IOs in a small open windows (considering there is some open windows before setting variable at driver), it is fine. 


~ Kashyap


> Thanks,
> 
> 	Jeff
> 
> 

