Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2FCC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05EE64E49
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhBCI7B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:59:01 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:51363 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232897AbhBCI7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Feb 2021 03:59:00 -0500
Received: from [192.168.0.2] (ip5f5aeaac.dynamic.kabel-deutschland.de [95.90.234.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id CF98220645D52;
        Wed,  3 Feb 2021 09:58:15 +0100 (CET)
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     John Garry <john.garry@huawei.com>, Martin Wilck <mwilck@suse.com>,
        Don Brace <Don.Brace@microchip.com>
Cc:     jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, hare@suse.de,
        Kevin Barnett <Kevin.Barnett@microchip.com>, hare@suse.com,
        Ming Lei <ming.lei@redhat.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        it+linux-scsi@molgen.mpg.de
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <475c5b49-7a75-3ee7-6f8d-de5f400856da@huawei.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <e60ed23d-676f-a1f9-81a1-44d2ca97f9da@molgen.mpg.de>
Date:   Wed, 3 Feb 2021 09:58:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <475c5b49-7a75-3ee7-6f8d-de5f400856da@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Linux folks,


Am 03.02.21 um 09:49 schrieb John Garry:
> On 02/02/2021 20:48, Martin Wilck wrote:
>> On Tue, 2021-02-02 at 20:04 +0000, Don.Brace@microchip.com wrote:
>>> -----Original Message-----
>>> From: John Garry [mailto:john.garry@huawei.com]
>>> Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
>>>
>>>
>>> Confirmed my suspicions - it looks like the host is sent more
>>> commands than it can handle. We would need many disks to see this
>>> issue though, which you have.
>>>
>>> So for stable kernels, 6eb045e092ef is not in 5.4 . Next is 5.10, and
>>> I suppose it could be simply fixed by setting .host_tagset in scsi
>>> host template there.
>>>
>>> Thanks,
>>> John
>>> -- 
>>> Don: Even though this works for current kernels, what would chances
>>> of this getting back-ported to 5.9 or even further?
>>>
>>> Otherwise the original patch smartpqi_fix_host_qdepth_limit would
>>> correct this issue for older kernels.
>>
>> True. However this is 5.12 material, so we shouldn't be bothered by
>> that here. For 5.5 up to 5.9, you need a workaround. But I'm unsure
>> whether smartpqi_fix_host_qdepth_limit would be the solution.
>> You could simply divide can_queue by nr_hw_queues, as suggested before,
>> or even simpler, set nr_hw_queues = 1.
>>
>> How much performance would that cost you?
>>
>> Distribution kernels would be yet another issue, distros can backport
>> host_tagset and get rid of the issue.
> 
> Aren't they (distros) the only issue? As I mentioned above, for 5.10 
> mainline stable, I think it's reasonable to backport a patch to set 
> .host_tagset for the driver.

Indeed. As per the Linux kernel Web site [1]: 5.5 and 5.9 are not 
maintained anymore (EOL) upstream. So, if distributions decided to go 
with another Linux kernel release, it’s their job to backport things. If 
the commit message is well written, and contains the Fixes tag, their 
tooling should be able to pick it up.


Kind regards,

Paul


[1]: https://www.kernel.org/
