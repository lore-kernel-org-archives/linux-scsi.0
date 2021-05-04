Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB93C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31177611CC
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhEDDXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 23:23:43 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:47080 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhEDDXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 23:23:42 -0400
Received: by mail-pf1-f176.google.com with SMTP id q2so6015938pfh.13
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 20:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K4TSsBPMHP7MDrIwJ3Cqb5LIBvtdGTNFZPtVitOx59Y=;
        b=pQyRE+cHcnn/JnvoSWEQ00ulzM0OwK+KPr+ic7Jk5Jkvk6w9q+sV6ITaQW3A6bW3UT
         y/TtDwlwoF/w/xIlE0lg5xD09D3UxSqYCtWwhyroXu3xSEzd2w4eo17xxZpBvuytACt1
         91hhpfzuBpEl7/C7XLqJTuG1aHZfZNhcOMsSW39ssInM10ZDoGLfrp69a+V5jL/VcNCh
         1CIsYcxhcN6t+OMDFf6blKEqAleQa6fRsUugj171GiPE+NxVuKRKoKUMbwq0OU3SDw+R
         QzO34/aUXgHfLuwf6YfS6ugx+Fgxl0OT1csuuMWjSGeFv0TtO7JktxeKe65FrD1p+H+J
         mjPQ==
X-Gm-Message-State: AOAM530wk91NO1Y7SSVz9Qc72alTe6sxjjgyEAjQHglVpEzzmFA/a+Ov
        FXySKkDeO0yThZc8P8rvIS2eWrG9Mr8=
X-Google-Smtp-Source: ABdhPJz2kzDT9LVVP6l4gO17VKxY2jyRiQ5DjymHOdKEJhEZ7BxA+5GT0Dir+iSIHb/6KC4aFr6j3Q==
X-Received: by 2002:a63:5143:: with SMTP id r3mr6380883pgl.346.1620098567780;
        Mon, 03 May 2021 20:22:47 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id c130sm3021518pfc.51.2021.05.03.20.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 20:22:47 -0700 (PDT)
Subject: Re: [PATCH 16/18] aacraid: store target id in host_scribble
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-17-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <28955e68-9fbe-72bd-090b-85e0ecebda84@acm.org>
Date:   Mon, 3 May 2021 20:22:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-17-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> The probe_container mechanism requires a target id to be present,
> even if the device itself isn't present (yet).
> As we're now allocating internal commands the target id of the
> device is immutable, so store the requested target id in the
> host_scribble field.

A more elegant solution is probably to introduce private data per SCSI
command and to set the .cmd_size member in the SCSI host template. I'd
like to get rid of the host_scribble field because it makes the SCSI
command data structure larger than necessary for SCSI LLDs that don't
use 'host_scribble'.

Thanks,

Bart.
