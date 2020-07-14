Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B38BC433FB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A60E221F0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XYw1XUIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgGNIuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:50:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41661 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgGNIun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 04:50:43 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200714085041euoutp0197c61b54c008e3e9e641bb6f111dcc01~hklYVA4H52506025060euoutp017
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 08:50:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200714085041euoutp0197c61b54c008e3e9e641bb6f111dcc01~hklYVA4H52506025060euoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594716641;
        bh=VLFLNyWnSpIRJnk0XeNogmxEcT9OMWW6Yb73NwYw8Y8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=XYw1XUIHm5U031DLpMWPTb5L2/uFSHBOawwlx12SaAN0iyuTQ8+SVhRl/gHIOa3KK
         wOw0vSe94ENPuu+pllU/598yZqjVR0D9BCjtj0jMG60dd+DuOMxeW2jf4Okg2jTDpL
         mq88yy8pDJIKHCw3SwCzK0z5d/wkAv+ba2WgiB48=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200714085040eucas1p2aaa79e2d5dc64673223ccf2a51b0ef18~hklX3OkFv0510105101eucas1p2H;
        Tue, 14 Jul 2020 08:50:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 73.4E.06318.0E17D0F5; Tue, 14
        Jul 2020 09:50:40 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200714085040eucas1p1466b8ae92a0931477aa7e7896782bb75~hklXZqd-60985509855eucas1p1J;
        Tue, 14 Jul 2020 08:50:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200714085040eusmtrp16a8ff47070fcb695f8df8e4225a46c9f~hklXZEA4n1070310703eusmtrp1a;
        Tue, 14 Jul 2020 08:50:40 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-27-5f0d71e09d70
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 44.49.06314.0E17D0F5; Tue, 14
        Jul 2020 09:50:40 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200714085040eusmtip1096180abd51ac9e3b88b39447902e762~hklXAJcP60922009220eusmtip1d;
        Tue, 14 Jul 2020 08:50:40 +0000 (GMT)
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     tasleson@redhat.com, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <dff66d00-e6c3-f9ef-3057-27c60e0bfc11@samsung.com>
Date:   Tue, 14 Jul 2020 10:50:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200714081750.GB862637@kroah.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7djPc7oPCnnjDa59t7JoXryezWLvLW2L
        YzseMVl0X9/BZnHx3k12B1aP/XPXsHu833eVzePzJrkA5igum5TUnMyy1CJ9uwSujNZzYQVP
        eCs+T7rM2MC4hLuLkYNDQsBE4k2rQBcjF4eQwApGibOPJzN1MXICOV8YJXbs0oKwPzNKPD7o
        AWKD1O94cYQVomE5o8TJCZNYIJy3jBLbV15kBJkqLGAnsfhnIUiDiICxRP/ZWewgNrNArsTF
        6w0sIDabgJXExPZVjCA2L1D5m4/3weIsAqoSBw9sAKsXFYiQ+PTgMCtEjaDEyZlPwGo4BQwk
        DretZYWYKS5x68l8JghbXmL72znMEIdOZpc4/YwPwnaR+P7zMzuELSzx6vgWKFtG4vTkHrD7
        JQTWMUr87XjBDOFsZ5RYPvkfG0SVtcSdc7/YQB5jFtCUWL9LHyLsKHH3yDsWSCjySdx4Kwhx
        A5/EpG3TmSHCvBIdbUIQ1WoSG5ZtYINZ27VzJfMERqVZSD6bheSbWUi+mYWwdwEjyypG8dTS
        4tz01GLjvNRyveLE3OLSvHS95PzcTYzAhHL63/GvOxj3/Uk6xCjAwajEwyvhzxMvxJpYVlyZ
        e4hRgoNZSYTX6ezpOCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8xotexgoJpCeWpGanphakFsFk
        mTg4pRoYszeLGAi8ruDYuHHXl7WF3JwN09+mZ9llzzku7sSwMDtBs+GwufH6zQ5KotI+Dz4v
        7HmWvkGrJ87CKfZE67xH33vn5HP8FH/8oe7Bze33nidbsm7nZpoxi+3dfBGbIMNA1d/B5z/c
        v+JRGL0xqH8X8/mGUNmDXOxJXretz5oW11xqSTbewMOlxFKckWioxVxUnAgAMqAYaSQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xu7oPCnnjDdbfkLBoXryezWLvLW2L
        YzseMVl0X9/BZnHx3k12B1aP/XPXsHu833eVzePzJrkA5ig9m6L80pJUhYz84hJbpWhDCyM9
        Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jNZzYQVPeCs+T7rM2MC4hLuLkZNDQsBE
        YseLI6xdjFwcQgJLGSWO/n3O1sXIAZSQkTi+vgyiRljiz7UuNoia14wSRz5MAasRFrCTWPyz
        EKRGRMBYov/sLHYQm1kgV+L9gTnMEPWNzBJzNnQxgyTYBKwkJravYgSxeYF633y8zwJiswio
        Shw8sAGsWVQgQuLwjllQNYISJ2c+AavhFDCQONy2lhVigbrEn3mXmCFscYlbT+YzQdjyEtvf
        zmGewCg0C0n7LCQts5C0zELSsoCRZRWjSGppcW56brGhXnFibnFpXrpecn7uJkZgHG079nPz
        DsZLG4MPMQpwMCrx8Er488QLsSaWFVfmHmKU4GBWEuF1Ons6Tog3JbGyKrUoP76oNCe1+BCj
        KdBzE5mlRJPzgTGeVxJvaGpobmFpaG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qB
        0eRTOu/X1UpM33b/dXs+8VeOj9zZS+FnNyzbeGLmdF2GE52eW3kZ3zy/dsKc4ZjHrJKi+qWt
        hnwcxh3feD6YP7See7lvit7KxvpbEwOlff5Y9u6ds7HCbN+nw1fzF+RbPXijZ7EjuP5Owv/n
        3TVpHm8elbne4jgZdGeJua7dYVNd1lkrH+Vx1imxFGckGmoxFxUnAgB3pXUJuQIAAA==
X-CMS-MailID: 20200714085040eucas1p1466b8ae92a0931477aa7e7896782bb75
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
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/14/20 10:17 AM, Greg Kroah-Hartman wrote:
> On Tue, Jul 14, 2020 at 10:06:05AM +0200, Bartlomiej Zolnierkiewicz wrote:
>>
>> Hi Tony,
>>
>> On 7/9/20 11:18 PM, Tony Asleson wrote:
>>> Hi Bartlomiej,
>>>
>>> On 6/24/20 5:35 AM, Bartlomiej Zolnierkiewicz wrote:
>>>> The root source of problem is that libata transport uses different
>>>> naming scheme for ->tdev devices (please see dev_set_name() in
>>>> ata_t{dev,link,port}_add()) than libata core for its logging
>>>> functionality (ata_{dev,link,port}_printk()).
>>>>
>>>> Since libata transport is part of sysfs ABI we should be careful
>>>> to not break it so one idea for solving the issue is to convert
>>>> ata_t{dev,link,port}_add() to use libata logging naming scheme and
>>>> at the same time add sysfs symlinks for the old libata transport
>>>> naming scheme.
> 
> Given the age of the current implementation, what suddenly broke that
> requires this to change at this point in time?

Unfortunately when adding libata transport classes (+ at the same
time embedding struct device-s in libata dev/link/port objects) in
the past someone has decided to use different naming scheme than
the one used for standard libata log messages (which use printk()
without any reference to struct device-s in libata dev/link/port
objects).

Now we would like to use dev_printk() for standard libata logging
functionality as this is required for 2 pending patchsets:

- move DPRINTK to dynamic debugging (from Hannes Reinecke)

- add persistent durable identifier storage log messages (from Tony)

but we don't want to change standard libata log messages and
confuse users..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
