Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2EDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 16:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E731861372
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 16:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhJEQZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 12:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhJEQZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 12:25:07 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91655C061753
        for <linux-scsi@vger.kernel.org>; Tue,  5 Oct 2021 09:23:16 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 5so12426885iov.9
        for <linux-scsi@vger.kernel.org>; Tue, 05 Oct 2021 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M0Efx4uhwfEZ38PmTZibKc9Nb9ZIpo8xruB3JZpP6uY=;
        b=ngv9K44X7yg3xjCLFbT/JX4x2Urt8rVeiKPi8W3zQW+9ttlooQ0a6+fvDpFA7JygAl
         syiSYblYBf6k2hGFF1yUh3muW7BKpoxCAc4ZEv+VR/ljkzHpSTlLr8JDF1L8CEFe05Y0
         r/UWVhUE1pMDv4VgAxh0kuqy8mxRaakm6ZA/PQJ2bmZN6r0kI/7/kIxNMAMDyV9VVnvd
         TGpdytgPyFxs0wcTyH0pxe1AHdCUJdskUIbGKro70Pvfa+1hkMh+Vk+yrw0IssXti+GA
         rrsnY7oDDvQuQVGzzOlOE0jKXad0XZnN2XDL1nXj1tbFbMYvW+WzVsPuPxRbiuNLg1bS
         paZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0Efx4uhwfEZ38PmTZibKc9Nb9ZIpo8xruB3JZpP6uY=;
        b=6noVihCRi4UdOjTeCRIwlsPITWOl/Zem4Q3Kk1AwFFyHG1/pgzmqSp+kUqqJ3C9WKe
         71X+uNdsyJvYUMXIHGIpt+/tBsjPiOdZ70uimuyvVWYCg8+wcarJ9q/oF1EVMJdFwxW8
         nlzSADrV+QuTNe3spWh8GWlwzOyZD6cnPvXhp9zftonQQYwuCb5/xgH2xCoq9wmojlzf
         H+jNcmeR7wnzLRa+fD4x41wFBUAkSQ/yx6DUIcjG1Afqc4lZBJ3bwMQD9yQEJvIGGGXO
         GKyoCFiyWkxxcnTR+9hgipWmN/0PBZ/BAS8vTDVOtwmZSF4jeZUscTOEwR6OmyACd65R
         LuAg==
X-Gm-Message-State: AOAM530X6Y+8E1xDA0OFJ3TqaNdnTdBNYRVTJHfTkcVPibknp9pMWWwb
        LaexF1M/l/ZH4+jhSs0s2ZC9qJo6W6G6X6luusE=
X-Google-Smtp-Source: ABdhPJyRBO2ZaWNNx9oMLxgSdzZt7zm1f0qHmfeVh7Otsqjj8H9nU4lh/eapGuyMyQ4riKNsyq/nzg==
X-Received: by 2002:a5d:9d44:: with SMTP id k4mr3043652iok.112.1633450995779;
        Tue, 05 Oct 2021 09:23:15 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k7sm2204139ilq.37.2021.10.05.09.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:23:15 -0700 (PDT)
Subject: Re: [PATCH v5 00/14] blk-mq: Reduce static requests memory footprint
 for shared sbitmap
To:     John Garry <john.garry@huawei.com>, kashyap.desai@broadcom.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
 <ae33dde8-96e8-2978-5f32-c7e0a6136e8e@kernel.dk>
 <81d9e019-b730-221e-a8c0-f72a8422a2ec@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1217e922-8bd5-9c2c-b7b0-1b75fff9ee04@kernel.dk>
Date:   Tue, 5 Oct 2021 10:23:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <81d9e019-b730-221e-a8c0-f72a8422a2ec@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 7:34 AM, John Garry wrote:
> On 05/10/2021 13:35, Jens Axboe wrote:
>>> Baseline is 1b2d1439fc25 (block/for-next) Merge branch 'for-5.16/io_uring'
>>> into for-next
>> Let's get this queued up for testing, thanks John.
> 
> Cheers, appreciated
> 
> @Kashyap, You mentioned that when testing you saw a performance 
> regression from v5.11 -> v5.12 - any idea on that yet? Can you describe 
> the scenario, like IO scheduler and how many disks and the type? Does 
> disabling host_tagset_enable restore performance?

FWIW, I ran my usual peak testing on this and didn't observe any regressions.
Caveat being that a) no scheduler is involved, and b) no shared tags. But
at least that fast case/path is fine.

-- 
Jens Axboe

