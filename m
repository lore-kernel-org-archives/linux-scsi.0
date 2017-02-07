From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 13/39] megaraid_sas : set residual bytes count during IO compeltion
Date: Tue, 7 Feb 2017 16:37:48 +0530
Message-ID: <c0f612adc620c800ec8be8d478134cfc@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-14-git-send-email-shivasharan.srikanteshwara@broadcom.com> <yq1poiuubbz.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34367 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdBGLHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 06:07:50 -0500
Received: by mail-qk0-f178.google.com with SMTP id s186so84101716qkb.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2017 03:07:50 -0800 (PST)
In-Reply-To: <yq1poiuubbz.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, February 07, 2017 5:22 AM
> To: Shivasharan S
> Cc: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> thenzl@redhat.com; jejb@linux.vnet.ibm.com;
> kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> hare@suse.com
> Subject: Re: [PATCH 13/39] megaraid_sas : set residual bytes count
during IO
> compeltion
>
> >>>>> "Shivasharan" == Shivasharan S
> <shivasharan.srikanteshwara@broadcom.com> writes:
>
> Shivasharan> Fixing issue of not setting residual bytes correctly.
>
> @@ -1464,6 +1465,15 @@ map_cmd_status(struct fusion_context *fusion,
>  			       SCSI_SENSE_BUFFERSIZE);
>  			scmd->result |= DRIVER_SENSE << 24;
>  		}
> +
> +		/*
> +		 * If the  IO request is partially completed, then MR FW
will
> +		 * update "io_request->DataLength" field with actual
number
> of
> +		 * bytes transferred.Driver will set residual bytes count
in
> +		 * SCSI command structure.
> +		 */
> +		resid = (scsi_bufflen(scmd) - data_length);
> +		scsi_set_resid(scmd, resid);
>
> Is data_length guaranteed to be a multiple of the logical block size?
> Otherwise you need to tweak the residual like we just did for mpt3sas.

Martin, Data length will be always guaranteed to be a multiple of the
logical block size until and unless we have some firmware defect.
In past, We have seen  some partial/complete DMA data length return from
firmware was not aligned with logical block size. Eventually, root caused
+ fixed in firmware.

>
> --
> Martin K. Petersen	Oracle Linux Engineering
