Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44314C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 164E664F1E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240962AbhCDMe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:34:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:54696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240890AbhCDMed (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 07:34:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4FD1AAE42;
        Thu,  4 Mar 2021 12:33:51 +0000 (UTC)
Subject: Re: [PATCH v8 07/16] lpfc: vmid: VMID params initialization
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
 <1614835646-16217-8-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <52e5c05c-37ad-3424-50ea-246b53c33d9b@suse.de>
Date:   Thu, 4 Mar 2021 13:33:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614835646-16217-8-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 6:27 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch initializes the VMID parameters like the type of vmid, max
> number of vmids supported and timeout value for the vmid registration
> based on the user input.
> 
> Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v8:
> No change
> 
> v7:
> No change
> 
> v6:
> No change
> 
> v5:
> No change
> 
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc_attr.c | 47 +++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index bdd9a29f4201..005099f2f58b 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -6150,6 +6150,44 @@ LPFC_ATTR_RW(enable_dpp, 1, 0, 1, "Enable Direct Packet Push");
>    */
>   LPFC_ATTR_R(enable_mi, 1, 0, 1, "Enable MI");
>   
> +/*
> + * lpfc_max_vmid: Maximum number of VMs to be tagged. This is valid only if
> + * either vmid_app_header or vmid_priority_tagging is enabled.
> + *       4 - 255  = vmid support enabled for 4-255 VMs
> + *       Value range is [4,255].
> + */
> +LPFC_ATTR_RW(max_vmid, LPFC_MIN_VMID, LPFC_MIN_VMID, LPFC_MAX_VMID,
> +	     "Maximum number of VMs supported");
> +
> +/*
> + * lpfc_vmid_inactivity_timeout: Inactivity timeout duration in hours
> + *       0  = Timeout is disabled
> + * Value range is [0,24].
> + */
> +LPFC_ATTR_RW(vmid_inactivity_timeout, 4, 0, 24,
> +	     "Inactivity timeout in hours");
> +
> +/*
> + * lpfc_vmid_app_header: Enable App Header VMID support
> + *       0  = Support is disabled (default)
> + *       1  = Support is enabled
> + * Value range is [0,1].
> + */
> +LPFC_ATTR_RW(vmid_app_header, LPFC_VMID_APP_HEADER_DISABLE,
> +	     LPFC_VMID_APP_HEADER_DISABLE, LPFC_VMID_APP_HEADER_ENABLE,
> +	     "Enable App Header VMID support");
> +
> +/*
> + * lpfc_vmid_priority_tagging: Enable Priority Tagging VMID support
> + *       0  = Support is disabled (default)
> + *       1  = Support is enabled
> + * Value range is [0,1]..
> + */
> +LPFC_ATTR_RW(vmid_priority_tagging, LPFC_VMID_PRIO_TAG_DISABLE,
> +	     LPFC_VMID_PRIO_TAG_DISABLE,
> +	     LPFC_VMID_PRIO_TAG_ALL_TARGETS,
> +	     "Enable Priority Tagging VMID support");
> +
>   struct device_attribute *lpfc_hba_attrs[] = {
>   	&dev_attr_nvme_info,
>   	&dev_attr_scsi_stat,
> @@ -6268,6 +6306,10 @@ struct device_attribute *lpfc_hba_attrs[] = {
>   	&dev_attr_lpfc_enable_bbcr,
>   	&dev_attr_lpfc_enable_dpp,
>   	&dev_attr_lpfc_enable_mi,
> +	&dev_attr_lpfc_max_vmid,
> +	&dev_attr_lpfc_vmid_inactivity_timeout,
> +	&dev_attr_lpfc_vmid_app_header,
> +	&dev_attr_lpfc_vmid_priority_tagging,
>   	NULL,
>   };
>   
> @@ -7327,6 +7369,11 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
>   	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
>   
>   	lpfc_EnableXLane_init(phba, lpfc_EnableXLane);
> +	/* VMID Inits */
> +	lpfc_max_vmid_init(phba, lpfc_max_vmid);
> +	lpfc_vmid_inactivity_timeout_init(phba, lpfc_vmid_inactivity_timeout);
> +	lpfc_vmid_app_header_init(phba, lpfc_vmid_app_header);
> +	lpfc_vmid_priority_tagging_init(phba, lpfc_vmid_priority_tagging);
>   	if (phba->sli_rev != LPFC_SLI_REV4)
>   		phba->cfg_EnableXLane = 0;
>   	lpfc_XLanePriority_init(phba, lpfc_XLanePriority);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
