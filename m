Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49492C47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2794A613C3
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbhE0Qox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 12:44:53 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:36409 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbhE0Qou (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 12:44:50 -0400
Received: by mail-pj1-f54.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so2731085pjt.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 09:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4DvwvX60dpeOF/3iz4ZO+bnuVIF49RXsA4bQi+Aj8X8=;
        b=IlaqW2Vsyi283Grv+eaei3E4pu4xH8pGsKvaZJFHTu2PlCq0upq1dZfYwD3sIkKqLj
         ABSznOyGgGb7GJEVAba4cN3gMvWXqLhI9FRySMU/9JiWJH8Fi7qCH5/k2UzcXBMvjms8
         E5kJVtwZIXBwSsrQKL350MPxUEcuLFS9RraNnW5co0VChaycNCocSGLjB9BB3rV3QI82
         dsL8sj+iJyar+j8wWDcpswhA8f7VbBRWPDZzhyWnKJ4I859+9AYEP9lbG6FO1Tw8Ll1i
         dgHb5L0iMQFjKOPnNE6Y5w8w4z/Bb2jIuK2UEOTOdThAfHalFBnCkzJDA3wwR/momBna
         XX7Q==
X-Gm-Message-State: AOAM532RBAzWEzHta9k6aKTTeebAD0H9XorNYYW+OZYWaWGapLDyZ8cZ
        oHcW3CUcrDj38C6h54zA9Hw=
X-Google-Smtp-Source: ABdhPJwbzyFByw+K5pqIIstu4gHK0y5nL42j6t6VO3X+E9W7aNJ4YD7coVyl6HM+OGnwM4UBogUr4Q==
X-Received: by 2002:a17:90a:de12:: with SMTP id m18mr1552539pjv.86.1622133796681;
        Thu, 27 May 2021 09:43:16 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k38sm2260243pgi.73.2021.05.27.09.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 09:43:16 -0700 (PDT)
Subject: Re: [PATCH] pcmcia/nsp_cs: Use SAM_STAT_CHECK_CONDITION
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20210527072217.117126-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <80a68701-2fe4-e2ae-8d9f-98b0e865c670@acm.org>
Date:   Thu, 27 May 2021 09:43:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527072217.117126-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/27/21 12:22 AM, Hannes Reinecke wrote:
> The nsp_cs driver stores the SAM status values in SCp.Status, so
> we need to use the non-shifted version SAM_STAT_CHECK_CONDITION.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/pcmcia/nsp_cs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index ac89002646a3..7c0f931e55e8 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -221,7 +221,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
>  
>  	data->CurrentSC		= SCpnt;
>  
> -	SCpnt->SCp.Status	= CHECK_CONDITION;
> +	SCpnt->SCp.Status	= SAM_STAT_CHECK_CONDITION;
>  	SCpnt->SCp.Message	= 0;
>  	SCpnt->SCp.have_data_in = IO_UNKNOWN;
>  	SCpnt->SCp.sent_command = 0;

Since this patch is a bug fix, does this patch need a Cc: stable tag?
I'm not sure how to add a Fixes: tag since this bug predates Linux
kernel v2.6.12.

Thanks,

Bart.


