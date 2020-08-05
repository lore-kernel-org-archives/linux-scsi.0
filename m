Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19375C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 03:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E296A2177B
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 03:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbgHFDhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 23:37:13 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2585 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731730AbgHFDhL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Aug 2020 23:37:11 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 76D9B13C12B98849F609;
        Wed,  5 Aug 2020 12:23:36 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.153) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 5 Aug 2020
 12:23:35 +0100
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
To:     <Don.Brace@microchip.com>, <hare@suse.de>,
        <don.brace@microsemi.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <SN6PR11MB28489516D2F4E7631A921BD9E14D0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <ccc119c8-4774-2603-fb79-e8c31a1476c6@huawei.com>
 <SN6PR11MB2848F0DD0CB3357541DBDAA9E14A0@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <013d4ba6-9173-e791-8e36-8393bde73588@huawei.com>
Date:   Wed, 5 Aug 2020 12:21:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848F0DD0CB3357541DBDAA9E14A0@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.153]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/08/2020 16:18, Don.Brace@microchip.com wrote:
>> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
>>        branch origin/reserved-tags.v6
> ok, great
> 
>> but I am getting an extra devices in the list which does not seem to
>> be coming from hpsa driver.
>>
>>> I assume that you are missing some other patches from >>that branch, like
>>> these:
>>> 77dcb92c31ae scsi: revamp host device handling
>>> 6e9884aefe66 scsi: Use dummy inquiry data for the host >>device a381637f8a6e scsi: use real inquiry data when >>initialising devices
>>> @Hannes, Any plans to get this series going again?
> I cherry-picked the following and this resolves the issue.
> 77dcb92c31ae scsi: revamp host device handling
> 6e9884aefe66 scsi: Use dummy inquiry data for the host device
> a381637f8a6e scsi: use real inquiry data when initialising devices
> I'll continue with more I/O stress testing.

ok, great. Please let me know about your testing, as I might just add 
that series to the v8 branch.

Cheers,
John
