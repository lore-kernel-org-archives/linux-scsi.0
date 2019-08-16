Return-Path: <SRS0=RKta=WM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35123C3A59C
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 16:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 120ED20665
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 16:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfHPQgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Aug 2019 12:36:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfHPQgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Aug 2019 12:36:44 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED7DD356C5;
        Fri, 16 Aug 2019 16:36:43 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80B8918863;
        Fri, 16 Aug 2019 16:36:43 +0000 (UTC)
Message-ID: <0f5f2d9bafb675208f9bbabc794a5ea1b62b8da7.camel@redhat.com>
Subject: Re: [PATCH v3] lpfc: Mitigate high memory pre-allocation by SCSI-MQ
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
Date:   Fri, 16 Aug 2019 12:36:42 -0400
In-Reply-To: <20190816023649.16682-1-jsmart2021@gmail.com>
References: <20190816023649.16682-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 16 Aug 2019 16:36:44 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-08-15 at 19:36 -0700, James Smart wrote:
> When SCSI-MQ is enabled, the SCSI-MQ layers will do pre-allocation of
> MQ resources based on shost values set by the driver. In newer cases
> of the driver, which attempts to set nr_hw_queues to the cpu count,
> the multipliers become excessive, with a single shost having SCSI-MQ
> pre-allocation reaching into the multiple GBytes range.  NPIV, which
> creates additional shosts, only multiply this overhead. On lower-memory
> systems, this can exhaust system memory very quickly, resulting in a
> system crash or failures in the driver or elsewhere due to low memory
> conditions.
> 
> After testing several scenarios, the situation can be mitigated by
> limiting the value set in shost->nr_hw_queues to 4. Although the shost
> values were changed, the driver still had per-cpu hardware queues of
> its own that allowed parallelization per-cpu.  Testing revealed that
> even with the smallish number for nr_hw_queues for SCSI-MQ, performance
> levels remained near maximum with the within-driver affiinitization.
> 
> A module parameter was created to allow the value set for the
> nr_hw_queues to be tunable.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> 
> ---
> v3: add Ming's reviewed-by tag
> ---
>  drivers/scsi/lpfc/lpfc.h      |  1 +
>  drivers/scsi/lpfc/lpfc_attr.c | 15 +++++++++++++++
>  drivers/scsi/lpfc/lpfc_init.c | 10 ++++++----
>  drivers/scsi/lpfc/lpfc_sli4.h |  5 +++++
>  4 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 2c3bb8a966e5..bade2e025ecf 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -824,6 +824,7 @@ struct lpfc_hba {
>  	uint32_t cfg_cq_poll_threshold;
>  	uint32_t cfg_cq_max_proc_limit;
>  	uint32_t cfg_fcp_cpu_map;
> +	uint32_t cfg_fcp_mq_threshold;
>  	uint32_t cfg_hdw_queue;
>  	uint32_t cfg_irq_chann;
>  	uint32_t cfg_suppress_rsp;
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index ea62322ffe2b..8d8c495b5b60 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -5709,6 +5709,19 @@ LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
>  	     "Embed NVME Command in WQE");
>  
>  /*
> + * lpfc_fcp_mq_threshold: Set the maximum number of Hardware Queues
> + * the driver will advertise it supports to the SCSI layer.
> + *
> + *      0    = Set nr_hw_queues by the number of CPUs or HW queues.
> + *      1,128 = Manually specify the maximum nr_hw_queue value to be set,
> + *
> + * Value range is [0,128]. Default value is 8.
> + */
> +LPFC_ATTR_R(fcp_mq_threshold, LPFC_FCP_MQ_THRESHOLD_DEF,
> +	    LPFC_FCP_MQ_THRESHOLD_MIN, LPFC_FCP_MQ_THRESHOLD_MAX,
> +	    "Set the number of SCSI Queues advertised");
> +
> +/*
>   * lpfc_hdw_queue: Set the number of Hardware Queues the driver
>   * will advertise it supports to the NVME and  SCSI layers. This also
>   * will map to the number of CQ/WQ pairs the driver will create.
> @@ -6030,6 +6043,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
>  	&dev_attr_lpfc_cq_poll_threshold,
>  	&dev_attr_lpfc_cq_max_proc_limit,
>  	&dev_attr_lpfc_fcp_cpu_map,
> +	&dev_attr_lpfc_fcp_mq_threshold,
>  	&dev_attr_lpfc_hdw_queue,
>  	&dev_attr_lpfc_irq_chann,
>  	&dev_attr_lpfc_suppress_rsp,
> @@ -7112,6 +7126,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
>  	/* Initialize first burst. Target vs Initiator are different. */
>  	lpfc_nvme_enable_fb_init(phba, lpfc_nvme_enable_fb);
>  	lpfc_nvmet_fb_size_init(phba, lpfc_nvmet_fb_size);
> +	lpfc_fcp_mq_threshold_init(phba, lpfc_fcp_mq_threshold);
>  	lpfc_hdw_queue_init(phba, lpfc_hdw_queue);
>  	lpfc_irq_chann_init(phba, lpfc_irq_chann);
>  	lpfc_enable_bbcr_init(phba, lpfc_enable_bbcr);
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index faf43b1d3dbe..03998579d6ee 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4309,10 +4309,12 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>  	shost->max_cmd_len = 16;
>  
>  	if (phba->sli_rev == LPFC_SLI_REV4) {
> -		if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ)
> -			shost->nr_hw_queues = phba->cfg_hdw_queue;
> -		else
> -			shost->nr_hw_queues = phba->sli4_hba.num_present_cpu;
> +		if (!phba->cfg_fcp_mq_threshold ||
> +		    phba->cfg_fcp_mq_threshold > phba->cfg_hdw_queue)
> +			phba->cfg_fcp_mq_threshold = phba->cfg_hdw_queue;
> +
> +		shost->nr_hw_queues = min_t(int, 2 * num_possible_nodes(),
> +					    phba->cfg_fcp_mq_threshold);
>  
>  		shost->dma_boundary =
>  			phba->sli4_hba.pc_sli4_params.sge_supp_len-1;
> diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
> index 3aeca387b22a..329f7aa7e169 100644
> --- a/drivers/scsi/lpfc/lpfc_sli4.h
> +++ b/drivers/scsi/lpfc/lpfc_sli4.h
> @@ -44,6 +44,11 @@
>  #define LPFC_HBA_HDWQ_MAX	128
>  #define LPFC_HBA_HDWQ_DEF	0
>  
> +/* FCP MQ queue count limiting */
> +#define LPFC_FCP_MQ_THRESHOLD_MIN	0
> +#define LPFC_FCP_MQ_THRESHOLD_MAX	128
> +#define LPFC_FCP_MQ_THRESHOLD_DEF	8
> +
>  /* Common buffer size to accomidate SCSI and NVME IO buffers */
>  #define LPFC_COMMON_IO_BUF_SZ	768
>  

Looks good.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
