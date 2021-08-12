Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD0DC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 16:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A96F6103A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 16:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhHLQKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 12:10:41 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:34520 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhHLQKl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 12:10:41 -0400
Received: by mail-pl1-f182.google.com with SMTP id d1so7951625pll.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 09:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AsblYZXWc/F/1s+n0V2i1w9eu6KrUP3XUXa3LRfRkws=;
        b=VKoUuPvxY7e+wftI4goP1+H11vvufw6LWOOOoXJuU0XeXMfxwcf2d7W3Ddk6UMU7vZ
         gxB7I6wp4TwDvjEyAdLHMwFYumRv9NrhO3si5ae/3INiYCfzrJ3K9YmhQLmmsEUk+1rp
         5apqcyuCvq7pU9GPMFiQ7dc96f/VUtkpI0eFwIUWOEi+p3Qo20TFrM5V6RD7H3ZQny61
         cYBhvJ0EhPFCufk+f/ncX2WbiM1ynPbokKTS6tJ0M+UgtN3A0gTwPC5oRZ6doh2Ey2Hd
         WkUuXcxqYFxTH+M2ABbhq608jVAiOBpb4llRlPryTj8MPevNs8HQ9Sx9lTQfhGQXVW+Q
         xxWg==
X-Gm-Message-State: AOAM530hJGXeztXeK/R8D1piPAcWxEm45MS6/tfYrFvwg8XCnKcCk3FU
        O0krqeuH9dZDORYMHWBw5bM=
X-Google-Smtp-Source: ABdhPJyM49Q0Irlc3w36K9UmZcLfqs3QeASjbi0fyGMBK/Cyb5epVXSHCZb2DVV6l09L97182kWkUw==
X-Received: by 2002:a17:90b:102:: with SMTP id p2mr17153022pjz.126.1628784615797;
        Thu, 12 Aug 2021 09:10:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:f9eb:d821:2884:27fd])
        by smtp.gmail.com with ESMTPSA id e4sm4196531pgt.22.2021.08.12.09.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:10:15 -0700 (PDT)
Subject: Re: [PATCH] scsi: cleanup scsi_get_vpd_page()
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210812074346.1048470-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f8b378b5-fa32-c9bc-2505-76ffc449e56b@acm.org>
Date:   Thu, 12 Aug 2021 09:10:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210812074346.1048470-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/21 12:43 AM, Damien Le Moal wrote:
> Get rid of all the gotos in scsi_get_vpd_page() to improve the code
> readability and make it more compact. Also update the outdated kernel
> doc comment for that function.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   drivers/scsi/scsi.c | 37 ++++++++++++++++++-------------------
>   1 file changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..14f7bb5e16cc 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -339,47 +339,46 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>    *
>    * SCSI devices may optionally supply Vital Product Data.  Each 'page'
>    * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
> - * If the device supports this VPD page, this routine returns a pointer
> - * to a buffer containing the data from that page.  The caller is
> - * responsible for calling kfree() on this pointer when it is no longer
> - * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
> + * If the device supports this VPD page, this routine fills @buf
> + * with the data from that page and return 0. If the VPD page is not
> + * supported or its content cannot be retrieved, -EINVAL is returned.
>    */
>   int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
>   		      int buf_len)
>   {
> +	bool found = false;
>   	int i, result;
>   
>   	if (sdev->skip_vpd_pages)
> -		goto fail;
> +		return -EINVAL;
>   
>   	/* Ask for all the pages supported by this device */
>   	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
>   	if (result < 4)
> -		goto fail;
> +		return -EINVAL;

The above conversions look fine to me.

>   	/* If the user actually wanted this page, we can skip the rest */
>   	if (page == 0)
>   		return 0;
>   
> -	for (i = 4; i < min(result, buf_len); i++)
> -		if (buf[i] == page)
> -			goto found;
> +	for (i = 4; i < min(result, buf_len); i++) {
> +		if (buf[i] == page) {
> +			found = true;
> +			break;
> +		}
> +	}

The above change goes against the kernel coding style and in my opinion 
makes this function harder to read. Please keep the goto.

Additionally, it is not clear to me why memchr() has been open-coded in 
this function?

Thanks,

Bart.
