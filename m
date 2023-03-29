Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDCEC6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 20:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjC2Uun (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC2Uum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 16:50:42 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862B444B8
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:50:40 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id iw3so16119033plb.6
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680123040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tSHHb5iei2rxNPIyHI4J0jENyddBcSnp4sget8lZBE=;
        b=kIVSi5ozYdfq83w5xEdRujvarRj4xR7dvBSXIF0kriHn2OI5M2TxeDDVsMihPdSi7x
         GCDrAUf5tYS3mdLTrx2IABslZUeBwwtmkZFM1ry4SAYqQnpCw4k40H9r46MYfgwAvOzv
         YA/WjKhp7aGtiPBIr3SzEqW62vNRmiAch/YFBkVlIqwVme3do8Pk2YR9Cd/Udh3qhYbb
         ljxHyp/1gPfvSTJ+eCM/UivjEyDTJNQEvvxAaoR7TaKjXK+CapDl/1gk2oBPxXV4/G0L
         cva+yojID35FKnmPFdTWD6lt1r83KcmmSGUFbjPqp7laAt7zv1t/m3/qa98mikg1fZWR
         xXig==
X-Gm-Message-State: AAQBX9ctRB798b270saiNNktLq2fNYiHAYjfCZjg4HF7SGw9klOqr1w9
        6rDqTsfN9+X0SHeAGHjBH5YVd4CaM8I=
X-Google-Smtp-Source: AKy350aFO7cL+X2sYu2Sneo54r7VQphjsTNmCHK7BXuuiWZdi3obYHEQJpB7Il68wwHGC47JSRTQHw==
X-Received: by 2002:a17:90b:896:b0:240:6623:733a with SMTP id bj22-20020a17090b089600b002406623733amr3631947pjb.8.1680123039723;
        Wed, 29 Mar 2023 13:50:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:c058:cec1:e4c9:184e? ([2620:15c:211:201:c058:cec1:e4c9:184e])
        by smtp.gmail.com with ESMTPSA id ij21-20020a17090af81500b0023b3d80c76csm1874061pjb.4.2023.03.29.13.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 13:50:39 -0700 (PDT)
Message-ID: <0461c1c5-19b0-89e7-7ee5-2a1c52907701@acm.org>
Date:   Wed, 29 Mar 2023 13:50:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: sr: simplify the sr_open function
Content-Language: en-US
To:     Enze Li <lienze@kylinos.cn>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, enze.li@gmx.com
References: <20230327030237.3407253-1-lienze@kylinos.cn>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230327030237.3407253-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/26/23 20:02, Enze Li wrote:
> Simplify the sr_open function by removing the goto label as it does only
> return one error code.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>   drivers/scsi/sr.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 9e51dcd30bfd..12869e6d4ebd 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -590,20 +590,15 @@ static int sr_open(struct cdrom_device_info *cdi, int purpose)
>   {
>   	struct scsi_cd *cd = cdi->handle;
>   	struct scsi_device *sdev = cd->device;
> -	int retval;
>   
>   	/*
>   	 * If the device is in error recovery, wait until it is done.
>   	 * If the device is offline, then disallow any access to it.
>   	 */
> -	retval = -ENXIO;
>   	if (!scsi_block_when_processing_errors(sdev))
> -		goto error_out;
> +		return -ENXIO;
>   
>   	return 0;
> -
> -error_out:
> -	return retval;	
>   }

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
