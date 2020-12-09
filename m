Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF654C4167B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 15:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA5F22B47
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 15:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbgLIPxw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 10:53:52 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2235 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730970AbgLIPwy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 10:52:54 -0500
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CrhKp70qkz67N4S;
        Wed,  9 Dec 2020 23:48:46 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 9 Dec 2020 16:52:07 +0100
Received: from [10.210.171.175] (10.210.171.175) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 9 Dec 2020 15:52:05 +0000
Subject: Re: problem booting 5.10
To:     Julia Lawall <julia.lawall@inria.fr>,
        Kashyap Desai <kashyap.desai@broadcom.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <nicolas.palix@univ-grenoble-alpes.fr>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
 <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
 <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
 <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
 <yq1sg8fud7y.fsf@ca-mkp.ca.oracle.com>
 <4f3cd4d4-87d3-dc9a-027d-293cba469d5a@huawei.com>
 <alpine.DEB.2.22.394.2012091644010.2691@hadrien>
From:   John Garry <john.garry@huawei.com>
Message-ID: <db450cdf-f411-c0ed-d2ce-60283dacfd06@huawei.com>
Date:   Wed, 9 Dec 2020 15:51:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2012091644010.2691@hadrien>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.175]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2020 15:44, Julia Lawall wrote:
> 
> On Tue, 8 Dec 2020, John Garry wrote:
> 
>> On 08/12/2020 22:51, Martin K. Petersen wrote:
>>> Julia,
>>>
>>>> This solves the problem.  Starting from 5.10-rc7 and doing this revert, I
>>>> get a kernel that boots.
>> Hi Julia,
>>
>> Can you also please test Ming's patchset here (without the megaraid sas
>> revert) when you get a chance:
>> https://lore.kernel.org/linux-block/20201203012638.543321-1-ming.lei@redhat.com/
> 5.10-rc7 plus these three commits boots fine.
> 

Hi Julia,

Ok, Thanks for the confirmation. A sort of relief.

@Kashyap, It would be good if we could recreate this, just in case.

Cheers,
John
