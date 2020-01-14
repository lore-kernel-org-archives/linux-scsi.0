Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCEDC33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 15:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D0FC2467D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 15:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgANPUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 10:20:16 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2268 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbgANPUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 10:20:16 -0500
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 8459F38DF2C7F76447CD;
        Tue, 14 Jan 2020 15:20:14 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML714-CAH.china.huawei.com (10.201.108.37) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 14 Jan 2020 15:20:14 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 14 Jan
 2020 15:20:13 +0000
Subject: Re: [PATCH v1] driver core: Use list_del_init to replace list_del at
 device_links_purge()
To:     Greg KH <gregkh@linuxfoundation.org>,
        James Bottomley <jejb@linux.ibm.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "saravanak@google.com" <saravanak@google.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <1578483244-50723-1-git-send-email-luojiaxing@huawei.com>
 <20200108122658.GA2365903@kroah.com>
 <73252c08-ac46-5d0d-23ec-16c209bd9b9a@huawei.com>
 <1578498695.3260.5.camel@linux.ibm.com> <20200108155700.GA2459586@kroah.com>
 <1578499287.3260.7.camel@linux.ibm.com>
 <4b185c9f-7fa2-349d-9f72-3c787ac30377@huawei.com>
 <3826a83d-a220-2f7d-59f6-efe8a4b995d7@huawei.com>
 <1578531860.3852.7.camel@linux.ibm.com> <20200114150739.GA1975985@kroah.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6820e1c4-07ab-0748-0bf3-e1c25c524a40@huawei.com>
Date:   Tue, 14 Jan 2020 15:20:12 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200114150739.GA1975985@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/01/2020 15:07, Greg KH wrote:
> On Wed, Jan 08, 2020 at 05:04:20PM -0800, James Bottomley wrote:
>> On Wed, 2020-01-08 at 17:10 +0000, John Garry wrote:
>>> On 08/01/2020 16:08, John Garry wrote:
>>>> On 08/01/2020 16:01, James Bottomley wrote:
>>>>>>>>      cdev->dev = NULL;
>>>>>>>>              return device_add(&cdev->cdev);
>>>>>>>>          }
>>>>>>>>      }
>>>>>>>>      return -ENODEV;
>>>>>>>> }
>>>>>>>
>>>>>>> The design of the code is simply to remove the link to the
>>>>>>> inserted device which has been removed.
>>>>>>>
>>>>>>> I*think*  this means the calls to device_del and device_add
>>>>>>> are unnecessary and should go.  enclosure_remove_links and
>>>>>>> the put of the enclosed device should be sufficient.
>>>>>>
>>>>>> That would make more sense than trying to "reuse" the device
>>>>>> structure here by tearing it down and adding it back.
>>>>>
>>>>> OK, let's try that.  This should be the patch if someone can try
>>>>> it (I've compile tested it, but the enclosure system is under a
>>>>> heap of stuff in the garage).
>>>>
>>>> I can test it now.
>>>>
>>>
>>> Yeah, that looks to have worked ok. SES disk locate was also fine
>>> after losing and rediscovering the disk.
>>
>> OK, I'll spin up a patch with fixes/reported and tested tags.
> 
> Did this get sent?  I can't seem to find it :(
> 

Yeah, but you were not cc'ed :(

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20200114&id=529244bd1afc102ab164429d338d310d5d65e60d

cheers.
John

> .
> 

