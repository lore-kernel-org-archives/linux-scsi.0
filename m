From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] [SCSI] mptfusion: unlock on error in mpt_config()
Date: Mon, 30 Apr 2012 10:58:21 +0300
Message-ID: <CA+_b7DJn_Nnx=NQKOfQawpy9Q_306P5dUc=nYCqA8wf4YJiX=A@mail.gmail.com>
References: <20110827095930.GK3775@shale.localdomain>
	<A6888A6805518E4EA4AF7072A28264A6042AD54397@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53320 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2D3H6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2012 03:58:22 -0400
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6042AD54397@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "open list:LSILOGIC MPT FUSI..." <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

Ping?

regards,
dan carpenter

On 8/30/11, Nandigama, Nagalakshmi <Nagalakshmi.Nandigama@lsi.com> wrote:
> The patch seem to be fine. Please consider this patch as Acked-by:
> "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
>
>
> Regards,
> Nagalakshmi
>
>
> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Saturday, August 27, 2011 3:30 PM
> To: Moore, Eric; Desai, Kashyap
> Cc: Support; DL-MPT Fusion Linux; open list:LSILOGIC MPT FUSI...;
> kernel-janitors@vger.kernel.org
> Subject: [patch] [SCSI] mptfusion: unlock on error in mpt_config()
>
> We introduced a new return here and forgot to unlock the mutex.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/drivers/message/fusion/mptbase.c
> b/drivers/message/fusion/mptbase.c
> index e9c6a60..e72320e 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -6482,6 +6482,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
>  				printk(MYIOC_s_INFO_FMT "%s: host reset in"
>  					" progress mpt_config timed out.!!\n",
>  					__func__, ioc->name);
> +				mutex_unlock(&ioc->mptbase_cmds.mutex);
>  				return -EFAULT;
>  			}
>  			spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
>
