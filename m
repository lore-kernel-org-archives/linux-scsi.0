Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D57CEED600
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 15:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbjIOPIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbjIOPIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 11:08:02 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A692718
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 08:06:35 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c336f5b1ffso20042775ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 08:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694790395; x=1695395195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYbJ3Mf32ImIJ9gj8KPAsS1r+3+V8G0tA6YaEqud+2w=;
        b=ljrJHSt2ZSH+A+zwymGQnrFWqdrH8HnhBoIYpnK+BRGLcVzuKC3MdqJwrFMaPiwoAK
         wjvy4CMjZjgXgjUcVCCjIpx2hqdeIKbsrfFC6zHqOpuy3CR+KVFWeelt0Zc2WRntye4Q
         g0EzvZQ9k5RlJi/6g3ErZ7t1PZ1f0bXhPGEY0/NF5f4yegkf/nlBxKDq/WO+gAsGbn6L
         IMBekmd4weDVvXdbNXCdROAlLIQNICJhzfJVd5eMujA/0zqN2kf0FG5GcB7GJ7XD7k8c
         dHJrOY9bX2vklasBJ5MEFTSueZiLI6QJ90L6WUs16mipS1Fd0tdOilpgK/KyDMHYIoI0
         oBYw==
X-Gm-Message-State: AOJu0YzLqC75rSsWQAsuyzMwJU8nD4LY1FXWv2cg37rGUBim9tlAjcot
        62ktadkJN7YpYkOh+octqRA=
X-Google-Smtp-Source: AGHT+IHcslBaHBONHY5LbdsH9aizfnmmpy6Jj5isjDhLPp0216S/zegQoHfTmc1XWvINyfuuBwqrQQ==
X-Received: by 2002:a17:903:1110:b0:1bf:1367:b7fb with SMTP id n16-20020a170903111000b001bf1367b7fbmr2202853plh.46.1694790394663;
        Fri, 15 Sep 2023 08:06:34 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090311cf00b001c3267ae317sm3608286plh.165.2023.09.15.08.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 08:06:34 -0700 (PDT)
Message-ID: <5b0c1aa5-b41b-46f9-af5a-9cf2a325ae95@acm.org>
Date:   Fri, 15 Sep 2023 08:06:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Do no try to probe for CDL on old drives
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>
References: <20230915022034.678121-1-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230915022034.678121-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/23 19:20, Damien Le Moal wrote:
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 92ae4b4f30ac..7aa70af1fc07 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1828,6 +1828,9 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
>   		hdr[2] = 0x7; /* claim SPC-5 version compatibility */
>   	}
>   
> +	if (args->dev->flags & ATA_DFLAG_CDL)
> +		hdr[2] = 0xd; /* claim SPC-6 version compatibility */

How about using the symbolic name SCSI_SPC_6 - 1 instead of the literal 
constant 0xd?

> -	sdev->scsi_level = inq_result[2] & 0x07;
> +	sdev->scsi_level = inq_result[2] & 0x0f;
>   	if (sdev->scsi_level >= 2 ||
>   	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
>   		sdev->scsi_level++;

Can support for inq_result[3] & 0x0f == 1 be dropped? From an SPC-2
draft from 2001: "A RESPONSE DATA FORMAT field value of two indicates 
that the data shall be in the format specified in this standard.
Response data format values less than two are obsolete. Response data 
format values greater than two are reserved."

> @@ -157,6 +157,9 @@ enum scsi_disposition {
>   #define SCSI_3          4        /* SPC */
>   #define SCSI_SPC_2      5
>   #define SCSI_SPC_3      6
> +#define SCSI_SPC_4	7
> +#define SCSI_SPC_5	8
> +#define SCSI_SPC_6	14

Please consider changing the SCSI_SPC_* constants such that these match 
the SPC standard. Having numerical values that do not match the standard 
is confusing.

Thanks,

Bart.
