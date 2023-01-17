Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD38C3DA78
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 17:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjAQRz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 12:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjAQRxp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 12:53:45 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F332E4F84A;
        Tue, 17 Jan 2023 09:43:05 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id jl4so34289954plb.8;
        Tue, 17 Jan 2023 09:43:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hvp+iR4BlWOarWYBjNCLj7ICflmxWG7PewjY8QZuX0=;
        b=C8+HScL57hPXOMd1x72j7q1ilokNgE4rCF+GhCAzjd+DT07BD9tytiR55JieU4fg1J
         GRR8MGV9QD1yMq28M+/xN/LTfcDPdpj7YJYbnbCoypgcLQPWiKxYSb53hx+pngk510hZ
         6MK1zin++VwabgPAS60F/U8ysXAFJLglx5TRCSrRWjeR6MXalXALv3CS6nYQ5fZBDKiE
         TO7row9EgVSA8L0Ia/eYd+neR7nGoYG9cgIruQnFwcr4TRUBNPryLcEt9WyNMZNKKtap
         2LFyRBxpDNFox0vi3d0Y+uwDatyvUxkp+uqI7FHf02khuCRbSwl6tKOo2sTlWRRrerQt
         y8mg==
X-Gm-Message-State: AFqh2koMjjUJ7aLWv/6PXqq28HkhZt/WWlMcKfPtX7Vfa6aWYztdQ5TA
        Ja8b7TH5xeMoovtc7ZkrfrA=
X-Google-Smtp-Source: AMrXdXvuht3ckpfK3o1aJAxmhnhTZ9UTKzSsj763fT4ZGg0TfUHEZB8TbX/4S249xYemTKmB39ti0w==
X-Received: by 2002:a17:902:c948:b0:186:def0:66f2 with SMTP id i8-20020a170902c94800b00186def066f2mr6198001pla.11.1673977385329;
        Tue, 17 Jan 2023 09:43:05 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f632:d9f5:6cbb:17d0? ([2620:15c:211:201:f632:d9f5:6cbb:17d0])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902ea0900b0017f57787a4asm21469407plg.229.2023.01.17.09.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 09:43:04 -0800 (PST)
Message-ID: <15f1424c-d979-6330-843c-d5ea84a8bfac@acm.org>
Date:   Tue, 17 Jan 2023 09:43:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] scsi: stex: fix MU_MAX_DELAY typecheck
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230117163834.1053763-1-arnd@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230117163834.1053763-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 08:38, Arnd Bergmann wrote:
> @@ -173,7 +173,7 @@ enum {
>   	ST_ADDITIONAL_MEM_MIN			= 0x80000,
>   	PMIC_SHUTDOWN				= 0x0D,
>   	PMIC_REUMSE					= 0x10,
> -	ST_IGNORED					= -1,
> +	ST_IGNORED					= -1u,
>   	ST_NOTHANDLED				= 7,
>   	ST_S3						= 3,
>   	ST_S4						= 4,

 From drivers/scsi/stex.c:

int st_sleep_mic;

... st_sleep_mic == ST_IGNORED ...

Can changing ST_IGNORED from signed to unsigned break the stex driver?

Thanks,

Bart.
