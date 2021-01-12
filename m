Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042A6C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B831A22CE3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhALRqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:46:05 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2321 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbhALRqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 12:46:05 -0500
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFdBn4Xs2z67Xx6;
        Wed, 13 Jan 2021 01:40:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 18:45:23 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 17:45:22 +0000
Subject: Re: About scsi device queue depth
To:     Ming Lei <ming.lei@redhat.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <20210112014203.GA60605@T590>
 <4b50f067-a368-2197-c331-a8c981f5cd02@huawei.com>
 <20210112090634.GA97446@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9241f2fa-3143-7aae-ee21-71e31e363c9a@huawei.com>
Date:   Tue, 12 Jan 2021 17:44:14 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210112090634.GA97446@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.61]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>> sdev qdepth	fio number jobs* 	1	10	20
>>>> 16					1590	1654	1660
>>>> 32					1545	1646	1654
>>>> 64					1436	1085	1070
>>>> 254 (default)				1436	1070	1050
>>> What does the performance number mean? IOPS or others? What is the fio
>>> io test? random IO or sequential IO?
>> So those figures are x1K IOPs read performance; so 1590, above, is 1.59M
>> IOPs read. Here's the fio script:
>>
>> [global]
>> rw=read
>> direct=1
>> ioengine=libaio
>> iodepth=40
>> numjobs=20
>> bs=4k
>> ;size=10240000m
>> ;zero_buffers=1
>> group_reporting=1
>> ;ioscheduler=noop
>> ;cpumask=0xffe
>> ;cpus_allowed=1-47
>> ;gtod_reduce=1
>> ;iodepth_batch=2
>> ;iodepth_batch_complete=2
>> runtime=60
>> ;thread
>> loops = 10000
> Is there any effect on random read IOPS when you decrease sdev queue
> depth? For sequential IO, IO merge can be enhanced by that way.
> 

Hi Ming,

fio randread results:

fio queue depth 40
sdev qdepth	fio number jobs* 	1	10	20
8					1308K	831K	814K
16					1435K	1073K	988K
32					1438K	1065K	990K
64					1432K	1061K	1020K
254 (default)				1439K	1099K	1083K


fio queue depth 128
sdev qdepth	fio number jobs* 	1	10	20
8					1310K	860K	849K
16					1435K	1048K	958K
32					1438K	1140K	951K
64					1438K	1065K	953k
254 (default)				1439K	1140K	1056K

So randread goes in the opposite direction (to read wrt queue depth).

Thanks,
John
