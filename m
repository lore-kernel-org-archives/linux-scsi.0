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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFA4C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 07:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624DF61076
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 07:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhHJHTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 03:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhHJHTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 03:19:06 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BD9C0613D3;
        Tue, 10 Aug 2021 00:18:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r6so2626157wrt.4;
        Tue, 10 Aug 2021 00:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gWww76GCF5bdJ3wwOyrVrOe81eD6ccbw3CbNhzGl6sA=;
        b=NZkGabqAvmYmZUO16jJsqhjL/CVU0Sj7skB8PuJhN/s7osQ3QymAZOFTma81Cnb1gT
         gyTR2VraTsCp515ookPa3CDbMKBwIZF6CDbBRp9+yA9YQm6QJ8VhaAzGEBv+tRZKt6J+
         bMdoQyA0GtZ87GGhT2cO8yvSXHBpjWqax6Sdl4mGfTpyV0O8LSqbRK9FHeC9J24mCXsk
         uXti+uGGUSHGAAJPfwbtGGszxhLiNkkaHLBLXnYidNI+9GnrH/qH08ouH5pgtoWwxT02
         +dCFV7bh6Cq6DDvneOO5EEhh6zzjUwc2/wWY3isQD2YQSL/HO/sBie9U48PTfn2w5+x7
         cIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gWww76GCF5bdJ3wwOyrVrOe81eD6ccbw3CbNhzGl6sA=;
        b=eweDzgqKh4sUcNpEuLEJZ47OM4weXu0FeIwDkMQTo4HEe7DDM+iyt4Q0u0xOsU3niJ
         RmY3zG4vD0hmcu4DvLEsY0gd8x1bcq8jzt9UobtopVdezTEi/HXJnyOofCAmYnSxS+6b
         aD2fasKahjubd+6Wry6nbvFUq8d2Gldu2uv1+VOdGOTa5Ir42eqtRLmiLn2NN0/Q6pKw
         6qAVVEYEWlqmbOGb1EQvOUEjapH1cPUhfDhZmI7AKnuSJnwaDsFPaOYwuT1zXj/XoIqo
         J+rIg1rx3E3XF8ChYdAZHTf4ycT3QzbVAxFhs3FJ/ZgIoha8poOPKg4VDui4IVPcNzK5
         mRPg==
X-Gm-Message-State: AOAM532bKvVYDJG/6yikB5GhKIMUvA8+yliMs2tBwOZfQGqURTsCfJMv
        GhEIibpfUZBWosgQsNspu/k=
X-Google-Smtp-Source: ABdhPJzeEI+6Wv48bLWllrtYVIG0GxMW7kOVFVZN/f/T4Pmfr25NEsZMy6wo5bmChExdxlHB+PCWKA==
X-Received: by 2002:a05:6000:18c2:: with SMTP id w2mr29071731wrq.282.1628579922602;
        Tue, 10 Aug 2021 00:18:42 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc187b7.dynamic.kabel-deutschland.de. [188.193.135.183])
        by smtp.gmail.com with ESMTPSA id d8sm22313152wrv.20.2021.08.10.00.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 00:18:42 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: target: pscsi: Fix possible null-pointer
 dereference in pscsi_complete_cmd()
To:     Tuo Li <islituo@gmail.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20210810040414.248167-1-islituo@gmail.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <e45b6019-0ccd-cb8a-20cd-80f8f26146d9@gmail.com>
Date:   Tue, 10 Aug 2021 09:18:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210810040414.248167-1-islituo@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10.08.21 06:04, Tuo Li wrote:
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
>      buf[2] |= 0x80;
> 
> To fix these possible null-pointer dereferences, dereference buf and call
> transport_kunmap_data_sg() only when buf is not NULL.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
> v2:
> * Put transport_kunmap_data_sg() into the else-branch of the if (!bug).
>    Thank Bodo Stroesser for helpful advice.
> ---
>   drivers/target/target_core_pscsi.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 2629d2ef3970..75ef52f008ff 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -620,17 +620,17 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
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
> -			}
> +				if (cdb[0] == MODE_SENSE_10) {
> +					if (!(buf[3] & 0x80))
> +						buf[3] |= 0x80;
> +				} else {
> +					if (!(buf[2] & 0x80))
> +						buf[2] |= 0x80;
> +				}
>   
> -			transport_kunmap_data_sg(cmd);
> +				transport_kunmap_data_sg(cmd);
> +			}
>   		}
>   	}
>   after_mode_sense:
> 

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>

Regards,
Bodo
