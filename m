From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mptsas: Fix annoying warning
Date: Wed, 4 May 2011 17:10:03 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157F09DC3@inbmail01.lsi.com>
References: <1304347778-12129-1-git-send-email-bp@amd64.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1304347778-12129-1-git-send-email-bp@amd64.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@amd64.org>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Please consider this patch as an ACKed.

~ Kashyap

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@amd64.org]
> Sent: Monday, May 02, 2011 8:20 PM
> To: Moore, Eric
> Cc: Borislav Petkov; Support; DL-MPT Fusion Linux; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] mptsas: Fix annoying warning
> 
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Shut up
> 
> drivers/message/fusion/mptsas.c: In function 'mptsas_event_process':
> drivers/message/fusion/mptsas.c:5015: warning: unused variable
> 'log_info'
> 
> for configs with CONFIG_SCSI_MPT2SAS_LOGGING unset.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/message/fusion/mptsas.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptsas.c
> b/drivers/message/fusion/mptsas.c
> index 66f9412..7596aec 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -5012,7 +5012,6 @@ mptsas_event_process(MPT_ADAPTER *ioc,
> EventNotificationReply_t *reply)
>  			(ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
>  			VirtTarget *vtarget = NULL;
>  			u8		id, channel;
> -			u32	 log_info = le32_to_cpu(reply->IOCLogInfo);
> 
>  			id = sas_event_data->TargetID;
>  			channel = sas_event_data->Bus;
> @@ -5023,7 +5022,8 @@ mptsas_event_process(MPT_ADAPTER *ioc,
> EventNotificationReply_t *reply)
>  				    "LogInfo (0x%x) available for "
>  				   "INTERNAL_DEVICE_RESET"
>  				   "fw_id %d fw_channel %d\n", ioc->name,
> -				   log_info, id, channel));
> +				   le32_to_cpu(reply->IOCLogInfo),
> +				   id, channel));
>  				if (vtarget->raidVolume) {
>  					devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  					"Skipping Raid Volume for inDMD\n",
> --
> 1.7.4.rc2
