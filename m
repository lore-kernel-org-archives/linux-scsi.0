Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E64C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C21208C7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKPIWF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:22:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:49532 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgKPIWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:22:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1A202AFA8;
        Mon, 16 Nov 2020 08:22:04 +0000 (UTC)
Subject: Re: [PATCH v7 2/5] scsi: No retries on abort success
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d684a564-d814-bead-36a8-468119bc49be@suse.de>
Date:   Mon, 16 Nov 2020 09:22:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1605070685-20945-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 5:58 AM, Muneendra wrote:
> Added a new optional routine eh_should_retry_cmd
> in scsi_host_template that allows the transport to decide if a
> cmd is retryable.Return true if the transport is in a state the
> cmd should be retried on.
> 
> Added a new interface scsi_eh_should_retry_cmd which checks and
> calls the new routine eh_should_retry_cmd.
> 
> Made changes in scmd_eh_abort_handler and scsi_eh_flush_done_q which
> calls the scsi_eh_should_retry_cmd to check whether the
> command needs to be retried.
> 
> The above changes were done based on a patch by Mike Christie.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> Added New routine in scsi_host_template to decide if a cmd is
> retryable instead of checking the same using  SCMD_NORETRIES_ABORT
> bit as the cmd retry part can be checked by validating the port state.
> 
> Moved the DID_TRANSPORT_MARGINAL changes to previous patch
> for reordering
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
>   drivers/scsi/scsi_error.c | 17 +++++++++++++++--
>   include/scsi/scsi_host.h  |  6 ++++++
>   2 files changed, 21 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
