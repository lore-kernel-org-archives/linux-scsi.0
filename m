Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB6CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 09:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC23523A6C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 09:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgLIJR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 04:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgLIJRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 04:17:54 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC70C061794
        for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2020 01:17:08 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id lt17so1070744ejb.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Dec 2020 01:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rhhiMX6lpyZpBTo++Wq1vgh3A63oG1sQxoZyJsc1aQg=;
        b=P8oh5+/uu8rb5ugbhTx6O474H6hkBIwZA2qWENj5ag15EIY80CWadHdfGxQnhTAuMR
         kbNk5JfBb6loUdVGVyaPVhWtBQ1NjpEdFVcn9tYOFB+qOgEbDjlfscYtu/qIoCbb5Chz
         7CiywHUQ67e3O04cgul518A1o0MfGZcqFpTZZnlXt5erd32JVIX/kIoOcJ7E6df5xpPw
         s6IYn+e1e1RXF/Z/qwRHiSnu9S2JvHXZspsCFFn7MliNwtnecrsJyM+LopbOJALx3N8D
         G9qQkXTWUv6aPxfla3mKnk96yIxMBMESNCDYDoAhR8RSGIVe6yWfam74imuEnHfJJPwT
         XFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rhhiMX6lpyZpBTo++Wq1vgh3A63oG1sQxoZyJsc1aQg=;
        b=UmFOmmYAUEsiIR+osMrFvaJ15/85om+qRYZqQ/bgOHpIRp30TISrXD5ZNMz1JZz3nc
         x4/Cy1clQwfOZBMyx0qmCTXQlSwUvc4/Amt3NxXkQdXCQlK4PHyT+77DOoqGXz7e+lCV
         xqC27OhHDw91HJrwObQeISX1b9cnasr2r9YVGjqkLBc6p0sL54mqiOmM2xQls46az+uu
         /oHUvT6CnoePheUzFcjCwcD+t8CdnRPM6aFPRCykxASUmf1i9ivPBdRxorS0f8o0+scA
         TNaYmoJVWEjX39ZvMbcgR73xQzKMuKT0NUsa+v1KtuaU3/FhYY6C+FjoCJCBsghvv6zg
         nm7w==
X-Gm-Message-State: AOAM533s5NKNVdTKoLNngwH4vrI+rUsA4YdiZNJGvLOUmm4P7CKCq2ja
        RvEeAByh854sXKGloulRCvn7PA==
X-Google-Smtp-Source: ABdhPJxbBbOAPum4JxhLDvVO8oH4bCpyUFUBf6xuJ19RfGwEp+yksU2UBrKm/QCGpkEPA7yZYkCfcA==
X-Received: by 2002:a17:906:a857:: with SMTP id dx23mr1242029ejb.189.1607505427041;
        Wed, 09 Dec 2020 01:17:07 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
        by smtp.gmail.com with ESMTPSA id j20sm874968ejy.124.2020.12.09.01.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 01:17:06 -0800 (PST)
Date:   Wed, 9 Dec 2020 10:17:05 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
Message-ID: <20201209091705.brzbbqedavtxvhms@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
 <20201207192453.vc6clbdhz73hzs7l@mpHalley>
 <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20201208122248.utv7pqthmmn6uwv6@mpHalley>
 <SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20201208131333.xoxincxcnh7iz33z@mpHalley>
 <SN4PR0401MB3598226CD4A32F65320A47379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN4PR0401MB3598226CD4A32F65320A47379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08.12.2020 13:24, Johannes Thumshirn wrote:
>On 08/12/2020 14:13, Javier González wrote:
>> On 08.12.2020 12:37, Johannes Thumshirn wrote:
>>> On 08/12/2020 13:22, Javier González wrote:
>>>> Good idea. Are you thinking of a sysfs entry to select the backend?
>>>
>>> Not sure on this one, initially I thought of a sysfs file, but then
>>> how would you do it. One "global" sysfs entry is probably a bad idea.
>>> Having one per block device to select native vs emulation maybe? And
>>> a good way to benchmark.
>>
>> I was thinking a per block device to target the use case where a certain
>> implementation / workload is better one way or the other.
>
>Yes something along those lines.
>
>>>
>>> The other idea would be a benchmark loop on boot like the raid library
>>> does.
>>>
>>> Then on the other hand, there might be workloads that run faster with
>>> the emulation and some that run faster with the hardware acceleration.
>>>
>>> I think these points are the reason the last attempts got stuck.
>>
>> Yes. I believe that any benchmark we run would be biased in a certain
>> way. If we can move forward with a sysfs entry and default to legacy
>> path, we would not alter current behavior and enable NVMe copy offload
>> (for now) for those that want to use it. We can then build on top of it.
>>
>> Does this sound like a reasonable approach?
>>
>
>Yes this sounds like a reasonable approach to me.

Cool. We will add this to the V3 then.

Thanks Johannes!
