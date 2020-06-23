Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6909CC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D5820781
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732489AbgFWLqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:46:11 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2358 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732245AbgFWLqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 07:46:10 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 809C446CFF0D20FDCD46;
        Tue, 23 Jun 2020 12:46:08 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.88) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 23 Jun
 2020 12:46:07 +0100
Subject: Re: fix ATAPI support for libsas drivers
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
CC:     <martin.petersen@oracle.com>, <brking@us.ibm.com>,
        <jinpu.wang@cloud.ionos.com>, <mpe@ellerman.id.au>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>
References: <20200615064624.37317-1-hch@lst.de>
 <d3459f71-501e-3fea-d5dc-a5599758459d@huawei.com>
 <20200618152848.GA30919@lst.de>
 <bed58e53-2019-cbb6-2ebe-93d0e404c90a@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2bcf7cc7-f3e0-de41-8bf2-b8c5979fe927@huawei.com>
Date:   Tue, 23 Jun 2020 12:44:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <bed58e53-2019-cbb6-2ebe-93d0e404c90a@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.2.88]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/06/2020 07:28, Hannes Reinecke wrote:
> On 6/18/20 5:28 PM, Christoph Hellwig wrote:
>> On Thu, Jun 18, 2020 at 10:02:58AM +0100, John Garry wrote:
>>> On 15/06/2020 07:46, Christoph Hellwig wrote:
>>>> Hi all,
>>>>
>>>> this series fixes the ATAPI DMA drain refactoring for SAS HBAs that
>>>> use libsas.
>>>> .
>>>>
>>>
>>> Something I meant to ask before and was curious about, specifically 
>>> since
>>> ipr doesn't actually use libsas: Why not wire up other SAS HBAs, like
>>> megaraid_sas?
>>
>> megaraid_sas and mpt3sas don't use the libata code at all.  ipr actually
>> is a special case and uses libata directly instead of libsas (something
>> I hadn't realized, but which doesn't change anything for the patches
>> itself, just possibly the commit log).
>>
> More to the point, megaraid_sas and mpt3sas have their own SATL in 
> firmware so there is no need to use libata here.

ok.

BTW, @Christoph, I have no setup to verify this refactoring for anything 
which uses libsas (that I know about, anyway).

Thanks

