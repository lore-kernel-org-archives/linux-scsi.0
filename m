Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8B2C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 16:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5750F61249
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 16:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhFHQ2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 12:28:45 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:34582 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhFHQ2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 12:28:44 -0400
Received: by mail-pg1-f173.google.com with SMTP id l1so16950974pgm.1;
        Tue, 08 Jun 2021 09:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=H/64u5HBxpU8n12okh0m7h52OQte0PI5U6h7hpD5dxM=;
        b=SG17ijU4E7zKzZ7Ys1bfeTryPeqIgjK67Nt1lVNzFmFFSJe3gw/DPbi2yhPsMrKHLP
         bBFwcK8yb/nIYI6z7O8+TP82ejizJb+K2bPbT43Ydznrw99gMPxv4rzmRtRkArL31M5j
         PpZrEWIcJ8ybwCGTRks9HA7QxP5ih0Q9uxjq55+w+kIPGtHKcFaoNc3jCc7mPei4HXH7
         j74sYZJLuvUfAd7zETAsPm77/Nf1F02V7RLXdMv2WNaPzWjvY7j4ZErWF8hgQpuuBuTC
         3+1/O28WT437EMkLkAaq0r4J2BErXbzUYDRnZftfu73fiui95BVTiNS3kr824qy1fKdc
         OfFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=H/64u5HBxpU8n12okh0m7h52OQte0PI5U6h7hpD5dxM=;
        b=pOfJT4iRr2RRis6+fFi18jlz6sz50tagp5gPjZxgmwdN+7x8LFizg4RazcBU7YwQk7
         K4us7Doh8YVDuNWOvypBDzJuQMyADCXaRMs4zHIyZNQY3hdWNJ2tyhbLIPGWrfSm54aa
         ABKKNb12QKGBJ1d1zf/+pVZMK0WwnNNVLDj7bAP0SSHjDcLb8WIASy3K08Su7QV6hpWU
         Ca9jk7221e18hrczg0liymNfXqxFIICFwyPAt2jdejMzS92fqxBEvRm+etmlljabN59c
         wSrfGdi5SIU8uPk5/TYk0AZwTrEIoM6oVhIz/FAftWFBbV8L3+WBmdj6oBKJ5I2Vscwf
         kA/Q==
X-Gm-Message-State: AOAM533o4Gmw2C9udaWmvs860hG+Pm7garOSzEdUFfkSkTrzLwMbOjSM
        gYLMBLehtjARA9I698Wb8sg=
X-Google-Smtp-Source: ABdhPJzI2xdpZPAzMOigHryCu7tZzJRR7Ur8/t/d7WhXhgm1zTmkFQ00WPahjG6iDckd5nkjdnVPSQ==
X-Received: by 2002:a63:6447:: with SMTP id y68mr23091760pgb.143.1623169540648;
        Tue, 08 Jun 2021 09:25:40 -0700 (PDT)
Received: from [192.168.0.217] (ip98-167-23-218.lv.lv.cox.net. [98.167.23.218])
        by smtp.gmail.com with ESMTPSA id p11sm15852194pjo.19.2021.06.08.09.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 09:25:40 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: lpfc_mem: Removed unnecessary 'return'
To:     lijian_8010a29@163.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
References: <20210608060422.256554-1-lijian_8010a29@163.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <60a7b65e-6c25-0e0f-76c1-778fcb61f142@gmail.com>
Date:   Tue, 8 Jun 2021 09:25:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608060422.256554-1-lijian_8010a29@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/7/2021 11:04 PM, lijian_8010a29@163.com wrote:
> From: lijian <lijian@yulong.com>
>
> Removed unnecessary 'return'.
>
> Signed-off-by: lijian <lijian@yulong.com>
> ---
>   drivers/scsi/lpfc/lpfc_mem.c | 7 -------
>   1 file changed, 7 deletions(-)
>
>
acking with the right email

Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
