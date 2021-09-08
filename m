Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E92C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 17:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB166113C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 17:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349962AbhIHRW2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 13:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231723AbhIHRW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Sep 2021 13:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DBC261132;
        Wed,  8 Sep 2021 17:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631121680;
        bh=/jSPmGyGki1+7VGj7FKBhSU4ni/tuERU2UwD0jeLqZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qZiUDJCo2zEW+HEf1W86o32k4Qiv3mV7tjC3sAWuzu4cj/4ufEgPFDDErG7RQ5OP2
         NB96PgKWAfx+IgAdmEe1rnLcDjeAxmSA76SaYPybMMLQKVpbN2mgmQ/xQAljAueALp
         GUyNQMqo6FED6OC49XUTRLzn6L8eEQorsPNIihsljAmu5I4zbAuO4QbuISzVOm4Bee
         ni69L0VsFh13IRog9pNV/tMPIH52nSLBPBk80dUAAkNe64AEU2gxSgdSgGx7+9RmFq
         FBEqbAjsVKbgJfllhAjOPoiFTMg5EpkzWohKxrGUFtwRQZDNy17Bu5M79eUdO8gmtK
         FLBoXd6r0S8wA==
Date:   Wed, 8 Sep 2021 10:21:16 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH v2] lpfc: Fix compilation errors on kernels with no
 CONFIG_DEBUG_FS
Message-ID: <YTjxDPsaoeQydKkR@archlinux-ax161>
References: <20210908050927.37275-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908050927.37275-1-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 07, 2021 at 10:09:27PM -0700, James Smart wrote:
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

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Build-tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
> v2:
>  Address review comments:
>  ifdef order in lpfc_sli4_driver_resource_setup()
>  Initialization of 0L in lpfc_queuecommand()
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 4 ++--
>  drivers/scsi/lpfc/lpfc_nvme.c | 2 --
>  drivers/scsi/lpfc/lpfc_scsi.c | 6 +-----
>  3 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index d3f1fa38269f..d2c16e4410a9 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8277,11 +8277,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>  	return 0;
>  
>  out_free_hba_hdwq_info:
> -	free_percpu(phba->sli4_hba.c_stat);
>  #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
> +	free_percpu(phba->sli4_hba.c_stat);
>  out_free_hba_idle_stat:
> -	kfree(phba->sli4_hba.idle_stat);
>  #endif
> +	kfree(phba->sli4_hba.idle_stat);
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
> index 0fde1e874c7a..63d8ac9f68a7 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5578,12 +5578,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
>  	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
>  	int err, idx;
>  	u8 *uuid = NULL;
> -#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
> -	uint64_t start = 0L;
> +	uint64_t start;
>  
> -	if (phba->ktime_on)
> -		start = ktime_get_ns();
> -#endif
>  	start = ktime_get_ns();
>  	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
>  
> -- 
> 2.26.2
> 
> 
