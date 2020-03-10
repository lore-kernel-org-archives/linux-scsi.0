Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8785FC10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 08:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 671F52467F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 08:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgCJInz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 04:43:55 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2529 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgCJInz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 04:43:55 -0400
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id B7B0F978F5CCA05BDAD6;
        Tue, 10 Mar 2020 08:43:53 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML714-CAH.china.huawei.com (10.201.108.37) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 10 Mar 2020 08:43:53 +0000
Received: from [127.0.0.1] (10.47.2.244) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 10 Mar
 2020 08:43:52 +0000
Subject: Re: [PATCH RFC 00/24] scsi: enable reserved commands for LLDDs
From:   John Garry <john.garry@huawei.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, "Ming Lei" <ming.lei@redhat.com>
References: <20190529132901.27645-1-hare@suse.de>
 <e5c2b01a-71d9-ef94-3bf6-0830d866e4cf@huawei.com>
 <801604cd-d51f-2a4a-0e68-b6fcff9c9974@huawei.com>
 <65727403-a390-795f-08ce-581ed4e3f3c2@suse.de>
 <736c92c7-149b-1473-faed-484304e254ab@huawei.com>
Message-ID: <2c5232c2-2954-f886-a74f-74cecf897dac@huawei.com>
Date:   Tue, 10 Mar 2020 08:43:51 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <736c92c7-149b-1473-faed-484304e254ab@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.2.244]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/03/2020 14:21, John Garry wrote:
> On 09/03/2020 13:57, Hannes Reinecke wrote:
>> On 3/9/20 1:48 PM, John Garry wrote:
>>> On 23/08/2019 14:26, John Garry wrote:
>>>>>
>>>>> quite some drivers use internal commands for various purposes, most
>>>>> commonly sending TMFs or querying the HBA status.
>>>>> While these commands use the same submission mechanism than normal
>>>>> I/O commands, they will not be counted as outstanding commands,
>>>>> requiring those drivers to implement their own mechanism to figure
>>>>> out outstanding commands.
>>>>> This patchset enables the use of reserved tags for the SCSI midlayer,
>>>>> enabling LLDDs to rely on the block layer for tracking outstanding
>>>>> commands.
>>>>> More importantly, it allows LLDD to request a valid tag from the block
>>>>> layer without having to implement some tracking mechanism within the
>>>>> driver. This removes quite some hacks which were required for some
>>>>> drivers (eg. fnic or snic).
>>>>>
>>>>> As usual, comments and reviews are welcome.
>>>>>
>>>>
>>> Hi Hannes,
>>>
>>> JFYI, I have rebased this series to 5.6-rc4 here:
>>>
>>> https://github.com/hisilicon/kernel-dev/tree/private-topic-sas-5.6-resv-commands-v1 
>>>
>>>
>>>
>>> I am interested in enabling this for libsas and associated HBAs, so
>>> there are some patches on top for that.
>>>
>>> No review comments have been addressed, apart from removing "block:
>>> disable elevator for reserved tags"
>>>
>>> Please let me know your plan for this series.
>>>
>> The plan is to wait for the shared tagset patchset to go in first :-)
>>
> 
> I think that one should go last. Or, to be more specific, switching the 
> drivers to expose multiple queues - which is part of that series - 
> should go last.
> 
>> Without it we'll be running on one tag bitmap per queue, and we risk
>> duplicate tags when sending down reserved commands :-(
> 
> Until we expose multiple queues, we still have a single HW queue from 
> blk-mq perspective, so will only have a single tagset per HBA, so no 
> chance of duplicate tags.
> 
> This series should be able to go in without dependencies.

BTW, for the other SCSI HBA drivers which use libsas, it would be better 
if they could stop managing their own tags and switch to use the request 
tag. That would mean that we need to reserve some tags, which is 
currently not done in those drivers (pm8xxx, anyway).

If I were to make this change, are there mvsas and aic9xxx cards around 
to test? I have a pm8xxx card.

Thanks,
John
