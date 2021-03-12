Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D105EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 18:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A1064F71
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 18:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhCLSbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:31:17 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:33072 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbhCLSbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 13:31:04 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 9A67C2EA2D7;
        Fri, 12 Mar 2021 13:31:03 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id CCzaeaoKjE7n; Fri, 12 Mar 2021 13:13:57 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id DD21D2EA008;
        Fri, 12 Mar 2021 13:31:02 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: sg: Fix a warning message
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YEsbyEf3/+AunY34@mwanda>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <66202741-2f76-1c04-9554-413e5c2fb234@interlog.com>
Date:   Fri, 12 Mar 2021 13:31:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YEsbyEf3/+AunY34@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-12 2:44 a.m., Dan Carpenter wrote:
> The WARN_ONCE() macro takes a condition and a warning message as
> parameters.  This code accidentally left out the condition so it
> doesn't print a warning (just a stack trace).
> 
> Fixes: ddfb8cbdf699 ("scsi: sg: Rework scatter-gather handling")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

This one wasn't addressed yesterday, thanks.


> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 79f05afa4407..e261260c1b8b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2525,7 +2525,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
>   	struct sg_fd *sfp;
>   
>   	if (!srp) {
> -		WARN_ONCE("%s: srp unexpectedly NULL\n", __func__);
> +		WARN_ONCE(1, "%s: srp unexpectedly NULL\n", __func__);
>   		return;
>   	}
>   	sfp = srp->parentfp;
> 

