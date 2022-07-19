Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A31EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 18:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbiGSSI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiGSSI5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 14:08:57 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339BD48EB1;
        Tue, 19 Jul 2022 11:08:56 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id w7so226320plp.5;
        Tue, 19 Jul 2022 11:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7MiZysmczU7UnTDpbAdedFqdy/EQ9HsgenZiYdkozzs=;
        b=H2pLxzruQhMn4l4qZI42eA7Mt56tvji6s1ca/GyiSnyu8hecHHKgYoLvjqTk/AwZ/C
         psAAausOipt23GmjfawQxVU4iszs0mh0Y15SklLtM4VOmV4owBw/Ipe1kK620eDejrcm
         1kHxd33nGegPlYcuD5rRzYZEin5UBl215ST0K0pl6LiXZCXaOKlbBWdUpeqEbh8f/xSu
         R+U19VDNJU4odfU9lTSCazP/v9hXzKwsd/l62+hSEYZHQcE2C8OlPHBLgasoJnFXHA71
         UdTsW8+nsS6TGiLheAXP+jLHyAP8aGqBo9uMvR/E3wDqJRAojrxn5u8y5gHULNhQQRtk
         k31w==
X-Gm-Message-State: AJIora9+OyFJ+R4iDIGfC6md30Twq5K4FmQmw6dxs5yne31ABFvZ/li0
        dzinIxr/JoH0AQxMGT6FvUo=
X-Google-Smtp-Source: AGRyM1teUnV5oCYMGhARB7o9AEKuKnCtmNXXmzhMVIiVoD6UviM6TTDbpcMLArw2pgXZ+RPiwLUvLw==
X-Received: by 2002:a17:90a:9b03:b0:1f1:85b2:c52b with SMTP id f3-20020a17090a9b0300b001f185b2c52bmr614201pjp.159.1658254135544;
        Tue, 19 Jul 2022 11:08:55 -0700 (PDT)
Received: from ?IPV6:2600:1010:b002:e126:5611:6026:69c2:37bc? ([2600:1010:b002:e126:5611:6026:69c2:37bc])
        by smtp.gmail.com with ESMTPSA id i6-20020a056a00004600b0052592a8ef62sm11835507pfk.110.2022.07.19.11.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:08:54 -0700 (PDT)
Message-ID: <2f0cba61-b98a-9b14-6bb5-700f2b367e3b@acm.org>
Date:   Tue, 19 Jul 2022 11:08:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: fix WARNING in scsi_alloc_sgtables
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de,
        syzbot+d44b35ecfb807e5af0b5@syzkaller.appspotmail.com
References: <20220719080026.1595874-1-yanaijie@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220719080026.1595874-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/22 01:00, Jason Yan wrote:
> When iovec_count is non-zero and dxfer_len is zero, the sg_io() just
> genarated a null bio, and finally caused a warning below. To fix it,
> skip generating a bio for this request if dxfer_len is zero.

Since this patch is a bug fix, I think it needs a Fixes: tag.

Thanks,

Bart.
