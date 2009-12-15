From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH -tip] fusion: fix warning when not using procfs
Date: Tue, 15 Dec 2009 09:57:40 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93CDEBF9@inbmail01.lsi.com>
References: <20091214212156.7c9f18c2.erik@kryo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:58526 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759216AbZLOE1y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2009 23:27:54 -0500
In-Reply-To: <20091214212156.7c9f18c2.erik@kryo.se>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erik Ekman <erik@kryo.se>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Erik,

Patch is valid. Please consider ACKED by me.
In future you can address all mptfusion related stuffs to me.

Thanks,
Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Erik Ekman
> Sent: Tuesday, December 15, 2009 1:52 AM
> To: Moore, Eric
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH -tip] fusion: fix warning when not using procfs
> 
> fusion: fix warning when not using procfs
> 
> Fixes the following warning:
> drivers/message/fusion/mptbase.c:129: warning: 'mpt_proc_root_dir' defined
> but not used
> also moves it from public data section since it is static.
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>
> ---
> diff --git a/drivers/message/fusion/mptbase.c
> b/drivers/message/fusion/mptbase.c
> index 85bc6a6..cb2dc59 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -126,8 +126,6 @@ static int mfcounter = 0;
>   *  Public data...
>   */
> 
> -static struct proc_dir_entry *mpt_proc_root_dir;
> -
>  #define WHOINIT_UNKNOWN		0xAA
> 
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=*/
> @@ -146,6 +144,9 @@ static MPT_EVHANDLER
> MptEvHandlers[MPT_MAX_PROTOCOL_DRIVERS];
>  static MPT_RESETHANDLER
> MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
>  static struct mpt_pci_driver
> 	*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
> 
> +#ifdef CONFIG_PROC_FS
> +static struct proc_dir_entry 	*mpt_proc_root_dir;
> +#endif
> 
>  /*
>   *  Driver Callback Index's
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
