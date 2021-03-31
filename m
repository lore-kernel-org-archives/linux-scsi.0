Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39021C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0B3E61927
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhCaDfL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 23:35:11 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:40947 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhCaDes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 23:34:48 -0400
Received: by mail-pj1-f44.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so457324pjq.5
        for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2021 20:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUPZBXO2NvYQwyfF9IlLRNP1FaxplPr9csRNBYYVkdY=;
        b=r/X1k7XD4NXrYbfRsFhyevcxyYvkBsWD0OaJy/6ptV+BgQjPAobA+k2o5eru+VaAAg
         np2/OzA5sxB0J9ivek5llu9lsSTR+xgRPDeDGu2qWRQkhfbiaNEXyIXLMfQ0mQUHMv3I
         MpepOyVgbQuLxleqJkz4paWMDw+E16sHvRWWNWzq7v1er/bwpK4ZpowCczrjOsd9vdTA
         yBAT4LeW4Gr8nAYw/I4HsRf9/WDzOsZm5nkkgwRR/qQZbqgsNG3BNtEVK8Y8eBgObYMO
         G7B/T3Lkc40gYgXxp+q/3dIjZgAOQpUqGibSuq88CGC+615KfZnFH6Dm7vS4K1KBBFnX
         v3aw==
X-Gm-Message-State: AOAM531GcRhbbKyWs7LF8Q7rWs373VoSeAgjRq6fHKqlIfvQ3YX8LkGi
        R3O1SG9oo/C1VJQAp5aPIEMcJpnhqoo=
X-Google-Smtp-Source: ABdhPJy7h2kqXIifnzOG7fVUmfCJL0JSsIn1Kqhtpxcf4VETkmVNpY2tKyKOYgfu28wIHvMK00H+7Q==
X-Received: by 2002:a17:902:b705:b029:e6:f027:adf8 with SMTP id d5-20020a170902b705b02900e6f027adf8mr1159454pls.72.1617161688264;
        Tue, 30 Mar 2021 20:34:48 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9743:2a26:e471:8a89? ([2601:647:4000:d7:9743:2a26:e471:8a89])
        by smtp.gmail.com with ESMTPSA id y12sm413933pfq.118.2021.03.30.20.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 20:34:47 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
References: <1617160475-1550-1-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ce9a2333-437e-143a-a0f0-c5f532a2c423@acm.org>
Date:   Tue, 30 Mar 2021 20:34:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1617160475-1550-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/21 8:14 PM, Can Guo wrote:
> It works like:
> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 4096 > monitor_chunk_size
> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 1 > monitor_enable
> /sys/bus/platform/drivers/ufshcd/*/monitor # grep ^ /dev/null *
> monitor_chunk_size:4096
> monitor_enable:1
> read_nr_requests:17
> read_req_latency_avg:169
> read_req_latency_max:594
> read_req_latency_min:66
> read_req_latency_sum:2887
> read_total_busy:2639
> read_total_sectors:136
> write_nr_requests:116
> write_req_latency_avg:440
> write_req_latency_max:4921
> write_req_latency_min:23
> write_req_latency_sum:51052
> write_total_busy:19584
> write_total_sectors:928

Are any of these attributes UFS-specific? If not, isn't this
functionality that should be added to the block layer instead of to the
UFS driver?

Thanks,

Bart.
