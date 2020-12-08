Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14CDC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 23:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE91423A7B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 23:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbgLHXAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731346AbgLHXAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 18:00:49 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2333C0613D6
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 15:00:03 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t3so13597811pgi.11
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 15:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cvX4Xg5ko6vGqIjHH66x4K4QBryzq3vXXA2jw9y8g7s=;
        b=GXND6WILUV13nGMPNsvyp3jDZl5GKURlUac6Fy1bWTowxbY6/Ty0LYcGcMZDExzJzr
         jz+hOI6q4ic3GN++qDpJy+Fj4YhKRMPpCJe920iDoJHNphm5pCxN3ym3xSumCeNvDQ73
         u9pjeY3qFpUiDo1XjFmBspf2nCeUJf6ErndeVw4gJjsORB7bqbBWy90BfgparUJ2c8xD
         cASwGT1bnldPaDRKzHNx3UWARJ4KIyoBm1jxwrmJjsvlimHeV3We98PobuR/oyqaAOKd
         WN4I+WsC//jShMx6S+Wax8hy98aONzhoqXoaq/JOpYGDwMS0zgffzHFeX3mMV0bIdF5P
         zOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cvX4Xg5ko6vGqIjHH66x4K4QBryzq3vXXA2jw9y8g7s=;
        b=XBjv870x51dWZ4EBq+NeDWHC/iKpc+nBK/v9vpyrTcUWRYjtszPFT/gdOpUkZ3Rre3
         NoKBwYO68OQvUeniDf7sVEVtnibbIHoIV2J64Har381d5ykMjjjRzk5Se8Qzde/xsFzM
         NPJ5xq86wr9fM7b2t+Mp92yf3LgvMFFFPnhexJWxfEC66di1AXQHa0FG/as4HP0lGmuQ
         ps3jjxyiDuV3XFjdNO/fM9QWF/tsWB1nKXEQYtJKe3nrQ0VeUKptIYtKCJKBkHfGvR8G
         fJOSJsGBkMdhnXXTus/ky6fAnkzOxksOg5rZUTGWAuvROHvSoPDO/4+6wlYBsqqxD0D/
         IY/A==
X-Gm-Message-State: AOAM533AmlZz2zto80pN2FHo85J4szCiIhQ3DFlreFcT8ikaDkh6dtYp
        OWkyDrIwRkNBzJTNVhlyBxjn6ilBl2tTZg==
X-Google-Smtp-Source: ABdhPJxp2R1oGJVXiZr63+jfMbon4n0SOZ/r/L2AlBnsAR7h5DkJcSKPLsOYmbePi+uRVkaf/tfpLA==
X-Received: by 2002:a65:68da:: with SMTP id k26mr260441pgt.303.1607468403277;
        Tue, 08 Dec 2020 15:00:03 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 125sm225182pfy.111.2020.12.08.15.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 15:00:02 -0800 (PST)
Subject: Re: problem booting 5.10
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julia Lawall <julia.lawall@inria.fr>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
 <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
 <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
 <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
 <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk>
 <yq1mtynud0n.fsf@ca-mkp.ca.oracle.com>
 <CAHk-=whCChtPRmGZqZM8XeCAFhfRzX8ts4RFKeXgGUyuNtWGMQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1364ec02-bfae-328e-8f55-14ac953dd30d@kernel.dk>
Date:   Tue, 8 Dec 2020 16:00:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whCChtPRmGZqZM8XeCAFhfRzX8ts4RFKeXgGUyuNtWGMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/20 3:56 PM, Linus Torvalds wrote:
> On Tue, Dec 8, 2020 at 2:54 PM Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>
>> Oh, I just realized the megaraid patch went in through block.
> 
> I'll take this as an "ack" for the revert, though ;)

You can add mine too, if you wish.

We'll follow up in 5.11 time once the other fixes have landed.

-- 
Jens Axboe

