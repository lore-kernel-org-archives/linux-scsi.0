Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C20C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 02:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173AD616EA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 02:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhELCW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 22:22:29 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:43909 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhELCW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2021 22:22:29 -0400
Received: by mail-pg1-f181.google.com with SMTP id k15so4344830pgb.10;
        Tue, 11 May 2021 19:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=daaDmlZfNtYf87e9KKZ0tzPnbye9JR8o5YOaGDdi4mk=;
        b=Opqe41XFmYsRx5pv4ZbRoFOXCHq6PmzEBBhRppPD0BsVYgkGeKIZY1JrmQAi5BcUnF
         aqq+eJ3ID/P+eZeSjCaOlD5+FLFdRDpboWtcG6QRAgBiMdnj6rX3Ol3YBaQEBF0Q5R59
         tmT3dcRimIPRra+EumbJWL4+4oEkKn+UGkJYn0Qb/4cXyt9hcu2k4NZ0c7LT28h9YfQw
         qnx1WUw1I3JYyxG7uaBhaBiBwUQr32Gw9kHQxwPPSs30uwUcPlLnU5DGS63Z5b0hq45S
         98Do/PC2i1BvcOVvzqdaO3EZXo1VMNerJ24RdxwcSrsVjCvFjyZ5RoetoTIQMqOtWhJ7
         x+YQ==
X-Gm-Message-State: AOAM530qJFHPE885M5X9fWAOMlZKOwEinmN7glGJLbBrIB8MJAEkKxpU
        pMuwDF2jEzlW3Yh4/ta9+Mc=
X-Google-Smtp-Source: ABdhPJxg29un7hemzeM5RTmLf4VW113rEN7QX/F07mMfJ5zwt/qmJ20P8JnH+74H64FqIu6d5/qcuA==
X-Received: by 2002:aa7:8e85:0:b029:28f:2620:957e with SMTP id a5-20020aa78e850000b029028f2620957emr33862188pfr.40.1620786080715;
        Tue, 11 May 2021 19:21:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:76b9:3c77:17e3:3073? ([2601:647:4000:d7:76b9:3c77:17e3:3073])
        by smtp.gmail.com with ESMTPSA id w74sm14613953pfc.173.2021.05.11.19.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 19:21:18 -0700 (PDT)
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
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
        "osandov@fb.com" <osandov@fb.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4b8985f1-8a94-d611-e9fb-1b5e32a19f1e@acm.org>
Date:   Tue, 11 May 2021 19:21:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/21 5:15 PM, Chaitanya Kulkarni wrote:
> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
> 
> I'd like to propose a session to go over this topic to understand :-
> 
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?

Are there any blockers left? My understanding is that what is needed is
to implement what has been proposed recently
(https://lore.kernel.org/linux-nvme/yq1blf3smcl.fsf@ca-mkp.ca.oracle.com/).
Anyway, I'm interested to attend the conversation about this topic.

Thanks,

Bart.
