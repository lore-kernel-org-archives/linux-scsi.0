Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BB1C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 18:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70D4F6124C
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 18:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhESSPt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 14:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhESSPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 14:15:44 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00679C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 11:14:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i13so16422956edb.9
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 11:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HSNG9HB/eC8cIhp09Mt6Q4ohNTWTXRJRAdMhkmEdo/8=;
        b=W5eeNf6l8zvyl5OKasIOndNiH7ntDL2tt10SesxD1exA8dwWYeE8pGz+/JBJ6yAc+p
         5vEDk7CIRvkzPCuqpDPRFgnxTLb0RNZ9DQzBFp/o6Z5T2R8nQASOh5iDS46gAgxn/53E
         v87K4Xfk7pKcbemt22n0jgkGbzPDz+tMnHgd9KHWAV9GrO2Dk7ivPNiP0sJrATcWx8Fu
         gpC5NwtYfapXC/rbrUbEbxNxftF71lslXab4DREzprd7weUNxvTafpj2wFLeJf6sgHzV
         fpjw2ZTG9ZCpERFAxCzt2HySPbSbnY7YVwS1dsiuNoKWi57dHw1uUgySuThEJuzGdYc4
         8Oqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HSNG9HB/eC8cIhp09Mt6Q4ohNTWTXRJRAdMhkmEdo/8=;
        b=LCAP461cC/Gy+MSjMVA9eV7+qwwGaBYedVtRCEqAHKItNSS20d23rhw7Rwd508bGNk
         tHhMMhQzIRk1Zf5Ct8y0pEIIvQo0+99wF+O3U4/KG7kruFJXrn1CdyOBPufwDBWSHFAl
         IJ0DTDMEubGJo6QnhngU5VqSC1j11f5hHaLjKfrlebfD9QaYdQdgYguYZhZ4ExcjuWX8
         AaaX+E0AYTYom07RqgmB3UNo3fEFTWCRHPNn9d2MSDuoglPqBg9+qcTRPMX+UBRFy2pz
         hyxwwFn1yncmA055kOEcFNOJUco9yo6vS34z2WfB59bbi2K5hXqLVUYUCx4j9Rfapz9d
         bl3Q==
X-Gm-Message-State: AOAM533/eG4TyqQfbYEWZ7xCl5woETFzWF8OkEaOeUzaFdFPp0cESgL+
        GunEZCUaUQleS+DJ5Cnz0lc=
X-Google-Smtp-Source: ABdhPJzdXSwOnimMcnw2TfXmuEPnz7nrS5MgruI9EMcUNQ9AEQuQQvyySiDHw5chOg8jJqiD2PniFA==
X-Received: by 2002:aa7:cd83:: with SMTP id x3mr304010edv.373.1621448062652;
        Wed, 19 May 2021 11:14:22 -0700 (PDT)
Received: from [192.168.178.40] ([188.193.20.102])
        by smtp.gmail.com with ESMTPSA id q16sm313155ejm.12.2021.05.19.11.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 11:14:22 -0700 (PDT)
Subject: Re: [PATCH v2 48/50] tcm_loop: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210518174450.20664-1-bvanassche@acm.org>
 <20210518174450.20664-49-bvanassche@acm.org>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <6803110a-102e-0150-de26-db6b5119fdd4@gmail.com>
Date:   Wed, 19 May 2021 20:14:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210518174450.20664-49-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18.05.21 19:44, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/target/loopback/tcm_loop.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 2687fd7d45db..834eceaac9cd 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -183,7 +183,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>   
>   	memset(tl_cmd, 0, sizeof(*tl_cmd));
>   	tl_cmd->sc = sc;
> -	tl_cmd->sc_cmd_tag = sc->request->tag;
> +	tl_cmd->sc_cmd_tag = scsi_cmd_to_rq(sc)->tag;
>   
>   	tcm_loop_target_queue_cmd(tl_cmd);
>   	return 0;
> @@ -249,7 +249,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
>   	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
>   	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
>   	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
> -				 sc->request->tag, TMR_ABORT_TASK);
> +				 scsi_cmd_to_rq(sc)->tag, TMR_ABORT_TASK);
>   	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
>   }
>   
> 

Looks good.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
