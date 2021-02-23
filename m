Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED74C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F3664DDA
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhBWJAX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 04:00:23 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2595 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhBWJAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 04:00:21 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DlCZ13ynYz67rv9;
        Tue, 23 Feb 2021 16:55:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Feb 2021 09:59:37 +0100
Received: from [10.47.0.222] (10.47.0.222) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 23 Feb
 2021 08:59:36 +0000
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     Roger Willcocks <roger@filmlight.ltd.uk>, <Don.Brace@microchip.com>
CC:     <mwilck@suse.com>, <buczek@molgen.mpg.de>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
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
 <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
 <0DB85ADC-B962-4AF9-B106-3F3B412CE4DB@filmlight.ltd.uk>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4bff6232-6abd-dae8-c240-07a1a40178bf@huawei.com>
Date:   Tue, 23 Feb 2021 08:57:49 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0DB85ADC-B962-4AF9-B106-3F3B412CE4DB@filmlight.ltd.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.0.222]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2021 14:23, Roger Willcocks wrote:
> FYI we have exactly this issue on a machine here running CentOS 8.3 (kernel 4.18.0-240.1.1) (so presumably this happens in RHEL 8 too.)
> 
> Controller is MSCC / Adaptec 3154-8i16e driving 60 x 12TB HGST drives configured as five x twelve-drive raid-6, software striped using md, and formatted with xfs.
> 
> Test software writes to the array using multiple threads in parallel.
> 
> The smartpqi driver would report controller offline within ten minutes or so, with status code 0x6100c
> 
> Changed the driver to set 'nr_hw_queues = 1’ and then tested by filling the array with random files (which took a couple of days), which completed fine, so it looks like that one-line change fixes it.
> 

That just makes the driver single-queue.

As such, since the driver uses blk_mq_unique_tag_to_hwq(), only hw queue 
#0 will ever be used in the driver.

And then, since the driver still spreads MSI-X interrupt vectors over 
all CPUs [from pci_alloc_vectors(PCI_IRQ_AFFINITY)], if CPUs associated 
with HW queue #0 are offlined (probably just cpu0), there is no CPUs 
available to service queue #0 interrupt. That's what I think would 
happen, from a quick glance at the code.


> Would, of course, be helpful if this was back-ported.
> 
> —
> Roger
> 
> 
> 
>> On 3 Feb 2021, at 15:56, Don.Brace@microchip.com wrote:
>>
>> -----Original Message-----
>> From: Martin Wilck [mailto:mwilck@suse.com]
>> Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
>>
>>>
>>>
>>> Confirmed my suspicions - it looks like the host is sent more commands
>>> than it can handle. We would need many disks to see this issue though,
>>> which you have.
>>>
>>> So for stable kernels, 6eb045e092ef is not in 5.4 . Next is 5.10, and
>>> I suppose it could be simply fixed by setting .host_tagset in scsi
>>> host template there.
>>>
>>> Thanks,
>>> John
>>> --
>>> Don: Even though this works for current kernels, what would chances of
>>> this getting back-ported to 5.9 or even further?
>>>
>>> Otherwise the original patch smartpqi_fix_host_qdepth_limit would
>>> correct this issue for older kernels.
>>
>> True. However this is 5.12 material, so we shouldn't be bothered by that here. For 5.5 up to 5.9, you need a workaround. But I'm unsure whether smartpqi_fix_host_qdepth_limit would be the solution.
>> You could simply divide can_queue by nr_hw_queues, as suggested before, or even simpler, set nr_hw_queues = 1.
>>
>> How much performance would that cost you?
>>
>> Don: For my HBA disk tests...
>>
>> Dividing can_queue / nr_hw_queues is about a 40% drop.
>> ~380K - 400K IOPS
>> Setting nr_hw_queues = 1 results in a 1.5 X gain in performance.
>> ~980K IOPS
>> Setting host_tagset = 1
>> ~640K IOPS
>>
>> So, it seem that setting nr_hw_queues = 1 results in the best performance.
>>
>> Is this expected? Would this also be true for the future?
>>
>> Thanks,
>> Don Brace
>>
>> Below is my setup.
>> ---
>> [3:0:0:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdd
>> [3:0:1:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sde
>> [3:0:2:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdf
>> [3:0:3:0]    disk    HP       EH0300FBQDD      HPD5  /dev/sdg
>> [3:0:4:0]    disk    HP       EG0900FDJYR      HPD4  /dev/sdh
>> [3:0:5:0]    disk    HP       EG0300FCVBF      HPD9  /dev/sdi
>> [3:0:6:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdj
>> [3:0:7:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdk
>> [3:0:8:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdl
>> [3:0:9:0]    disk    HP       MO0200FBRWB      HPD9  /dev/sdm
>> [3:0:10:0]   disk    HP       MM0500FBFVQ      HPD8  /dev/sdn
>> [3:0:11:0]   disk    ATA      MM0500GBKAK      HPGC  /dev/sdo
>> [3:0:12:0]   disk    HP       EG0900FBVFQ      HPDC  /dev/sdp
>> [3:0:13:0]   disk    HP       VO006400JWZJT    HP00  /dev/sdq
>> [3:0:14:0]   disk    HP       VO015360JWZJN    HP00  /dev/sdr
>> [3:0:15:0]   enclosu HP       D3700            5.04  -
>> [3:0:16:0]   enclosu HP       D3700            5.04  -
>> [3:0:17:0]   enclosu HPE      Smart Adapter    3.00  -
>> [3:1:0:0]    disk    HPE      LOGICAL VOLUME   3.00  /dev/sds
>> [3:2:0:0]    storage HPE      P408e-p SR Gen10 3.00  -
>> -----
>> [global]
>> ioengine=libaio
>> ; rw=randwrite
>> ; percentage_random=40
>> rw=write
>> size=100g
>> bs=4k
>> direct=1
>> ramp_time=15
>> ; filename=/mnt/fio_test
>> ; cpus_allowed=0-27
>> iodepth=4096
>>
>> [/dev/sdd]
>> [/dev/sde]
>> [/dev/sdf]
>> [/dev/sdg]
>> [/dev/sdh]
>> [/dev/sdi]
>> [/dev/sdj]
>> [/dev/sdk]
>> [/dev/sdl]
>> [/dev/sdm]
>> [/dev/sdn]
>> [/dev/sdo]
>> [/dev/sdp]
>> [/dev/sdq]
>> [/dev/sdr]
>>
>>
>> Distribution kernels would be yet another issue, distros can backport host_tagset and get rid of the issue.
>>
>> Regards
>> Martin
>>
>>
>>
>>
>>
>>
>>
>>
>>
>>
> 
> .
> 

