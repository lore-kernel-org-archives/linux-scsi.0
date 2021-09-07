Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234BEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 23:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F37D861102
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 23:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbhIGXIE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 19:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240690AbhIGXID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Sep 2021 19:08:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4D5B600CC;
        Tue,  7 Sep 2021 23:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631056016;
        bh=uvOEYG7Cxdn5PBm8989tVCmAZebPsV0/5lTj1WjFrQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LgsioUshjBXReK+5nU3T0YC+efeTTL38q/XV4KVbXW30/wh7MbKwGW8emeVLulKo+
         4FTjK6vnNK0qRuH3RSqeJXQz4sH0hqi08JOFCrrJEMbWG+bcXZI2OkOPbhsd3y4iwE
         x4MX/YruAznpvNQ4Ssh0pRSPJTifV3u0XRR0WX99TseK0jy6920qgPMp52LBvpiUL8
         /9WC6ALRyPXbJ35/GXCPz9l6bvMidTaYn78opxgPjT/Uj9gm7Oz/c3fYyOToFtS7EM
         mdC/zCgI4ic16ZFx+BCNfpuHAXaO4vuP6Bv7FURPA7yHzq0yybzqoBKLZscLjw1oIV
         vLEv4VHnaJCnA==
Date:   Tue, 7 Sep 2021 16:06:52 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix compilation errors on kernels with no
 CONFIG_DEBUG_FS
Message-ID: <YTfwjGOHqKY55cwQ@MSI.localdomain>
References: <20210830231305.6334-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830231305.6334-1-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 30, 2021 at 04:13:05PM -0700, James Smart wrote:
> The Kernel test robot flagged the following warning:
> ".../lpfc_init.c:7788:35: error: 'struct lpfc_sli4_hba' has no member
> named 'c_stat'"
> 
> Reviewing this issue highlighted that one of the recent patches caused
> the driver to no longer compile cleanly if CONFIG_DEBUG_FS is not set.
> 
> Correct the different areas that are failing to compile.
> 
> Fixes: 02243836ad6f ("scsi: lpfc: Add support for the CM framework")
> Co-developed-by: Justin Tee <justin.tee@broadcom.com>
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

I got bit by this in certain configurations, it would be helpful to get
this into mainline sooner rather than later.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Couple of comments below.

> ---
>  drivers/scsi/lpfc/lpfc_init.c | 12 ++++++++----
>  drivers/scsi/lpfc/lpfc_nvme.c |  2 --
>  drivers/scsi/lpfc/lpfc_scsi.c |  4 ----
>  3 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index d3f1fa38269f..a6127a51b4fe 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8254,7 +8254,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>  		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
>  				"3331 Failed allocating per cpu cgn stats\n");
>  		rc = -ENOMEM;
> -		goto out_free_hba_hdwq_info;
> +#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
> +		goto out_free_hba_hdwq_stat;
> +#else
> +		goto out_free_hba_idle_stat;
> +#endif
>  	}
>  
>  	/*
> @@ -8276,12 +8280,12 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>  
>  	return 0;
>  
> -out_free_hba_hdwq_info:

Wouldn't it be simpler to just move the ifdef up one line and the endif
down one line to avoid the ifdef in the first hunk?

> -	free_percpu(phba->sli4_hba.c_stat);
>  #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
> +out_free_hba_hdwq_stat:
> +	free_percpu(phba->sli4_hba.c_stat);
> +#endif
>  out_free_hba_idle_stat:
>  	kfree(phba->sli4_hba.idle_stat);
> -#endif
>  out_free_hba_eq_info:
>  	free_percpu(phba->sli4_hba.eq_info);
>  out_free_hba_cpu_map:
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 73a3568ff17e..479b3eed6208 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -1489,9 +1489,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
>  	struct lpfc_nvme_qhandle *lpfc_queue_info;
>  	struct lpfc_nvme_fcpreq_priv *freqpriv;
>  	struct nvme_common_command *sqe;
> -#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>  	uint64_t start = 0;
> -#endif
>  
>  	/* Validate pointers. LLDD fault handling with transport does
>  	 * have timing races.
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 0fde1e874c7a..dae5cc03e8c2 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5578,12 +5578,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
>  	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
>  	int err, idx;
>  	u8 *uuid = NULL;
> -#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>  	uint64_t start = 0L;
>  
> -	if (phba->ktime_on)
> -		start = ktime_get_ns();
> -#endif
>  	start = ktime_get_ns();

Someone is probably going to come along and complain that the 0L is a
dead store. I would remove the assignment at the least but it might be
worth combining the two lines.

>  	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
>  
> -- 
> 2.26.2
