From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas: Fix missing reference tag seed with Type 2
 devices
Date: Mon, 11 Apr 2011 10:59:13 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157DBBCE3@inbmail01.lsi.com>
References: <yq162rudrmn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38106 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab1DKF2E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2011 01:28:04 -0400
In-Reply-To: <yq162rudrmn.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnersh>

James,

We discuss this patch internally and found as valid candidate to be ACKed.
Please consider this patch as an ACKed.

Thanks, Kashyap

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, March 08, 2011 12:30 PM
> To: linux-scsi@vger.kernel.org; James.Bottomley@hansenpartnership.com;
> Desai, Kashyap; Moore, Eric
> Subject: [PATCH] mpt2sas: Fix missing reference tag seed with Type 2
> devices
> 
> 
> Ensure that the initial reference tag is passed on to the HBA firmware
> for DIF Type 2 devices.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 16e99b6..f423fe9 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -3230,6 +3230,7 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd,
> Mpi2SCSIIORequest_t *mpi_request)
> 
>  	switch (prot_type) {
>  	case SCSI_PROT_DIF_TYPE1:
> +	case SCSI_PROT_DIF_TYPE2:
> 
>  		/*
>  		* enable ref/guard checking
> @@ -3242,13 +3243,6 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd,
> Mpi2SCSIIORequest_t *mpi_request)
>  		    cpu_to_be32(scsi_get_lba(scmd));
>  		break;
> 
> -	case SCSI_PROT_DIF_TYPE2:
> -
> -		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
> -		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
> -		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
> -		break;
> -
>  	case SCSI_PROT_DIF_TYPE3:
> 
>  		/*
