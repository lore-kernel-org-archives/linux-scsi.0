Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35ABDC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E449B64F76
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhBCIvW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:51:22 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2489 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhBCIvS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 03:51:18 -0500
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DVwJ40swJz67k8T;
        Wed,  3 Feb 2021 16:45:56 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 09:50:35 +0100
Received: from [10.210.171.46] (10.210.171.46) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 08:50:34 +0000
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     Martin Wilck <mwilck@suse.com>, <Don.Brace@microchip.com>,
        <buczek@molgen.mpg.de>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>
CC:     <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>, <Kevin.Barnett@microchip.com>,
        <pmenzel@molgen.mpg.de>, <hare@suse.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <475c5b49-7a75-3ee7-6f8d-de5f400856da@huawei.com>
Date:   Wed, 3 Feb 2021 08:49:06 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
Content-Type: text/plain; charset="iso-8859-15"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.46]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/02/2021 20:48, Martin Wilck wrote:
> On Tue, 2021-02-02 at 20:04 +0000, Don.Brace@microchip.com wrote:
>> -----Original Message-----
>> From: John Garry [mailto:john.garry@huawei.com]
>> Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count
>> early
>>
>>
>> Confirmed my suspicions - it looks like the host is sent more
>> commands than it can handle. We would need many disks to see this
>> issue though, which you have.
>>
>> So for stable kernels, 6eb045e092ef is not in 5.4 . Next is 5.10, and
>> I suppose it could be simply fixed by setting .host_tagset in scsi
>> host template there.
>>
>> Thanks,
>> John
>> --
>> Don: Even though this works for current kernels, what would chances
>> of this getting back-ported to 5.9 or even further?
>>
>> Otherwise the original patch smartpqi_fix_host_qdepth_limit would
>> correct this issue for older kernels.
> 
> True. However this is 5.12 material, so we shouldn't be bothered by
> that here. For 5.5 up to 5.9, you need a workaround. But I'm unsure
> whether smartpqi_fix_host_qdepth_limit would be the solution.
> You could simply divide can_queue by nr_hw_queues, as suggested before,
> or even simpler, set nr_hw_queues = 1.
> 
> How much performance would that cost you?
> 
> Distribution kernels would be yet another issue, distros can backport
> host_tagset and get rid of the issue.

Aren't they (distros) the only issue? As I mentioned above, for 5.10 
mainline stable, I think it's reasonable to backport a patch to set 
.host_tagset for the driver.

Thanks,
John
