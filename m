Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87360C4708F
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 02:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C1B3613D8
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 02:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCCdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 22:33:51 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:44786 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFCCdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 22:33:51 -0400
Received: by mail-pf1-f180.google.com with SMTP id u18so3721922pfk.11
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jun 2021 19:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHElNFINwehYjyJWqeQbMdfw4TnV6yMdBeI9SwqKJz0=;
        b=EbXvYbX4+e7O8PSsoTLzSyxq3jlSfyKgdD2tpmw33NKPBazsOFdJa5oHKE6q71v3/c
         KDpveXYQ81FFqaksuSZHlRviI5CFLrpvVxSJSOAKVYjZpP60GlpyiHJItP6MG0ZAIpcP
         JLihUsWx6C23pfOvR3dbkGlnTJAoWX3xfJxEjpK497NVAVq2vAibUvwZFS2zikrVr0O6
         Qs/4g0HKc9eK/DVyjFjpGCdwC48luCYXnbLKe91R6hFln4leAktQ5uj3UjtUfJPARphx
         WzGNg2Ir+VAGGm4eZYpDJr/PWNukjwlCDeRO2gUIBNNeNfPnTOikt1hP5AEDRDG5iSZO
         dk/w==
X-Gm-Message-State: AOAM533jViQUeoVUChPKBFJWIQN0t0YzdlHLZhc6zP35UsJ+ozRNUkcY
        YyE4ITn6FTHY3aruCmc0fIM=
X-Google-Smtp-Source: ABdhPJxWiQspOQVpk8bWRsTqptZnKyqDSvGf0bOpHz6X4e6ABxubuxQAf7rOzNOeLWhOhE2owxuwkw==
X-Received: by 2002:a63:1e4f:: with SMTP id p15mr37168817pgm.40.1622687527329;
        Wed, 02 Jun 2021 19:32:07 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d14sm573382pjc.56.2021.06.02.19.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 19:32:06 -0700 (PDT)
Subject: Re: [PATCH 2/4] scsi: core: fix failure handling of
 scsi_add_host_with_dma
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-3-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <95812a80-8b99-da12-7935-dc23ca81b7ea@acm.org>
Date:   Wed, 2 Jun 2021 19:32:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 6:30 AM, Ming Lei wrote:
> When scsi_add_host_with_dma() return failure, the caller will call
> scsi_host_put(shost) to release everything allocated for this host
> instance. So we can't free allocated stuff in scsi_add_host_with_dma(),
> otherwise double free will be caused.
> 
> Strictly speaking, these host resources allocation should have been
> moved to scsi_host_alloc(), but the allocation may need driver's
> info which can be built between calling scsi_host_alloc() and
> scsi_add_host(), so just keep the allocations in
> scsi_add_host_with_dma().
> 
> Fixes the problem by relying on host device's release handler to
> release everything.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
