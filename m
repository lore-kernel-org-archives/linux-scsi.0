Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FEFC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 07:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82923613BE
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 07:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhDFHpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 03:45:45 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2759 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhDFHpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 03:45:45 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FDzsp5tZPz686lR;
        Tue,  6 Apr 2021 15:38:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 09:45:27 +0200
Received: from [10.210.166.136] (10.210.166.136) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 08:45:27 +0100
Subject: Re: [PATCH] scsi: hisi_sas: fix IRQ checks
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
 <73de21af-8097-9bd3-9da4-32c9523fa148@omprussia.ru>
From:   John Garry <john.garry@huawei.com>
Message-ID: <67ebfc0b-7de5-376c-1f78-a696eb719cce@huawei.com>
Date:   Tue, 6 Apr 2021 08:43:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <73de21af-8097-9bd3-9da4-32c9523fa148@omprussia.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.166.136]
X-ClientProxiedBy: lhreml711-chm.china.huawei.com (10.201.108.62) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/04/2021 15:27, Sergey Shtylyov wrote:
> On 4/3/21 11:43 PM, Sergey Shtylyov wrote:
> 
>> Commit df2d8213d9e3 ("hisi_sas: use platform_get_irq()") failed to take
>> into account that irq_of_parse_and_map() and platform_get_irq() have a
>> different way of indicating an error: the former returns 0 and the latter
>> returns a negative error code. Fix up the IRQ checks!
>>
>> Fixes: df2d8213d9e3 ("hisi_sas: use platform_get_irq()")
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>
>> ---
> 
>     Sorry, forgot to mention that this patch is against the 'fixes' branch of
> Martin Petgersen's 'scsi.git' repo.

JFYI, The HW for this v1 hw driver is all but dead, and I was 
considering deleting the driver.

But, for now, if you want to fix up to ensure no one copies this 
pattern, then fine.

Thanks,
John
