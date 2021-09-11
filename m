Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B28C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 02:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2503A61211
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 02:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhIKCjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 22:39:16 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:40565 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbhIKCjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 22:39:15 -0400
Received: by mail-pg1-f179.google.com with SMTP id h3so3548750pgb.7
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 19:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q4lLRz2hNGXvUEsoCTdIDTwoDQbJDNU6KINVCtAoATI=;
        b=hHGZb43u6dMrQzo1HrNRnJSo8kMvqV17WDsx5hPFL5giYGIcIccXYpQrBLg1SCDhXY
         SW3rZsif/KOsc1peko9g61lZcWDH5B1+a3/XDVzAdjnN3YUR0piWQegaAP+4kpd0Co9/
         vJ/BV2qx1xjFYQhPkXCOzhKuzDDiZRcSb0yUMHQY9U/p6GAeVSEHRml2xTn5FTBxqqb2
         +BE7L8CE8JNNFBuS5f+XKEXEbunSxYpSDONHVRyMpRViCcyuo2DR1JUNGoBNpgfN7sSz
         L5g2zyweHvCKqXQTqy+kQIaRw/NBQnhQrncHU4LGGcNyGoH17fnqMCDReSUf92IrO2CQ
         Angw==
X-Gm-Message-State: AOAM532RtfRcRzWN+vQT6/IzaOfmdTw40XbkK7KrBONExLCx9t+DMQLo
        bjSiMPM7d/8qj49hLJpQ8JWhXAPqQsk=
X-Google-Smtp-Source: ABdhPJxIfjQb7od5jqc1NkhMxtLcLIWEo6daomDyc9RAG2/g6xx2KWOBT9aN0piOxkJAfrEH1jsQ9w==
X-Received: by 2002:a63:e74b:: with SMTP id j11mr698322pgk.322.1631327883145;
        Fri, 10 Sep 2021 19:38:03 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:2c24:10db:f5a3:3a53? ([2601:647:4000:d7:2c24:10db:f5a3:3a53])
        by smtp.gmail.com with UTF8SMTPSA id l13sm259610pji.3.2021.09.10.19.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 19:38:02 -0700 (PDT)
Message-ID: <c5c5d45d-6422-8577-8e2e-c75898668a0b@acm.org>
Date:   Fri, 10 Sep 2021 19:37:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: sd_spinup_disk() now is a little noisy
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Loehle <cloehle@hyperstone.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
References: <485ac2f7-e83a-6fcd-b849-c20608e26810@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <485ac2f7-e83a-6fcd-b849-c20608e26810@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/10/21 15:59, Heiner Kallweit wrote:
>   		do {
> +			u8 media_was_present = sdkp->media_present;

How about using 'bool' instead of 'u8'?

>   			cmd[0] = TEST_UNIT_READY;
>   			memset((void *) &cmd[1], 0, 9);
>   
> @@ -2138,7 +2140,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>   			 * with any more polling.
>   			 */
>   			if (media_not_present(sdkp, &sshdr)) {
> -				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
> +				if (media_was_present)
> +					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
>   				return;
>   			}

Thanks,

Bart.
