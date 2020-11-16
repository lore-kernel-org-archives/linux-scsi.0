Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A80C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A4862225E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgKPHoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:44:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:49972 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgKPHoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 02:44:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B355BAC54;
        Mon, 16 Nov 2020 07:44:07 +0000 (UTC)
Subject: Re: [PATCH v4 05/19] lpfc: vmid: API to check if VMID is enabled.
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-6-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <60c0e014-81b1-2679-4e68-6cefa0604628@suse.de>
Date:   Mon, 16 Nov 2020 08:44:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-6-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This API will determine if VMID is enabled by the user or not.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc.h | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 8f0062d2b891..a62e985aa180 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -1506,3 +1506,27 @@ static const char *routine(enum enum_name table_key)			\
>   	}								\
>   	return name;							\
>   }
> +
> +/**
> + * lpfc_is_vmid_enabled - returns if VMID is enabled for either switch types
> + * @phba: Pointer to HBA context object.
> + *
> + * Relationship between the enable, target support and if vmid tag is required
> + * for the particular combination
> + * ---------------------------------------------------
> + * Switch    Enable Flag  Target Support  VMID Needed
> + * ---------------------------------------------------
> + * App Id     0              NA              N
> + * App Id     1               0              N
> + * App Id     1               1              Y
> + * Pr Tag     0              NA              N
> + * Pr Tag     1               0              N
> + * Pr Tag     1               1              Y
> + * Pr Tag     2               *              Y
> + ---------------------------------------------------
> + *
> + **/
> +static inline int lpfc_is_vmid_enabled(struct lpfc_hba *phba)
> +{
> +	return phba->cfg_vmid_app_header || phba->cfg_vmid_priority_tagging;
> +}
> 
Feels a bit weird, having this patch on its own; maybe merge it with the 
next one?
But I'm not bothered either way.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
