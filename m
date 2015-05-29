From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH] lpfc: in sli3 use configured sg_seg_cnt for sg_tablesize
Date: Fri, 29 May 2015 10:05:09 -0400
Message-ID: <55687215.4050300@avagotech.com>
References: <10f4d2$5t7km8@dgate20u.abg.fsc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36824 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbbE2OFN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2015 10:05:13 -0400
Received: by qgf2 with SMTP id 2so29513453qgf.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2015 07:05:12 -0700 (PDT)
In-Reply-To: <10f4d2$5t7km8@dgate20u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bstroesser@ts.fujitsu.com, linux-scsi@vger.kernel.org

Bodo,

This is a valid fix.  Thank you.

I assume you were changing the driver module parameter to up the SG 
count ?  without the fix we would have been capped at 64 sges.

-- james

Reviewed-By: James Smart <james.smart@avagotech.com>



On 5/29/2015 8:22 AM, bstroesser@ts.fujitsu.com wrote:
> Hi James,
>
> We had some performance problems with RAID systems connected to LPe12k.
> AFAICS, the reason is a small bug in lpfc.ko, causing the IO-size to
> be smaller than expected.
>
> The patch below fixes it for us.
>
> Please CC me, I'm not on the list.
>
> Best regards
> Bodo
>
>
> ------------------------------------------------------
>
> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Date: Fri, 29 May 2015 13:34:19 +0200
> Subject: [PATCH] lpfc: in sli3 use configured sg_seg_cnt for sg_tablesize
>
> Currently the module parameter lpfc_sg_seg_count does not have effect
> for sli3 devices.
>
> In lpfc_sli_driver_resource_setup(), which is used for sli3, the code
> writes the configured sg_seg_cnt into lpfc_template.sg_tablesize.
> But lpfc_template is the template used for sli4 only. Thus the value should
> correctly be written to lpfc_template_s3->sg_tablesize.
>
> This patch is for kernel 4.1-rc5, but is tested with lpfc 10.2.405.26 only.
>
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>
> --- a/drivers/scsi/lpfc/lpfc_init.c	2015-05-29 10:19:02.000000000 +0200
> +++ b/drivers/scsi/lpfc/lpfc_init.c	2015-05-29 10:19:56.000000000 +0200
> @@ -4988,7 +4988,7 @@ lpfc_sli_driver_resource_setup(struct lp
>   
>   	/* Initialize the host templates the configured values. */
>   	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
> -	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
> +	lpfc_template_s3.sg_tablesize = phba->cfg_sg_seg_cnt;
>   
>   	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp */
>   	if (phba->cfg_enable_bg) {

