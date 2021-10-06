Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA139C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 17:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F106113A
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 17:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbhJFRf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 13:35:28 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:42839 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhJFRf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 13:35:28 -0400
Received: by mail-pj1-f46.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso471335pjb.1;
        Wed, 06 Oct 2021 10:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b0udGD6yPXFIVJbeGvfLIzJwm0LmddvqozG4vFBfvTE=;
        b=ZPqNZPwXBI6xmgS3O7IOfXqglzgK11exax56Pds4fVYOeKSP6G8DA7zkj7hqneepWC
         A+jWU+ewLPCT71vKfNiI58SJJcrs6NusRRSmv9afagfoexsQeFdCSoQ40gO/+vFT3m2q
         kv7+tKpZGpJjCAxvJKzko8Sl4d+HiVOENhFP6sAzS7bjLCg/9+Jz2fBonj6Rc6mI9NiX
         8UfSqnNiPKd8b3I9hvV903ep6yC/OXpFmbDdWOHJBDhNuT3vHGrMKvuGZbesTqoisMeV
         +7LhwWd4RgIUmTL9Qzx5Mx0cX6qAzEUz0DUEMc6UhZlZ9Ih+BqYCWVDqkROCaoJh81V7
         qbiQ==
X-Gm-Message-State: AOAM530cD1FfkwXSfaRtKLS5PeGk+b8Ym18/UW6WQMGCq8c2BtCqZoxM
        cFC0RBK7uoVl78idHCEygws=
X-Google-Smtp-Source: ABdhPJww5vn0LIX4yaBzMmvw+4zhd9LR+fC9FR6Wt5P5+rHOabghLfn4cJcj1iGMZ4cyBz8ApUN3GQ==
X-Received: by 2002:a17:902:e801:b0:13f:255:9db5 with SMTP id u1-20020a170902e80100b0013f02559db5mr1022291plg.23.1633541615361;
        Wed, 06 Oct 2021 10:33:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6ad6:c36f:fdfb:9e74])
        by smtp.gmail.com with ESMTPSA id c15sm9368288pfp.39.2021.10.06.10.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 10:33:34 -0700 (PDT)
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
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
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
Date:   Wed, 6 Oct 2021 10:33:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/21 3:05 AM, Javier González wrote:
> I agree that the topic is complex. However, we have not been able to
> find a clear path forward in the mailing list.

Hmm ... really? At least Martin Petersen and I consider device mapper 
support essential. How about starting from Mikulas' patch series that 
supports the device mapper? See also 
https://lore.kernel.org/all/alpine.LRH.2.02.2108171630120.30363@file01.intranet.prod.int.rdu2.redhat.com/

> What do you think about joining the call to talk very specific next
> steps to get a patchset that we can start reviewing in detail.

I can do that.

Thanks,

Bart.
