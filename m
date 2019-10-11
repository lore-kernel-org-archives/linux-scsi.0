Return-Path: <SRS0=6PDV=YE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C62BECE58D
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Oct 2019 17:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 032CA2084C
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Oct 2019 17:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbfJKRPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Oct 2019 13:15:20 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33953 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfJKRPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Oct 2019 13:15:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id k7so4763732pll.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Oct 2019 10:15:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09hXBtuQFyta3qLQH9+GFzAVNdmvS1bMvP4CgqF9ieQ=;
        b=tMcWwtiMB+mU83SBNgvBLmlN/lVbBliZoq6y4p3W0qlS2KFkwaXYFlYNX4QNd0cJf0
         G4JKkG8Tg1JA9H84GmYs1BrkXSEklbsE9hNT3uqWOAUfae5xVaulnGHEyjYupur6p2Cs
         7g0ph5nKE82OU6XNPkClDBrqrsDCPRwMMxDQoYIef7KD4CYMAjJfu/c6nT7qdBPPuUhX
         S5nnIRbdL7GWCTcOhbcjQFY8TaKXCxDt+N0BgR8EfyZ5hhiiEQcKdfMc+8BRxn/ObGMr
         fOEJXIUVOAptH4wgPEu7QVnZxV7cyj6Bf7mUrIW1ebxnnn0D5pd+GCN1qREcIsUTe71x
         Mhhg==
X-Gm-Message-State: APjAAAV39FgBl5gdqx2y3BdvsFjHhuvj5HZ/KP5p2w7nQ9rzwbs+iFTq
        RT3hJeFx663GcMGhV5PVgFXVQ4Nz
X-Google-Smtp-Source: APXvYqzhsd1QludZd/mf5qAhp0GxBCXgeDnHNGy40ePvVT/RQJ6wubmH351OdLBg2u2Hzrl5o8GiYw==
X-Received: by 2002:a17:902:1:: with SMTP id 1mr16149818pla.109.1570814118787;
        Fri, 11 Oct 2019 10:15:18 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id r18sm13563296pfc.3.2019.10.11.10.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2019 10:15:17 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: fix uninit-value access of variable sshdr
To:     "zhengbin (A)" <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <1570709143-147364-1-git-send-email-zhengbin13@huawei.com>
 <fe58cc1c-f15a-2b05-24b7-24d9ef6f4f34@acm.org>
 <fd1239fd-96a9-1779-f5d4-5ce91d64819b@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1aede11e-8032-2b62-0f40-cd1d3f817693@acm.org>
Date:   Fri, 11 Oct 2019 10:15:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fd1239fd-96a9-1779-f5d4-5ce91d64819b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/19 8:07 PM, zhengbin (A) wrote:
> Besides, scsi_sense_hdr is just 8 bytes, memset it to 0 will not affect performance

That's true ...

Bart.
