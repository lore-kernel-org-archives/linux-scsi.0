Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D612DC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD28613D7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbhDUVMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:12:33 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:44614 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbhDUVMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:12:33 -0400
Received: by mail-pl1-f179.google.com with SMTP id y1so6724851plg.11
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 14:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jWMJFs1jhdUh/9XtrdFu81P43/H81S8chNItA/AzTjs=;
        b=NvHn9WbZaeo/rgU3gULODfyGkjdoZiny3vj0DzJvogQy1N6GlA0NnH5rD+GCeAUWg6
         ybFwgwpjY71O/FmiHzS5+rmzCtYErZnnorjtFWZr5tUP22jveipKHitFHXEVVsgHOxo0
         FYBd640zO/kF4hoHeudCEa/UAnZ6VkL3IH5VVzICIhkgxzsi+bqVTYrpBAAyJeL0XN1H
         vgj9SslDBGTnlSyKBS/YN6mShpOdWCtBugfFqbusKJdI/rPFlG08ls8mRiwdnjVTxACB
         Spqrpguk99v43HugDWi2hB7/Gm8lTAzvlu9za1oJl6fWT9dHAPFhAgFKTjlXDJV/p7dn
         ntIA==
X-Gm-Message-State: AOAM532MsG+rdwimOM8m63m1P4vcHbzcPo6KnwxWsSG8q4wNqgdejuYB
        7cJs5bQZhz8/NbPOET9O949RYIXuc1xzeg==
X-Google-Smtp-Source: ABdhPJymrHs4QyTufXIiqFLaxCS82yyLhjAA4U1mCsg40Hj3qLpgixdIz1CDjp09pWht9KZjHAg8qg==
X-Received: by 2002:a17:903:2285:b029:eb:d7b:7687 with SMTP id b5-20020a1709032285b02900eb0d7b7687mr35057366plh.82.1619039519199;
        Wed, 21 Apr 2021 14:11:59 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b3sm2814960pjo.37.2021.04.21.14.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 14:11:58 -0700 (PDT)
Subject: Re: [PATCH 15/42] NCR5380: use SCSI result accessors
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-16-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <75df2cf5-ea29-ea54-f8d3-0f44a845409f@acm.org>
Date:   Wed, 21 Apr 2021 14:11:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-16-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> Use accessors to set the SCSI result.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/NCR5380.c | 28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index d7594b794d3c..855edda9db41 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -538,7 +538,7 @@ static void complete_cmd(struct Scsi_Host *instance,
>   
>   	if (hostdata->sensing == cmd) {
>   		/* Autosense processing ends here */
> -		if (status_byte(cmd->result) != GOOD) {
> +		if (get_status_byte(cmd) != SAM_STAT_GOOD) {
>   			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
>   		} else {
>   			scsi_eh_restore_cmnd(cmd, &hostdata->ses);

Do all SCSI devices from the nineties report SCSI status values with the 
lower bit set to 0? If so, can the status_byte() macro be removed entirely?

Thanks,

Bart.
