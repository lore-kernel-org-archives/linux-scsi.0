Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CE7C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 15:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9551561041
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 15:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbhDKP7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 11:59:12 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:43778 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbhDKP7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 11:59:11 -0400
Received: by mail-pj1-f52.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso5660664pjh.2;
        Sun, 11 Apr 2021 08:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v5B/SxQlFrHLo+Ii4FhwOsO2iGqGZQI3Qni9NgWHOwA=;
        b=s+X8kFgFjEUe3xgZZS7i6Fe+zjv9WWh4fPN6iv/vS/y9AvH2WaPBUiCVEefxfZgLX3
         OySx7bRU/W160yFEZidVHVRfqBumCOzgd36JNyN6PoKrsys5B5jv49S4XFzM4kHVA2C/
         jsVKjBMMiLuqig9dmvEST9jEIiYQVnsLsWU8GDo5OQrnhrt3YDpG4UAd//wO2+yrfNAW
         OgY4Y5beMh7HO6k7ReCjYnFuSuLEZJrxXDijI0b5WeBI36tJO0oFsDlN+srUenw7BprH
         tS9vQyGTWGe8vAFV4UWO26QgfdrEWucnJCpDc0nEwzZq5UvXsezlVFcyFRhx65X9qzaB
         n99w==
X-Gm-Message-State: AOAM532pGcCARdeLL1wE5PNYMnlZrtKd/D0Xp1a2r/PW4D00lU4N70m6
        Aj70r52KEAfX0gI7g6tLsXuqfMIMhuo=
X-Google-Smtp-Source: ABdhPJyK2adZtQk/OjYeR4ypZP0ipNQSXpvgS28NGUzoqoncHcOmb7mHAUFjXjUg9wBfeqt2vA6IpA==
X-Received: by 2002:a17:90a:55ca:: with SMTP id o10mr23382029pjm.173.1618156734486;
        Sun, 11 Apr 2021 08:58:54 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:7c41:980e:bfa1:bbb4? ([2601:647:4000:d7:7c41:980e:bfa1:bbb4])
        by smtp.gmail.com with ESMTPSA id j3sm7224630pfc.49.2021.04.11.08.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 08:58:53 -0700 (PDT)
Subject: Re: [PATCH] scsi: qla2xxx: Re-use existing error handling path
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <6973844a1532ec2dc8e86f3533362e79d78ed774.1618132821.git.christophe.jaillet@wanadoo.fr>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f237fbd4-2ebf-0105-2a1a-93672cd446cb@acm.org>
Date:   Sun, 11 Apr 2021 08:58:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6973844a1532ec2dc8e86f3533362e79d78ed774.1618132821.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/21 2:21 AM, Christophe JAILLET wrote:
> The code above this hunk looks spurious to me.
> 
> It looks like an error handling path (i.e.
> "if (response_len > bsg_job->reply_payload.payload_len)")
> but returns 0, which is the initial value of 'ret'.
> 
> Shouldn't we have ret = -<something> here?

Hmm ... if I read that code path correctly it is on purpose that that
code path returns 0 and error reporting happens by reporting the
EXT_STATUS_BUFFER_TOO_SMALL error code to user space.

> ---
>  drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index aef2f7cc89d3..d42b2ad84049 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2585,8 +2585,8 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
>  
>  	data = kzalloc(response_len, GFP_KERNEL);
>  	if (!data) {
> -		kfree(req_data);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto host_stat_out;
>  	}
>  
>  	ret = qla2xxx_get_ini_stats(fc_bsg_to_shost(bsg_job), req_data->stat_type,

Since the above looks good to me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
