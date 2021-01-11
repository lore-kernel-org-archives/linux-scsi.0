Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AD5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0E320738
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389746AbhAKRqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:46:07 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2308 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389586AbhAKRqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 12:46:07 -0500
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DF1Gl4xF6z67P74;
        Tue, 12 Jan 2021 01:41:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 18:45:25 +0100
Received: from [10.210.171.188] (10.210.171.188) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 17:45:24 +0000
Subject: Re: [PATCH] scsi: libsas and users: Remove notifier indirection
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <artur.paszkiewicz@intel.com>, <jinpu.wang@cloud.ionos.com>,
        <corbet@lwn.net>, <yanaijie@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <intel-linux-scu@intel.com>, <linux-doc@vger.kernel.org>
References: <1610386112-132641-1-git-send-email-john.garry@huawei.com>
 <X/yN3uNT77yy8Usi@lx-t490>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a056f28e-bbdc-1400-83f2-b6d76afd92b9@huawei.com>
Date:   Mon, 11 Jan 2021 17:44:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <X/yN3uNT77yy8Usi@lx-t490>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.188]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/01/2021 17:41, Ahmed S. Darwish wrote:
> On Tue, Jan 12, 2021 at 01:28:32AM +0800, John Garry wrote:
> ...
>> index a920eced92ec..6a51abdc59ae 100644
>> --- a/drivers/scsi/mvsas/mv_sas.c
>> +++ b/drivers/scsi/mvsas/mv_sas.c
>> @@ -230,7 +230,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
>>   	}
>>
>>   	sas_ha = mvi->sas;
>> -	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
>> +	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
>>
> 
> Minor point: "sas_ha" is now not used anywhere; it should be removed.
> .
> 

ah, yes, it can be removed.

BTW, on separate topic, did intel-linux-scu@intel.com bounce for you?

Thanks,
John
