From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH] mptfusion: print Doorbell register in a case of hard
 reset and timeout
Date: Tue, 22 Jun 2010 18:18:03 +0900
Message-ID: <4C207FCB.2010403@jp.fujitsu.com>
References: <4BD533BE.4090001@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37083 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759118Ab0FVJTE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2010 05:19:04 -0400
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o5M9J20X014564
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Tue, 22 Jun 2010 18:19:02 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 5B6C545DE6F
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jun 2010 18:19:02 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2EFEE45DE4D
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jun 2010 18:19:02 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id EF8D5E38002
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jun 2010 18:19:01 +0900 (JST)
Received: from m021.s.css.fujitsu.com (m021.s.css.fujitsu.com [10.0.81.61])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 7C1691DB803F
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jun 2010 18:19:01 +0900 (JST)
In-Reply-To: <4BD533BE.4090001@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <kashyap.desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Kei Tokunaga wrote:
> Hi Kashyap,
> 
> Printing Doorbell register in a case of hard reset and timeout
> should be useful for figuring out the state of the system.

Hi Kashyap,

Can you give this patch an ACK?  I confirmed it still applies to
03.04.16.

Thanks,
Kei

> Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> 
>  drivers/message/fusion/mptbase.c  |   13 ++++++++-----
>  drivers/message/fusion/mptctl.c   |   20 ++++++++++++++++----
>  drivers/message/fusion/mptsas.c   |    5 +++--
>  drivers/message/fusion/mptscsih.c |   12 ++++++++----
>  4 files changed, 35 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index a6a5701..50d5b23 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -5062,8 +5062,9 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
>  		if (ioc->mptbase_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
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
> @@ -6454,8 +6455,9 @@ out:
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
> @@ -7144,7 +7146,8 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
>  	rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag);
>  	if (rc != 0) {
>  		printk(KERN_WARNING MYNAM
> -		    ": WARNING - (%d) Cannot recover %s\n", rc, ioc->name);
> +		       ": WARNING - (%d) Cannot recover %s, doorbell=0x%08x\n",
> +		       rc, ioc->name, mpt_GetIocState(ioc, 0));
>  	} else {
>  		if (ioc->hard_resets < -1)
>  			ioc->hard_resets++;
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index f06b291..b8a925c 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -946,10 +946,14 @@ retry_wait:
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
> +		} else {
>  			goto retry_wait;
> +		}
>  		goto fwdl_out;
>  	}
>  
> @@ -2293,6 +2297,10 @@ retry_wait:
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
> @@ -2600,10 +2608,14 @@ retry_wait:
>  			mpt_free_msg_frame(ioc, mf);
>  			goto out;
>  		}
> -		if (!timeleft)
> +		if (!timeleft) {
> +			printk(MYIOC_s_WARN_FMT
> +			       "HOST INFO command timeout, doorbell=0x%08x\n",
> +			       ioc->name, mpt_GetIocState(ioc, 0));
>  			mptctl_timeout_expired(ioc, mf);
> -		else
> +		} else {
>  			goto retry_wait;
> +		}
>  		goto out;
>  	}
>  
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index ac000e8..0a34e0c 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -4727,8 +4727,9 @@ mptsas_broadcast_primative_work(struct fw_event_work *fw_event)
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
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 7bd4c0f..693af3b 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1704,8 +1704,9 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun,
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
> @@ -3047,8 +3048,11 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
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
> 
> 
> 
> 

