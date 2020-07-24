Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A53C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 08:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307B92070B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 08:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pEPpJwey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgGXIur (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 04:50:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45908 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgGXIur (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 04:50:47 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200724085045euoutp02c8db09cea7dd6122a6c35dd46201ad5b~kpCS-uQ451843918439euoutp02_
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2020 08:50:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200724085045euoutp02c8db09cea7dd6122a6c35dd46201ad5b~kpCS-uQ451843918439euoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595580645;
        bh=JCaoIX/Ct2B1o6jzU1B+BPTjqPyceMizPHeHhqEvRPE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=pEPpJweyxPgLATd6DIxnWKM8jX2UaNeqEbCbCsdSPoGOkrjfqC/SHXZPtaXmHUyxD
         Jt8Q1AWmAaphCNJM+TDc5T2gfvCgUWUNfJc5lKv0PluJGU9GUBhQhJtaksx1Z9bZdY
         xxQSXibHXh+7AYrN092gSdJdIlVeKjQMqiHLJTEg=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200724085045eucas1p2ffef272f435a518fa4d1cf773626ab4e~kpCSsGiBA2974529745eucas1p2_;
        Fri, 24 Jul 2020 08:50:45 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 76.EF.06456.5E0AA1F5; Fri, 24
        Jul 2020 09:50:45 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200724085044eucas1p2bae591d154a38a8283ef0d55a48be7bf~kpCR7SUDN3011730117eucas1p23;
        Fri, 24 Jul 2020 08:50:44 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200724085044eusmtrp1371cb979181545dde0a463205d4d0273~kpCR6oqbU1666716667eusmtrp1D;
        Fri, 24 Jul 2020 08:50:44 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-e0-5f1aa0e5731a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C2.30.06017.4E0AA1F5; Fri, 24
        Jul 2020 09:50:44 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724085044eusmtip1375ed4e8129771eaa312921c96d036e4~kpCRj2LN92939429394eusmtip16;
        Fri, 24 Jul 2020 08:50:44 +0000 (GMT)
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     tasleson@redhat.com, Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <800d28d5-2432-f591-f942-df63aa37086c@samsung.com>
Date:   Fri, 24 Jul 2020 10:50:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <84fec7af-3f51-c956-d2ca-41581e0f3cbb@redhat.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djPc7pPF0jFG2w7LWqx+m4/m0Xz4vVs
        FntvaVsc2/GIyaL7+g42i4v3brI7sHlcPlvqsX/uGnaP9/uusnl83iQXwBLFZZOSmpNZllqk
        b5fAlTHn4nWmgh08FR/WrWVqYOzn6mLk5JAQMJE4cukvWxcjF4eQwApGiYurzkA5Xxglbs3p
        ZYJwPjNK7PnUygrTcmPHb6iq5YwSbY82QFW9ZZT4tG4zkMPBISxgJ7H4ZyGIKSJgKvH1sgZI
        CbNAN6PEvav9YIPYBKwkJravYgSxeYHKF25axARiswioSqx59xSsRlQgQuLTg8OsEDWCEidn
        PmEBmckJVL9sfjlImFlAXOLWk/lMELa8xPa3c5hBdkkILGKXmP3oNAvE0S4S06eeZYSwhSVe
        Hd/CDmHLSJye3MMC0bCOUeJvxwuo7u2MEssn/2ODqLKWuHPuFxvIZmYBTYn1u/Qhwo4Sd4+8
        AztIQoBP4sZbQYgj+CQmbZvODBHmlehoE4KoVpPYsGwDG8zarp0rmScwKs1C8tksJO/MQvLO
        LIS9CxhZVjGKp5YW56anFhvmpZbrFSfmFpfmpesl5+duYgSmmtP/jn/awfj1UtIhRgEORiUe
        Xok6yXgh1sSy4srcQ4wSHMxKIrxOZ0/HCfGmJFZWpRblxxeV5qQWH2KU5mBREuc1XvQyVkgg
        PbEkNTs1tSC1CCbLxMEp1cDIdMj5WeExNr7kp9lFTe/Ftk9Unl52uqnzusj+U3zXTm01Wz7P
        qPHFM47KeUxLN/7Z8txFt2V6ptn8i5/3ZB43Wxi3/djaNSxZ6aKv1zRuuxC36sKhK2VuuzL5
        ahn1Sp+Jm6pfyWc8VOS1tMPa8vgySd1pq7vTUvdrB4r2fwjh11todv3UDsM5SizFGYmGWsxF
        xYkAZs098zEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xu7pPFkjFGzQdkrdYfbefzaJ58Xo2
        i723tC2O7XjEZNF9fQebxcV7N9kd2Dwuny312D93DbvH+31X2Tw+b5ILYInSsynKLy1JVcjI
        Ly6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy5hz8TpTwQ6eig/r1jI1
        MPZzdTFyckgImEjc2PGbDcQWEljKKPHkH3sXIwdQXEbi+PoyiBJhiT/XuoBKuIBKXjNKbNmw
        kwWkRljATmLxz0IQU0TAVOLrZQ2QEmaBbkaJf00/2CHqj7FIPPpznBVkEJuAlcTE9lWMIDYv
        UO/CTYuYQGwWAVWJNe+egtWICkRIHN4xC6pGUOLkzCdguziB6pfNLwcJMwuoS/yZd4kZwhaX
        uPVkPhOELS+x/e0c5gmMQrOQdM9C0jILScssJC0LGFlWMYqklhbnpucWG+kVJ+YWl+al6yXn
        525iBMbVtmM/t+xg7HoXfIhRgINRiYdXok4yXog1say4MvcQowQHs5IIr9PZ03FCvCmJlVWp
        RfnxRaU5qcWHGE2BfpvILCWanA+M+bySeENTQ3MLS0NzY3NjMwslcd4OgYMxQgLpiSWp2amp
        BalFMH1MHJxSDYxZr5aovfG9M+n6H6aTTu99nl9mncvgcUnQoea1LFuuioPtqS3hzW/fMTgE
        BnAs/C1rNe/ZyRSjWEnehCOMs077ZsS+SQptPqTinB2+bcGD0+fyns3iqPvY+6r+vMtmo1Px
        Glzme69pnluvHSrN8ODmQf8FKY/Yvc7ETVbZLLJHoaLjbo/fvnlKLMUZiYZazEXFiQDLsSXe
        wQIAAA==
X-CMS-MailID: 20200724085044eucas1p2bae591d154a38a8283ef0d55a48be7bf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
References: <20200623191749.115200-1-tasleson@redhat.com>
        <20200623191749.115200-6-tasleson@redhat.com>
        <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
        <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
        <7ed08b94-755f-baab-0555-b4e454405729@redhat.com>
        <cfff719b-dc12-a06a-d0ee-4165323171de@samsung.com>
        <20200714081750.GB862637@kroah.com>
        <dff66d00-e6c3-f9ef-3057-27c60e0bfc11@samsung.com>
        <20200717100610.GA2667456@kroah.com>
        <e6517dd6-b6b6-ead3-2e60-03832e0c43bf@samsung.com>
        <84fec7af-3f51-c956-d2ca-41581e0f3cbb@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/17/20 9:47 PM, Tony Asleson wrote:
> On 7/17/20 5:27 AM, Bartlomiej Zolnierkiewicz wrote:
>>
>> On 7/17/20 12:06 PM, Greg Kroah-Hartman wrote:
>>
>>> Just use the device name and don't worry about it, I doubt anyone will
>>> notice, unless the name is _really_ different.
>>
>> Well, Geert has noticed and complained pretty quickly:
>>
>> https://lore.kernel.org/linux-ide/alpine.DEB.2.21.2003241414490.21582@ramsan.of.borg/
>>
>> Anyway, I don't insist that hard on keeping the old names and
>> I won't be the one handling potential bug-reports.. (added Jens to Cc:).
> 
> I would think having sysfs use one naming convention and the logging
> using another would be confusing for users, but apparently they've
> managed this long with that.
> 
> 
> It appears changes are being rejected because of logging content
> differences, implying we shouldn't be changing printk usage to dev_printk.
> 
> Should I re-work my changes to support dev_printk path in addition to
> utilizing printk_emit functionality so that we can avoid user space

Unfortunately this won't fix the issue for Hannes' patchset.

> visible log changes?  I don't see a way to make the transition from
> printk to dev_printk without having user visible changes to message content.
The usage of sysfs symlinks for fixing the naming issue turned out
to not be (easily) possible so we should consider other options (or
just go forward with the original dev_printk() conversion)..

Jens?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
