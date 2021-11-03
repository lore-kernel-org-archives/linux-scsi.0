Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6A3C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD8D61101
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhKCTau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 15:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhKCTat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 15:30:49 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DA9C061714
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 12:28:12 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id x16-20020a9d7050000000b00553d5d169f7so4980453otj.6
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 12:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UePDyJ5YGTt0SI7wSYrq2teto/cQR2vkkj6nAm2W3a0=;
        b=iJPu7qjoWnWpnlD3pbi8ofB5MCwNTChZ4jlIPjBLmxcCizs6UsV3G8NIpJvwQns6xz
         Mcu2063seKgTdnAoui3FtZzMw8tih4oa/T0SA1zkZ8TWIgMTCTlvKwUnRQJJX9o8hTQo
         NO5VmJ63MSPyzGtQlLxtrNhEUEkrQEkpnINZoI7anc9hmGLMdLfv28zMqBiXyzp7XfrI
         Ch4low2MMbl4FMIg2eatNVS8VMh4Fy+7tyv+dPfwdSjjwvwv6LXIR/YJ6bywUGJoXBmN
         xJ2/AiVAJMuY6c1kefCFBdNCE67M6OuV9vkZKDH4WRUFtlR5dRH6zzPvPZ7M7qHdques
         FncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UePDyJ5YGTt0SI7wSYrq2teto/cQR2vkkj6nAm2W3a0=;
        b=4fQEfMNh1TqTcK9xEVTg0BloAOHUw+/2GJbrJ+Q28GDs+3x9J8yrbRIJoz4eis4K5A
         BfSxSXf+eLS+l2v7bxL9Sm2g/mPdRTbdVW++qzeNDhAKWNSVOG3zDRyzhHIqK1JnQYCN
         c/dCgZhPHspgFiVzq8YPmCJftcA4WBd2ICZ3fIb501PgafaQvuMu0B4559p3BK+oe1VC
         mSjMnhSxdl93EJLUQgflHokxmx3QVte3g68Q1Txk7doMr2aRZBwhuX0KNv+m71h8ybcZ
         rY7DVNfnLk4hPaw3e5wQT7CjAxUGeX+J3fBrq8Sx+gMQYuOZi9uf5azeZv0R2BVOngpa
         bhlQ==
X-Gm-Message-State: AOAM53367XVgruigMGFnj2KKuFQUeVvRmHHaDs1l5SYJC55+r7JET/Td
        Xz4GMXiwCB/Dsg2kmMXtJ4hM7Q==
X-Google-Smtp-Source: ABdhPJyDHe9v7v0ovnKDw8B7RfOBJHhSliZhy8hiaOCde7In7CDoT4l8tvqDIUDUaywzpQBTQ1nVDQ==
X-Received: by 2002:a05:6830:2058:: with SMTP id f24mr19740345otp.248.1635967691754;
        Wed, 03 Nov 2021 12:28:11 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c1sm790336otl.71.2021.11.03.12.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 12:28:11 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] last set for add_disk() error handling
To:     Luis Chamberlain <mcgrof@kernel.org>, hch@lst.de,
        penguin-kernel@i-love.sakura.ne.jp, dan.j.williams@intel.com,
        vishal.l.verma@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, richard@nod.at, miquel.raynal@bootlin.com,
        vigneshr@ti.com, efremov@linux.com, song@kernel.org,
        martin.petersen@oracle.com, hare@suse.de, jack@suse.cz,
        ming.lei@redhat.com, tj@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211103181258.1462704-1-mcgrof@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e01938a3-11c9-e368-65da-fcb5830e5a4c@kernel.dk>
Date:   Wed, 3 Nov 2021 13:28:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211103181258.1462704-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/21 12:12 PM, Luis Chamberlain wrote:
> This v4 only updates the last 2 patches from my v3 series of stragglers
> to account for Christoph's request to split the __register_blkdev()
> probe call changes into 3 patches, one for documentation, the other 2
> patches for each respective driver.

Part of the reason why I think this has taken so long is that there's
a hundreds of series, and then you get partial updates, etc. It's really
super hard to keep track of...

Can we please just have one final series, not 1 and then another one
that turns the last two into more?

-- 
Jens Axboe

