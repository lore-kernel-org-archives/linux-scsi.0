Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176D3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiCBFGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiCBFGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:06:10 -0500
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFD3A1462;
        Tue,  1 Mar 2022 21:05:27 -0800 (PST)
Received: by mail-pg1-f170.google.com with SMTP id 195so677207pgc.6;
        Tue, 01 Mar 2022 21:05:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=grFy95UMmw6XvQWZ5Vr9x+TwK2mEpVY3Ui9h0IeBjZ4=;
        b=c5V3UY2MeQAyynpduQCeeqcvHx+3tZiV8/JtKjLA7/ZBiDuSzK6+cRXmOFzvjufAe0
         q3TPZBIljjorACDi844klOn0pY1EcxOeqXeUDzwhL8wT8UvOmP00FRrCDq0k8ZD/aoCC
         /8EKXyyX9T4JhmiKnpdl8miTRPhQURXbUdIEE+EIboXzh0ardtMtZ5zoYtZTpbdW3CO5
         h2KSRGgy4jsucXbUrQqb90P0+NP8q4HOfNqM5ofvqO94GTRadvkzl4TjDP18uAalQHpL
         Uoc0dkxixiAg6sNGJtPRspza8rvLkFjAUVgXCZxfeyC9SZKwq8+JHHJeENKzqyRu1g0i
         FvRw==
X-Gm-Message-State: AOAM532e4hbfhDLCGS3zCAaCBydGUYGhNWguamgTbCuhC4XzOIIlW2gh
        VI1Qv24dFMHkDzAozKnKXDXzHHEJyCsYGg==
X-Google-Smtp-Source: ABdhPJzF/kXNU/ZHajn5wh6Te0YLvbIb4Sj2XeBYEqdx1dObioM/pdgrxoOY8j+rwSnDCg0PPOPkeA==
X-Received: by 2002:a05:6a00:1a04:b0:4e1:786c:cce3 with SMTP id g4-20020a056a001a0400b004e1786ccce3mr31231669pfv.81.1646197527155;
        Tue, 01 Mar 2022 21:05:27 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b004f40e8b3133sm3755946pfw.188.2022.03.01.21.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 21:05:26 -0800 (PST)
Message-ID: <c61b6a0d-c3b5-30e2-14c5-efa7ea475c23@acm.org>
Date:   Tue, 1 Mar 2022 21:05:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: move more work to disk_release v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220227172144.508118-1-hch@lst.de>
 <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org> <20220301125632.GA3911@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220301125632.GA3911@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 04:56, Christoph Hellwig wrote:
> On Sun, Feb 27, 2022 at 03:18:24PM -0800, Bart Van Assche wrote:
>> The second issue I run into with this branch is as follows
>> (also for nvmeof-mp/002):
> 
> You'll need this patch, which is only in mainline but not the
> for-5.18/block branch:
> 
> fd9f4e62a39f09a7c014d7415c2b9d1390aa0504
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Tue Jan 18 08:04:44 2022 +0100
> 
>      block: assign bi_bdev for cloned bios in blk_rq_prep_clone

Hmm ... even with that patch applied, I still see the crash reported in 
my previous email. After I observed that crash I did a clean kernel 
build to make sure that the kernel binaries used in my test match the 
source code.

Bart.

BUG: KASAN: null-ptr-deref in __blk_account_io_start+0x28/0xa0
Read of size 8 at addr 0000000000000008 by task kworker/0:1H/155

CPU: 0 PID: 155 Comm: kworker/0:1H Not tainted 5.17.0-rc2-dbg+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
Workqueue: kblockd blk_mq_requeue_work
Call Trace:
[ ... ]
