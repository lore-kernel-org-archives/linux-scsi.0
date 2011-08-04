From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 04/05] mptfusion: Fix for device offline while doing
 aggressive HBA reset
Date: Thu, 4 Aug 2011 19:07:01 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED7016650A1BA@inbmail01.lsi.com>
References: <201108041051.p74AprAP005912@milmhbs0.lsil.com>
 <4E3A9A05.8090602@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58352 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab1HDNg0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 09:36:26 -0400
In-Reply-To: <4E3A9A05.8090602@itwm.fraunhofer.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>



> -----Original Message-----
> From: Bernd Schubert [mailto:bernd.schubert@itwm.fraunhofer.de]
> Sent: Thursday, August 04, 2011 6:39 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; Nandigama, Nagalakshmi; Prakash, Sathya;
> Moore, Eric; JBottomley@parallels.com
> Subject: Re: [PATCH 04/05] mptfusion: Fix for device offline while doing
> aggressive HBA reset
> 
> On 08/04/2011 01:13 PM, kashyap.desai@lsi.com wrote:
> > Issue:
> > Device goes offline while doing aggressive HBA reset
> > along with IO using some utility.
> >
> > Root cause:
> > FW goes into bad state due to aggressive reset. Softreset does
> > not help to recover FW. And also aggressive reset open up the
> > window for Error handling thread to kicked off at the same time
> > HBA will be in constant RESET loop as part of aggressive reset
> > test case can lead Device to goes offline.
> >
> > Changes:
> > 1. Added extra check as below inside eh_timed_out call back as below.
> > if(ioc->ioc_reset_in_progress)
> >      Rc = EH_TIMER_RESET
> > 2. Removed " DOORBELL_ACTIVE" check for SAS controller from task
> management context.
> >     Since SAS controller uses high priority queue for task management.
> This check is
> >     not required for SAS controller.
> > 3. Moved SoftReset call to HardReset from Task Mgmt context.
> 
> [...]
> 
> 
> > --- a/drivers/message/fusion/mptscsih.c
> > +++ b/drivers/message/fusion/mptscsih.c
> > @@ -1630,7 +1630,13 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8
> type, u8 channel, u8 id, int lun,
> >   		return 0;
> >   	}
> >
> > -	if (ioc_raw_state&  MPI_DOORBELL_ACTIVE) {
> > +	/* DOORBELL ACTIVE check is not required if
> > +	*  MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q is supported.
> > +	*/
> > +
> > +	if (!((ioc->facts.IOCCapabilities&
> MPI_IOCFACTS_CAPABILITY_HIGH_PRI_Q)
> > +		&&  (ioc->facts.MsgVersion>= MPI_VERSION_01_05))&&
> > +		(ioc_raw_state&  MPI_DOORBELL_ACTIVE)) {
> >   		printk(MYIOC_s_WARN_FMT
> >   			"TaskMgmt type=%x: ioc_state: "
> >   			"DOORBELL_ACTIVE (0x%x)!\n",
> > @@ -1729,7 +1735,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8
> type, u8 channel, u8 id, int lun,
> >   		printk(MYIOC_s_WARN_FMT
> >   		       "Issuing Reset from %s!! doorbell=0x%08x\n",
> >   		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
> > -		retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
> > +		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
> >   		mpt_free_msg_frame(ioc, mf);
> >   	}
> 
> Have you ever tested that with dual port 501030C parallel scsi HBAs? The
> hard reset with those HBAs will reset *both* ports and eventually *both*
> ports will fail. A couple of years ago I tried to convince Eric to
> disable hard resets for those chips at all (and even sent a patch), but
> Eric never agreed on that.
> The soft-reset handler was a workaround for that problem, but with that
> patch the issue will re-appear. The affected systems are still in
> production and probably will still be for the next few years.

I did not tried with dual port 501030C parallel scsi HBA.. I remember that exact issue you have described here.
I can add check for ioc->bus_type == SAS to have HardReset and other case I will continue with SoftReset.
Just wanted to know Is this fine to avoid issue which you have mentioned ?

Pls let me know your view on it, so that I can resend the patch.

~ Kashyap
> 
> 
> Thanks,
> Bernd
