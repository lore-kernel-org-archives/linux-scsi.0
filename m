Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75FDC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 07:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693BD21D91
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 07:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgIKHdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 03:33:38 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2806 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbgIKHdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 03:33:35 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 66A0033003E3BFA749F8;
        Fri, 11 Sep 2020 08:33:27 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.154) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 11 Sep
 2020 08:33:26 +0100
Subject: Re: [PATCH v8 2/2] pm80xx : Staggered spin up support.
To:     <Viswas.G@microchip.com>, <martin.petersen@oracle.com>,
        <Viswas.G@microchip.com.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Deepak.Ukey@microchip.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
References: <20200820185123.27354-1-Viswas.G@microchip.com.com>
 <20200820185123.27354-3-Viswas.G@microchip.com.com>
 <yq1k0xdf006.fsf@ca-mkp.ca.oracle.com>
 <SN6PR11MB3488EA8136D36F11D93074919D240@SN6PR11MB3488.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <30b03265-c2cc-2ce9-1c7c-b2404e51b274@huawei.com>
Date:   Fri, 11 Sep 2020 08:30:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB3488EA8136D36F11D93074919D240@SN6PR11MB3488.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.154]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/09/2020 06:41, Viswas.G@microchip.com wrote:
> Hi Martin,
> 
> All raid controllers, newer HBAs, and sas expanders do this operation in the product firmware itself and there is no mass need to have it done in libsas. In that case, Will it be good to keep this in driver itself ?
> 

pm80xx seems the most advanced HBA which uses libsas, so I doubt other 
HBA drivers who use libsas support it. And one of these libsas users, 
hisi_sas, does not even have firmware at all, but would like this kernel 
support at some stage.

And I wouldn't expect expander kernel support, since, as you say, 
expanders can support with firmware. I'm not sure if it's even possible 
for the kernel (host) to support this anyway.

Thanks,
John

> Regards,
> Viswas G
> 
>> -----Original Message-----
>> From: Martin K. Petersen <martin.petersen@oracle.com>
>> Sent: Wednesday, September 2, 2020 6:51 AM
>> To: Viswas G <Viswas.G@microchip.com.com>
>> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664
>> <Vasanthalakshmi.Tharmarajan@microchip.com>; Viswas G - I30667
>> <Viswas.G@microchip.com>; Deepak Ukey - I31172
>> <Deepak.Ukey@microchip.com>; martin.petersen@oracle.com;
>> yuuzheng@google.com; auradkar@google.com; vishakhavc@google.com;
>> bjashnani@google.com; radha@google.com; akshatzen@google.com
>> Subject: Re: [PATCH v8 2/2] pm80xx : Staggered spin up support.
>>
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>> the content is safe
>>
>> Viswas,
>>
>>> As a part of drive discovery, driver will initaite the drive spin up.
>>> If all drives do spin up together, it will result in large power
>>> consumption. To reduce the power consumption, driver provide an option
>>> to make a small group of drives (say 3 or 4 drives together) to do the
>>> spin up. The delay between two spin up group and no of drives to spin
>>> up (group) can be programmed by the customer in seeprom and driver
>>> will use it to control the spinup.
>>
>> Please implement this in libsas as several people have suggested.
>> Thanks!
>>
>> --
>> Martin K. Petersen      Oracle Linux Engineering
> .
> 

