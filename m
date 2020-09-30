Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3220BC47420
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63F820754
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgI3J1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:27:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:58290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgI3J1T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 05:27:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E74B0ACDF;
        Wed, 30 Sep 2020 09:27:17 +0000 (UTC)
Subject: Re: [PATCH v2 4/8] scsi: No retries on abort success
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-5-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7921db51-9d58-492d-e45e-503e7aef64f0@suse.de>
Date:   Wed, 30 Sep 2020 11:27:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601268657-940-5-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 6:50 AM, Muneendra wrote:
> Made an additional check in scsi_noretry_cmd to verify whether user has
> decided not to do retries on abort success by setting the
> SCMD_NORETRIES_ABORT bit
> 
> If SCMD_NORETRIES_ABORT bit is set we are making sure there won't be any
> retries done on the same path and also setting the host byte as
> DID_TRANSPORT_MARGINAL so that the error can be propogated as recoverable
> transport error to the blk layers.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> set the hostbyte as DID_TRANSPORT_MARGINAL instead of
> DID_TRANSPORT_FAILFAST.
> ---
>   drivers/scsi/scsi_error.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 5f3726abed78..3f14ea10d5da 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1748,6 +1748,16 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   		return 0;
>   
>   check_type:
> +	/*
> +	 * Check whether caller has decided not to do retries on
> +	 * abort success by setting the SCMD_NORETRIES_ABORT bit
> +	 */
> +	if ((test_bit(SCMD_NORETRIES_ABORT, &scmd->state)) &&
> +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
> +		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
> +		return 1;
> +	}
> +
>   	/*
>   	 * assume caller has checked sense and determined
>   	 * the check condition was retryable.
> 
As indicated, the first part of the previous patch should be merged with 
this patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
