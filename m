Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB2DC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 17:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5D261181
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 17:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhHWRWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 13:22:08 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:40825 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhHWRWH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 13:22:07 -0400
Received: by mail-ej1-f51.google.com with SMTP id lc21so6123687ejc.7
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 10:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xFZ1nwqiJ3yMX624wDBY6+6QGWwRvaBOfsjCWVShAnQ=;
        b=YTdnDBMEbSmIoBMH7q22/vZNh6CSfhgMDZClxyDtW5lZLQPRIuuXAp7pRanEQOf2uI
         werUFK+0BXPTcNgXTcG2DQ3wzEAxNo1In6KCHwdj7r3YSYy/U5Rhzmd1R1UNKZ2P6z8Y
         5uRMJhdXf65wzjdnWR5MFtahw9lSvbEjFTbvbkqyJBFHquXONiPqlCAMFS6TAswGEGFJ
         omvJIiY4F3/W5z9tBlkBe/gXV2UBuOWNGCnQAHCPZuoAoXGxKxo5Xqr0MArJTRelglda
         x2vbNawORhSSNI4CzDeUMWDNDGoYrBHaGc1le6vo9dEmx4DuoydJ2scyXJxtvZ0V2da8
         dxiA==
X-Gm-Message-State: AOAM532ec/RCua4LN2p7qtmzQPE3PmSvGQxpWXf4XjKaMSKk+w1U5yuZ
        dzzJCQLe7/011PtUcxqE+CI=
X-Google-Smtp-Source: ABdhPJxbo+Z6eUdl+qvu1sBx7005ZEOwn05i+F/w0rLIPxgvvyNQ0V+gqlM83RFd04Btr1F9Bgmj/w==
X-Received: by 2002:a17:906:c087:: with SMTP id f7mr35708865ejz.487.1629739284094;
        Mon, 23 Aug 2021 10:21:24 -0700 (PDT)
Received: from [10.100.102.14] (109-186-228-184.bb.netvision.net.il. [109.186.228.184])
        by smtp.gmail.com with ESMTPSA id t16sm4668980ejj.54.2021.08.23.10.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 10:21:23 -0700 (PDT)
Subject: Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-nvme@lists.infradead.org, Ming Lei <ming.lei@redhat.com>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210823125649.16061-1-njavali@marvell.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
Date:   Mon, 23 Aug 2021 10:21:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210823125649.16061-1-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/23/21 5:56 AM, Nilesh Javali wrote:
> Currently nvme fc doesn't support map queue functionality. This patch
> set adds map_queue functionality to nvme_fc_mq_ops and
> nvme_fc_port_template, providing an option to LLDs to map queues
> similar to SCSI. For qla2xxx, minimum 10% improvement is noticed
> with this change as it helps in reducing cpu thrashing.

Does this make nvme-fc use managed irq?

CCing Ming to see if this affects his patchset.
