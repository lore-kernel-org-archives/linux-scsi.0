From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [patch 1/2] drivers/message/fusion/mptsas.c: fix warning
Date: Wed, 19 Jan 2011 19:36:48 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED7091C7046@inbmail01.lsi.com>
References: <201101182201.p0IM1W4g007848@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:35738 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850Ab1ASOGR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2011 09:06:17 -0500
In-Reply-To: <201101182201.p0IM1W4g007848@imap1.linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

Without debug enable log_info will not be used.
Please consider this patch as an ACKed.

Thanks, Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of akpm@linux-foundation.org
> Sent: Wednesday, January 19, 2011 3:32 AM
> To: James.Bottomley@HansenPartnership.com
> Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org; Moore, Eric
> Subject: [patch 1/2] drivers/message/fusion/mptsas.c: fix warning
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> drivers/message/fusion/mptsas.c: In function 'mptsas_event_process':
> drivers/message/fusion/mptsas.c:5010: warning: unused variable
> 'log_info'
> 
> Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/message/fusion/mptsas.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/message/fusion/mptsas.c~drivers-message-fusion-
> mptsasc-fix-warning drivers/message/fusion/mptsas.c
> --- a/drivers/message/fusion/mptsas.c~drivers-message-fusion-mptsasc-
> fix-warning
> +++ a/drivers/message/fusion/mptsas.c
> @@ -5009,7 +5009,6 @@ mptsas_event_process(MPT_ADAPTER *ioc, E
>  			(ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
>  			VirtTarget *vtarget = NULL;
>  			u8		id, channel;
> -			u32	 log_info = le32_to_cpu(reply->IOCLogInfo);
> 
>  			id = sas_event_data->TargetID;
>  			channel = sas_event_data->Bus;
> @@ -5020,7 +5019,8 @@ mptsas_event_process(MPT_ADAPTER *ioc, E
>  				    "LogInfo (0x%x) available for "
>  				   "INTERNAL_DEVICE_RESET"
>  				   "fw_id %d fw_channel %d\n", ioc->name,
> -				   log_info, id, channel));
> +				   le32_to_cpu(reply->IOCLogInfo), id,
> +				   channel));
>  				if (vtarget->raidVolume) {
>  					devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  					"Skipping Raid Volume for inDMD\n",
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
