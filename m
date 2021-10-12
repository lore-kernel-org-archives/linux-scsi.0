Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FADC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43C316103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhJLUbd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:31:33 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40939 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhJLUbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 16:31:33 -0400
Received: by mail-pf1-f176.google.com with SMTP id o133so517837pfg.7
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 13:29:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CuBfyWjaKk5a460k18x5y+nZceyCaSv5QMcRDpm3fC8=;
        b=2/3N63g1TLlavMt8N0n2Pd0fayBIz8d+yHaueSvA0FYXoP3RgBWj7QU63DeIsboX95
         pq+vGN14pfmMg5hzpb9+yhcurQ4QlnBo945c5oy0RdxAFm0xs696vWRc8F4lZNlUwnYP
         52+9uPbF0UTStsCd3pjh46FDvviVaeJvpEU4ZxwK5H75xN79asgrQBFkG1GAd+jgtBRp
         U/+AQUeBk84mPxDoqUrcXKRorIVKbi9qQgJDwgbaE9XfxYE/GdQhoiCzofrLo19/aryu
         ZiwXRIKn4kxqhwtTWoaAGX7ka20uKiTxbfRFff0g0+ewcM7eH4gHKecMt4MmKIuU8wO8
         rqsw==
X-Gm-Message-State: AOAM532bIWnBluxobpWY+Q8leoDDGuyNmLy+J/eQyfG8mwXtWEoKwOOK
        2iJ2hKtni4vU+EP/gMoQE3Y=
X-Google-Smtp-Source: ABdhPJwjfjuNxx43DrpDf9z+3VstsZJuaqGhKtQ4YbAv95Zf6RtL7qyWH3dtAlah1OfeesKFC2XRHA==
X-Received: by 2002:a63:5914:: with SMTP id n20mr23963995pgb.164.1634070570645;
        Tue, 12 Oct 2021 13:29:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id k22sm4036652pji.2.2021.10.12.13.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 13:29:29 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: qla2xxx: Fix a memory leak in an error path of
 qla2x00_process_els()
To:     Joy Gu <jgu@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com
References: <20211012191834.90306-1-jgu@purestorage.com>
 <20211012191834.90306-2-jgu@purestorage.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <adc816e2-9c5f-4a18-e40e-b46d2822e925@acm.org>
Date:   Tue, 12 Oct 2021 13:29:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012191834.90306-2-jgu@purestorage.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 12:18 PM, Joy Gu wrote:
> Change the == to a != to avoid leaking the fcport structure or freeing
> unallocated memory.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
