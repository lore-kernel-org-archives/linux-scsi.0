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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E489BC4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 10:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB22460F93
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 10:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhHIKga (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 06:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbhHIKg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 06:36:26 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195D6C0613D3;
        Mon,  9 Aug 2021 03:36:06 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so11178959wmb.5;
        Mon, 09 Aug 2021 03:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oyK3DK7dZ8B3CuDhQ4Icy2bryrgMxTkDyrctLoPcTvA=;
        b=EB4/zfNBdczLKQVrCD4PktpowRlF8xRDE8RcYyKzzQnA2mC8kXnhDQfxOc29y4YxuK
         UEocQe3EyD6UHrZCEN3QwHJUwc+fwMT4J2H2miBaBvL/piyP1EVz8c2SwBS8euyMOQkP
         Z86pKEo9K8dVnuG0nIhk/ksmyGHYjLh2l5IlOcSl64lSzjwItYaICIALu9Aya8czliPm
         LTAtTVbHYlj7jgrkANDQCxU3D8KBovswX1UxXnQRyj+snv7KqOSz6CKSIYIXVsmK7CAp
         aYZUb86p4fFX4R2/JkH26mvAm/1n3GB5ahR68qRoJiNWaHrCdnRBPg1DlpX0Y683RKxw
         284Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyK3DK7dZ8B3CuDhQ4Icy2bryrgMxTkDyrctLoPcTvA=;
        b=J4IYSy3vBAMY6ZsPIDvcSBUa9t4UAQVt2NvrYxJLaRQQu78Kpjblwmn9eUNNHPxBAL
         kM7UXBpBSkCASxMk7PnipjP7sF4z3Z4ogCHLINX7bgYe2qOzVWev4Fyif9dl7ymZrdHa
         nkq71Gck3hafO4BBiHXbuqhrLHdJmABchBK/c80HPhEJS/Odp8xyYRKfdMdNCQQybTcq
         ITKSuhUtOhNhfz2LDiQM+ppWiYQswxjdTBx5j3A9LicjeuXiyJ8qR4acoK7oXSg+ycqN
         mLgrrLcczvAPQ646u3zKMdeolNoLIdh/oTiMFJCJY6hRaKVzBabhL2pfbsZ8BWXqfYIt
         17TQ==
X-Gm-Message-State: AOAM532meznFKKJrXd6ihJpBEPGagXjNhcep6RBQhE0KRJfnG853vLmy
        y22433kK4jHJsBS3o4yPF0q1KT5eJ4Q=
X-Google-Smtp-Source: ABdhPJzcle4XOWUWQttq3Btk2YWnl6HGu2LK65hbO8Bv9KBHjtnViSfJgHG8q8aI+O5slqhS7mPjgQ==
X-Received: by 2002:a1c:1b4b:: with SMTP id b72mr1654692wmb.168.1628505364701;
        Mon, 09 Aug 2021 03:36:04 -0700 (PDT)
Received: from [192.168.178.40] ([188.193.135.183])
        by smtp.gmail.com with ESMTPSA id i14sm14504278wmq.40.2021.08.09.03.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 03:36:04 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: pscsi: Fix possible null-pointer
 dereference in pscsi_complete_cmd()
To:     Tuo Li <islituo@gmail.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20210807134651.245436-1-islituo@gmail.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <dea07ecc-7700-5ee7-aa40-2d4455dc6c3f@gmail.com>
Date:   Mon, 9 Aug 2021 12:36:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210807134651.245436-1-islituo@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07.08.21 15:46, Tuo Li wrote:
> The return value of transport_kmap_data_sg() is assigned to the variable
> buf:
>    buf = transport_kmap_data_sg(cmd);
> 
> And then it is checked:
>    if (!buf) {
> 
> This indicates that buf can be NULL. However, it is dereferenced in the
> following statements:
>    if (!(buf[3] & 0x80))
>      buf[3] |= 0x80;
>    if (!(buf[2] & 0x80))
> 	buf[2] |= 0x80;
> 
> To fix these possible null-pointer dereferences, dereference buf only when
> it is not NULL.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
>   drivers/target/target_core_pscsi.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 2629d2ef3970..560815729182 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -620,14 +620,14 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
>   			buf = transport_kmap_data_sg(cmd);
>   			if (!buf) {
>   				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
> -			}
> -
> -			if (cdb[0] == MODE_SENSE_10) {
> -				if (!(buf[3] & 0x80))
> -					buf[3] |= 0x80;
>   			} else {
> -				if (!(buf[2] & 0x80))
> -					buf[2] |= 0x80;
> +				if (cdb[0] == MODE_SENSE_10) {
> +					if (!(buf[3] & 0x80))
> +						buf[3] |= 0x80;
> +				} else {
> +					if (!(buf[2] & 0x80))
> +						buf[2] |= 0x80;
> +				}
>   			}
>   
>   			transport_kunmap_data_sg(cmd);
> 

I'm wondering whether we should better put the
transport_kunmap_data_sg into the else-branch of the if (!buf)?
AFAICS, calling it after transport_kmap_data_sg failed does not
cause problems, but I feel it would be cleaner.

Otherwise it looks good to me.
