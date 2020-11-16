Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14701C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8222208C7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgKPIXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:23:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:50176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgKPIXs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:23:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 25533AC2E;
        Mon, 16 Nov 2020 08:23:47 +0000 (UTC)
Subject: Re: [PATCH v7 5/5] scsi:lpfc: Added support for eh_should_retry_cmd
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-6-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d1c194a9-1b5c-c86c-e1f0-b3ced680f569@suse.de>
Date:   Mon, 16 Nov 2020 09:23:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1605070685-20945-6-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 5:58 AM, Muneendra wrote:
> Added support to handle eh_should_retry_cmd in lpfc_template.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> New patch
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 4ffdfd2c8604..dbc80e6423ea 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -6040,6 +6040,7 @@ struct scsi_host_template lpfc_template = {
>   	.info			= lpfc_info,
>   	.queuecommand		= lpfc_queuecommand,
>   	.eh_timed_out		= fc_eh_timed_out,
> +	.eh_should_retry_cmd    = fc_eh_should_retry_cmd,
>   	.eh_abort_handler	= lpfc_abort_handler,
>   	.eh_device_reset_handler = lpfc_device_reset_handler,
>   	.eh_target_reset_handler = lpfc_target_reset_handler,
> 
I guess this change is pretty generic, and should be made to every FC 
HBA driver. But probably not your immediate scope, I do agree :-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
