Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B8FC432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 02:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A40660F57
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 02:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbhH3Ck4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Aug 2021 22:40:56 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:45637 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbhH3Ck4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Aug 2021 22:40:56 -0400
Received: by mail-pl1-f173.google.com with SMTP id d17so7653211plr.12
        for <linux-scsi@vger.kernel.org>; Sun, 29 Aug 2021 19:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AJ89m4vsnGYBLMOXvE16U0r+DauIZhCqAl1YDWX+x0E=;
        b=o9bw+HwV/RzYoZX7tP+iIdZ64oSoIimKsOsXpMief1Zzt0QpXPezjaJkTr+MjCDD8T
         Rm6v61fSoWotFOYNVsqmWB+iF2tQgrKfkizMJnYTTcOs/FfvhSxxltpv9KUBI7/bkAi6
         rwg10zkZYER5aqrEwzGiPQmOAcwlNW0iPtaHL05+8vh2jhM9B1wMLnT6PIuBdyPe3g6n
         ZzRt/J7X87bzcskomJ1gLLTKhd2rHtHUr+EEdB9LKStzjn8f9tjpQjXYP4IpdtZclSYu
         uy8i5g8aBRwFc3Ue+UAsphbObQLL3ULJz7cXrba70pzmhxmQiUg5ufPIOter34ipe/Xh
         TYoQ==
X-Gm-Message-State: AOAM5306TP39uPV/TkA6Qu1qoVhBceAzhsI+aQaW4qtoe0HaYGUo7eBD
        lKpkS1E+4IaQF+EZqpeD2Ik=
X-Google-Smtp-Source: ABdhPJyjNY469Z5zfUXfavNdk3/wJI/xY/XRcrZv3F3UL0aszuXkq3UXAeRat0gIASl8G2J1Jb69xw==
X-Received: by 2002:a17:902:7049:b0:131:bdef:522d with SMTP id h9-20020a170902704900b00131bdef522dmr19870800plt.85.1630291202756;
        Sun, 29 Aug 2021 19:40:02 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:3a42:154:b70e:7868? ([2601:647:4000:d7:3a42:154:b70e:7868])
        by smtp.gmail.com with UTF8SMTPSA id r22sm15445778pjp.7.2021.08.29.19.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 19:40:01 -0700 (PDT)
Message-ID: <3efd607c-43df-4c2a-7948-de794b414406@acm.org>
Date:   Sun, 29 Aug 2021 19:40:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH] mpt3sas: Add io_uring iopoll support
Content-Language: en-US
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20210727081212.2742-1-sreekanth.reddy@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210727081212.2742-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/21 01:12, Sreekanth Reddy wrote:
> +	/*
> +	 * wait for current poll to complete.
> +	 */
> +	for (qid = 0; qid < iopoll_q_count; qid++) {
> +		while (atomic_read(&ioc->io_uring_poll_queues[qid].busy))
> +			udelay(500);
> +	}

So this loop busy-waits without calling cpu_relax()? That's not OK ...

An additional question: is mpt3sas_base_hard_reset_handler() the only 
function that calls mpt3sas_base_pause_mq_polling() and 
mpt3sas_base_resume_mq_polling()? If so, why have these functions been 
introduced since the SCSI core guarantees that all pending requests 
either have failed or have timed out before the SCSI error handler is 
invoked?

Thanks,

Bart.
