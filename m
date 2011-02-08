From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas: fix a compile issue
Date: Tue, 8 Feb 2011 17:50:14 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED71121F60A@inbmail01.lsi.com>
References: <4D4ABE95.5090105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39657 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab1BHMT2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2011 07:19:28 -0500
In-Reply-To: <4D4ABE95.5090105@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

I have verified this patch and it is valid changes.
Tomas, Thanks for providing the patch. 

Please consider this as an ACKed patch.

~ Kashyap

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Thursday, February 03, 2011 8:11 PM
> To: 'linux-scsi@vger.kernel.org'
> Cc: Desai, Kashyap; 'James.Bottomley@HansenPartnership.com'; Prakash,
> Sathya
> Subject: [PATCH] mpt2sas: fix a compile issue
> 
> Without CONFIG_SCSI_MPT2SAS_LOGGING defined the
> variable mpi_reply isn't defined.
> 
> This patch moves the #endif below the expression where
> the mpi_reply is used.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index eda347c..40b57c6 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -2741,13 +2741,14 @@ _scsih_sas_control_complete(struct
> MPT2SAS_ADAPTER *ioc, u16 smid,
>  #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
>  	Mpi2SasIoUnitControlReply_t *mpi_reply =
>  	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
> -#endif
> +
>  	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
>  	    "sc_complete:handle(0x%04x), (open) "
>  	    "smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
>  	    ioc->name, le16_to_cpu(mpi_reply->DevHandle), smid,
>  	    le16_to_cpu(mpi_reply->IOCStatus),
>  	    le32_to_cpu(mpi_reply->IOCLogInfo)));
> +#endif
>  	return 1;
>  }
> 
> 

