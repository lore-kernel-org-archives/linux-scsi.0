Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDFAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 16:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 920B56141B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 16:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349805AbhI3QVw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 12:21:52 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:41907 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349579AbhI3QVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 12:21:51 -0400
Received: by mail-pl1-f171.google.com with SMTP id x8so4394907plv.8;
        Thu, 30 Sep 2021 09:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yG1/o+/DnMH77sK/4dZhI1SBFsLkmeMylzKyExyvyVo=;
        b=VMOMxXrk3WipEBkwtyRKsqEK/+hGcd6Xyv2//4vlFXzFr4kYcDxEG8qPMfLnEJCU46
         L7lGjp3A0jTO7A2w8Nu9vj/3qfEVpzcHp31SFcuzf94+yQmtPAh9QBCO9Y3Jnmutz2xw
         MW6bzrww9mCCWv3YOkSvSuLEczumDBQJ90fmE/1PAdpbxWqCsNk8VgYGoV5dw1vL18hT
         H11wBYoQlxdKpldScRPa3o3ayID3taRq+xPtIPuGhyMcH8kdQlFOyVpF688PGFKjum+8
         LnyIqX5W5cgx7EUQDNi1C7LTqesPp3ShBYA1LoOaNYByN+Xxo+D51IMNoDFDWmGKUkwr
         gfJw==
X-Gm-Message-State: AOAM530cKxHipAVZYvrPwObMt6VEtaijjkgs3l4IOMchU6wlXElRJ/Ft
        Z6HvhDfPKGLUXEd1CrQLx1g=
X-Google-Smtp-Source: ABdhPJzaCOnFZETcMKaHwCPxzFz713M2S082LglpsjtX0j5t65Ek+coBFDcqzxklnkgshMeKu30lrQ==
X-Received: by 2002:a17:90b:104d:: with SMTP id gq13mr14201836pjb.101.1633018808562;
        Thu, 30 Sep 2021 09:20:08 -0700 (PDT)
Received: from [10.254.204.66] (50-242-106-94-static.hfc.comcastbusiness.net. [50.242.106.94])
        by smtp.gmail.com with ESMTPSA id t15sm3663221pgi.80.2021.09.30.09.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 09:20:07 -0700 (PDT)
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
Date:   Thu, 30 Sep 2021 09:20:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 12:13 PM, Javier González wrote:
> Since we are not going to be able to talk about this at LSF/MM, a few of
> us thought about holding a dedicated virtual discussion about Copy
> Offload. I believe we can use Chaitanya's thread as a start. Given the
> current state of the current patches, I would propose that we focus on
> the next step to get the minimal patchset that can go upstream so that
> we can build from there.
> 
> Before we try to find a date and a time that fits most of us, who would
> be interested in participating?

Given the technical complexity of this topic and also that the people who are
interested live in multiple time zones, I prefer email to discuss the technical
aspects of this work. My attempt to summarize how to implement copy offloading
is available here: https://github.com/bvanassche/linux-kernel-copy-offload.
Feedback on this text is welcome.

Thanks,

Bart.
