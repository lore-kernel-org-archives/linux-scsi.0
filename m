Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8552C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 10:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8487020734
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 10:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HhCwo2et"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgGQK1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 06:27:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36037 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgGQK1l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 06:27:41 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200717102739euoutp028e194b513b79c0f4fbe90ecd57970253~ig1562nrR0495904959euoutp02h
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2020 10:27:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200717102739euoutp028e194b513b79c0f4fbe90ecd57970253~ig1562nrR0495904959euoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594981659;
        bh=GCBjWDcrMnG38qjYCEA11Ot2XOnA4sWzJETM5YLkq10=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=HhCwo2etRSYBfmSy36SJT9+Yc4JTlgjTbQtfUNGehLHZ2h4//vMuvR2z9PGl7sJoD
         NP0aEUxT/XrWBrT4NR4xrWmn5UegtLYynbYNEgMdeKdGsfggrusMhV7qjOAtNltTcm
         N7uaIWbwHbDIdqB0aUwp5bCM3SluZ86ecEQTdkYc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200717102739eucas1p1f30ec9d11c98b79b470a9b8bdb4cf1a2~ig15tdAa92663326633eucas1p1v;
        Fri, 17 Jul 2020 10:27:39 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 39.13.06318.B1D711F5; Fri, 17
        Jul 2020 11:27:39 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200717102739eucas1p20ecc9169dbae3898d48e04a0d28f94d5~ig15P39my0782607826eucas1p2v;
        Fri, 17 Jul 2020 10:27:39 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200717102739eusmtrp195c57224947067fe509402612e4b1d41~ig15PTvvj1159811598eusmtrp1n;
        Fri, 17 Jul 2020 10:27:39 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-b2-5f117d1bd151
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 68.D9.06017.B1D711F5; Fri, 17
        Jul 2020 11:27:39 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200717102738eusmtip2ddecac7a3ad6008727d442ad037bc409~ig14513dY2740927409eusmtip2k;
        Fri, 17 Jul 2020 10:27:38 +0000 (GMT)
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     tasleson@redhat.com, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <e6517dd6-b6b6-ead3-2e60-03832e0c43bf@samsung.com>
Date:   Fri, 17 Jul 2020 12:27:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200717100610.GA2667456@kroah.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djPc7rStYLxBh2TFCxW3+1ns2hevJ7N
        Yu8tbYtjOx4xWXRf38FmcfHeTXYHNo/LZ0s99s9dw+7xft9VNo/Pm+QCWKK4bFJSczLLUov0
        7RK4MrZs28FeMEuk4sWP7UwNjCcEuhg5OCQETCRm/AntYuTiEBJYwSjx9vl7RgjnC6PE2rYP
        bBDOZ0aJ9ovz2WA6GtdHQcSXM0rs/nWfGcJ5yyjR3PGEGaRIWMBOYvHPwi5GTg4RAWOJ/rOz
        2EFqmAV6GSXeTZ3KDJJgE7CSmNi+ihHE5gWqn3dgLROIzSKgKvH/1R2wGlGBCIlPDw6zQtQI
        Spyc+YQFxOYUMJSYOb8DrJ5ZQFzi1pP5ULa8xPa3c8AOkhBYxC7R2bwcLCEh4CLR9fkwO4Qt
        LPHq+BYoW0bi9OQeFoiGdYwSfzteQHVvZ5RYPvkfG0SVtcSdc7/A/mcW0JRYv0sfIuwocffI
        OxZIsPBJ3HgrCHEEn8SkbdOZIcK8Eh1tQhDVahIblm1gg1nbtXMl8wRGpVlIXpuF5J1ZSN6Z
        hbB3ASPLKkbx1NLi3PTUYuO81HK94sTc4tK8dL3k/NxNjMBUc/rf8a87GPf9STrEKMDBqMTD
        u8BLIF6INbGsuDL3EKMEB7OSCK/T2dNxQrwpiZVVqUX58UWlOanFhxilOViUxHmNF72MFRJI
        TyxJzU5NLUgtgskycXBKNTA2O8RemGN7rnK+473N75+yWinKG7+dzfglXOHDlxU+7k6CJznf
        rprVfJdnidavUz/TjIKOVt3d1v63N5Tx+20Ld7PGH2VSFTtOKP6499tY+hzPdwf/p2HTf18o
        nR7J3q0wT93AreR1pw2fnITkDxvGYunKkgu83vMWVa3W9TsSelH+7nMbLVslluKMREMt5qLi
        RADLiqDrMQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xe7rStYLxBh9ms1qsvtvPZtG8eD2b
        xd5b2hbHdjxisui+voPN4uK9m+wObB6Xz5Z67J+7ht3j/b6rbB6fN8kFsETp2RTll5akKmTk
        F5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZWzZtoO9YJZIxYsf25ka
        GE8IdDFycEgImEg0ro/qYuTiEBJYyiix/cUmVoi4jMTx9WVdjJxAprDEn2tdbBA1rxklzp9s
        YwGpERawk1j8sxCkRkTAWKL/7Cx2EJtZoJdR4tkRf4j6u8wSLXuPsoIk2ASsJCa2r2IEsXmB
        eucdWMsEYrMIqEr8f3WHGcQWFYiQOLxjFlSNoMTJmU9YQGxOAUOJmfM7mCAWqEv8mXeJGcIW
        l7j1ZD5UXF5i+9s5zBMYhWYhaZ+FpGUWkpZZSFoWMLKsYhRJLS3OTc8tNtIrTswtLs1L10vO
        z93ECIysbcd+btnB2PUu+BCjAAejEg/vAi+BeCHWxLLiytxDjBIczEoivE5nT8cJ8aYkVlal
        FuXHF5XmpBYfYjQFem4is5Rocj4w6vNK4g1NDc0tLA3Njc2NzSyUxHk7BA7GCAmkJ5akZqem
        FqQWwfQxcXBKNTDOKFjHHtWox+TXMM2xxYx5b9o7+WcagWyb3FazrJ52Wm2Oc7Fc8+NVfFuF
        1eK251d0b557znri6z8T2P8cnq6/RVhmhYXxstrzKo/WcIu+FMhfz8hgwae8vEfS5Izv1Vp/
        wVmWkc3T134WuD+jIu+Ax17rexeYPRWNXj3wuVRhnsM4fVvdm2lKLMUZiYZazEXFiQBUgHDi
        wgIAAA==
X-CMS-MailID: 20200717102739eucas1p20ecc9169dbae3898d48e04a0d28f94d5
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
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/17/20 12:06 PM, Greg Kroah-Hartman wrote:
> On Tue, Jul 14, 2020 at 10:50:39AM +0200, Bartlomiej Zolnierkiewicz wrote:
>>
>> On 7/14/20 10:17 AM, Greg Kroah-Hartman wrote:
>>> On Tue, Jul 14, 2020 at 10:06:05AM +0200, Bartlomiej Zolnierkiewicz wrote:
>>>>
>>>> Hi Tony,
>>>>
>>>> On 7/9/20 11:18 PM, Tony Asleson wrote:
>>>>> Hi Bartlomiej,
>>>>>
>>>>> On 6/24/20 5:35 AM, Bartlomiej Zolnierkiewicz wrote:
>>>>>> The root source of problem is that libata transport uses different
>>>>>> naming scheme for ->tdev devices (please see dev_set_name() in
>>>>>> ata_t{dev,link,port}_add()) than libata core for its logging
>>>>>> functionality (ata_{dev,link,port}_printk()).
>>>>>>
>>>>>> Since libata transport is part of sysfs ABI we should be careful
>>>>>> to not break it so one idea for solving the issue is to convert
>>>>>> ata_t{dev,link,port}_add() to use libata logging naming scheme and
>>>>>> at the same time add sysfs symlinks for the old libata transport
>>>>>> naming scheme.
>>>
>>> Given the age of the current implementation, what suddenly broke that
>>> requires this to change at this point in time?
>>
>> Unfortunately when adding libata transport classes (+ at the same
>> time embedding struct device-s in libata dev/link/port objects) in
>> the past someone has decided to use different naming scheme than
>> the one used for standard libata log messages (which use printk()
>> without any reference to struct device-s in libata dev/link/port
>> objects).
>>
>> Now we would like to use dev_printk() for standard libata logging
>> functionality as this is required for 2 pending patchsets:
>>
>> - move DPRINTK to dynamic debugging (from Hannes Reinecke)
>>
>> - add persistent durable identifier storage log messages (from Tony)
>>
>> but we don't want to change standard libata log messages and
>> confuse users..
> 
> All of that mess with symlinks just for a common debug printk?  That
> seems excessive :)

Unfortunately "a common debug printk" means all log messages generated
by libata core..

> Just use the device name and don't worry about it, I doubt anyone will
> notice, unless the name is _really_ different.

Well, Geert has noticed and complained pretty quickly:

https://lore.kernel.org/linux-ide/alpine.DEB.2.21.2003241414490.21582@ramsan.of.borg/

Anyway, I don't insist that hard on keeping the old names and
I won't be the one handling potential bug-reports.. (added Jens to Cc:).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
