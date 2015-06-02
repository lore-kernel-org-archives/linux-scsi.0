From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] lpfc: in sli3 use configured sg_seg_cnt for
 sg_tablesize
Date: Tue, 2 Jun 2015 23:09:29 +0200
Message-ID: <20150602230929.000025a4@localhost>
References: <fe5b2b$6sl0ed@dgate10u.abg.fsc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54250 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbbFBVJy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jun 2015 17:09:54 -0400
In-Reply-To: <fe5b2b$6sl0ed@dgate10u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bstroesser@ts.fujitsu.com
Cc: james.smart@avagotech.com, linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

bstroesser@ts.fujitsu.com wrote:
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
>  	/* Initialize the host templates the configured values. */
>  	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
> -	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
> +	lpfc_template_s3.sg_tablesize = phba->cfg_sg_seg_cnt;
>  
>  	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp */
>  	if (phba->cfg_enable_bg) {

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>

Sebastian
