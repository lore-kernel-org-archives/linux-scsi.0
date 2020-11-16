Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE55DC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 747522071E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgKPIQK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:16:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:37348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKPIQK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:16:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4E5B8AC2E;
        Mon, 16 Nov 2020 08:16:08 +0000 (UTC)
Subject: Re: [PATCH v7 1/5] scsi: Added a new error code
 DID_TRANSPORT_MARGINAL in scsi.h
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-2-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <318aefc9-2545-c881-95a7-d28efc7a20ec@suse.de>
Date:   Mon, 16 Nov 2020 09:16:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1605070685-20945-2-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 5:58 AM, Muneendra wrote:
> Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
> errors in scsi.h
> 
> Added a code in scsi_result_to_blk_status to translate
> a new error DID_TRANSPORT_MARGINAL to the corresponding blk_status_t
> i.e BLK_STS_TRANSPORT
> 
> Added DID_TRANSPORT_MARGINAL case to scsi_decide_disposition
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> Rearranged the patch by moving the DID_TRANSPORT_MARGINAL
> and the changes with respect to the same to this patch
> from the previous patch2 in v6
> 
> Removed the previuos patch patch1 in v6 as in the
> current approach there is no need of this bit SCMD_NORETRIES_ABORT
> 
> v6:
> Rearranged the patch by merging second hunk of the patch2 in v5
> to this patch
> 
> v5:
> added the DID_TRANSPORT_MARGINAL case to
> scsi_decide_disposition
> v4:
> Modified the comments in the code appropriately
> 
> v3:
> Merged  first part of the previous patch(v2 patch3) with
> this patch.
> 
> v2:
> set the hostbyte as DID_TRANSPORT_MARGINAL instead of
> DID_TRANSPORT_FAILFAST.
> ---
>   drivers/scsi/scsi_error.c | 6 ++++++
>   drivers/scsi/scsi_lib.c   | 1 +
>   include/scsi/scsi.h       | 1 +
>   3 files changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f11f51e2465f..28056ee498b3 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1861,6 +1861,12 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>   		 * the fast io fail tmo fired), so send IO directly upwards.
>   		 */
>   		return SUCCESS;
> +	case DID_TRANSPORT_MARGINAL:
> +		/*
> +		 * caller has decided not to do retries on
> +		 * abort success, so send IO directly upwards
> +		 */
> +		return SUCCESS;
>   	case DID_ERROR:
>   		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
>   		    status_byte(scmd->result) == RESERVATION_CONFLICT)
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 20a357563d3d..ce1e2adaca36 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -629,6 +629,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
>   			return BLK_STS_OK;
>   		return BLK_STS_IOERR;
>   	case DID_TRANSPORT_FAILFAST:
> +	case DID_TRANSPORT_MARGINAL:
>   		return BLK_STS_TRANSPORT;
>   	case DID_TARGET_FAILURE:
>   		set_host_byte(cmd, DID_OK);
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5339baadc082..5b287ad8b727 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -159,6 +159,7 @@ static inline int scsi_is_wlun(u64 lun)
>   				 * paths might yield different results */
>   #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
>   #define DID_MEDIUM_ERROR  0x13  /* Medium error */
> +#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
>   #define DRIVER_OK       0x00	/* Driver status                           */
>   
>   /*
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
