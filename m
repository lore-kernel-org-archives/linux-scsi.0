Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1EDC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B6D2073E
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgHJGKx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:10:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:35862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgHJGKx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 02:10:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0361EB1B1;
        Mon, 10 Aug 2020 06:11:12 +0000 (UTC)
Subject: Re: [PATCH 1/5] scsi: Added a new macro in scsi_cmnd.h
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-2-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <24e0d0d5-112c-c526-0843-c4526c0c0aaf@suse.de>
Date:   Mon, 10 Aug 2020 08:10:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596595862-11075-2-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/20 4:50 AM, Muneendra wrote:
> Added a new macro SCMD_NORETRIES_ABORT in scsi_cmnd.h
> 
It's not a macro, it's a definition.

> The SCMD_NORETRIES_ABORT macro  defines the third bit postion
> in scmd->state
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>   include/scsi/scsi_cmnd.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index e76bac4..e1883fe 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -64,6 +64,9 @@ struct scsi_pointer {
>   /* for scmd->state */
>   #define SCMD_STATE_COMPLETE	0
>   #define SCMD_STATE_INFLIGHT	1
> +#define SCMD_NORETRIES_ABORT	2 /* If this bit is set then there won't be any
> +				   * retries of scmd on abort success
> +				   */
>   
>   struct scsi_cmnd {
>   	struct scsi_request req;
> 
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
