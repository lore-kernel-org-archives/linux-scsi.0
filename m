Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3017DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D31460F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbhHQDOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:14:45 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:44829 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhHQDOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 23:14:44 -0400
Received: by mail-pj1-f51.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so3852637pjb.3;
        Mon, 16 Aug 2021 20:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JoQLvjsYItLOiE1HWjDofqYeImyE73Bei9ARdw5/4dI=;
        b=Wh8bycid4ZzYIK9WSG45WkviD/iEEiFG53Z/dUaXdT5yHU5Jt69vzI7HcwkBiKiBV3
         6UVXgmkp6Fzefmn4SKKQLJxdMkrdqjYKigoAaV4Z0HTDHP3Yal0qklFFmiNOt9aXRqRp
         QOl7R6D+4zcqgKjDW7Fc34RCPe2sQ6WsT96BD8oMIDjAHYOZs4yo6uGk0HKvG99sAlVt
         nE8T9IwN99IRNFi2XiiRmMw5S4AdxX5vKtm3H+UKv/ymludVlCO7LVckngqdomw9JreF
         uWSRVahQVaJHOU8S0lKXwDvOOZLeEfnp6n7AXtuInBqU4SsBnuWqYQn+ox7rl77mHseh
         1QcQ==
X-Gm-Message-State: AOAM530laFmJS3ObuGYXtte956zJBYhHcpmbBK3aqQ0dH0sWnG+VKFNY
        JQO/TWXJHF7Jc9kJpC7xLno=
X-Google-Smtp-Source: ABdhPJxusKSe/9yzlsxL4qUpDUUYqPQ/A46IO5YlZs/+Txl64i+KbLJCPNpv2tTcgPUPxsYZw/wqDA==
X-Received: by 2002:a17:90b:f8d:: with SMTP id ft13mr1266374pjb.228.1629170052197;
        Mon, 16 Aug 2021 20:14:12 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:11e7:e120:dc0c:66b5? ([2601:647:4000:d7:11e7:e120:dc0c:66b5])
        by smtp.gmail.com with ESMTPSA id ob6sm441515pjb.4.2021.08.16.20.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 20:14:11 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: Do not exit sd_spinup_disk quietly
To:     =?UTF-8?Q?Christian_L=c3=b6hle?= <CLoehle@hyperstone.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <CWXP265MB26803209FD08A64222EEEA02C4FD9@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <dc8e51c6-6859-df73-feb1-98d38a4dfc67@acm.org>
Date:   Mon, 16 Aug 2021 20:14:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CWXP265MB26803209FD08A64222EEEA02C4FD9@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/21 2:37 AM, Christian Löhle wrote:
> The sd_spinup_disk function logs what is happening nicely.
> Unfortunately this output stops if the media was marked removed
> in the meantime. To prevent a puzzling output, add a print
> for this case, too.
> 
> Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
> ---
>  drivers/scsi/sd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b8d55af763f9..7e556f5b57e0 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2180,8 +2180,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>  			 * doesn't have any media in it, don't bother
>  			 * with any more polling.
>  			 */
> -			if (media_not_present(sdkp, &sshdr))
> +			if (media_not_present(sdkp, &sshdr)) {
> +				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
>  				return;
> +			}
>  
>  			if (the_result)
>  				sense_valid = scsi_sense_valid(&sshdr);
> 

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
