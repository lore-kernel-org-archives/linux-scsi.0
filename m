From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mptfusion: print Doorbell register in a case of hard
 reset and timeout
Date: Tue, 22 Jun 2010 18:28:25 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249029016FBDC@inbmail02.lsi.com>
References: <4BD533BE.4090001@jp.fujitsu.com>
 <4C207FCB.2010403@jp.fujitsu.com>
 <1C9608B8A4CD534FB19C7C7543CBB249029016FB62@inbmail02.lsi.com>
 <4C208A0F.7090808@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:59982 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302Ab0FVM6g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2010 08:58:36 -0400
In-Reply-To: <4C208A0F.7090808@jp.fujitsu.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

Can you please consider below patch sent by Kei as an Acked patch and consider it for next merge window.

A much thanks,
Kashyap

> -----Original Message-----
> From: Kei Tokunaga [mailto:tokunaga.keiich@jp.fujitsu.com]
> Sent: Tuesday, June 22, 2010 3:32 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; Kei Tokunaga
> Subject: Re: [PATCH] mptfusion: print Doorbell register in a case of
> hard reset and timeout
> 
> Desai, Kashyap wrote:
> >
> >> -----Original Message-----
> >> From: Kei Tokunaga [mailto:tokunaga.keiich@jp.fujitsu.com]
> >> Sent: Tuesday, June 22, 2010 2:48 PM
> >> To: Desai, Kashyap
> >> Cc: linux-scsi@vger.kernel.org; Kei Tokunaga
> >> Subject: Re: [PATCH] mptfusion: print Doorbell register in a case of
> >> hard reset and timeout
> >>
> >> Kei Tokunaga wrote:
> >>
> >>> Hi Kashyap,
> >>>
> >>> Printing Doorbell register in a case of hard reset and timeout
> >>> should be useful for figuring out the state of the system.
> >>>
> >> Hi Kashyap,
> >>
> >> Can you give this patch an ACK?  I confirmed it still applies to
> >> 03.04.16.
> >>
> > Kei,
> >
> > Patch looks OK to me. I have commented few things below. Can you
> please correct it and resend?
> > Thanks, Kashyap
> Thanks for reviewing it.  Here is a corrected version of it.
> 
> Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> 
>  drivers/message/fusion/mptbase.c  |   13 ++++++++-----
>  drivers/message/fusion/mptctl.c   |   18 ++++++++++++++----
>  drivers/message/fusion/mptsas.c   |    5 +++--
>  drivers/message/fusion/mptscsih.c |   12 ++++++++----
>  4 files changed, 33 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c
> b/drivers/message/fusion/mptbase.c
> index c36d5b9..e319abc 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -5063,8 +5063,9 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc,
> u8 persist_opcode)
>  		if (ioc->mptbase_cmds.status &
> MPT_MGMT_STATUS_DID_IOCRESET)
>  			goto out;
>  		if (!timeleft) {
> -			printk(KERN_DEBUG "%s: Issuing Reset from %s!!\n",
> -			    ioc->name, __func__);
> +			printk(MYIOC_s_WARN_FMT
> +			       "Issuing Reset from %s!!, doorbell=0x%08x\n",
> +			       ioc->name, __func__, mpt_GetIocState(ioc, 0));
>  			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  			mpt_free_msg_frame(ioc, mf);
>  		}
> @@ -6455,8 +6456,9 @@ out:
>  	mutex_unlock(&ioc->mptbase_cmds.mutex);
>  	if (issue_hard_reset) {
>  		issue_hard_reset = 0;
> -		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
> -		    ioc->name, __func__);
> +		printk(MYIOC_s_WARN_FMT
> +		       "Issuing Reset from %s!!, doorbell=0x%08x\n",
> +		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
>  		if (retry_count == 0) {
>  			if (mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP) != 0)
>  				retry_count++;
> @@ -7146,7 +7148,8 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int
> sleepFlag)
>  	rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER,
> sleepFlag);
>  	if (rc != 0) {
>  		printk(KERN_WARNING MYNAM
> -		    ": WARNING - (%d) Cannot recover %s\n", rc, ioc->name);
> +		       ": WARNING - (%d) Cannot recover %s,
> doorbell=0x%08x\n",
> +		       rc, ioc->name, mpt_GetIocState(ioc, 0));
>  	} else {
>  		if (ioc->hard_resets < -1)
>  			ioc->hard_resets++;
> diff --git a/drivers/message/fusion/mptctl.c
> b/drivers/message/fusion/mptctl.c
> index 9bd89ce..40046f5 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -954,9 +954,12 @@ retry_wait:
>  			mpt_free_msg_frame(iocp, mf);
>  			goto fwdl_out;
>  		}
> -		if (!timeleft)
> +		if (!timeleft) {
> +			printk(MYIOC_s_WARN_FMT
> +			       "FW download timeout, doorbell=0x%08x\n",
> +			       iocp->name, mpt_GetIocState(iocp, 0));
>  			mptctl_timeout_expired(iocp, mf);
> -		else
> +		} else
>  			goto retry_wait;
>  		goto fwdl_out;
>  	}
> @@ -2301,6 +2304,10 @@ retry_wait:
>  			goto done_free_mem;
>  		}
>  		if (!timeleft) {
> +			printk(MYIOC_s_WARN_FMT
> +			       "mpt cmd timeout, doorbell=0x%08x"
> +			       " function=0x%x\n",
> +			       ioc->name, mpt_GetIocState(ioc, 0), function);
>  			if (function == MPI_FUNCTION_SCSI_TASK_MGMT)
>  				mutex_unlock(&ioc->taskmgmt_cmds.mutex);
>  			mptctl_timeout_expired(ioc, mf);
> @@ -2608,9 +2615,12 @@ retry_wait:
>  			mpt_free_msg_frame(ioc, mf);
>  			goto out;
>  		}
> -		if (!timeleft)
> +		if (!timeleft) {
> +			printk(MYIOC_s_WARN_FMT
> +			       "HOST INFO command timeout,
> doorbell=0x%08x\n",
> +			       ioc->name, mpt_GetIocState(ioc, 0));
>  			mptctl_timeout_expired(ioc, mf);
> -		else
> +		} else
>  			goto retry_wait;
>  		goto out;
>  	}
> diff --git a/drivers/message/fusion/mptsas.c
> b/drivers/message/fusion/mptsas.c
> index f42781b..8cdc58c 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -4816,8 +4816,9 @@ mptsas_broadcast_primative_work(struct
> fw_event_work *fw_event)
>  	mutex_unlock(&ioc->taskmgmt_cmds.mutex);
> 
>  	if (issue_reset) {
> -		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
> -		    ioc->name, __func__);
> +		printk(MYIOC_s_WARN_FMT
> +		       "Issuing Reset from %s!! doorbell=0x%08x\n",
> +		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
>  		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  	}
>  	mptsas_free_fw_event(ioc, fw_event);
> diff --git a/drivers/message/fusion/mptscsih.c
> b/drivers/message/fusion/mptscsih.c
> index c5c8fb8..dceb67a 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1706,8 +1706,9 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8
> type, u8 channel, u8 id, int lun,
> 
>  	CLEAR_MGMT_STATUS(ioc->taskmgmt_cmds.status)
>  	if (issue_hard_reset) {
> -		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
> -			ioc->name, __func__);
> +		printk(MYIOC_s_WARN_FMT
> +		       "Issuing Reset from %s!! doorbell=0x%08x\n",
> +		       ioc->name, __func__, mpt_GetIocState(ioc, 0));
>  		retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  		mpt_free_msg_frame(ioc, mf);
>  	}
> @@ -3051,8 +3052,11 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD
> *io)
>  			goto out;
>  		}
>  		if (!timeleft) {
> -			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
> -			    ioc->name, __func__);
> +			printk(MYIOC_s_WARN_FMT
> +			       "Issuing Reset from %s!! doorbell=0x%08xh"
> +			       " cmd=0x%02x\n",
> +			       ioc->name, __func__, mpt_GetIocState(ioc, 0),
> +			       cmd);
>  			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  			mpt_free_msg_frame(ioc, mf);
>  		}
> 
> 

