Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4DEC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 02:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DFCE60F48
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 02:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhIUC5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 22:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237680AbhIUCXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 22:23:32 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914EAC1DDC6B;
        Mon, 20 Sep 2021 11:50:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h3-20020a17090a580300b0019ce70f8243so124131pji.4;
        Mon, 20 Sep 2021 11:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AEf79rWn/9hTeD9zwPcYIx29i0uIYHTFx/+Rb5okHyA=;
        b=aUNnRE2bPwUnM530gy1QMPLkyf+ddc/uzBEVJqypT0HenlLa66c+jST32dpWaTo2As
         uEFu30EtvlSpI5a9YXGEKaCeUJQIOIBA3uobm1n/C5RgdO8HSb03NF62mK1oxX7S6MLC
         vcYYIH2VlZV9ym4bVe7VpmR/0/M1tQWnQ6isG+jpCHuuIQ6XPhOGpe8kyYG/F+j991yc
         aAiJ1emuz0ce5OERRV0xHXQ9mpNeI4jXT+hLROrQeti0kZWUY2H+tKqYx6KRW++kKSma
         Mwfwu7RN7+9uJ6qMzDx0pGZOdeOQ4X84I0l1MY2SEgarjsgTVat83o6+1agECW+Iyuu/
         c7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AEf79rWn/9hTeD9zwPcYIx29i0uIYHTFx/+Rb5okHyA=;
        b=LkekmXPmz4/9D+6DOIe2LuTm1wQXIQ9yn+123zDJYA1HRZtcZbX6fctW9aNkxGUaKl
         v8GhlgVrLf0uKJTMnEAHZEWSp5BrV+qZNMC6GM10j6xztPPTltBlo+1RCyfJ0IsNo6L0
         v/CzXUPBKf9hh9otMHNSduvyj2rrJyEiSDBmndRbpWD7yZzWm1lQKn5TL8Bo/GJutNhj
         ulGkIuXY25nt3DwAiZwiGTWEQjjgMIj49vrjQR/pURpmJmuUJ/awUERdH6lKjPSmM2gr
         o77CJHygVx3AA0o7uweAoo+MQrXkv+ym2W1dIlN5/6KTYu4AKh7+phEZB9xqaIcKkwBv
         EOgg==
X-Gm-Message-State: AOAM533BrN3GCr6oqChJmW6o6yzhl8x+JqyhTTTDHbBM/F6UlOi1r26b
        n6e9ScSDF/ZWxNmtBC8r25A=
X-Google-Smtp-Source: ABdhPJwyRtjipL3juujjlnSSZ7iaf9xGw/l+MgfBA1qbjWuI79wP+PUEyOKmCYlq7okQqpUaNhcyrQ==
X-Received: by 2002:a17:90b:4d8a:: with SMTP id oj10mr494845pjb.233.1632163800115;
        Mon, 20 Sep 2021 11:50:00 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z17sm5450158pfa.148.2021.09.20.11.49.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:49:59 -0700 (PDT)
Message-ID: <a4c0a2fd-8b33-8b30-ed74-e033136d496a@gmail.com>
Date:   Mon, 20 Sep 2021 11:49:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] scsi: lpfc: Fix gcc -Wstringop-overread warning, again
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Justin Tee <justin.tee@broadcom.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210920095628.1191676-1-arnd@kernel.org>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20210920095628.1191676-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/2021 2:56 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> I fixed a stringop-overread warning earlier this year, now a
> second copy of the original code was added and the warning came
> back:
> 
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_cmf_info_show':
> drivers/scsi/lpfc/lpfc_attr.c:289:25: error: 'strnlen' specified bound 4095 exceeds source size 24 [-Werror=stringop-overread]
>    289 |                         strnlen(LPFC_INFO_MORE_STR, PAGE_SIZE - 1),
>        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix it the same way as the other copy.
> 
> Fixes: ada48ba70f6b ("scsi: lpfc: Fix gcc -Wstringop-overread warning")
> Fixes: 74a7baa2a3ee ("scsi: lpfc: Add cmf_info sysfs entry")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/lpfc/lpfc_attr.c | 7 ++-----


Thank You Arnd. Looks good.

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
