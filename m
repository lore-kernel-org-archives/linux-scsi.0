Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585C6C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 262E964E6C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhBIRGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbhBIRGm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 12:06:42 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE5BC061574;
        Tue,  9 Feb 2021 09:06:00 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id i8so32835342ejc.7;
        Tue, 09 Feb 2021 09:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qfsWSXNe4jcQ7VyJTaYvrqK7T7y289+gs+tFsu/SzwI=;
        b=m1xFOpIInVdMxNg5kbA80s17ZRcMN4ZJMRZ8rx8UHFS3PKMJi/SSrYEHnUAiign0Nc
         Mstee9ssuTsOvJ9soKEYIpng94j1wUy5hY09+PWeOy6C9UdyKRPKoYYmly/1Fjpy7bvk
         vNF4S/IPMGMuLzwK+LoZhqyCzP0VUWxGOczUscjKuplucvBuoDeI2S+/hk4Camn/oIui
         Xv0Mwnmaem68kzls/pKVNnzsdJWxf1hNaZh5A5AT+4Ela+iPLbuxsoTqftpLoyf+IoKJ
         uQP80Wiaan+rF3kCxJq19uwJkBbYXgnV9mLgkpP/A/IVJMDf1GD3N99tUwJoOSP/RHMI
         V8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qfsWSXNe4jcQ7VyJTaYvrqK7T7y289+gs+tFsu/SzwI=;
        b=jobjKZ24uCMdyq0SN+swjNwoQrVtu1IGE59PacDDKCwJNVsgOzeJbIA6vDJLR2fpym
         /Ww7G/BdO+9jD6LqG0DiEXJcOfCHgd2Wsc9KmweZnaaFGuEGtodGE+niy+N9dIYonV5S
         rYdWcPXvEUF3hWX7a1IE1tk/cA3gtcMcstRcH8ByNAncs+746dKh2qDUfW8mNQvzcOz9
         DYdHG6UYqc8k5Ehm9Im07emKk0XbH3CTvTntCOGt9Pkc6v2+612aKxQnwHLTrkJ2uCUZ
         O/eGBbDb3E446aGNkj6abSeHVpLYp+w2xn5yX+Rj8Z7JnIrc6jav7HNxObNoXJ3BSev6
         fbtQ==
X-Gm-Message-State: AOAM532KGRDB+i6DRIFrI0nE3rJwYwy5MNhh9lJQUD2fgEQfLDnvECYY
        tKQ2/mcdnGXvRJIK3Ls3Neg=
X-Google-Smtp-Source: ABdhPJwky4zzHbEsDsu1UyxyQVokhOPFV0mv5z9oYLeiSvq+3lTh3xiVCiAUGiHGhfnmEvqze6fAVg==
X-Received: by 2002:a17:906:804a:: with SMTP id x10mr23287509ejw.184.1612890359740;
        Tue, 09 Feb 2021 09:05:59 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id ks16sm11038259ejb.30.2021.02.09.09.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 09:05:59 -0800 (PST)
Subject: Re: [PATCH 13/13] target: flush submission work during TMR processing
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-14-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <47fd4d39-33ab-4d9f-bc74-5826fc47b067@gmail.com>
Date:   Tue, 9 Feb 2021 18:05:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209123845.4856-14-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09.02.21 13:38, Mike Christie wrote:
> If a cmd is on the submission workqueue then the TMR code will
> miss it, and end up returning task not found or success for
> lun resets. The fabric driver might then tell the initiator that
> the running cmds have been handled when they are about to run.
> 
> This adds a cancel when we are processing TMRs.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_tmr.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 7347285471fa..9b7f159f9341 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -124,6 +124,8 @@ void core_tmr_abort_task(
>   	int i;
>   
>   	for (i = 0; i < dev->queue_cnt; i++) {
> +		cancel_work_sync(&dev->queues[i].sq.work);
> +
>   		spin_lock_irqsave(&dev->queues[i].lock, flags);
>   		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
>   					 state_list) {
> @@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
>   	 * in the Control Mode Page.
>   	 */
>   	for (i = 0; i < dev->queue_cnt; i++) {
> +		cancel_work_sync(&dev->queues[i].sq.work);
> +
>   		spin_lock_irqsave(&dev->queues[i].lock, flags);
>   		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
>   					 state_list) {
> 

Is there a possible race?

I mean, if cancel_work_sync() is called for a work that was queued but not started,
can we end up with cmds sleeping in a queue until a further cmd is queued to the same queue?
