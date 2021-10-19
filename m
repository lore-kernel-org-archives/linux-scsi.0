Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEC3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 16:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108E96103B
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 16:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhJSQjK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 12:39:10 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:46023 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbhJSQjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2021 12:39:09 -0400
Received: by mail-pl1-f169.google.com with SMTP id s1so12242284plg.12;
        Tue, 19 Oct 2021 09:36:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kLdN4liOKdc+fP0eP65RqqF4TfZVXdiQZ9p/Tw3qQU8=;
        b=HarQYOj26/zHVwCu3eisFNJvjup1KNFR5m7TIe5DpFK74770Q8wmW45mtSrAyAFY91
         i7ivMaducnXirbiacEqqNZOAur+Ze/vb9cYH+fTiszlEyjqXY53SFxlcvKw1fabXGeH0
         7/Sgd+15vsFuSTRg6FHOzGv2Wa26JiNnh4cYoZ+9nxJ2E/I0etWOPC82i5V9tP9NJsb6
         nDLnb5h0RoTd6zjZs5wTF3c+MB2kujtsolO2F/ZlUUs+HKTvAd/sQRCXq5hD0YlicMkV
         JrAvXUej0sASdx3Mc0wVbRDpa6L51m7hOI01PPrg0GYThpXI+hFM1NNeoDfcUh3W0stn
         7qhw==
X-Gm-Message-State: AOAM530FLh4U2CrBSIXQPcXLgG3ZMu9GEEmxjoFd4IFwO+PhIkxEm8eI
        KyGaNg6iGWqZ5gg/LQpM/gBi1qSEXrM=
X-Google-Smtp-Source: ABdhPJwCY35pOvxvGym85U/8cYQFG4xdT9I5H6WrOoEm+Ps5AaJUfhzoOFAbtov19JdMyFN9XhDJYw==
X-Received: by 2002:a17:90b:fd0:: with SMTP id gd16mr858576pjb.157.1634661415526;
        Tue, 19 Oct 2021 09:36:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f60:dc0f:50d7:6a24])
        by smtp.gmail.com with ESMTPSA id t14sm16110248pga.62.2021.10.19.09.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 09:36:55 -0700 (PDT)
Subject: Re: [PATCH] scsi: mpt3sas: make mpt3sas_dev_attrs static
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        sathya.prakash@broadcom.com
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9cdf9d31-cb90-0792-29e8-52339c1e1043@acm.org>
Date:   Tue, 19 Oct 2021 09:36:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/21 3:27 AM, Jiapeng Chong wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> This symbol is not used outside of mpt3sas_ctl.c, so marks it static.
> 
> Fixes the following sparse warning:
> 
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:3988:18: warning: symbol
> 'mpt3sas_dev_attrs' was not declared. Should it be static?
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 1bb3ca27d2ca ("scsi: mpt3sas: Switch to attribute groups")
> Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 0aabc9761be1..05b6c6a073c3 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -3985,7 +3985,7 @@ sas_ncq_prio_enable_store(struct device *dev,
>   }
>   static DEVICE_ATTR_RW(sas_ncq_prio_enable);
>   
> -struct attribute *mpt3sas_dev_attrs[] = {
> +static struct attribute *mpt3sas_dev_attrs[] = {
>   	&dev_attr_sas_address.attr,
>   	&dev_attr_sas_device_handle.attr,
>   	&dev_attr_sas_ncq_prio_supported.attr,
> 

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
