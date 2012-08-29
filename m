From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH 4/5] mpt2sas: Return the correct sense key for DIF errors
Date: Wed, 29 Aug 2012 15:55:24 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E20ADBFA@inbmail02.lsi.com>
References: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
 <1346178577-28628-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:58846 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751751Ab2H2KZc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Aug 2012 06:25:32 -0400
In-Reply-To: <1346178577-28628-4-git-send-email-martin.petersen@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>

James,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <Sreekanth.reddy@lsi.com>

Regards,
Sreekanth.

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Wednesday, August 29, 2012 12:00 AM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@hansenpartnership.com; Martin K. Petersen;
> Nandigama, Nagalakshmi; Moore, Eric
> Subject: [PATCH 4/5] mpt2sas: Return the correct sense key for DIF
> errors
> 
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Only a target device should return ABORTED COMMAND when a PI error is
> discovered. The HBA should always set the sense key to ILLEGAL REQUEST.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Nagalakshmi.Nandigama@lsi.com
> Cc: Eric.Moore@lsi.com
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |   14 ++------------
>  1 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 7d774c5..bfda0ec 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -3772,8 +3772,6 @@ static void
>  _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>  {
>  	u8 ascq;
> -	u8 sk;
> -	u8 host_byte;
> 
>  	switch (ioc_status) {
>  	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
> @@ -3790,16 +3788,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd
> *scmd, u16 ioc_status)
>  		break;
>  	}
> 
> -	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
> -		sk = ILLEGAL_REQUEST;
> -		host_byte = DID_ABORT;
> -	} else {
> -		sk = ABORTED_COMMAND;
> -		host_byte = DID_OK;
> -	}
> -
> -	scsi_build_sense_buffer(0, scmd->sense_buffer, sk, 0x10, ascq);
> -	scmd->result = DRIVER_SENSE << 24 | (host_byte << 16) |
> +	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> 0x10, ascq);
> +	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
>  	    SAM_STAT_CHECK_CONDITION;
>  }
> 
> --
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
