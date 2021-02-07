Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF0CC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 02:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7B164E30
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 02:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBGCVx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 21:21:53 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:45154 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBGCVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 21:21:47 -0500
Received: by mail-pg1-f173.google.com with SMTP id o21so6570233pgn.12;
        Sat, 06 Feb 2021 18:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vRl839H4B+mxYDenDA16eRhD9TENdd+1sYt4/bsdS5E=;
        b=dRzFnHqUYDC55t75C2B+5oiQw44Ie8edmgIbFIFas+mq8Ks6dzTV5c5A0OdXbXRNHO
         JxxmgLlTZCtUrQuQyT6PO34Vnh8jVIi5S5jzeNo3yA1YJMKNxqp+BLfM0s4mEfVpahuO
         pmMgaXx2Va4PczfPhJWyQNCog1kTAeHIojjVgg6DUJO6aQRCggWcqp4meyeDwEqU3tfD
         kfz0OZ8eEu+dLMoPsDIDEmYumFIK2j3EJ4Y05NDukcnhN8DO1bAKO2QjB9WEkrVR1J83
         IP2cIH2ItmqkBOYSI2OrMKsgaX5JZ1msGr8Iy0V4N4mU+oo+Hs5WXAxrWdOsty0OQJhX
         6Hbw==
X-Gm-Message-State: AOAM533C2/JSwfkiAuMYpV+VJhaZIdTSI1BaVNhv1m7SnTy9tnl6ChLH
        M6T68pQPXWTszxvMTiB0wdj8MIuHSdc=
X-Google-Smtp-Source: ABdhPJx6vTQo7mESg+A9IbIFkQIw9J3WMrk2kfxnrZBw3pzABcHGC7foI/5nrEimPKT3KQwSMxMHqA==
X-Received: by 2002:aa7:961b:0:b029:1db:532c:9030 with SMTP id q27-20020aa7961b0000b02901db532c9030mr2566771pfg.30.1612664466124;
        Sat, 06 Feb 2021 18:21:06 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:7d2:d17b:df07:7747? ([2601:647:4000:d7:7d2:d17b:df07:7747])
        by smtp.gmail.com with ESMTPSA id r68sm3415446pfc.49.2021.02.06.18.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Feb 2021 18:21:05 -0800 (PST)
Subject: Re: [PATCH 08/11] target iblock: add backend plug/unplug callouts
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-9-michael.christie@oracle.com>
 <BYAPR04MB496546E04938C9B78B71401586B09@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <19d5fe27-cf06-72b0-5351-5b41f711d2b5@acm.org>
Date:   Sat, 6 Feb 2021 18:21:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB496546E04938C9B78B71401586B09@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/21 5:06 PM, Chaitanya Kulkarni wrote:
> On 2/4/21 03:40, Mike Christie wrote:
>>  
>> +	ib_dev->ibd_plug = kcalloc(nr_cpu_ids, sizeof(*ib_dev->ibd_plug),
>> +				   GFP_KERNEL);
> I'd actually prefer struct xxx in sizeof, but maybe that is just my
> preference.
> Not sure what is the standard practice in target code.

The above code is easier to verify than the suggested alternative. With
the alternative one has to look up the definition of ibd_plug to verify
correctness of the code. The above code can be verified without having
to look up the definition of the ibd_plug member.

Bart.


