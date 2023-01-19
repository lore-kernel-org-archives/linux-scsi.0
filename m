Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAF6C6379F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 17:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjASRgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 12:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjASRgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 12:36:17 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C44B4742E
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 09:36:15 -0800 (PST)
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C9E4E61CC457B;
        Thu, 19 Jan 2023 18:36:12 +0100 (CET)
Subject: Re: [PATCH] mpt3sas: Remove scsi_dma_map errors messages
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <20220303140203.12642-1-sreekanth.reddy@broadcom.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <0b858add-818a-b2f6-d78d-4743b1a801f9@molgen.mpg.de>
Date:   Thu, 19 Jan 2023 18:36:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20220303140203.12642-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, 

please excuse a probably naive question:

Why can't this result in errors being silently ignored? Most callers of `_base_build_sg` via `ioc->build_sg()` seem to ignore the return value.

I assume, this is not a problem, but a short confirmation would be very much appreciated.

Thanks

  Donald


On 3/3/22 3:02 PM, Sreekanth Reddy wrote:
> When scsi_dma_map() fails by returning a sges_left value less than
> zero, the amount of logging can be extremely high.  In a recent
> end-user environment, 1200 messages per second were being sent to
> the log buffer.  This eventually overwhelmed the system and it
> stalled. Also these error messages are not needed and hence
> removing them.
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 511726f92d9a..ebb61b47dc2f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2593,12 +2593,8 @@ _base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
>  
>  	/* Get the SG list pointer and info. */
>  	sges_left = scsi_dma_map(scmd);
> -	if (sges_left < 0) {
> -		sdev_printk(KERN_ERR, scmd->device,
> -			"scsi_dma_map failed: request for %d bytes!\n",
> -			scsi_bufflen(scmd));
> +	if (sges_left < 0)
>  		return 1;
> -	}
>  
>  	/* Check if we need to build a native SG list. */
>  	if (!base_is_prp_possible(ioc, pcie_device,
> @@ -2705,12 +2701,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
>  
>  	sg_scmd = scsi_sglist(scmd);
>  	sges_left = scsi_dma_map(scmd);
> -	if (sges_left < 0) {
> -		sdev_printk(KERN_ERR, scmd->device,
> -		 "scsi_dma_map failed: request for %d bytes!\n",
> -		 scsi_bufflen(scmd));
> +	if (sges_left < 0)
>  		return -ENOMEM;
> -	}
>  
>  	sg_local = &mpi_request->SGL;
>  	sges_in_segment = ioc->max_sges_in_main_message;
> @@ -2853,12 +2845,8 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
>  
>  	sg_scmd = scsi_sglist(scmd);
>  	sges_left = scsi_dma_map(scmd);
> -	if (sges_left < 0) {
> -		sdev_printk(KERN_ERR, scmd->device,
> -			"scsi_dma_map failed: request for %d bytes!\n",
> -			scsi_bufflen(scmd));
> +	if (sges_left < 0)
>  		return -ENOMEM;
> -	}
>  
>  	sg_local = &mpi_request->SGL;
>  	sges_in_segment = (ioc->request_sz -
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
