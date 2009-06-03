From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] Fix double free of MPT request frames.
Date: Wed, 3 Jun 2009 14:54:55 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A26108B@inbmail01.lsi.com>
References: <1243365953.20345.24.camel@alok-dev1>
	 <1243464883.20345.56.camel@alok-dev1>
	 <0D1E8821739E724A86F4D16902CE275C141A260DB0@inbmail01.lsi.com>
 <1243708475.7040.18.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:47202 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZFCJY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 05:24:58 -0400
In-Reply-To: <1243708475.7040.18.camel@alok-dev1>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "akataria@vmware.com" <akataria@vmware.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Alok,

Answers inline.

Thanks,
Kashyap


-----Original Message-----
From: Alok Kataria [mailto:akataria@vmware.com] 
Sent: Sunday, May 31, 2009 12:05 AM
To: Desai, Kashyap
Cc: Moore, Eric; James.Bottomley@HansenPartnership.com; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; Prakash, Sathya
Subject: RE: [PATCH] Fix double free of MPT request frames.


On Fri, 2009-05-29 at 22:56 -0700, Desai, Kashyap wrote:
> Alok,
> 
> This part of code is obsolete in LSI's new driver. 
> Very soon you will not see " mptscsih_tm_wait_for_completion" fuction.
> It is replaced by "wait_for_completion_timeout()".

Where is that code checked in ? I don't see it for 2.6.30..
Anyways we still need a fix for the previous kernels. 
---> This code is submitted to upstream. Not yet part of any release.
	Check this patch set: 

	http://marc.info/?l=linux-scsi&m=124359642904576&w=2

> 
> I will say for your kernel panic due to double free in msg frame link
> list can be avoided by changing " mpt_free_msg_frame".

Yeah we thought about it.
But that still leaves another race, there is no guarantee that the frame
would not be reused by mpt_HardResetHandler. Since after reset it can
call SendEventNotification, which can allocate message frame, which may
then confuse your freeing logic. If that happens it would result in we
freeing some other used frame. Another thing that we thought about was
having this check in mpt_free_msg_frame along with moving the
free_msg_frame call before mpt_HardResetHandler, but that too leaves a
window open for the request frame to be reused due to the 250ms msleep.

IMHO the best way to fix this is avoid having these double free calls in
the first place rather than putting in these checks in the
mpt_free_msg_frame function.

---> I agree with this concern. There is some other problem exist in your patch which I thought because you are trying to avoid above condition.

Consider below two points as potential bug in your patch.

#1. As per MPT Fusion design, driver should not free message frame which is still with FW. We should make sure that FW will not use submitted message frame in future before freeing it. There are multiple way to make sure FW will not use msg frame. 
	a. Successful return in ISR for msg frame.
	b. HardReset
	c. Task Abort (success case)

Potential bug in your patch is you are freeing msg frame before HardReset.
There is still possibility that FW will use that freed message frame. It can fault IOC or may be IOC hangs.

#2. Making TmState to NONE much before completing cleanup work for previously faild TM.  In general, TmState = TM_STATE_NONE should be just before you return from mptscsih_tm_wait_for_completion() failure case.






Thanks,
Alok
>  See snippet of code below.
> ------------------------------------------------------------------
> void
> mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
> {
> 	unsigned long flags;
> 
> 	/*  Put Request back on FreeQ!  */
> 	spin_lock_irqsave(&ioc->FreeQlock, flags);
> 	if (cpu_to_le32(mf->u.frame.linkage.arg1) == 0xdeadbeaf)  <----------
> 		goto out;
> 	/* signature to know if this mf is freed */
> 	mf->u.frame.linkage.arg1 = cpu_to_le32(0xdeadbeaf);
> 	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
> out:
> 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> }
> ----------------------------------------------------------------
> 
> 
> This is how we are doing in LSI's Inbox driver. 
> 
> 
> Thanks,
> Kashyap
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Alok Kataria
> Sent: Thursday, May 28, 2009 4:25 AM
> To: Moore, Eric; James.Bottomley@HansenPartnership.com
> Cc: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] Fix double free of MPT request frames.
> 
> Ccing James...any comments on the patch below ? 
> 
> Thanks,
> Alok
> 
> On Tue, 2009-05-26 at 12:25 -0700, Alok Kataria wrote:
> > Hi, 
> > 
> > While testing scsi path failover for disks using MPT drivers we hit a
> > kernel oops on RHEL 5.1-64bit, while analyzing the problem we noticed
> > that this is due to a race present in the mpt scsi code path. The same
> > race seems to be present in the latest git kernel code too.
> > 
> > Here is the description of the race,
> > If a command has run for too long - which can happen often in the
> > failover case - the SCSI stack decides to abort that command and invokes
> > a device's abort handler. 
> > The code flow is...
> > 
> > mptscsih_abort ==> mptscsih_TMHandle (ABORT_TASK) ==>
> > mptscsih_IssueTaskMgmt (submits the command ) ==>
> > mptscsih_tm_wait_for_completion()
> > 
> > the mptscsih_tm_wait_for_completion code looks like this
> > 
> > do {
> >                 spin_lock_irqsave(&ioc->FreeQlock, flags);
> >                 if(hd->tmPending == 0) {
> >                         status = SUCCESS;
> >                         spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> >                         break;
> >                 }
> >                 spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> >                 msleep(250);                        <<==================
> >         } while (--loop_count);
> > 
> > where its looping on hd->tmPending (SUCCESS) or until timeout expires
> > (FAILURE).
> > 
> > Every thing works fine in the success case, in the failure case we
> > return to mptscsih_IssueTaskMgmt, and call mpt_HardResetHandler, where
> > we throw all inflight commands (hard reset) and free request via
> > mpt_free_msg_frame. Which also seems fine.
> > 
> > Now notice in the loop above that in the last iteration we sleep for
> > 250ms after the last read to tmPending, the TM command could complete
> > between this check of tmPending and before the adapter is hard reset. 
> > In such a case the request is double freed once when the command
> > completes (interrupt gets delivered and mpt_reply releases request
> > frame), and once after the mpt_HardResetHandler. This results in
> > corruption of  the linked list of empty request frames and causes a oops
> > on next list access.
> > 
> > The patch below attempts to fix this race by freeing the request_frame
> > before mpt_HardReset and doing that atomically after checking for
> > tmPending value. Also the mptscsih_taskmgmt_complete function returns
> > "1" irrespective of the tmPending value which results in always freeing
> > of the request frame from mpt_reply, so I have modified that function to
> > look at the tmPending value before returning. 
> > 
> > While I am at it, I have also added a BUG_ON statement in
> > mpt_free_msg_frame to check for double free, instead of silently
> > corrupting the list.
> > 
> > Please consider the patch below for inclusion.
> > 
> > 
> > Signed-off-by: Alok N Kataria <akataria@vmware.com>
> > Cc: <stable@kernel.org>
> > ---
> > 
> >  drivers/message/fusion/mptbase.c  |   11 ++++-------
> >  drivers/message/fusion/mptbase.h  |   10 +++++++++-
> >  drivers/message/fusion/mptscsih.c |   25 +++++++++++++++++++++----
> >  3 files changed, 34 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> > index 5d496a9..a1637bf 100644
> > --- a/drivers/message/fusion/mptbase.c
> > +++ b/drivers/message/fusion/mptbase.c
> > @@ -974,7 +974,7 @@ mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
> >  
> >  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> >  /**
> > - *	mpt_free_msg_frame - Place MPT request frame back on FreeQ.
> > + *	__mpt_free_msg_frame - Place MPT request frame back on FreeQ.
> >   *	@ioc: Pointer to MPT adapter structure
> >   *	@mf: Pointer to MPT request frame
> >   *
> > @@ -982,18 +982,15 @@ mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
> >   *	FreeQ.
> >   */
> >  void
> > -mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
> > +__mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
> >  {
> > -	unsigned long flags;
> > -
> > +	BUG_ON(mf->u.frame.linkage.arg1 == 0xdeadbeaf);
> >  	/*  Put Request back on FreeQ!  */
> > -	spin_lock_irqsave(&ioc->FreeQlock, flags);
> >  	mf->u.frame.linkage.arg1 = 0xdeadbeaf; /* signature to know if this mf is freed */
> >  	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
> >  #ifdef MFCNT
> >  	ioc->mfcnt--;
> >  #endif
> > -	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> >  }
> >  
> >  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> > @@ -7612,7 +7609,7 @@ EXPORT_SYMBOL(mpt_device_driver_deregister);
> >  EXPORT_SYMBOL(mpt_get_msg_frame);
> >  EXPORT_SYMBOL(mpt_put_msg_frame);
> >  EXPORT_SYMBOL(mpt_put_msg_frame_hi_pri);
> > -EXPORT_SYMBOL(mpt_free_msg_frame);
> > +EXPORT_SYMBOL(__mpt_free_msg_frame);
> >  EXPORT_SYMBOL(mpt_add_sge);
> >  EXPORT_SYMBOL(mpt_send_handshake_request);
> >  EXPORT_SYMBOL(mpt_verify_adapter);
> > diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> > index b3e981d..4e4ee53 100644
> > --- a/drivers/message/fusion/mptbase.h
> > +++ b/drivers/message/fusion/mptbase.h
> > @@ -906,7 +906,7 @@ extern void	 mpt_reset_deregister(u8 cb_idx);
> >  extern int	 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx);
> >  extern void	 mpt_device_driver_deregister(u8 cb_idx);
> >  extern MPT_FRAME_HDR	*mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc);
> > -extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
> > +extern void	 __mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
> >  extern void	 mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
> >  extern void	 mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
> >  extern void	 mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t dma_addr);
> > @@ -924,6 +924,14 @@ extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
> >  extern int	 mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk);
> >  extern void     mpt_halt_firmware(MPT_ADAPTER *ioc);
> >  
> > +static inline void
> > +mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
> > +{
> > +	unsigned long flags;
> > +	spin_lock_irqsave(&ioc->FreeQlock, flags);
> > +	__mpt_free_msg_frame(ioc, mf);
> > +	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> > +}
> >  
> >  /*
> >   *  Public data decl's...
> > diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> > index e62c6bc..afe7fc0 100644
> > --- a/drivers/message/fusion/mptscsih.c
> > +++ b/drivers/message/fusion/mptscsih.c
> > @@ -1719,6 +1719,18 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, i
> >  	}
> >  
> >  	if(mptscsih_tm_wait_for_completion(hd, timeout) == FAILED) {
> > +		unsigned long flags;
> > +
> > +		spin_lock_irqsave(&ioc->FreeQlock, flags);
> > +		if(hd->tmPending == 0) {
> > +                        spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> > +                        goto out_success;
> > +                }
> > +		__mpt_free_msg_frame(ioc, mf);
> > +		hd->tmPending = 0;
> > +		hd->tmState = TM_STATE_NONE;
> > +		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> > +
> >  		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT "task management request TIMED OUT!"
> >  			" (hd %p, ioc %p, mf %p) \n", ioc->name, hd,
> >  			ioc, mf));
> > @@ -1727,9 +1739,10 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, i
> >  		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
> >  		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rc=%d \n",
> >  			 ioc->name, retval));
> > -		goto fail_out;
> > +		return FAILED;
> >  	}
> >  
> > +out_success:
> >  	/*
> >  	 * Handle success case, see if theres a non-zero ioc_status.
> >  	 */
> > @@ -2159,6 +2172,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *m
> >  	u16			 iocstatus;
> >  	u8			 tmType;
> >  	u32			 termination_count;
> > +	int			 retval = 1;
> >  
> >  	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt completed (mf=%p,mr=%p)\n",
> >  	    ioc->name, mf, mr));
> > @@ -2235,12 +2249,15 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *m
> >  
> >   out:
> >  	spin_lock_irqsave(&ioc->FreeQlock, flags);
> > -	hd->tmPending = 0;
> > -	hd->tmState = TM_STATE_NONE;
> > +	if (hd->tmPending) {
> > +		hd->tmPending = 0;
> > +		hd->tmState = TM_STATE_NONE;
> > +	} else
> > +		retval = 0;
> >  	hd->tm_iocstatus = iocstatus;
> >  	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> >  
> > -	return 1;
> > +	return retval;
> >  }
> >  
> >  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

