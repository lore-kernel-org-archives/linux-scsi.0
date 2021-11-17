Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA71EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 15:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26A261261
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 15:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbhKQPzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 10:55:45 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:35741 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbhKQPzp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 10:55:45 -0500
Received: by mail-pl1-f182.google.com with SMTP id b13so2553074plg.2;
        Wed, 17 Nov 2021 07:52:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hfy7Gp3+JeXESUrx1Gbx2zkhaFaWF3TcaVpxpcqkTgE=;
        b=qliwbOrww5KAByjnOAqAYU5fek/NrZUvH7eY+dDZM7UqhdnVR5neFcIHQ+0an6XM95
         SoLEiXXxsOeE+eiPLP9uQlfsgMIna3ufOlS3dHtI/UjFJ7P49BTDLf825BeX1yhi9l4N
         IrVo6OUzxRgQYCu1uun7xj+nylmLS/my2zOBv5B/B/mDHm8xeh34sUunSNQFSb0i11NS
         zk9boeJkswrB2g9WE2D30PpLA/QWFa1o1cXSQZmYGAe3yc3mHuA9cU+qmI7IFfhlGhDu
         nLK8X0uayuzOYOatTvzyCfThPukntPeA/6GlT+K4DIjwvygVcS6+aDPa95jzSzlfsZri
         Y7JA==
X-Gm-Message-State: AOAM531QVClcfiB0dfynaPuIMczq+klFEdsDuZ5vf5OZ/kTi2as9QO8R
        AWSk+7S6lYbA5PcWifXpzQs=
X-Google-Smtp-Source: ABdhPJxm8WqyX8LthpnLwyvUjiFp2PmfTmFgScb1CA1TW0//yPGqt3+fmIM8D+HX4+Lp5dSpUb7G3w==
X-Received: by 2002:a17:90a:d70a:: with SMTP id y10mr855973pju.36.1637164366198;
        Wed, 17 Nov 2021 07:52:46 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h196sm71706pfe.216.2021.11.17.07.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 07:52:45 -0800 (PST)
Message-ID: <553c2a78-1902-aa10-6cc6-a76cbd14364c@acm.org>
Date:   Wed, 17 Nov 2021 07:52:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Content-Language: en-US
To:     =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
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
 <20211117125224.z36hp2crpj4fwngc@ArmHalley.local>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211117125224.z36hp2crpj4fwngc@ArmHalley.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/21 04:53, Javier González wrote:
> Thanks for sharing this. We will make sure that DM / MD are supported
> and then we can cover examples. Hopefully, you guys can help with the
> bits for dm-crypt to make the decision to offload when it make sense.

Will ask around to learn who should work on this.

> I will update the notes to keep them alive. Maybe we can have them open
> in your github page?

Feel free to submit a pull request.

Thanks,

Bart.
