Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2509C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 02:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B9F264E0F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 02:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhCLCdF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 21:33:05 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:50883 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhCLCcp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 21:32:45 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id B3B052EA45F;
        Thu, 11 Mar 2021 21:32:44 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id BfnoFxK84qvP; Thu, 11 Mar 2021 21:15:41 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id E79F12EA3A7;
        Thu, 11 Mar 2021 21:32:43 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH][next] scsi: sg: return -ENOMEM on out of memory error
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210311233359.81305-1-colin.king@canonical.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <90e260c2-34f7-e156-0c36-6ff00c91311b@interlog.com>
Date:   Thu, 11 Mar 2021 21:32:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210311233359.81305-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-11 6:33 p.m., Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The sg_proc_seq_show_debug should return -ENOMEM on an
> out of memory error rather than -1. Fix this.
> 
> Fixes: 94cda6cf2e44 ("scsi: sg: Rework debug info")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 79f05afa4407..85e86cbc6891 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -4353,7 +4353,7 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
>   	if (!bp) {
>   		seq_printf(s, "%s: Unable to allocate %d on heap, finish\n",
>   			   __func__, bp_len);
> -		return -1;
> +		return -ENOMEM;
>   	}
>   	read_lock_irqsave(&sg_index_lock, iflags);
>   	sdp = it ? sg_lookup_dev(it->index) : NULL;
> 

