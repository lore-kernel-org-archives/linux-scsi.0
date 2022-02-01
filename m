Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9FFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiBAVUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:20:31 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:43618 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiBAVUb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:20:31 -0500
Received: by mail-pf1-f173.google.com with SMTP id d187so17008510pfa.10
        for <linux-scsi@vger.kernel.org>; Tue, 01 Feb 2022 13:20:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FrxIot1ZjWR/GBvsD77WX1iw7OHDPE148/niNcKbPGM=;
        b=BD09If1w0pFr8XHDI7v41DGaGL4ns8iAuRa2hsaXKGoSzJfym2vhbRhoEK2RYk4JPc
         agZ4GaZ3OMSIv5fpHjpVwVDDE+4rmHSg3rqDDJcY8Au9xdXgxMKyVcSuOMCoJV7xWy5g
         gj3E2WgyXLTAbggbEPWNlgf0jcFUdmI6TtWDnIY2jQAoAZZxjMSNLubX2kdSkPh8em4+
         n/CBQzXfSEEMPxxI405/yRZIqRL2AGEyD6ufvkiE7TtVRrnEYks+pIusTwnmJYbogGIL
         8esuCvMICKWGRsEcpYFAjXdbSjpRoazs05TznU8gI4QfrpRlqHKUys8xcKnDxsvYhqQZ
         bJVQ==
X-Gm-Message-State: AOAM530UL7EDn9qQHl+5uB4XqfWpxI8aZFC+wsUR8URudTJU1WP38Wag
        azP4KDllHHnmRodQWY1UTHw=
X-Google-Smtp-Source: ABdhPJzrlh/zj2Ho5IsmQGMptFesJU4OOCsvxAZ0usXqWvjD64b9Cf6VrrA5CGb/Qb/NFrD7F4jd2g==
X-Received: by 2002:a05:6a00:17a2:: with SMTP id s34mr27136839pfg.72.1643750430580;
        Tue, 01 Feb 2022 13:20:30 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t15sm3664446pjy.17.2022.02.01.13.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 13:20:29 -0800 (PST)
Message-ID: <99a87f32-71e6-6d78-861a-5a75d3e61848@acm.org>
Date:   Tue, 1 Feb 2022 13:20:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 16/44] esp_scsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-17-bvanassche@acm.org>
 <a33be8ce-6f5d-6b97-2b69-3f3326c51b1f@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a33be8ce-6f5d-6b97-2b69-3f3326c51b1f@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/31/22 14:46, Finn Thain wrote:
> After that, you're free to do this:
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index bb88995a12c7..4934a5490716 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2746,9 +2746,6 @@ static struct spi_function_template esp_transport_ops = {
>   
>   static int __init esp_init(void)
>   {
> -	BUILD_BUG_ON(sizeof(struct scsi_pointer) <
> -		     sizeof(struct esp_cmd_priv));
> -
>   	esp_transport_template = spi_attach_transport(&esp_transport_ops);
>   	if (!esp_transport_template)
>   		return -ENODEV;

Right, that BUILD_BUG_ON() statement can now be removed. I will check 
for are similar statements in other SCSI drivers too.

Thanks,

Bart.
