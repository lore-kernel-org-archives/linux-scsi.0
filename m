Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87A1C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 14:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A11B664E2A
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 14:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBJOp4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 09:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhBJOpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 09:45:54 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C31C061756
        for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2021 06:45:12 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id z18so2016606ile.9
        for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2021 06:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ysd4jTSM/A3Qbvo3IAamzntPbVEsPTPu5msfcyC0amY=;
        b=n/cl3sU4LxnsDfTlbLqkffWFtoeo/limIQtoBM8kz/2fWU2gL1fPfJ2kXfAXu+gcVa
         nhqwc2x/5b+bogrjP+YNHvnzG7LtQmY33VDtQ62/D9hiL2S5l/2QbIzpsE289QYd6INV
         nCKWcb+Gosn6FHz6FRn6UaGFwchiiA21g7C/I/Rk/3JMwzK3Fhid1vmH6BBZR5XNUD66
         mKBuFGIU1gH3EN9fT9WHhMQLyByOlJPpbX8FOwRPocPek2Odww3BhWLT08k9vvqR5dY3
         ibIT8pO4WLWI49PogeDRiDHb7DJoJlU8HLwX0Gkep21uFk+o/WsAEuuS+dVFarSG+vSz
         c8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ysd4jTSM/A3Qbvo3IAamzntPbVEsPTPu5msfcyC0amY=;
        b=rTbmWsVCEaPOmy1POk9JbAiSu5UTsr6o6VhTl+Dv5CsmQPNIYRZp4uVm8WPnw9BBDD
         F/2RsADzdcwRMWx8w7sU3B+EJCMXaRssAZbTwGf0ckdj2/CzDFsTLUZCKRCFgqRdDNYG
         9aCnxMU8Lz6xEpUI7dDHWfdolKG+rn2jTPJOfpHbANlcUuFjbujcrWmuDWjwbJZ5tGK5
         mHt17NIMYQywOj578QIqiim2KmZHDlR81kuzputZbvFiUghPNRfRxAySAzCAN/tcV+HB
         0doC7b9Ga6YjKeeLGNQ45cZmd4fjAKcpWhfoizxdIcA9WYICy32/5jYhzfxZKJT1DBVM
         IrkQ==
X-Gm-Message-State: AOAM532Xf1GqAyk/04Cf3FW/HDWowTAgRiE9YVLrbfDQ0lGrhOegnWMF
        I4OQatcX9wzUHbM5BS9LvlNQRQ==
X-Google-Smtp-Source: ABdhPJzLNMS1CqKK3WC8WmbvmcLOE3sfTRaTeeyEbcdTj69ndKl5ePzTxDZuwjdkwGqxqKGNIyEpJA==
X-Received: by 2002:a92:4b06:: with SMTP id m6mr1345567ilg.177.1612968312334;
        Wed, 10 Feb 2021 06:45:12 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h9sm1086368ili.43.2021.02.10.06.45.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:45:12 -0800 (PST)
Subject: Re: [PATCH v4 0/8] block: add zone write granularity limit
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cfe15751-e07e-101f-49d8-a2f184e30618@kernel.dk>
Date:   Wed, 10 Feb 2021 07:45:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 9:47 PM, Damien Le Moal wrote:
> The first patch of this series adds missing documentation of the
> zone_append_max_bytes sysfs attribute.
> 
> The following 3 patches are cleanup and preparatory patches for the
> introduction of the zone write granularity limit. The goal of these
> patches is to have all code setting a device queue zoned model to use
> the helper function blk_queue_set_zoned(). The nvme driver, null_blk
> driver and the partition code are modified to do so.
> 
> The fourth patch in this series introduces the zone write granularity
> queue limit to indicate the alignment constraint for write operations
> into sequential zones of zoned block devices. This limit is always set
> by default to the device logical block size. The following patch
> documents this new limit.
> 
> The last 2 patches introduce the blk_queue_clear_zone_settings()
> function and modify the SCSI sd driver to clear the zone related queue
> limits and resources of a host-aware zoned disk that is changed to a
> regular disk due to the presence of partitions.

Applied, thanks.

-- 
Jens Axboe

