Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE939C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D37206B5
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgHJGTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:19:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:38472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgHJGTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 02:19:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 23716B1B1;
        Mon, 10 Aug 2020 06:19:57 +0000 (UTC)
Subject: Re: [PATCH 3/5] scsi: No retries on abort success
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-4-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b034215e-c106-9e96-9d6b-71e6707f921c@suse.de>
Date:   Mon, 10 Aug 2020 08:19:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596595862-11075-4-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/20 4:51 AM, Muneendra wrote:
> Made an additional check in scsi_noretry_cmd to verify whether user has
> decided not to do retries on abort(issued on scsi timeouts) success  by
> checking the SCMD_NORETRIES_ABORT bit
> 
> If SCMD_NORETRIES_ABORT bit is set we are making sure there won't be any
> retries done on the same path and also setting the host byte as
> DID_TRANSPORT_FAILFAST so that the error can be propogated as recoverable
> transport error to the blk layers.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>   drivers/scsi/scsi_error.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 927b1e6..3222496 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1749,6 +1749,16 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   
>   check_type:
>   	/*
> +	 * Check whether caller has decided not to do retries on
> +	 * abort success by setting the SCMD_NORETRIES_ABORT bit
> +	 */
> +	if ((test_bit(SCMD_NORETRIES_ABORT, &scmd->state)) &&
> +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
> +		set_host_byte(scmd, DID_TRANSPORT_FAILFAST);
> +		return 1;
> +	}
> +
> +	/*
>   	 * assume caller has checked sense and determined
>   	 * the check condition was retryable.
>   	 */
> 
_Actually_ DID_TRANSPORT_FAILFAST is just for transport aborted 
commands, so maybe we should use a different error code (or add a new one).
But other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
