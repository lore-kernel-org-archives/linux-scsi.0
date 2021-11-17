Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104B3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 12:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E358E61465
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 12:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbhKQM4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 07:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhKQM4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 07:56:51 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BA9C061570
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2021 04:53:52 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so2027305wmb.5
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2021 04:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hss0my1U543SYA62Ffactpc9+//eg0/Fsm4KpfOP4TA=;
        b=cNSGVCgXy2Jr0DDROORE8h8J8ohDTgYgTeZwzXZy1XX72D7vMjy8+FDF8OElAFsPlt
         YU9hPx/B9RhVz9/JaIqmgAPMZsUtogLmKaV2ijNZ05+Z/4iFpO3J8Umt6jEbcvAWAcZK
         mcrAEBQkoqFKbQKvlwGe8/9d/35yaUQoHDbiLSEQR+TrKeunKkyCyKnQZJWWVlKj1RBP
         AZ1vSLkAoORo7sWj9raNWButcAjsPxq5x4irMkgt8Vh/lC9uY2RebAWWlyQfk7rpPU8I
         H96skOZMMuajYOxCQGi9C76/4onuRGkYVs1n7zwvLjpY4xg/f+XVlxq+ev/f9uqThiNu
         wsqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hss0my1U543SYA62Ffactpc9+//eg0/Fsm4KpfOP4TA=;
        b=A8VpQ5arnkixukLY5v30pqSo9i5AEE/Z6PBY4HO+/bYaHO+Wex7J2e4aBhhlhScOWO
         /+eBOglv+2WVS0VA4YG4rzGjq9sI6nrJU+0GvI4J2X40VWVVarHUdxdAMIwRdOK6axFF
         PFG2bHYxxcGxxnGYjJCQbbMp8CePjdsETwj81FjE2YDiptwE1zEXwAp2D52fVkKsXUVO
         9iFxGcTmyGZ+dxL3pmtGrkXUaTE6Mf7OSeRBhqR0lcbZ6vkoE9smWwnqVBWIYpCTZZPv
         kydlbBB8KGcJxrKWmL4q38ttcS5NhiOF1aA8cpWEVT8qy+aizbPAG92I6mBP81vEP6T+
         yFRw==
X-Gm-Message-State: AOAM53310lGNEG/awgmDuMStEi+ho43M3oKk01rxyv+1B60pBQk7kR0G
        XVO8eu38Z+tQp6Gw8G6Uhgb/aw==
X-Google-Smtp-Source: ABdhPJxOXnHxfcN/nA4AKyAuhHjB0XGlYF1ByvmNcUHfw88xbXLPy+hq3hyfltHTbv+vqGO7YiaBXA==
X-Received: by 2002:a1c:43c2:: with SMTP id q185mr77977369wma.30.1637153631243;
        Wed, 17 Nov 2021 04:53:51 -0800 (PST)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id w4sm8368899wrs.88.2021.11.17.04.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 04:53:50 -0800 (PST)
Date:   Wed, 17 Nov 2021 13:53:49 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211117125224.z36hp2crpj4fwngc@ArmHalley.local>
References: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <20211029081447.ativv64dofpqq22m@ArmHalley.local>
 <20211103192700.clqzvvillfnml2nu@mpHalley-2>
 <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
 <ab4ec640-9a89-ea25-fe68-85bae2ae5d8d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab4ec640-9a89-ea25-fe68-85bae2ae5d8d@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16.11.2021 09:59, Bart Van Assche wrote:
>On 11/16/21 05:43, Javier González wrote:
>>             - Here, we need copy emulation to support encryption 
>>without dealing with HW issues and garbage
>
>Hi Javier,
>
>Thanks very much for having taken notes and also for having shared 
>these.

My pleasure. Thanks for attending. Happy to see this moving.

>Regarding the above comment, after the meeting I learned that 
>the above is not correct. Encryption in Android is LBA independent and 
>hence it should be possible to offload F2FS garbage collection in 
>Android once the (UFS) storage controller supports this.
>
>For the general case, I propose to let the dm-crypt driver decide 
>whether or not to offload data copying since that driver knows whether 
>or not data copying can be offloaded.

Thanks for sharing this. We will make sure that DM / MD are supported
and then we can cover examples. Hopefully, you guys can help with the
bits for dm-crypt to make the decision to offload when it make sense.

I will update the notes to keep them alive. Maybe we can have them open
in your github page?

>
>Thanks,
>
>Bart.

