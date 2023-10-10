Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81599CD68E5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 09:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjJJJCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 05:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjJJJCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 05:02:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1959F
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 02:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696928506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WT+cRgvE6j4m6iIs9CQA2K/PgdEYLs2ZCdC3DU5bQN0=;
        b=WGa7DsH98xuWOJ5KnNk/R9Wo5PkE0EiWTCKFztF1pns/2GYZaWbRQ2QLyE+WHs5QOJD55C
        FWcrO6eiU/upERYZbLLcdcl8ufAiYj/13WXNinSaoUPq0Y3j4l7IP8cL+snFdE1X9iBDCz
        UUEIsbLaTMp0DepdQceyUPxqjrdnnI8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-3VNU6RXWOseYjgqDeHoCTg-1; Tue, 10 Oct 2023 05:01:45 -0400
X-MC-Unique: 3VNU6RXWOseYjgqDeHoCTg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-997c891a88dso183817066b.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 02:01:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696928503; x=1697533303;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WT+cRgvE6j4m6iIs9CQA2K/PgdEYLs2ZCdC3DU5bQN0=;
        b=kjJ+DTqrQ62S67zb5TnBFFQTsoaqWGZdZXlbWVDvLOxeotDCoWZht8LhKc330Phcfq
         DiApMAq0ED60KHJ+Xlk+zarCENE0j+oRp30RZofRIT5dXTJ3mwXYMoN8t6iUUoTfYawI
         9pQIaMmZg/xzxGxE6bwGcjLi8KnRQww+dhspQ4A+Ui8XKe6ApYyZS6oqVbennmqYsXeV
         dhIy9pJjQIa3+cnWB3kvIZzv2MByIzKeU1Stwl2kgwCNFWJbfdYQqbo9Dao8hqi1/Ylm
         Zw7Rz3un2DoyB8eQ0q8wbxK1WJJsJMkPyb852DXLSi0XQFlWsC9caAwyLHlkSge9GBKp
         mOIQ==
X-Gm-Message-State: AOJu0Yx8Wu0ey8FTz4d7/WHdJLTfuxd/KADN6XGMkyVqXbTbaYTZBPuu
        9uvUjPTIhSCqU6XlIRkFAg3bHskkonlprWsPSvO1vkg/fKingZJ1FQ1iMndPTZN1XFK++kNW3qG
        6Ghs0jDNc0zTxdd2W+hCpBhbyonhp4BHsXY8hSo/5x4cV+VP/o6yZqWv6xCbgJUl9ImpRs8+69c
        xTDhc=
X-Received: by 2002:a17:907:b0d:b0:9ae:37c2:11b2 with SMTP id h13-20020a1709070b0d00b009ae37c211b2mr14029100ejl.15.1696928503717;
        Tue, 10 Oct 2023 02:01:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeTgUspWwEL30w1fP2RqnSKNifpzHvFp/oP2hDm0CQnL2NFw5TIZ4rnC/IjEDtsU7ZFYig2A==
X-Received: by 2002:a17:907:b0d:b0:9ae:37c2:11b2 with SMTP id h13-20020a1709070b0d00b009ae37c211b2mr14029081ejl.15.1696928503329;
        Tue, 10 Oct 2023 02:01:43 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id p26-20020a1709060dda00b0099bc08862b6sm8265793eji.171.2023.10.10.02.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 02:01:42 -0700 (PDT)
Message-ID: <696c643d-cbe8-5ef4-c360-db86d0c1d357@redhat.com>
Date:   Tue, 10 Oct 2023 11:01:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] mpt3sas: suppress a warning in debug kernel
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
References: <20231009152730.14925-1-thenzl@redhat.com>
In-Reply-To: <20231009152730.14925-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There might be an issue related to this patch, I shall post a modified V2.

Please drop this patch.

On 10/9/23 17:27, Tomas Henzl wrote:
> The mpt3sas_ctl_exit should be called after communication
> with the controller stops but in the current place it may cause
> false warnings about memory not released.
> Fix it by moving the call right after mpt3sas_base_detach.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index c3c1f466fe01..9af7a7e24474 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -11350,6 +11350,7 @@ static void scsih_remove(struct pci_dev *pdev)
>  	}
>  
>  	mpt3sas_base_detach(ioc);
> +	mpt3sas_ctl_exit(hbas_to_enumerate);
>  	spin_lock(&gioc_lock);
>  	list_del(&ioc->list);
>  	spin_unlock(&gioc_lock);
> @@ -12931,8 +12932,6 @@ _mpt3sas_exit(void)
>  
>  	pci_unregister_driver(&mpt3sas_driver);
>  
> -	mpt3sas_ctl_exit(hbas_to_enumerate);
> -
>  	scsih_exit();
>  }
>  

